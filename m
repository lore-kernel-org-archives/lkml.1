Return-Path: <linux-kernel-owner+w=401wt.eu-S1758401AbZDRPKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401AbZDRPKc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 11:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbZDRPKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 11:10:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45036 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773AbZDRPKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 11:10:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: 900af0d breaks some embedded suspend/resume
Date: Sat, 18 Apr 2009 17:09:46 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <20090417231009.GB6900@flint.arm.linux.org.uk> <200904181626.10388.rjw@sisk.pl> <20090418144132.GC7148@flint.arm.linux.org.uk>
In-Reply-To: <20090418144132.GC7148@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904181709.47480.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 April 2009, Russell King wrote:
> On Sat, Apr 18, 2009 at 04:26:09PM +0200, Rafael J. Wysocki wrote:
> > On Saturday 18 April 2009, Russell King wrote:
> > > On Sat, Apr 18, 2009 at 03:23:35PM +0200, Rafael J. Wysocki wrote:
> > > > The patchset in question had been discussed quite extensively before it was
> > > > merged and it's a pity none of the people caring for the affected platforms
> > > > took part in those discussions.  That would allow us to avoid the breakage.
> > > 
> > > Maybe on some list, but not everyone is subscribed to a million and one
> > > mailing lists.  I don't have enough time to read those which I'm currently
> > > subscribed to, so I definitely don't want any more.
> > > 
> > > > > or provide alternative equivalent functionality where the platform code is
> > > > > notified of the PM event prior to the late suspend callback being issued.
> > > > 
> > > > There is the .begin() callback that could be used, but if you need the
> > > > platform to be notified _just_ prior to the late suspend callback, then the
> > > > only thing I can think of at the moment is the appended patch.
> > > > 
> > > > It shouldn't break anything in theory, because the majority of drivers put
> > > > their devices into low power states in the "regular" suspend callbacks anyway.
> > > 
> > > Okay, my requirement is:
> > > 
> > > What I need to be able to do is to suspend most devices on the host side
> > > which may involve talking to a separate microcontroller via I2C to shut
> > > down power to peripherals.
> > > 
> > > Once that's complete, I then need to inform this microcontroller via I2C
> > > that we're going to be entering suspend mode, and wait for it to acknowledge
> > > that (after it's done its own suspend preparations).  At that point I can
> > > shutdown the I2C controller, and enter suspend mode.
> > 
> > Would it be an option to use a sysdev for that?
> 
> No, sysdevs are shut down after IRQs are turned off and the I2C driver
> has been shut down.  The I2C driver needs IRQs to work in slave mode,
> and we need slave mode to work.

Hm, but up to and including 2.6.29 we called the late suspend callbacks with
interrupts off.  Not any more, though. :-)

OK

> > This patch undoes some previous changes, but I'm not too comfortable with
> > it, because I think that putting devices into low power states after
> > .prepare() may not work on some ACPI systems.  Since devices should
> > generally be put into low power states during the "late" suspend (ie.
> > when their interrupt handlers are not invoked), it may be quite
> > inconvenient.
> 
> Maybe we need yet more levels of callbacks? :P
> 
> Realistically, not all platforms are going to have the same requirements,
> so I don't think imposing ACPI requirements (by changing what is a
> currently working suspend ordering) on everyone else is not the way
> to go.

Well, we didn't have the problem before, because the platforms apparently
agreed with each other in that respect previously. :-)

I generally agree nevertheless.

> Maybe we need a way to allow hooks to be placed into the suspend/resume
> mechanism in a dynamic way.  Eg, define the suspend order as:
> 
> - early device suspend
> - normal device suspend
> - irqs off
> - late device suspend
> - sysdev suspend

That currently is

- normal device suspend
- suspend_device_irqs() (in kernel/irq/pm.c)
- late device suspend
- irqs off
- sysdev suspend

> and allow hooks into that order to be added.  Maybe something like:
> 
> struct pm_hook {
> 	struct list_head node;
> 	unsigned int priority;
> 	int (*suspend)(suspend_state_t);
> 	int (*resume)(suspend_state_t);
> };
> 
> static int early_device_suspend(suspend_state_t state)
> {
> 	return device_suspend(PMSG_SUSPEND);
> }
> 
> static int early_device_resume(suspend_state_t state)
> {
> 	return device_resume(PMSG_RESUME);
> }
> 
> static struct pm_hook early_device_hook = {
> 	.priority = SUSP_EARLY_DEVICE,
> 	.suspend = early_device_suspend,
> 	.resume = early_device_resume,
> };
> 
> 
> int suspend(suspend_state_t state)
> {
> 	struct pm_hook *hook;
> 	int err;
> 
> 	list_for_each(hook, &suspend_hooks, node) {
> 		err = hook->suspend(state);
> 		if (err) {
> 			list_for_each_entry_continue_reverse(hook, &suspend_hooks, node)
> 				hook->resume(state);
> 			break;
> 		}
> 	}
> 
> 	return err;
> }
> 
> where suspend_hooks is an ordered list according to 'priority'.
> 
> This would allow dynamic insertion of platforms suspend/resume requirements
> into the PM system.

Hmm, what about redefining platform_suspend_ops in the following way:

struct platform_suspend_ops {
	int (*valid)(suspend_state_t state);
	int (*begin)(suspend_state_t state);
	int (*devices_suspended)(void);
	int (*prepare)(void);
	int (*enter)(suspend_state_t state);
	void (*wake)(void);
	int (*resume_devices)(void);
	void (*end)(void);
	void (*recover)(void);
};

where:

* begin() will be called before suspending devices (no change)
* devices_suspended() will be called after suspending devices (before
  suspend_device_irqs())
* prepare() will be callled after the late suspend callbacks
* enter() will be called to enter the sleep state (no change)
* wake() will be called before the early resume callbacks
* resume_devices() will be called before resuming devices (after
  resume_device_irqs()
* end() will be called after resuming devices (no change)

I don't think we'll need more platform hooks than that.

Thanks,
Rafael
