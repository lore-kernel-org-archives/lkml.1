Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbZBCVi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbZBCVi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 16:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZBCViU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 16:38:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866AbZBCViT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 16:38:19 -0500
Date: Tue, 3 Feb 2009 13:37:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, oleg@redhat.com,
       viro@ZenIV.linux.org.uk, davidel@xmailserver.org, davem@davemloft.net,
       hch@lst.de, linux-api@vger.kernel.org, mpm@selenic.com,
       alan@lxorguk.ukuu.org.uk, corbet@lwn.net
Subject: Re: [PATCH 1/4] Use bit operations for file->f_flags
Message-Id: <20090203133722.9e70de76.akpm@linux-foundation.org>
In-Reply-To: <1233598811-6871-2-git-send-email-corbet@lwn.net>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net>
	<1233598811-6871-2-git-send-email-corbet@lwn.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Feb 2009 11:20:08 -0700
Jonathan Corbet <corbet@lwn.net> wrote:

> Turn struct file->f_flags into an unsigned long and use bitops to change
> its contents.  This allows the safe manipulation of these flags without the
> need for locks.  BKL use is removed where possible, but manipulations of
> the FASYNC bit still require it (that will be fixed in a later patch).
> 
> ...
>
> diff --git a/arch/alpha/include/asm/fcntl.h b/arch/alpha/include/asm/fcntl.h
> index 25da001..de7172f 100644
> --- a/arch/alpha/include/asm/fcntl.h
> +++ b/arch/alpha/include/asm/fcntl.h
> @@ -9,13 +9,18 @@
>  #define O_NOCTTY	010000	/* not fcntl */
>  
>  #define O_NONBLOCK	 00004
> +#define NR_O_NONBLOCK	 2
>  #define O_APPEND	 00010
> +#define NR_O_APPEND	 3
>  #define O_SYNC		040000
> +#define NR_O_SYNC	14
>  #define O_DIRECTORY	0100000	/* must be a directory */
>  #define O_NOFOLLOW	0200000 /* don't follow links */
>  #define O_LARGEFILE	0400000 /* will be set by the kernel on every open */
>  #define O_DIRECT	02000000 /* direct disk access - should check with OSF/1 */
> +#define NR_O_DIRECT	19
>  #define O_NOATIME	04000000
> +#define NR_O_NOATIME	20
>  #define O_CLOEXEC	010000000 /* set close_on_exec */
>  
>  #define F_GETLK		7
> diff --git a/arch/arm/include/asm/fcntl.h b/arch/arm/include/asm/fcntl.h
> index a80b660..e74b8d1 100644
> --- a/arch/arm/include/asm/fcntl.h
> +++ b/arch/arm/include/asm/fcntl.h
> @@ -4,6 +4,7 @@
>  #define O_DIRECTORY	 040000	/* must be a directory */
>  #define O_NOFOLLOW	0100000	/* don't follow links */
>  #define O_DIRECT	0200000	/* direct disk access hint - currently ignored */
> +#define NR_O_DIRECT	16
>  #define O_LARGEFILE	0400000
>  
>  #include <asm-generic/fcntl.h>

hm, it's not exactly a vision of splendour, is it.

I suppose we could/should do

#define O_NONBLOCK	(1 << NR_O_NONBLOCK)

but that doesn't prevent people from accidentally doing open-coded &/|
in the future.  Perhaps renaming f_flags to f__flags_atomic (stupid
name?) would help.

> +static void tweak_flags_bit(int nr, int on, unsigned long *flags)
> +{
> +	if (on)
> +		set_bit(nr, flags);
> +	else
> +		clear_bit(nr, flags);
> +}

I see this construct fairly frequently.  I think.  Someone(tm) should
check ;) If correct I guess we should have some generic version, put it
in include/linux/bitops.h.

>  
>  static int setfl(int fd, struct file * filp, unsigned long arg)
>  {
> @@ -187,9 +195,17 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
>  			if (error < 0)
>  				goto out;
>  		}
> +		change_bit(NR_FASYNC, &filp->f_flags);
>  	}
>  
> -	filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
> +	/*
> +	 * Now that we use bitops we have to tweak each bit individually.
> +	 */
> +	tweak_flags_bit(NR_O_APPEND, arg & O_APPEND, &filp->f_flags);
> +	tweak_flags_bit(NR_O_NONBLOCK, arg & O_NONBLOCK, &filp->f_flags);
> +	tweak_flags_bit(NR_O_NDELAY, arg & O_NDELAY, &filp->f_flags);
> +	tweak_flags_bit(NR_O_DIRECT, arg & O_DIRECT, &filp->f_flags);
> +	tweak_flags_bit(NR_O_NOATIME, arg & O_NOATIME, &filp->f_flags);

Could pass the file* to tweak_flags_bit() - that would generate less
code.  Unless the compiler chooses to inline tweak_flags_bit().

>   out:
>  	unlock_kernel();
>  	return error;
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 240ec63..fc0db36 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -392,22 +392,24 @@ static int file_ioctl(struct file *filp, unsigned int cmd,
>  
>  static int ioctl_fionbio(struct file *filp, int __user *argp)
>  {
> -	unsigned int flag;
>  	int on, error;
>  
>  	error = get_user(on, argp);
>  	if (error)
>  		return error;
> -	flag = O_NONBLOCK;
>  #ifdef __sparc__
>  	/* SunOS compatibility item. */
> -	if (O_NONBLOCK != O_NDELAY)
> -		flag |= O_NDELAY;
> +	if (O_NONBLOCK != O_NDELAY) {
> +		if (on)
> +			set_bit(NR_O_NDELAY, &filp->f_flags);
> +		else
> +			clear_bit(NR_O_NDELAY, &filp->f_flags);

hey, I recognise that!

> +	}
>  #endif
>  	if (on)
> -		filp->f_flags |= flag;
> +		set_bit(NR_O_NONBLOCK, &filp->f_flags);
>  	else
> -		filp->f_flags &= ~flag;
> +		clear_bit(NR_O_NONBLOCK, &filp->f_flags);

and that.


as for the whole patchset: gee, that global lock you had is looking
attractive ;)

