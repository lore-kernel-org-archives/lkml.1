Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbZEWXUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbZEWXUj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 19:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbZEWXUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 19:20:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59355 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbZEWXUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 19:20:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: INFO: possible circular locking dependency at cleanup_workqueue_thread
Date: Sun, 24 May 2009 01:20:29 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com> <200905230023.16377.rjw@sisk.pl> <1243066902.4606.42.camel@johannes.local>
In-Reply-To: <1243066902.4606.42.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905240120.30336.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 May 2009, Johannes Berg wrote:
> On Sat, 2009-05-23 at 00:23 +0200, Rafael J. Wysocki wrote:
> 
> > > I just arrived at the same conclusion, heh. I can't say I understand
> > > these changes though, the part about calling the platform differently
> > > may make sense, but calling why disable non-boot CPUs at a different
> > > place?
> > 
> > Because the ordering of platform callbacks and cpu[_up()|_down()] is also
> > important, at least on resume.
> > 
> > In principle we can call device_pm_unlock() right before calling
> > disable_nonboot_cpus() and take the lock again right after calling
> > enable_nonboot_cpus(), if that helps.
> 
> Probably, unless the cpu_add_remove_lock wasn't a red herring after all.
> I'd test, but I don't have much time today, will be travelling tomorrow
> and be at UDS all week next week so I don't know when I'll get to it --
> could you provide a patch and also attach it to
> http://bugzilla.kernel.org/show_bug.cgi?id=13245 please? Miles (the
> reporter of that bug) has been very helpful in testing before.

OK

The patch is appended for reference (Alan, please have a look; I can't recall
why exactly we have called device_pm_lock() from the core suspend/hibernation
code instead of acquiring the lock locally in drivers/base/power/main.c) and
I'll attach it to the bug entry too.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Do not hold dpm_list_mtx while disabling/enabling nonboot CPUs

We shouldn't hold dpm_list_mtx while executing
[disable|enable]_nonboot_cpus(), because theoretically this may lead
to a deadlock as shown by the following example (provided by Johannes
Berg):

CPU 3       CPU 2                     CPU 1
                                      suspend/hibernate
            something:
            rtnl_lock()               device_pm_lock()
                                       -> mutex_lock(&dpm_list_mtx)

            mutex_lock(&dpm_list_mtx)

linkwatch_work
 -> rtnl_lock()
                                      disable_nonboot_cpus()
                                       -> flush CPU 3 workqueue

Fortunately, device drivers are supposed to stop any activities that
might lead to the registration of new device objects and/or to the
removal of the existing ones way before disable_nonboot_cpus() is
called, so it shouldn't be necessary to hold dpm_list_mtx over the
entire late part of device suspend and early part of device resume.

Thus, during the late suspend and the early resume of devices acquire
dpm_list_mtx only when dpm_list is going to be traversed and release
it right after that.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |    4 ++++
 kernel/kexec.c            |    2 --
 kernel/power/disk.c       |   21 +++------------------
 kernel/power/main.c       |    7 +------
 4 files changed, 8 insertions(+), 26 deletions(-)

Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c
+++ linux-2.6/kernel/power/disk.c
@@ -215,8 +215,6 @@ static int create_image(int platform_mod
 	if (error)
 		return error;
 
-	device_pm_lock();
-
 	/* At this point, device_suspend() has been called, but *not*
 	 * device_power_down(). We *must* call device_power_down() now.
 	 * Otherwise, drivers for some devices (e.g. interrupt controllers)
@@ -227,7 +225,7 @@ static int create_image(int platform_mod
 	if (error) {
 		printk(KERN_ERR "PM: Some devices failed to power down, "
 			"aborting hibernation\n");
-		goto Unlock;
+		return error;
 	}
 
 	error = platform_pre_snapshot(platform_mode);
@@ -280,9 +278,6 @@ static int create_image(int platform_mod
 	device_power_up(in_suspend ?
 		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
 
- Unlock:
-	device_pm_unlock();
-
 	return error;
 }
 
@@ -348,13 +343,11 @@ static int resume_target_kernel(bool pla
 {
 	int error;
 
-	device_pm_lock();
-
 	error = device_power_down(PMSG_QUIESCE);
 	if (error) {
 		printk(KERN_ERR "PM: Some devices failed to power down, "
 			"aborting resume\n");
-		goto Unlock;
+		return error;
 	}
 
 	error = platform_pre_restore(platform_mode);
@@ -407,9 +400,6 @@ static int resume_target_kernel(bool pla
 
 	device_power_up(PMSG_RECOVER);
 
- Unlock:
-	device_pm_unlock();
-
 	return error;
 }
 
@@ -468,11 +458,9 @@ int hibernation_platform_enter(void)
 		goto Resume_devices;
 	}
 
-	device_pm_lock();
-
 	error = device_power_down(PMSG_HIBERNATE);
 	if (error)
-		goto Unlock;
+		goto Resume_devices;
 
 	error = hibernation_ops->prepare();
 	if (error)
@@ -497,9 +485,6 @@ int hibernation_platform_enter(void)
 
 	device_power_up(PMSG_RESTORE);
 
- Unlock:
-	device_pm_unlock();
-
  Resume_devices:
 	entering_platform_hibernation = false;
 	device_resume(PMSG_RESTORE);
Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -271,12 +271,10 @@ static int suspend_enter(suspend_state_t
 {
 	int error;
 
-	device_pm_lock();
-
 	if (suspend_ops->prepare) {
 		error = suspend_ops->prepare();
 		if (error)
-			goto Done;
+			return error;
 	}
 
 	error = device_power_down(PMSG_SUSPEND);
@@ -325,9 +323,6 @@ static int suspend_enter(suspend_state_t
 	if (suspend_ops->finish)
 		suspend_ops->finish();
 
- Done:
-	device_pm_unlock();
-
 	return error;
 }
 
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -357,6 +357,7 @@ static void dpm_power_up(pm_message_t st
 {
 	struct device *dev;
 
+	mutex_lock(&dpm_list_mtx);
 	list_for_each_entry(dev, &dpm_list, power.entry)
 		if (dev->power.status > DPM_OFF) {
 			int error;
@@ -366,6 +367,7 @@ static void dpm_power_up(pm_message_t st
 			if (error)
 				pm_dev_err(dev, state, " early", error);
 		}
+	mutex_unlock(&dpm_list_mtx);
 }
 
 /**
@@ -614,6 +616,7 @@ int device_power_down(pm_message_t state
 	int error = 0;
 
 	suspend_device_irqs();
+	mutex_lock(&dpm_list_mtx);
 	list_for_each_entry_reverse(dev, &dpm_list, power.entry) {
 		error = suspend_device_noirq(dev, state);
 		if (error) {
@@ -622,6 +625,7 @@ int device_power_down(pm_message_t state
 		}
 		dev->power.status = DPM_OFF_IRQ;
 	}
+	mutex_unlock(&dpm_list_mtx);
 	if (error)
 		device_power_up(resume_event(state));
 	return error;
Index: linux-2.6/kernel/kexec.c
===================================================================
--- linux-2.6.orig/kernel/kexec.c
+++ linux-2.6/kernel/kexec.c
@@ -1451,7 +1451,6 @@ int kernel_kexec(void)
 		error = device_suspend(PMSG_FREEZE);
 		if (error)
 			goto Resume_console;
-		device_pm_lock();
 		/* At this point, device_suspend() has been called,
 		 * but *not* device_power_down(). We *must*
 		 * device_power_down() now.  Otherwise, drivers for
@@ -1489,7 +1488,6 @@ int kernel_kexec(void)
 		enable_nonboot_cpus();
 		device_power_up(PMSG_RESTORE);
  Resume_devices:
-		device_pm_unlock();
 		device_resume(PMSG_RESTORE);
  Resume_console:
 		resume_console();
