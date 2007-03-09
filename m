Return-Path: <linux-kernel-owner+w=401wt.eu-S2993146AbXCIVTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993146AbXCIVTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993145AbXCIVTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:19:31 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2214 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2993144AbXCIVTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:19:30 -0500
Date: Fri, 9 Mar 2007 21:19:10 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Johnson <ajohnson@intrinsyc.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Software Suspend: Fix suspend when console is in VT_AUTO/KD_GRAPHICS mode
Message-ID: <20070309211910.GD6374@ucw.cz>
References: <1173394485.28589.17.camel@localhost.localdomain> <20070309090805.GA5822@atrey.karlin.mff.cuni.cz> <20070309153456.GA28664@srcf.ucam.org> <1173466942.29923.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173466942.29923.6.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > So... if current console is graphical, we leave X accessing the
> > > console... That's bad, because video state is not going to be
> > > restored...?
> > 
> > A graphical console is not necessarily X. Is there any requirement for 
> > there to be a single VT that isn't in text mode? The vt switching is 
> > a hack, we shouldn't make life difficult for people who have their own 
> > userspace code that's entirely capable of restoring video state on its 
> > own.
> 
> I realised that the previous patch would disallow a console switch while
> running X.  Attached is an updated patch with this scenario fixed.
> 
> Another approach might be to fail in vt_waitactive() if a console switch
> is not going to occur.
> 
> -- Andrew
> 

>  
> -void set_console(int nr)
> +extern char vt_dont_switch;
> +

What does this variable do and why do we want to use it here?

> +int set_console(int nr)
>  {
> +	struct vc_data *vc = vc_cons[fg_console].d;
> +
> +	if(!vc_cons_allocated(nr) || vt_dont_switch || 

'if ('

> +		(vc->vt_mode.mode != VT_PROCESS && vc->vc_mode == KD_GRAPHICS)) {
> +
> +		return -EINVAL;
> +	}
> +

I assume you want ...mode == VT_AUTO here?

And big comment explaining why we want this behaviour?

And another big comment explaining why this will not break existing
set_console() users?

>  	want_console = nr;
>  	schedule_console_callback();
> +
> +	return 0;
>  }
>  
>  struct tty_driver *console_driver;
> diff -rup linux-2.6.20.1/drivers/char/vt_ioctl.c
> linux/drivers/char/vt_ioctl.c
> --- linux-2.6.20.1/drivers/char/vt_ioctl.c	2007-02-19 22:34:32.000000000
> -0800
> +++ linux/drivers/char/vt_ioctl.c	2007-03-08 14:15:41.000000000 -0800
> @@ -34,7 +34,7 @@
>  #include <linux/kbd_diacr.h>
>  #include <linux/selection.h>
>  
> -static char vt_dont_switch;
> +char vt_dont_switch;
>  extern struct tty_driver *console_driver;
>  
>  #define VT_IS_IN_USE(i)	(console_driver->ttys[i] &&
> console_driver->ttys[i]->count)
> diff -rup linux-2.6.20.1/include/linux/kbd_kern.h
> linux/include/linux/kbd_kern.h
> --- linux-2.6.20.1/include/linux/kbd_kern.h	2007-02-19
> 22:34:32.000000000 -0800
> +++ linux/include/linux/kbd_kern.h	2007-03-08 14:15:41.000000000 -0800
> @@ -75,7 +75,7 @@ extern int do_poke_blanked_console;
>  
>  extern void (*kbd_ledfunc)(unsigned int led);
>  
> -extern void set_console(int nr);
> +extern int set_console(int nr);
>  extern void schedule_console_callback(void);
>  
>  static inline void set_leds(void)
> diff -rup linux-2.6.20.1/kernel/power/console.c
> linux/kernel/power/console.c
> --- linux-2.6.20.1/kernel/power/console.c	2007-02-19 22:34:32.000000000
> -0800
> +++ linux/kernel/power/console.c	2007-03-08 14:15:41.000000000 -0800
> @@ -27,7 +27,11 @@ int pm_prepare_console(void)
>  		return 1;
>  	}
>  
> -	set_console(SUSPEND_CONSOLE);
> +	if (set_console(SUSPEND_CONSOLE)) {
> +		/* Unable to change to the new console */

That's not what the comment should say.

It should explain why it is okay to proceed when we can't change to
text console.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
