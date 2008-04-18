Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbYDRVna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbYDRVna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbYDRVnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 17:43:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014AbYDRVnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 17:43:19 -0400
Date: Fri, 18 Apr 2008 14:42:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: uaccess: add probe_kernel_write()
Message-Id: <20080418144230.7a0e2df8.akpm@linux-foundation.org>
In-Reply-To: <200804181858.m3IIwxCO009750@hera.kernel.org>
References: <200804181858.m3IIwxCO009750@hera.kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 18:58:59 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c33fa9f5609e918824446ef9a75319d4a802f1f4
> Commit:     c33fa9f5609e918824446ef9a75319d4a802f1f4
> Parent:     4b119e21d0c66c22e8ca03df05d9de623d0eb50f
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Thu Apr 17 20:05:36 2008 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu Apr 17 20:05:36 2008 +0200
> 
>     uaccess: add probe_kernel_write()
>     
>     add probe_kernel_read() and probe_kernel_write().
>     
>     Uninlined and restricted to kernel range memory only, as suggested
>     by Linus.
>     
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>     Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
>
> diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
> index 975c963..fec6dec 100644
> --- a/include/linux/uaccess.h
> +++ b/include/linux/uaccess.h
> @@ -84,4 +84,26 @@ static inline unsigned long __copy_from_user_nocache(void *to,
>  		ret;					\
>  	})
>  
> +/*
> + * probe_kernel_read(): safely attempt to read from a location
> + * @dst: pointer to the buffer that shall take the data
> + * @src: address to read from
> + * @size: size of the data chunk
> + *
> + * Safely read from address @src to the buffer at @dst.  If a kernel fault
> + * happens, handle that and return -EFAULT.
> + */
> +extern long probe_kernel_read(void *dst, void *src, size_t size);
> +
> +/*
> + * probe_kernel_write(): safely attempt to write to a location
> + * @dst: address to write to
> + * @src: pointer to the data that shall be written
> + * @size: size of the data chunk
> + *
> + * Safely write to address @dst from the buffer at @src.  If a kernel fault
> + * happens, handle that and return -EFAULT.
> + */
> +extern long probe_kernel_write(void *dst, void *src, size_t size);

The above comments appear to be kerneldoc but actually aren't.  I don't
think there's much point in duplicating the kerneldoc comments in the .h
file as well - people should know by now to go to the definition site to
find the documentation.

> --- /dev/null
> +++ b/mm/maccess.c
> @@ -0,0 +1,49 @@
> +/*
> + * Access kernel memory without faulting.
> + */
> +#include <linux/uaccess.h>
> +#include <linux/module.h>
> +#include <linux/mm.h>
> +
> +/**
> + * probe_kernel_read(): safely attempt to read from a location
> + * @dst: pointer to the buffer that shall take the data
> + * @src: address to read from
> + * @size: size of the data chunk
> + *
> + * Safely read from address @src to the buffer at @dst.  If a kernel fault
> + * happens, handle that and return -EFAULT.
> + */
> +long probe_kernel_read(void *dst, void *src, size_t size)
> +{
> +	long ret;
> +
> +	pagefault_disable();
> +	ret = __copy_from_user_inatomic(dst,
> +			(__force const void __user *)src, size);
> +	pagefault_enable();
> +
> +	return ret ? -EFAULT : 0;
> +}
> +EXPORT_SYMBOL_GPL(probe_kernel_read);

I think the documentation should point out that this function can probe both
a user address and a kernel address (if that's right, which I think it is).

And just looking at it, I think the set_fs() in probe_kernel_address() was
always unneeded.

As I pointed out the other day (was apparently ignored) I think we
can/should reimplement probe_kernel_address() to use this.  For
compatibility reasons, this will require EXPORT_SYMBOL(), not
EXPORT_SYMBOL_GPL().



All the above observations should of course have been made prior to the
patch begin merged into mainline but afacit it was never sent out for
review?

