Return-Path: <linux-kernel-owner+w=401wt.eu-S967018AbXILLQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967018AbXILLQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 07:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965655AbXILLQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 07:16:23 -0400
Received: from ozlabs.org ([203.10.76.45]:40512 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965357AbXILLQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 07:16:22 -0400
From: Michael Neuling <mikey@neuling.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, paulus@samba.org,
       Alan Cox <alan@redhat.com>, "David S. Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] powerpc: add new required termio functions 
In-reply-to: <20070912040109.3f6a9149.akpm@linux-foundation.org> 
References: <8018.1189562679@neuling.org> <20070912102032.GB7858@osiris.boeblingen.de.ibm.com> <20070912040109.3f6a9149.akpm@linux-foundation.org>
Comments: In-reply-to Andrew Morton <akpm@linux-foundation.org>
   message dated "Wed, 12 Sep 2007 04:01:09 -0700."
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 21.4.1
Date: Wed, 12 Sep 2007 21:16:19 +1000
Message-ID: <3350.1189595779@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20070912040109.3f6a9149.akpm@linux-foundation.org> you wrote:
> On Wed, 12 Sep 2007 12:20:32 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> 
> > On Wed, Sep 12, 2007 at 12:04:39PM +1000, Michael Neuling wrote:
> > > The "tty: termios locking functions break with new termios type" patch
> > > (f629307c857c030d5a3dd777fee37c8bb395e171) breaks the powerpc compile.
> > > [...]
> > > I'm guessing other architectures are broken too?
> > 
> > FWIW, the above quoted patch breaks s390 as well.
> 
> Does this fix it?

FYI it does fix powerpc, but I suspect you were asking about s390 here.

Mikey

> 
> diff -puN drivers/char/tty_ioctl.c~powerpc-add-new-required-termio-functions 
drivers/char/tty_ioctl.c
> --- a/drivers/char/tty_ioctl.c~powerpc-add-new-required-termio-functions
> +++ a/drivers/char/tty_ioctl.c
> @@ -795,6 +795,19 @@ int n_tty_ioctl(struct tty_struct * tty,
>  			if (L_ICANON(tty))
>  				retval = inq_canon(tty);
>  			return put_user(retval, (unsigned int __user *) arg);
> +#ifndef TCGETS2
> +		case TIOCGLCKTRMIOS:
> +			if (kernel_termios_to_user_termios((struct termios __us
er *)arg, real_tty->termios_locked))
> +				return -EFAULT;
> +			return 0;
> +
> +		case TIOCSLCKTRMIOS:
> +			if (!capable(CAP_SYS_ADMIN))
> +				return -EPERM;
> +			if (user_termios_to_kernel_termios(real_tty->termios_lo
cked, (struct termios __user *) arg))
> +				return -EFAULT;
> +			return 0;
> +#else
>  		case TIOCGLCKTRMIOS:
>  			if (kernel_termios_to_user_termios_1((struct termios __
user *)arg, real_tty->termios_locked))
>  				return -EFAULT;
> @@ -806,6 +819,7 @@ int n_tty_ioctl(struct tty_struct * tty,
>  			if (user_termios_to_kernel_termios_1(real_tty->termios_
locked, (struct termios __user *) arg))
>  				return -EFAULT;
>  			return 0;
> +#endif
>  
>  		case TIOCPKT:
>  		{
> _
> 
