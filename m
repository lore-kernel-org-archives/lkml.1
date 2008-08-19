Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbYHSREY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbYHSREY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 13:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756907AbYHSRDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 13:03:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756882AbYHSRDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 13:03:47 -0400
Date: Tue, 19 Aug 2008 13:03:17 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jirislaby@gmail.com
Subject: Re: [PATCH] vt: kill tty->count usage (v2)
Message-ID: <20080819170317.GC7154@redhat.com>
References: <20080808213625.GK20355@redhat.com> <20080808222635.4fe52b51@lxorguk.ukuu.org.uk> <20080812145812.GH7154@redhat.com> <20080818181902.59ac763b@lxorguk.ukuu.org.uk> <20080818210414.GB7154@redhat.com> <20080819160318.26f70590@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819160318.26f70590@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,
> > > > The commit e0426e6a09954d205da2d674a3d368d2715e3afd fixes a real race but
> > > > still isn't enough to prevent these:
> > > > 
> > > > kobject_add_internal failed for vcs7 with -EEXIST, don't try to register
> > > > things with the same name in the same direc.
> > > 
> > > Patch dropped due to testing failures.
> > > 
> > > Boot to run level 3, log in and type "reboot\n". Wait
> > > 
> > > Spews vt->driver_data == NULL warnings and oopses
> > do you mind posting the logs somewhere? I wasn't able to reproduce it here so
> 
> I decided it might be better to tackle this one 'head on' and go to the
> root of the problem. I've pushed the following into the stack of patches
> for -next
> 
> tty: shutdown method
I agree with the idea, but:

>  /**
>   *	release_one_tty		-	release tty structure memory
>   *	@kref: kref of tty we are obliterating
> @@ -1489,27 +1514,11 @@ static void release_one_tty(struct kref *kref)
>  {
>  	struct tty_struct *tty = container_of(kref, struct tty_struct, kref);
>  	struct tty_driver *driver = tty->driver;
> -	int devpts = tty->driver->flags & TTY_DRIVER_DEVPTS_MEM;
> -	struct ktermios *tp;
> -	int idx = tty->index;
> -
> -	if (!devpts)
> -		tty->driver->ttys[idx] = NULL;
> -
> -	if (tty->driver->flags & TTY_DRIVER_RESET_TERMIOS) {
> -		/* FIXME: Locking on ->termios array */
> -		tp = tty->termios;
> -		if (!devpts)
> -			tty->driver->termios[idx] = NULL;
> -		kfree(tp);
> -
> -		tp = tty->termios_locked;
> -		if (!devpts)
> -			tty->driver->termios_locked[idx] = NULL;
> -		kfree(tp);
> -	}
> -
>  
> +	if (tty->ops->shutdown)
> +		tty->ops->shutdown(tty);
> +	else
> +		tty_shutdown(tty);
>  	tty->magic = 0;
>  	/* FIXME: locking on tty->driver->refcount */
>  	tty->driver->refcount--;
isn't too late for drivers that wait for the remaining data to be transmitted
such as amiserial and cyclades? Unless there's a plan to do it at
release_dev()?

-- 
Aristeu

