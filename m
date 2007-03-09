Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbXCIJIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbXCIJIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 04:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbXCIJII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 04:08:08 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:42427 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbXCIJIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 04:08:06 -0500
Date: Fri, 9 Mar 2007 10:08:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Johnson <ajohnson@intrinsyc.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Software Suspend: Fix suspend when console is in VT_AUTO/KD_GRAPHICS mode
Message-ID: <20070309090805.GA5822@atrey.karlin.mff.cuni.cz>
References: <1173394485.28589.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173394485.28589.17.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> When the console is in VT_AUTO/KD_GRAPHICS mode, switching to the
> SUSPEND_CONSOLE fails, resulting in vt_waitactive() waiting indefinately
> or until the task is interrupted.  The following patch tests if a
> console switch can occur in set_console() and returns early if a console
> switch is not possible.

Your mailer wraps lines...

How do I reproduce this? Suspending from X works for me...?

> Signed-off-by: Andrew Johnson <ajohnson@intrinsyc.com>
> 
> diff -rup linux-2.6.20.1/drivers/char/vt.c linux/drivers/char/vt.c
> --- linux-2.6.20.1/drivers/char/vt.c	2007-02-19 22:34:32.000000000 -0800
> +++ linux/drivers/char/vt.c	2007-03-08 14:15:41.000000000 -0800
> @@ -2188,10 +2188,20 @@ static void console_callback(struct work
>  	release_console_sem();
>  }
>  
> -void set_console(int nr)
> +extern char vt_dont_switch;
> +
> +int set_console(int nr)
>  {
> +	struct vc_data *vc = vc_cons[fg_console].d;
> +
> +	if(!vc_cons_allocated(nr) || vt_dont_switch || vc->vc_mode ==
> KD_GRAPHICS) {
> +		return -EINVAL;
> +	}
> +

So... if current console is graphical, we leave X accessing the
console... That's bad, because video state is not going to be
restored...?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
