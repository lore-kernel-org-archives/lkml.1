Return-Path: <linux-kernel-owner+w=401wt.eu-S1761358AbZBYVkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761358AbZBYVkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZBYVk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:40:27 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:37706 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbZBYVk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:40:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=grWfDzDHY9p5rw7eRqghbaCuBTOGm7acn/uLlifPabguUdrwoSB0mmiGEp8b3aAuK0
         uGQHHvB1mn8tRWNuHO9i1RVQrYYqTJzTVHP2WmYDWO1FyGuYZ9Noo+BDDYLUXwB+bObQ
         DckizwWijWBlgtBEIaGpYT2OwcddE5Ef0/JQE=
Date: Wed, 25 Feb 2009 22:40:19 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/4] uaccess: add copy_word_from_user
Message-ID: <20090225214018.GB5838@nowhere>
References: <20090225203007.582030664@goodmis.org> <20090225203427.382137706@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225203427.382137706@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 03:30:08PM -0500, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The ftrace utility reads space delimited words from user space.
> Andrew Morton did not like how ftrace open coded this. He had
> a good point since more than one location performed this feature.
> 
> This patch creates a copy_word_from_user function that can copy
> a space delimited word from user space. This puts the code in
> a new lib/uaccess.c file. This keeps the code in a single location
> and may be optimized in the future.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  include/linux/uaccess.h |    4 ++
>  lib/Makefile            |    3 +-
>  lib/uaccess.c           |  134 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 140 insertions(+), 1 deletions(-)
>  create mode 100644 lib/uaccess.c
> 
> diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
> index 6b58367..2d706d9 100644
> --- a/include/linux/uaccess.h
> +++ b/include/linux/uaccess.h
> @@ -106,4 +106,8 @@ extern long probe_kernel_read(void *dst, void *src, size_t size);
>   */
>  extern long probe_kernel_write(void *dst, void *src, size_t size);
>  
> +extern int copy_word_from_user(void *to, const void __user *from,
> +			       unsigned int copy, unsigned int read,
> +			       unsigned int *copied, int skip);
> +
>  #endif		/* __LINUX_UACCESS_H__ */
> diff --git a/lib/Makefile b/lib/Makefile
> index 32b0e64..46ce28c 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -11,7 +11,8 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
>  	 rbtree.o radix-tree.o dump_stack.o \
>  	 idr.o int_sqrt.o extable.o prio_tree.o \
>  	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
> -	 proportions.o prio_heap.o ratelimit.o show_mem.o is_single_threaded.o
> +	 proportions.o prio_heap.o ratelimit.o show_mem.o is_single_threaded.o \
> +	 uaccess.o
>  
>  lib-$(CONFIG_MMU) += ioremap.o
>  lib-$(CONFIG_SMP) += cpumask.o
> diff --git a/lib/uaccess.c b/lib/uaccess.c
> new file mode 100644
> index 0000000..5b9a4ac
> --- /dev/null
> +++ b/lib/uaccess.c
> @@ -0,0 +1,134 @@
> +/*
> + * lib/uaccess.c
> + * generic user access file.
> + *
> + * started by Steven Rostedt
> + *
> + *  Copyright (C) 2009 Red Hat, Inc., Steven Rostedt <srostedt@redhat.com>
> + *
> + * This source code is licensed under the GNU General Public License,
> + * Version 2.  See the file COPYING for more details.
> + */
> +#include <linux/uaccess.h>
> +#include <linux/ctype.h>
> +
> +/**
> + * copy_word_from_user - copy a space delimited word from user space
> + * @to:	     The location to copy to
> + * @from:    The location to copy from
> + * @copy:    The number of bytes to copy
> + * @read:    The number of bytes to read
> + * @copied:  The number of bytes actually copied to @to
> + * @skip:    If other than zero, will skip leading white space
> + *


Why not expand it to a copy_delimited_from_user() ?
This way we could use any separator we want, not just spaces.
We could use one more parameter for the separator and
copy_work_from_user would be a wrapper above.


> + * This reads from a user buffer, a space delimited word.
> + * If skip is set, then it will trim all leading white space.
> + * Then it will copy all non white space until @copy bytes have
> + * been copied, @read bytes have been read from the user buffer,
> + * or more white space has been encountered.
> + *
> + * Note, if skip is not set, and white space exists at the beginning
> + *  it will return immediately.
> + *
> + * Returns:
> + *  The number of bytes read from user space
> + *
> + *  -EAGAIN, if we copied a word successfully, but never hit
> + *    ending white space. The number of bytes copied will be the same
> + *    as @read. Note, if skip is set, and all we hit was white space
> + *    then we will also returne -EAGAIN with @copied = 0.
> + *
> + *  @copied will contain the number of bytes copied into @to
> + *
> + *  -EFAULT, if we faulted during any part of the copy.
> + *     @copied will be undefined.
> + *
> + *  -EINVAL, if we fill up @from before hitting white space.
> + *    @copy must be bigger than the expected word to read.
> + */
> +int copy_word_from_user(void *to, const void __user *from,
> +			unsigned int copy, unsigned int read,
> +			unsigned int *copied, int skip)
> +{
> +	unsigned int have_read = 0;
> +	unsigned int have_copied = 0;
> +	const char __user *user = from;
> +	char *kern = to;
> +	int ret;
> +	char ch;
> +
> +	/* get the first character */
> +	ret = get_user(ch, user++);
> +	if (ret)
> +		return ret;
> +	have_read++;
> +
> +	/*
> +	 * If skip is set, and the first character is white space
> +	 * then we will continue to read until we find non white space.
> +	 */
> +	if (skip) {
> +		while (have_read < read && isspace(ch)) {
> +			ret = get_user(ch, user++);
> +			if (ret)
> +				return ret;
> +			have_read++;
> +		}
> +
> +		/*
> +		 * If ch is still white space, then have_read == read.
> +		 * We successfully copied zero bytes. But this is
> +		 * still valid. Just let the caller try again.
> +		 */
> +		if (isspace(ch)) {
> +			ret = -EAGAIN;
> +			goto out;
> +		}
> +	} else if (isspace(ch)) {
> +		/*
> +		 * If skip was not set and the first character was
> +		 * white space, then we return immediately.
> +		 */
> +		ret = have_read;
> +		goto out;
> +	}
> +
> +
> +	/* Now read the actual word */
> +	while (have_read < read &&
> +	       have_copied < copy && !isspace(ch)) {
> +
> +		kern[have_copied++] = ch;
> +
> +		ret = get_user(ch, user++);
> +		if (ret)
> +			return ret;
> +
> +		have_read++;
> +	}
> +
> +	/*
> +	 * If we ended with white space then we have successfully
> +	 * read in a full word.
> +	 *
> +	 * If ch is not white space, and we have filled up @from,
> +	 * then this was an invalid word.
> +	 *
> +	 * If ch is not white space, and we still have room in @from
> +	 * then we let the caller know we have split a word.
> +	 *  (have_read == read)
> +	 */
> +	if (isspace(ch))
> +		ret = have_read;
> +	else if (have_copied == copy)
> +		ret = -EINVAL;
> +	else {
> +		WARN_ON(have_read != read);
> +		ret = -EAGAIN;
> +	}
> +
> + out:
> +	*copied = have_copied;
> +
> +	return ret;
> +}
> -- 
> 1.5.6.5
> 
> -- 

