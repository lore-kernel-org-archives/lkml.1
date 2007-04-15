Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbXDOTk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbXDOTk1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 15:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbXDOTk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 15:40:27 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:4638 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbXDOTk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 15:40:26 -0400
Date: Sun, 15 Apr 2007 21:40:24 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Brownell <david-b@pacbell.net>, linux-pm@lists.linux-foundation.org,
       pavel@suse.cz, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-pm@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [linux-pm] Linux 2.6.21-rc6
Message-ID: <20070415194023.GA2538@melchior.yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	David Brownell <david-b@pacbell.net>,
	linux-pm@lists.linux-foundation.org, pavel@suse.cz,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, linux-pm@lists.osdl.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Adrian Bunk <bunk@stusta.de>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <200704151316.26136.rjw@sisk.pl> <200704150814.01747.david-b@pacbell.net> <200704151837.40756.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200704151837.40756.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Sunday, 15 April 2007 17:14, David Brownell wrote:
> > On Sunday 15 April 2007 4:16 am, Rafael J. Wysocki wrote:
> > > On Sunday, 15 April 2007 10:02, Tobias Diedrich wrote:
> > 
> > > > > > > Yes, it's a Asus M2N-SLI-Deluxe Mainboard with a Athlon64 3200+
> > > > > > > single core CPU.
> > 
> > And NVidia southbridge, so OHCI not UHCI (plus EHCI) ... one experiment
> > would be to disable the EHCI (high speed USB) support in BIOS, to make
> > for a simpler hardware configuration, and see if that makes BIOS happier.
> > (Or better, just take EHCI out of your Linux config.)  Likewise, taking
> > the 8042 drivers out of Linux.
> > 
> > I wouldn't be surprised if those factors didn't matter, but it'd be good
> > to rule them out.
> 
> I think the disabling of i8042 support might help.

Still hangs with "# CONFIG_SERIO_I8042 is not set".

> > > Dmitry, could you please have a look?
> > > 
> > > > And I can now confirm that unpatched 2.6.21-rc6 works fine as long
> > > > as USB legacy support is disabled (however without legacy support I
> > > > can't use the USB keyboard to control grub).
> > > 
> > > I think using the 'shutdown' mode of suspend would be better.  There's a little
> > > point in using 'platform' on desktop systems anyway.
> > > 
> > > Frankly, I don't know what to do about it.  If we move platform_finish() after
> > > device_resume(), some systems may be broken ...
> > 
> > What I'm curious about is exactly why the patch matters.  What ACPI
> > magic is being invoked to confuse, or unconfuse, those controllers?
> 
> I think the patch helps, because it makes the ACPI magic be done while the
> i8042's .resume() is being executed.
> 
> Which makes me think the following patch might help:

Unfortunately not, I tried this before disabling CONFIG_SERIO_I8042.

>  drivers/input/serio/i8042.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.21-rc6/drivers/input/serio/i8042.c
> ===================================================================
> --- linux-2.6.21-rc6.orig/drivers/input/serio/i8042.c	2007-04-07 12:15:19.000000000 +0200
> +++ linux-2.6.21-rc6/drivers/input/serio/i8042.c	2007-04-15 18:30:01.000000000 +0200
> @@ -846,7 +846,8 @@ static long i8042_panic_blink(long count
>  static int i8042_suspend(struct platform_device *dev, pm_message_t state)
>  {
>  	if (dev->dev.power.power_state.event != state.event) {
> -		if (state.event == PM_EVENT_SUSPEND)
> +		if (state.event == PM_EVENT_SUSPEND
> +		    || state.event == PM_EVENT_PRETHAW)
>  			i8042_controller_reset();
>  
>  		dev->dev.power.power_state = state;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
