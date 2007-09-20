Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbXITVc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbXITVc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 17:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbXITVcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 17:32:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40481 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbXITVcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 17:32:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when booted, USB-related WARNING
Date: Thu, 20 Sep 2007 23:45:00 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@osdl.org>,
       miklos@szeredi.hu
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <200709202239.11070.rjw@sisk.pl> <1190322532.3085.42.camel@chaos>
In-Reply-To: <1190322532.3085.42.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709202345.01682.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Thursday, 20 September 2007 23:08, Thomas Gleixner wrote:
> Rafael,
> 
> On Thu, 2007-09-20 at 22:39 +0200, Rafael J. Wysocki wrote:
> > > Works as well. What's the difference between this and the real thing ?
> > 
> > The real thing also calls device_power_down(PMSG_FREEZE), which is a
> > counterpart of sysdev_shutdown(), more or less, and I think that's what goes
> > belly up.
> > 
> > You can use the patch below (on top of -rc6-mm1), which just disables the image
> > creation (that should be irrelevant anyway) and see what happens.
> 
> In meantime I figured out what's happening. The ordering in
> hibernate_snapshot() is wrong. It does:
> 
> 	swsusp_shrink_memory();
>         suspend_console();
>         device_suspend(PMSG_FREEZE);
>         platform_prepare(platform_mode);
> 
> 	disable_nonboot_cpus();
> 
>         swsusp_suspend();
> 
> 	enable_nonboot_cpus();
> 
> 	platform_finish(platform_mode);
>         device_resume();
>         resume_console();
> 
> We disable everything in device_suspend()

No, we don't.  sysdevs are _not_ suspended in device_suspend().
They are suspended in device_power_down(), which is called
_after_ disable_nonboot_cpus() (from swsusp_suspend()).

> including timekeeping,

No, the timekeeping is suspended in device_power_down() (or at least it should
be).

> so any  code which is depending on working timekeeping and timer
> functionality (which is suspended in timekeeping_suspend() as well) is
> busted. 
> 
> enable_nonboot_cpus() definitely relies on working timekeeping and
> timers depending on the codepath. It's just a surprise that this did not
> blow up earlier (also before clock events).
> 
> I changed the ordering of the above to:
> 
> 	disable_nonboot_cpus();
> 
> 	swsusp_shrink_memory();
>         suspend_console();
>         device_suspend(PMSG_FREEZE);
>         platform_prepare(platform_mode);
>         swsusp_suspend();
> 	platform_finish(platform_mode);
>         device_resume();
>         resume_console();
> 
> 	enable_nonboot_cpus();

Actually, we can't do this here, because of ACPI and some interrupt handling
related problems.  Unfortunately, platform_finish() needs to go _after_
enable_nonboot_cpus() and device_resume() needs to go after platform_finish().
Analogously, disable_nonboot_cpus() has to go after platform_prepare().

Otherwise, some systems will break.

> and non-surprisingly the "my VAIO needs help from keyboard" problem went
> away immediately. See patch below. (on top of rc7-hrt1, -mm1 does not
> work at all on my VAIO due to some yet not identified wreckage)

Hm, I really don't know why it helps, but that's not because of the timekeeping
suspend, IMO.

> I did not yet look into the suspend to ram code, but I guess that there
> is an equivalent problem.

Yes, the code ordering is the same, but it's not totally wrong, IMHO.

> But I have no idea why this affects Andrews jinxed VAIO (UP machine),
> though I suspect that we have more timekeeping/timer depending code
> somewhere waiting to bite us.

That's possible.

> Also I still need to debug why the HIBERNATION_TEST code path (which has
> a msleep(5000) in it) does not fail,

See above. :-)

> but I postpone this until tomorrow morning. I'm dead tired after hunting
> this Heisenbug which changes with every other printk added to the code.
> I'm going to add some really noisy messages for everything which accesses
> timekeeping / timers _after_ those systems have been shut down.
> 
> We really need to fix this once and forever _before_ 2.6.23 final, even
> if it requires a -rc8.

Agreed.

Greetings,
Rafael
