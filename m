Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231AbZDRNYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbZDRNYU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 09:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbZDRNYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 09:24:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44774 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599AbZDRNYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 09:24:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Russell King <rmk@arm.linux.org.uk>, Len Brown <lenb@kernel.org>
Subject: Re: 900af0d breaks some embedded suspend/resume
Date: Sat, 18 Apr 2009 15:23:35 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <20090417231009.GB6900@flint.arm.linux.org.uk>
In-Reply-To: <20090417231009.GB6900@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904181523.36010.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 April 2009, Russell King wrote:
> Some platforms need to talk via I2C to power control devices during
> the suspend method.  Currently, they do this via the platform PM ops
> prepare callback, relying on the I2C driver being hooked into the
> 'late' suspend method, and hence being shut down _after_ the prepare
> callback.

Well, I was not aware of this dependency and it seems quite unusual for a
platform to depend on a driver like this.

> However, as of the above commit, the ordering is changed such that
> platforms don't get notified of suspends until after all devices are
> well and truely shut down.
> 
> This can't work, and actively breaks some platforms.

Sorry for that.

The patchset in question had been discussed quite extensively before it was
merged and it's a pity none of the people caring for the affected platforms
took part in those discussions.  That would allow us to avoid the breakage.
 
> Please come up with another solution for your PCI problems,

I don't think this is possible, sorry.

> or provide alternative equivalent functionality where the platform code is
> notified of the PM event prior to the late suspend callback being issued.

There is the .begin() callback that could be used, but if you need the
platform to be notified _just_ prior to the late suspend callback, then the
only thing I can think of at the moment is the appended patch.

It shouldn't break anything in theory, because the majority of drivers put
their devices into low power states in the "regular" suspend callbacks anyway.

Len, what do you think?

Thanks,
Rafael

---
 kernel/power/disk.c |   43 +++++++++++++++++++++++--------------------
 kernel/power/main.c |   19 +++++++++----------
 2 files changed, 32 insertions(+), 30 deletions(-)

Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -291,21 +291,21 @@ static int suspend_enter(suspend_state_t
 
 	device_pm_lock();
 
-	error = device_power_down(PMSG_SUSPEND);
-	if (error) {
-		printk(KERN_ERR "PM: Some devices failed to power down\n");
-		goto Done;
-	}
-
 	if (suspend_ops->prepare) {
 		error = suspend_ops->prepare();
 		if (error)
-			goto Power_up_devices;
+			goto Done;
 	}
 
 	if (suspend_test(TEST_PLATFORM))
 		goto Platfrom_finish;
 
+	error = device_power_down(PMSG_SUSPEND);
+	if (error) {
+		printk(KERN_ERR "PM: Some devices failed to power down\n");
+		goto Platfrom_finish;
+	}
+
 	error = disable_nonboot_cpus();
 	if (error || suspend_test(TEST_CPUS))
 		goto Enable_cpus;
@@ -326,13 +326,12 @@ static int suspend_enter(suspend_state_t
  Enable_cpus:
 	enable_nonboot_cpus();
 
+	device_power_up(PMSG_RESUME);
+
  Platfrom_finish:
 	if (suspend_ops->finish)
 		suspend_ops->finish();
 
- Power_up_devices:
-	device_power_up(PMSG_RESUME);
-
  Done:
 	device_pm_unlock();
 
Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c
+++ linux-2.6/kernel/power/disk.c
@@ -217,6 +217,13 @@ static int create_image(int platform_mod
 
 	device_pm_lock();
 
+	error = platform_pre_snapshot(platform_mode);
+	if (error)
+		goto Unlock;
+
+	if (hibernation_test(TEST_PLATFORM))
+		goto Platform_finish;
+
 	/* At this point, device_suspend() has been called, but *not*
 	 * device_power_down(). We *must* call device_power_down() now.
 	 * Otherwise, drivers for some devices (e.g. interrupt controllers)
@@ -227,12 +234,8 @@ static int create_image(int platform_mod
 	if (error) {
 		printk(KERN_ERR "PM: Some devices failed to power down, "
 			"aborting hibernation\n");
-		goto Unlock;
-	}
-
-	error = platform_pre_snapshot(platform_mode);
-	if (error || hibernation_test(TEST_PLATFORM))
 		goto Platform_finish;
+	}
 
 	error = disable_nonboot_cpus();
 	if (error || hibernation_test(TEST_CPUS)
@@ -274,12 +277,12 @@ static int create_image(int platform_mod
  Enable_cpus:
 	enable_nonboot_cpus();
 
- Platform_finish:
-	platform_finish(platform_mode);
-
 	device_power_up(in_suspend ?
 		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
 
+ Platform_finish:
+	platform_finish(platform_mode);
+
  Unlock:
 	device_pm_unlock();
 
@@ -346,16 +349,16 @@ static int resume_target_kernel(bool pla
 
 	device_pm_lock();
 
+	error = platform_pre_restore(platform_mode);
+	if (error)
+		goto Unlock;
+
 	error = device_power_down(PMSG_QUIESCE);
 	if (error) {
 		printk(KERN_ERR "PM: Some devices failed to power down, "
 			"aborting resume\n");
-		goto Unlock;
-	}
-
-	error = platform_pre_restore(platform_mode);
-	if (error)
 		goto Cleanup;
+	}
 
 	error = disable_nonboot_cpus();
 	if (error)
@@ -398,11 +401,11 @@ static int resume_target_kernel(bool pla
  Enable_cpus:
 	enable_nonboot_cpus();
 
+	device_power_up(PMSG_RECOVER);
+
  Cleanup:
 	platform_restore_cleanup(platform_mode);
 
-	device_power_up(PMSG_RECOVER);
-
  Unlock:
 	device_pm_unlock();
 
@@ -466,17 +469,17 @@ int hibernation_platform_enter(void)
 
 	device_pm_lock();
 
-	error = device_power_down(PMSG_HIBERNATE);
+	error = hibernation_ops->prepare();
 	if (error)
 		goto Unlock;
 
-	error = hibernation_ops->prepare();
+	error = device_power_down(PMSG_HIBERNATE);
 	if (error)
 		goto Platofrm_finish;
 
 	error = disable_nonboot_cpus();
 	if (error)
-		goto Platofrm_finish;
+		goto Power_up_devices;
 
 	local_irq_disable();
 	sysdev_suspend(PMSG_HIBERNATE);
@@ -484,6 +487,8 @@ int hibernation_platform_enter(void)
 	/* We should never get here */
 	while (1);
 
+ Power_up_devices:
+	device_power_up(PMSG_RESTORE);
 	/*
 	 * We don't need to reenable the nonboot CPUs or resume consoles, since
 	 * the system is going to be halted anyway.
@@ -491,8 +496,6 @@ int hibernation_platform_enter(void)
  Platofrm_finish:
 	hibernation_ops->finish();
 
-	device_power_up(PMSG_RESTORE);
-
  Unlock:
 	device_pm_unlock();
 
