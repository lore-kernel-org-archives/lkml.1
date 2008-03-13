Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbYCMKOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbYCMKOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 06:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbYCMKLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 06:11:48 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35274 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbYCMKLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 06:11:44 -0400
Date: Thu, 13 Mar 2008 10:28:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>
Subject: Re: pm_register() and pm_send_all()
Message-ID: <20080313092813.GA24027@elf.ucw.cz>
References: <20080312150042.96668bcd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312150042.96668bcd.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-03-12 15:00:42, Andrew Morton wrote:
> 
> This:
> 
> kernel/power/pm.c:203: warning: 'pm_register' is deprecated (declared at kernel/power/pm.c:62)
> kernel/power/pm.c:203: warning: 'pm_register' is deprecated (declared at kernel/power/pm.c:62)
> kernel/power/pm.c:204: warning: 'pm_send_all' is deprecated (declared at kernel/power/pm.c:178)
> kernel/power/pm.c:204: warning: 'pm_send_all' is deprecated (declared at kernel/power/pm.c:178)
> 
> is getting a bit boring.  These were marked deprecated at least three years
> ago.
> 
> 
> pm_register() no longer has any callers and afacit can be removed
> immediately.
> 
> pm_send_all() has just a handful of callers:
> 
> arch/x86/kernel/apm_32.c
> arch/mips/au1000/common/power.c
> arch/frv/kernel/pm.c

AFAICT pm_send_all is a nop when noone uses pm_register...

Hmm.. can we just force CONFIG_PM_LEGACY=n, and see what happens?

Or maybe this is better idea? It may break build somewhere, but it
should be easy to fix... (it builds here, i386 and x86-64).

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/arch/frv/kernel/pm.c b/arch/frv/kernel/pm.c
index c57ce3f..73f3aee 100644
--- a/arch/frv/kernel/pm.c
+++ b/arch/frv/kernel/pm.c
@@ -163,14 +163,11 @@ static int sysctl_pm_do_suspend(ctl_tabl
 	if ((mode != 1) && (mode != 5))
 		return -EINVAL;
 
-	retval = pm_send_all(PM_SUSPEND, (void *)3);
-
 	if (retval == 0) {
 		if (mode == 5)
 		    retval = pm_do_bus_sleep();
 		else
 		    retval = pm_do_suspend();
-		pm_send_all(PM_RESUME, (void *)0);
 	}
 
 	return retval;
@@ -183,9 +180,6 @@ static int try_set_cmode(int new_cmode)
 	if (!(clock_cmodes_permitted & (1<<new_cmode)))
 		return -EINVAL;
 
-	/* tell all the drivers we're suspending */
-	pm_send_all(PM_SUSPEND, (void *)3);
-
 	/* now change cmode */
 	local_irq_disable();
 	frv_dma_pause_all();
@@ -201,8 +195,6 @@ #endif
 	frv_dma_resume_all();
 	local_irq_enable();
 
-	/* tell all the drivers we're resuming */
-	pm_send_all(PM_RESUME, (void *)0);
 	return 0;
 }
 
diff --git a/arch/mips/au1000/common/power.c b/arch/mips/au1000/common/power.c
index 54047d6..a9f7f63 100644
--- a/arch/mips/au1000/common/power.c
+++ b/arch/mips/au1000/common/power.c
@@ -258,7 +258,6 @@ #endif
 static int pm_do_sleep(ctl_table * ctl, int write, struct file *file,
 		       void __user *buffer, size_t * len, loff_t *ppos)
 {
-	int retval = 0;
 #ifdef SLEEP_TEST_TIMEOUT
 #define TMPBUFLEN2 16
 	char buf[TMPBUFLEN2], *p;
@@ -278,33 +277,21 @@ #ifdef SLEEP_TEST_TIMEOUT
 		p = buf;
 		sleep_ticks = simple_strtoul(p, &p, 0);
 #endif
-		retval = pm_send_all(PM_SUSPEND, (void *) 2);
-
-		if (retval)
-			return retval;
 
 		au_sleep();
-		retval = pm_send_all(PM_RESUME, (void *) 0);
 	}
-	return retval;
+	return 0;
 }
 
 static int pm_do_suspend(ctl_table * ctl, int write, struct file *file,
 			 void __user *buffer, size_t * len, loff_t *ppos)
 {
-	int retval = 0;
-
 	if (!write) {
 		*len = 0;
 	} else {
-		retval = pm_send_all(PM_SUSPEND, (void *) 2);
-		if (retval)
-			return retval;
 		suspend_mode = 1;
-
-		retval = pm_send_all(PM_RESUME, (void *) 0);
 	}
-	return retval;
+	return 0;
 }
 
 
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index d4438ef..d7e92bf 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -1189,19 +1189,6 @@ static int suspend(int vetoable)
 	int err;
 	struct apm_user	*as;
 
-	if (pm_send_all(PM_SUSPEND, (void *)3)) {
-		/* Vetoed */
-		if (vetoable) {
-			if (apm_info.connection_version > 0x100)
-				set_system_power_state(APM_STATE_REJECT);
-			err = -EBUSY;
-			ignore_sys_suspend = 0;
-			printk(KERN_WARNING "apm: suspend was vetoed.\n");
-			goto out;
-		}
-		printk(KERN_CRIT "apm: suspend was vetoed, but suspending anyway.\n");
-	}
-
 	device_suspend(PMSG_SUSPEND);
 	local_irq_disable();
 	device_power_down(PMSG_SUSPEND);
@@ -1224,7 +1211,6 @@ static int suspend(int vetoable)
 	device_power_up();
 	local_irq_enable();
 	device_resume();
-	pm_send_all(PM_RESUME, (void *)0);
 	queue_event(APM_NORMAL_RESUME, NULL);
  out:
 	spin_lock(&user_list_lock);
@@ -1337,7 +1323,6 @@ #endif
 			if ((event != APM_NORMAL_RESUME)
 			    || (ignore_normal_resume == 0)) {
 				device_resume();
-				pm_send_all(PM_RESUME, (void *)0);
 				queue_event(event, NULL);
 			}
 			ignore_normal_resume = 0;
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index e2d7b39..d6d8f8b 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -19,16 +19,6 @@ config PM
 	  will issue the hlt instruction if nothing is to be done, thereby
 	  sending the processor to sleep and saving power.
 
-config PM_LEGACY
-	bool "Legacy Power Management API (DEPRECATED)"
-	depends on PM
-	default n
-	---help---
-	   Support for pm_register() and friends.  This old API is obsoleted
-	   by the driver model.
-
-	   If unsure, say N.
-
 config PM_DEBUG
 	bool "Power Management Debug Support"
 	depends on PM
diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index e5693d6..523abb9 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -4,7 +4,6 @@ EXTRA_CFLAGS	+=	-DDEBUG
 endif
 
 obj-y				:= main.o
-obj-$(CONFIG_PM_LEGACY)		+= pm.o
 obj-$(CONFIG_PM_SLEEP)		+= process.o console.o sleepy.o
 obj-$(CONFIG_HIBERNATION)	+= swsusp.o disk.o snapshot.o swap.o user.o
 
diff --git a/kernel/power/pm.c b/kernel/power/pm.c
deleted file mode 100644
index 60c73fa..0000000
--- a/kernel/power/pm.c
+++ /dev/null
@@ -1,205 +0,0 @@
-/*
- *  pm.c - Power management interface
- *
- *  Copyright (C) 2000 Andrew Henroid
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/spinlock.h>
-#include <linux/mm.h>
-#include <linux/slab.h>
-#include <linux/pm.h>
-#include <linux/pm_legacy.h>
-#include <linux/interrupt.h>
-#include <linux/mutex.h>
-
-/*
- *	Locking notes:
- *		pm_devs_lock can be a semaphore providing pm ops are not called
- *	from an interrupt handler (already a bad idea so no change here). Each
- *	change must be protected so that an unlink of an entry doesn't clash
- *	with a pm send - which is permitted to sleep in the current architecture
- *
- *	Module unloads clashing with pm events now work out safely, the module 
- *	unload path will block until the event has been sent. It may well block
- *	until a resume but that will be fine.
- */
- 
-static DEFINE_MUTEX(pm_devs_lock);
-static LIST_HEAD(pm_devs);
-
-/**
- *	pm_register - register a device with power management
- *	@type: device type 
- *	@id: device ID
- *	@callback: callback function
- *
- *	Add a device to the list of devices that wish to be notified about
- *	power management events. A &pm_dev structure is returned on success,
- *	on failure the return is %NULL.
- *
- *      The callback function will be called in process context and
- *      it may sleep.
- */
- 
-struct pm_dev *pm_register(pm_dev_t type,
-			   unsigned long id,
-			   pm_callback callback)
-{
-	struct pm_dev *dev = kzalloc(sizeof(struct pm_dev), GFP_KERNEL);
-	if (dev) {
-		dev->type = type;
-		dev->id = id;
-		dev->callback = callback;
-
-		mutex_lock(&pm_devs_lock);
-		list_add(&dev->entry, &pm_devs);
-		mutex_unlock(&pm_devs_lock);
-	}
-	return dev;
-}
-
-/**
- *	pm_send - send request to a single device
- *	@dev: device to send to
- *	@rqst: power management request
- *	@data: data for the callback
- *
- *	Issue a power management request to a given device. The 
- *	%PM_SUSPEND and %PM_RESUME events are handled specially. The
- *	data field must hold the intended next state. No call is made
- *	if the state matches.
- *
- *	BUGS: what stops two power management requests occurring in parallel
- *	and conflicting.
- *
- *	WARNING: Calling pm_send directly is not generally recommended, in
- *	particular there is no locking against the pm_dev going away. The
- *	caller must maintain all needed locking or have 'inside knowledge'
- *	on the safety. Also remember that this function is not locked against
- *	pm_unregister. This means that you must handle SMP races on callback
- *	execution and unload yourself.
- */
- 
-static int pm_send(struct pm_dev *dev, pm_request_t rqst, void *data)
-{
-	int status = 0;
-	unsigned long prev_state, next_state;
-
-	if (in_interrupt())
-		BUG();
-
-	switch (rqst) {
-	case PM_SUSPEND:
-	case PM_RESUME:
-		prev_state = dev->state;
-		next_state = (unsigned long) data;
-		if (prev_state != next_state) {
-			if (dev->callback)
-				status = (*dev->callback)(dev, rqst, data);
-			if (!status) {
-				dev->state = next_state;
-				dev->prev_state = prev_state;
-			}
-		}
-		else {
-			dev->prev_state = prev_state;
-		}
-		break;
-	default:
-		if (dev->callback)
-			status = (*dev->callback)(dev, rqst, data);
-		break;
-	}
-	return status;
-}
-
-/*
- * Undo incomplete request
- */
-static void pm_undo_all(struct pm_dev *last)
-{
-	struct list_head *entry = last->entry.prev;
-	while (entry != &pm_devs) {
-		struct pm_dev *dev = list_entry(entry, struct pm_dev, entry);
-		if (dev->state != dev->prev_state) {
-			/* previous state was zero (running) resume or
-			 * previous state was non-zero (suspended) suspend
-			 */
-			pm_request_t undo = (dev->prev_state
-					     ? PM_SUSPEND:PM_RESUME);
-			pm_send(dev, undo, (void*) dev->prev_state);
-		}
-		entry = entry->prev;
-	}
-}
-
-/**
- *	pm_send_all - send request to all managed devices
- *	@rqst: power management request
- *	@data: data for the callback
- *
- *	Issue a power management request to a all devices. The 
- *	%PM_SUSPEND events are handled specially. Any device is 
- *	permitted to fail a suspend by returning a non zero (error)
- *	value from its callback function. If any device vetoes a 
- *	suspend request then all other devices that have suspended 
- *	during the processing of this request are restored to their
- *	previous state.
- *
- *	WARNING:  This function takes the pm_devs_lock. The lock is not dropped until
- *	the callbacks have completed. This prevents races against pm locking
- *	functions, races against module unload pm_unregister code. It does
- *	mean however that you must not issue pm_ functions within the callback
- *	or you will deadlock and users will hate you.
- *
- *	Zero is returned on success. If a suspend fails then the status
- *	from the device that vetoes the suspend is returned.
- *
- *	BUGS: what stops two power management requests occurring in parallel
- *	and conflicting.
- */
- 
-int pm_send_all(pm_request_t rqst, void *data)
-{
-	struct list_head *entry;
-	
-	mutex_lock(&pm_devs_lock);
-	entry = pm_devs.next;
-	while (entry != &pm_devs) {
-		struct pm_dev *dev = list_entry(entry, struct pm_dev, entry);
-		if (dev->callback) {
-			int status = pm_send(dev, rqst, data);
-			if (status) {
-				/* return devices to previous state on
-				 * failed suspend request
-				 */
-				if (rqst == PM_SUSPEND)
-					pm_undo_all(dev);
-				mutex_unlock(&pm_devs_lock);
-				return status;
-			}
-		}
-		entry = entry->next;
-	}
-	mutex_unlock(&pm_devs_lock);
-	return 0;
-}
-
-EXPORT_SYMBOL(pm_register);
-EXPORT_SYMBOL(pm_send_all);
-


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
