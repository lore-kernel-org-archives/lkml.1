Return-Path: <linux-kernel-owner+w=401wt.eu-S1762629AbZDJVjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762629AbZDJVjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 17:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbZDJVjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 17:39:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277AbZDJVjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 17:39:22 -0400
Date: Fri, 10 Apr 2009 14:36:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: kirill@shutemov.name, v.mayatskih@gmail.com, linux-kernel@vger.kernel.org,
       xemul@openvz.org
Subject: Re: [PATCH] Remove double initialization of retval in 
 load_misc_binary()
Message-Id: <20090410143657.fb81514d.akpm@linux-foundation.org>
In-Reply-To: <871vs3lgsy.wl%vmayatsk@redhat.com>
References: <87ljqcmsjs.wl%vmayatsk@redhat.com>
	<cc557aab0904080032u5b468d56v836a4332434c7d78@mail.gmail.com>
	<871vs3lgsy.wl%vmayatsk@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Apr 2009 09:56:29 +0200
Vitaly Mayatskikh <v.mayatskih@gmail.com> wrote:

> At Wed, 8 Apr 2009 10:32:48 +0300, Kirill A. Shutemov wrote:
> 
> > Probably, better way is removing both 'retval = -ENOEXEC;'__ and initialize it within definition.
> 
> Agree.
> 
> Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index c4e8353..f10150f 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -109,14 +109,12 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
>  	struct file * interp_file = NULL;
>  	char iname[BINPRM_BUF_SIZE];
>  	char *iname_addr = iname;
> -	int retval;
> +	int retval = -ENOEXEC;
>  	int fd_binary = -1;
>  
> -	retval = -ENOEXEC;
>  	if (!enabled)
>  		goto _ret;
>  
> -	retval = -ENOEXEC;
>  	if (bprm->recursion_depth > BINPRM_MAX_RECURSION)
>  		goto _ret;
>  

I don't think this is really a desirable change.

What the existing code is effectively doing is:

	if (!enabled) {
		retval = -ENOEXEC;
		goto _ret;
	}

	if (bprm->recursion_depth > BINPRM_MAX_RECURSION) {
		retval = -ENOEXEC;
		goto _ret;
	}

only it's doing this via an odd coding trick which used to (and might
still) generate more efficient code.

Those two pieces of code are logically separate things and it's just by
coincidence that they both happen to use the same errno.

Your proposed patch will create a linkage between those two unique
pieces of code which wasn't there previously.  It's a snmall thing.

Plus the compiler will surely remove one of the loads anyway, so this
is purely a source-level change.  And I don't think it made the source
easier to read and maintain!

