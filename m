Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbXGXPRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbXGXPRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 11:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbXGXPRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 11:17:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55438 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbXGXPRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 11:17:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Towards eliminating the freezer
Date: Tue, 24 Jul 2007 17:24:49 +0200
User-Agent: KMail/1.9.5
Cc: Oliver Neukum <oliver@neukum.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0707241027280.3568-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707241027280.3568-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707241724.50330.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 24 July 2007 16:29, Alan Stern wrote:
> On Tue, 24 Jul 2007, Rafael J. Wysocki wrote:
> 
> > > Now here's an idea which might work.  Can we require every caller of
> > > device_add() to hold some existing device's semaphore?  Normally it
> > > would be the semaphore of the new device's parent, but it could be a
> > > higher ancestor.  There even could be a single "root" semaphore for
> > > drivers registering a top-level device with no parent.
> > > 
> > > (Some testing shows that during startup things like ACPI and IDE don't 
> > > fulfill this requirement, so maybe we should require it only after 
> > > userspace has begun running.  After all, the system can't suspend 
> > > until then.)
> > > 
> > > It seems like a reasonable sort of thing to do.  Hotplugged devices
> > > tend to be registered as they are discovered by their parent's driver,
> > > so it shouldn't be too much to ask that the parent's semaphore be held
> > > when the new device is registered.  Static devices generally aren't
> > > quite so nice; the serial and floppy drivers in particular would need a
> > > little work (and probably some other drivers too).
> > > 
> > > If we do this, then once the PM core has acquired the semaphore for 
> > > every device it will be guaranteed that no new devices can be added.  
> > > It would be a simple solution to a rather nasty problem.
> > 
> > Hmm, in device_pm_add() and device_pm_remove() we acquire dpm_list_mtx which
> > also is acquired by device_suspend() and device_resume().  Thus, every attempt
> > to register a new device or unregister an existing one will be blocked while
> > either device_suspend() or device_resume() is running.
> > 
> > If we arrange things so that dpm_list_mtx is acquired, but not released, by
> > device_suspend() and released, but not acquired, by device_resume(), then it
> > won't be possible to register/unregister a device during a suspend-resume
> > cycle.
> 
> As with Oliver's suggestion, this would create a locking order 
> violation.  Drivers registering children (and thus acquiring 
> dpm_list_mtx) will often already hold the parent's sem.  But 
> device_suspend() needs to acquire device sems while holding 
> dpm_list_mtx.

Hmm, but this is done already (ie. device_suspend() acquires device sems
while holding dpm_list_mtx in the current code).

What I'm suggesting is not to let device_suspend() release dpm_list_mtx
when it's finished.  The appended patch illustrates that I mean.

Greetings,
Rafael


---
dpm_list_mtx is used by the PM core to prevent device objects from being
added/removed while device_suspend() and device_resume() are running.  However,
it should also be impossible to add a device after device_suspend() has
finished, because at that time the dpm_active list is empty and adding new
devices to it would break the ordering of devices during the next suspend.
Thus, it seems reasonable to leave device_suspend() with dpm_list_mtx held
and release at the end of device_resume().

In that case device_suspend() and device_resume() cannot be run concurrently
and dpm_mtx is no longer needed.  Also, it's a bug to run device_resume() after
a failing device_suspend(), so the APM code needs to be updated.

---
 arch/i386/kernel/apm.c       |    5 ++++-
 drivers/base/power/main.c    |    1 -
 drivers/base/power/power.h   |    5 -----
 drivers/base/power/resume.c  |    3 ---
 drivers/base/power/suspend.c |    3 ---
 5 files changed, 4 insertions(+), 13 deletions(-)

Index: linux-2.6.23-rc1/arch/i386/kernel/apm.c
===================================================================
--- linux-2.6.23-rc1.orig/arch/i386/kernel/apm.c	2007-07-23 22:28:35.000000000 +0200
+++ linux-2.6.23-rc1/arch/i386/kernel/apm.c	2007-07-24 11:04:45.000000000 +0200
@@ -1202,7 +1202,9 @@ static int suspend(int vetoable)
 		printk(KERN_CRIT "apm: suspend was vetoed, but suspending anyway.\n");
 	}
 
-	device_suspend(PMSG_SUSPEND);
+	err = device_suspend(PMSG_SUSPEND);
+	if (err)
+		goto send_resume;
 	local_irq_disable();
 	device_power_down(PMSG_SUSPEND);
 
@@ -1224,6 +1226,7 @@ static int suspend(int vetoable)
 	device_power_up();
 	local_irq_enable();
 	device_resume();
+ send_resume:
 	pm_send_all(PM_RESUME, (void *)0);
 	queue_event(APM_NORMAL_RESUME, NULL);
  out:
Index: linux-2.6.23-rc1/drivers/base/power/resume.c
===================================================================
--- linux-2.6.23-rc1.orig/drivers/base/power/resume.c	2007-07-23 22:06:42.000000000 +0200
+++ linux-2.6.23-rc1/drivers/base/power/resume.c	2007-07-24 11:18:04.000000000 +0200
@@ -72,7 +72,6 @@ static int resume_device_early(struct de
  */
 void dpm_resume(void)
 {
-	mutex_lock(&dpm_list_mtx);
 	while(!list_empty(&dpm_off)) {
 		struct list_head * entry = dpm_off.next;
 		struct device * dev = to_device(entry);
@@ -99,9 +98,7 @@ void dpm_resume(void)
 void device_resume(void)
 {
 	might_sleep();
-	mutex_lock(&dpm_mtx);
 	dpm_resume();
-	mutex_unlock(&dpm_mtx);
 }
 
 EXPORT_SYMBOL_GPL(device_resume);
Index: linux-2.6.23-rc1/drivers/base/power/suspend.c
===================================================================
--- linux-2.6.23-rc1.orig/drivers/base/power/suspend.c	2007-07-23 22:06:42.000000000 +0200
+++ linux-2.6.23-rc1/drivers/base/power/suspend.c	2007-07-24 11:17:52.000000000 +0200
@@ -127,7 +127,6 @@ int device_suspend(pm_message_t state)
 	int error = 0;
 
 	might_sleep();
-	mutex_lock(&dpm_mtx);
 	mutex_lock(&dpm_list_mtx);
 	while (!list_empty(&dpm_active) && error == 0) {
 		struct list_head * entry = dpm_active.prev;
@@ -153,11 +152,9 @@ int device_suspend(pm_message_t state)
 				error == -EAGAIN ? " (please convert to suspend_late)" : "");
 		put_device(dev);
 	}
-	mutex_unlock(&dpm_list_mtx);
 	if (error)
 		dpm_resume();
 
-	mutex_unlock(&dpm_mtx);
 	return error;
 }
 
Index: linux-2.6.23-rc1/drivers/base/power/main.c
===================================================================
--- linux-2.6.23-rc1.orig/drivers/base/power/main.c	2007-07-23 22:06:42.000000000 +0200
+++ linux-2.6.23-rc1/drivers/base/power/main.c	2007-07-24 11:17:16.000000000 +0200
@@ -28,7 +28,6 @@ LIST_HEAD(dpm_active);
 LIST_HEAD(dpm_off);
 LIST_HEAD(dpm_off_irq);
 
-DEFINE_MUTEX(dpm_mtx);
 DEFINE_MUTEX(dpm_list_mtx);
 
 int (*platform_enable_wakeup)(struct device *dev, int is_on);
Index: linux-2.6.23-rc1/drivers/base/power/power.h
===================================================================
--- linux-2.6.23-rc1.orig/drivers/base/power/power.h	2007-07-23 22:06:42.000000000 +0200
+++ linux-2.6.23-rc1/drivers/base/power/power.h	2007-07-24 11:17:33.000000000 +0200
@@ -12,11 +12,6 @@ extern void device_shutdown(void);
  */
 
 /*
- * Used to synchronize global power management operations.
- */
-extern struct mutex dpm_mtx;
-
-/*
  * Used to serialize changes to the dpm_* lists.
  */
 extern struct mutex dpm_list_mtx;
