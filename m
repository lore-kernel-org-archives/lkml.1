Return-Path: <linux-kernel-owner+w=401wt.eu-S1752918AbXITVxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbXITVxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 17:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbXITVxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 17:53:14 -0400
Received: from www.osadl.org ([213.239.205.134]:53946 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750919AbXITVxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 17:53:13 -0400
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when
	booted, USB-related WARNING
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@osdl.org>,
       miklos@szeredi.hu
In-Reply-To: <200709202345.01682.rjw@sisk.pl>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	 <200709202239.11070.rjw@sisk.pl> <1190322532.3085.42.camel@chaos>
	 <200709202345.01682.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 23:53:11 +0200
Message-Id: <1190325191.3085.64.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

On Thu, 2007-09-20 at 23:45 +0200, Rafael J. Wysocki wrote:
> > We disable everything in device_suspend()
> 
> No, we don't.  sysdevs are _not_ suspended in device_suspend().
> They are suspended in device_power_down(), which is called
> _after_ disable_nonboot_cpus() (from swsusp_suspend()).
> 
> > including timekeeping,
> 
> No, the timekeeping is suspended in device_power_down() (or at least it should
> be).

Damn, you are right. Reading through 30 different logs confused me.

> > 	enable_nonboot_cpus();
> 
> Actually, we can't do this here, because of ACPI and some interrupt handling
> related problems.  Unfortunately, platform_finish() needs to go _after_
> enable_nonboot_cpus() and device_resume() needs to go after platform_finish().
> Analogously, disable_nonboot_cpus() has to go after platform_prepare().
>
> Otherwise, some systems will break.

Well, I don't buy this one. The system would break in the same way, when
I take CPU#1 offline before I initiate the suspend.

> > and non-surprisingly the "my VAIO needs help from keyboard" problem went
> > away immediately. See patch below. (on top of rc7-hrt1, -mm1 does not
> > work at all on my VAIO due to some yet not identified wreckage)
> 
> Hm, I really don't know why it helps, but that's not because of the timekeeping
> suspend, IMO.

It is related. We rely on some subtle thing which is not up when we
resume the non boot cpu.

> > I did not yet look into the suspend to ram code, but I guess that there
> > is an equivalent problem.
> 
> Yes, the code ordering is the same, but it's not totally wrong, IMHO.
> 
> > But I have no idea why this affects Andrews jinxed VAIO (UP machine),
> > though I suspect that we have more timekeeping/timer depending code
> > somewhere waiting to bite us.
> 
> That's possible.
> 
> > Also I still need to debug why the HIBERNATION_TEST code path (which has
> > a msleep(5000) in it) does not fail,
> 
> See above. :-)

Yes. It makes sense. When I change the TEST code path to:

-	printk("swsusp debug: Waiting for 5 seconds.\n");
- 	msleep(5000);
+	printk("swsusp debug: before swsusp_suspend\n");
+ 	error = swsusp_suspend();

then I have the same effect as I get from real hibernation. And we
actually shut down time keeping somewhere in that code path.

ACPI: PCI interrupt for device 0000:00:1b.0 disabled
swsusp debug: before swsusp_suspend
Suspend timekeeping
swsusp: critical section: 
swsusp: Need to copy 112429 pages
swsusp: Normal pages needed: 35399 + 1024 + 40, available pages: 193876
swsusp: critical section: done (112429 pages copied)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Resume timekeeping
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
-> works fine

This is with my patch applied. Without that I get:

CPU1 is down
swsusp debug: before swsusp_suspend
Suspend timekeeping
swsusp: critical section: 
swsusp: Need to copy 112429 pages
swsusp: Normal pages needed: 35399 + 1024 + 40, available pages: 193876
swsusp: critical section: done (112429 pages copied)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Resume timekeeping
Enabling non-boot CPUs
--> Waits for ever until a key is pressed

Thanks,

	tglx


