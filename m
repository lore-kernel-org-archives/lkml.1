Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbZBBWH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbZBBWH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 17:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbZBBWHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 17:07:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750715AbZBBWHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 17:07:14 -0500
Date: Mon, 2 Feb 2009 14:05:54 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: PCI PM: Restore standard config registers of all devices early
In-Reply-To: <200902022239.02453.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0902021343280.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <alpine.LFD.2.00.0902021241430.3247@localhost.localdomain> <alpine.LFD.2.00.0902021251130.3247@localhost.localdomain> <200902022239.02453.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Feb 2009, Rafael J. Wysocki wrote:
> 
> Yes, which is why I thought it might be a good idea to make the AML interpreter
> allow is to execute AML with interrupts off, so that we can put devices into
> low power states and/or put them into D0 with interrupts off.
> 
> Then, we'll be able to make ACPI happy (up to some strange ordering
> expectations of some insane BIOSes maybe) and fix the interrupts issue at
> the same time.
> 
> The idea would be to have a special code path(s) where AML can be executed
> with interrupts off and a couple of special entry points into the AML
> interpreter for this purpose.

Well, I don't think anybody wants to (or necessarily has the ability) 
touch ACPI internals.

How about this kind of approach:

 - step#1: split "sysdev" device suspend/resume from the general 
   "device_power_on/off()" step

   Rationale: sysdev's include things like the actual interrupt controller 
   etc, and we almost certainly really do want to have hard interrupts 
   disabled over that whole thing. 

   I'm appending a suggested trivial patch for this.

 - step#2: make suspend/resume actually do the three phases:

	a) existing device->suspend() (interrupts on, everything live)

	b) disable_device_irq()'s: things are live, but device interrupts 
	   are turned off by essentially looping over the irq_desc_ptr[] 
	   table. 

	c) existing device->suspend_late(). System is kind of live, but 
	   all interrupts have been shut off at the source. But we really 
	   could try to keep timers etc alive.

	d) disable CPU interrupts.

	e) sysdev_suspend(). This turns off the interrupt controller etc

	*suspend cpu*

   and then do the resume in reverse order.

The reason step#1 is needed is just because we have that irq handling 
difference between the two. And if timers are running, we really can 
pretty much run all normal code (turning timers off does hurt anything 
that uses timeouts like msleep() or schedule_timeout()). Otherwise step#1 
isn't important in itself.

Hmm? It doesn't look too painful, and it would mean that we could go back 
to a perfectly regular pci_set_power_state() in the early-resume codepath. 

Ingo: how do we walk over all the interrupt descriptors in todays world? 
The whole sparse-vs-nonsparse makes things a bit more complex. 

		Linus

---
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Feb 2 13:36:19 2009 -0800

    Split up sysdev_[suspend|resume] from device_power_[down|up]
    
    This just moves the sysdev_suspend/resume from the callee to the
    callers, with no real change in semantics.
    
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/x86/kernel/apm_32.c  |    4 ++++
 drivers/base/power/main.c |    3 ---
 drivers/xen/manage.c      |    8 ++++++++
 kernel/kexec.c            |    7 +++++++
 kernel/power/disk.c       |   11 +++++++++++
 kernel/power/main.c       |    8 ++++++--
 6 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 98807bb..67021ad 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -1192,6 +1192,7 @@ static int suspend(int vetoable)
 	device_suspend(PMSG_SUSPEND);
 	local_irq_disable();
 	device_power_down(PMSG_SUSPEND);
+	sysdev_syspend();
 
 	local_irq_enable();
 
@@ -1208,6 +1209,7 @@ static int suspend(int vetoable)
 	if (err != APM_SUCCESS)
 		apm_error("suspend", err);
 	err = (err == APM_SUCCESS) ? 0 : -EIO;
+	sysdev_resume();
 	device_power_up(PMSG_RESUME);
 	local_irq_enable();
 	device_resume(PMSG_RESUME);
@@ -1228,6 +1230,7 @@ static void standby(void)
 
 	local_irq_disable();
 	device_power_down(PMSG_SUSPEND);
+	sysdev_suspend();
 	local_irq_enable();
 
 	err = set_system_power_state(APM_STATE_STANDBY);
@@ -1235,6 +1238,7 @@ static void standby(void)
 		apm_error("standby", err);
 
 	local_irq_disable();
+	sysdev_resume();
 	device_power_up(PMSG_RESUME);
 	local_irq_enable();
 }
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 670c9d6..2d14f4a 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -333,7 +333,6 @@ static void dpm_power_up(pm_message_t state)
  */
 void device_power_up(pm_message_t state)
 {
-	sysdev_resume();
 	dpm_power_up(state);
 }
 EXPORT_SYMBOL_GPL(device_power_up);
@@ -577,8 +576,6 @@ int device_power_down(pm_message_t state)
 		}
 		dev->power.status = DPM_OFF_IRQ;
 	}
-	if (!error)
-		error = sysdev_suspend(state);
 	if (error)
 		dpm_power_up(resume_event(state));
 	return error;
diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 9b91617..fb183a0 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -45,6 +45,13 @@ static int xen_suspend(void *data)
 		       err);
 		return err;
 	}
+	err = sysdev_suspend();
+	if (err) {
+		printk(KERN_ERR "xen_suspend: sysdev_suspend failed: %d\n",
+			err);
+		device_power_up(PMSG_RESUME);
+		return err;
+	}
 
 	xen_mm_pin_all();
 	gnttab_suspend();
@@ -61,6 +68,7 @@ static int xen_suspend(void *data)
 	gnttab_resume();
 	xen_mm_unpin_all();
 
+	sysdev_resume();
 	device_power_up(PMSG_RESUME);
 
 	if (!*cancelled) {
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 8a6d7b0..b780288 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1465,6 +1465,11 @@ int kernel_kexec(void)
 		error = device_power_down(PMSG_FREEZE);
 		if (error)
 			goto Enable_irqs;
+
+		/* Suspend system devices */
+		error = sysdev_suspend();
+		if (error)
+			goto Power_up_devices;
 	} else
 #endif
 	{
@@ -1477,6 +1482,8 @@ int kernel_kexec(void)
 
 #ifdef CONFIG_KEXEC_JUMP
 	if (kexec_image->preserve_context) {
+		sysdev_resume();
+ Power_up_devices:
 		device_power_up(PMSG_RESTORE);
  Enable_irqs:
 		local_irq_enable();
diff --git a/kernel/power/disk.c b/kernel/power/disk.c
index 432ee57..07dc9a2 100644
--- a/kernel/power/disk.c
+++ b/kernel/power/disk.c
@@ -227,6 +227,12 @@ static int create_image(int platform_mode)
 			"aborting hibernation\n");
 		goto Enable_irqs;
 	}
+	sysdev_suspend();
+	if (error) {
+		printk(KERN_ERR "PM: Some devices failed to power down, "
+			"aborting hibernation\n");
+		goto Power_up_devices;
+	}
 
 	if (hibernation_test(TEST_CORE))
 		goto Power_up;
@@ -242,9 +248,11 @@ static int create_image(int platform_mode)
 	if (!in_suspend)
 		platform_leave(platform_mode);
  Power_up:
+	sysdev_resume();
 	/* NOTE:  device_power_up() is just a resume() for devices
 	 * that suspended with irqs off ... no overall powerup.
 	 */
+ Power_up_devices:
 	device_power_up(in_suspend ?
 		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
  Enable_irqs:
@@ -335,6 +343,7 @@ static int resume_target_kernel(void)
 			"aborting resume\n");
 		goto Enable_irqs;
 	}
+	sysdev_suspend();
 	/* We'll ignore saved state, but this gets preempt count (etc) right */
 	save_processor_state();
 	error = restore_highmem();
@@ -357,6 +366,7 @@ static int resume_target_kernel(void)
 	swsusp_free();
 	restore_processor_state();
 	touch_softlockup_watchdog();
+	sysdev_resume();
 	device_power_up(PMSG_RECOVER);
  Enable_irqs:
 	local_irq_enable();
@@ -440,6 +450,7 @@ int hibernation_platform_enter(void)
 	local_irq_disable();
 	error = device_power_down(PMSG_HIBERNATE);
 	if (!error) {
+		sysdev_suspend();
 		hibernation_ops->enter();
 		/* We should never get here */
 		while (1);
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 2399888..7709556 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -298,8 +298,12 @@ static int suspend_enter(suspend_state_t state)
 		goto Done;
 	}
 
-	if (!suspend_test(TEST_CORE))
-		error = suspend_ops->enter(state);
+	error = sysdev_suspend();
+	if (!error) {
+		if (!suspend_test(TEST_CORE))
+			error = suspend_ops->enter(state);
+		sysdev_resume();
+	}
 
 	device_power_up(PMSG_RESUME);
  Done:
