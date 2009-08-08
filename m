Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbZHHAVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbZHHAVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 20:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZHHAVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 20:21:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38679 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbZHHAVV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 20:21:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH V2 0/4] introduce device async actions mechanism
Date: Sat, 8 Aug 2009 02:22:03 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, "dtor@mail.ru" <dtor@mail.ru>
References: <1248404514.2670.107.camel@rzhang-dt> <200908041821.26578.rjw@sisk.pl> <1249439048.2670.454.camel@rzhang-dt>
In-Reply-To: <1249439048.2670.454.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908080222.03172.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 August 2009, Zhang Rui wrote:
> On Wed, 2009-08-05 at 00:21 +0800, Rafael J. Wysocki wrote:
> > On Tuesday 04 August 2009, Zhang Rui wrote:
> > > On Tue, 2009-08-04 at 05:18 +0800, Rafael J. Wysocki wrote:
> > > > On Friday 24 July 2009, Zhang Rui wrote:
> > > > > Hi,
> > > > 
> > > > Hi,
> > > > 
> > > > > this is the patch set I made to speed up the device
> > > > > suspend/resume/shutdown process.
> > > > > 
> > > > > A new mechanism called Device Async Actions is introduced
> > > > > in this patch set.
> > > > 
> > > > Well, I'm not sure we'll need that.
> > > > 
> > > > > The basic idea is that,
> > > > > if the suspend/resume/shutdown process of a device group, including
> > > > > a root device and its child devices, are independent of other devices,
> > > > > we create an async domain for this device group,
> > > > > and make them suspend/resume/shutdown asynchronously.    
> > > > 
> > > > I don't really think this is the right approach.  IMO, we should rather try to
> > > > identify groups of devices for which the PM callbacks (forget about .shutdown()
> > > > for now) can be executed in parallel.
> > > 
> > > hah, I see.
> > > You want to execute as more PM callbacks﻿ at one time as possible,
> > > right?
> > 
> > Not only that.  I'd like to simplify the design, because IMO using one async
> > domain would be much more straightforward than using multiple ones.
> > 
> something like this?
> 
> 1. device suspend/resume are split into several stages. And the PM
> callbacks of every device should be put into one of these stage.

That's correct.

> 2. run all the PM callbacks in current stage asynchronously, in the
> global domain.

Yes, except that not all of the PM callbacks at given stage may be run in
parallel with each other.

Generally speaking, it should be possible to divide the device tree into
layers, where each layer contains devices for which the PM callbacks can be
executed in parallel and where the PM callbacks from layer 1 should be executed
before the PM callbacks from layer 2 and so on.

Now the question is how to determine which layer to put given device into.
Of course the leaf devices with no dependencies and the other devices is the
simplest possible way of dividing devices into such layers, but in principle
it should be possible to identify more layers.

Alternatively we can identify branches of the device tree that can be handled
in parallel, which I think was your idea, wasn't it?  It also might work, but
for this purpose we'd have to divide dpm_list into several lists and call
dpm_resume() etc. for them in parallel.  Seems doable too.

> 3. run async_synchronize_full to finish the current state.

Yes.

> 4. stage++, and goto step 2.

Something like this.

> > > I'm afraid this won't bring as many benefits as it looks like because
> > > most of the suspend/resume time is cost on several specified devices.
> > 
> > That shouldn't matter.  As long as there's one driver that waits long enough
> > for the others' devices to be handled while it's waiting, we are not going
> > to be hurt by this and the design is going to be simpler IMO.
> > 
> > > Take the dmesg I attached for example.
> > > 
> > > total device suspend time is 1.532s.
> > > serio2		0.407s
> > > sd 0.0.0.0	0.452s
> > > serio0		0.103s
> > > 0b.4.2		0.114s
> > > 00.1f.2		0.080s
> > > 00.19.0		0.072s
> > > all the others	0.304s
> > > 
> > > total device resume time is 2.899s
> > > PNP0C0A:00(bat)	0.896s
> > > 00.19.0		0.056s
> > > 0b.4.0		0.139s
> > > 0b.1.1		0.064s
> > > usb1		0.052s
> > > usb2		0.051s
> > > usb3		0.042s
> > > usb8		0.248s
> > > sd 0.0.0.0	0.118s
> > > usb 3-1		0.261s
> > > usb 8-1		0.511s
> > > all the others	0.461s
> > > 
> > > We can see that these several devices take 80%~85% suspend/resume time,
> > > while all the other (nearly 500) devices take 20%.
> > 
> > OK, so it doesn't matter how we run the suspend/resume of the 500 'fast'
> > devices as long as it doesn't take more than 0.896s total.  In particular, it
> > seems we can do that in parallel just fine.
> > 
> > > Running a lot device PM callbacks at one time is not equal to saving a
> > > lot time if the devices listed above still run synchronously.
> > > 
> > > So I think the key point to speed up suspend/resume is to invoke the PM
> > > callbacks of these devices asynchronously.
> > > And I use the asynchronous functions for two reasons.
> > > 1. devices with dependency are in the same asynchronous domain so that
> > >    their PM callbacks run in-order.
> > > ﻿2. PM callbacks of the devices without any dependency run
> > > asynchronously
> > >    by using different asynchronous domains.
> > 
> > If I understand the async framework correctly, the domains are only used for
> > synchronization, ie. if you want to wait for a group of async operations to
> > complete, you can put them all into one domain and then call
> > async_synchronize_full_domain() to wait for them all together.
> > 
> yes, you're right.
> please ignore my previous reply in this thread.
> 
> > You don't need multiple domains to run multiple things in parallel.
> > 
> > > > One such group is leaf devices, ie.
> > > > devices that have no children.  Of course, some of them will depend of the
> > > > other indirectly, so we should make it possible to declare (in the driver)
> > > > whether the device can be suspended/resumed asynchronously and use the
> > > > following logic (at the core level), in pseudo code:
> > > > 
> > > > if (has_no_children(dev) && asynchronous_suspend_resume_allowed(dev))
> > > >     async_resume(dev);
> > > > else
> > > >     resume(dev);
> > > > 
> > > > and analogously for suspend.  Then, we can easily use one async domain for all
> > > > of these devices.
> > > 
> > > > Later, we can add async domains for devices that have children, but can be
> > > > suspended and woken up in parallel with each other.
> > > >   IOW, I think the async
> > > > domains should span the levels rather than branches of the device
> > > > tree.
> > > > 
> > > 
> > > Hmm, as I said above,
> > > this approach works only if we can make sure that the specified devices
> > > are put in the same async domain, i.e. run in parallel.
> > 
> > Sure and that's the point.
> > 
> > For starters, let's put all devices (or rather drivers) without any
> > dependencies
> 
> you still mean the leaf devices here, don't you?

Yes.

> >  into one async domain and call suspend/resume for them using the
> > async framework (they will be suspended/resumed in parallel with each other as
> > well as in parallel with the rest).  Then, let's call
> > async_synchronize_full_domain() for that domain when we've finished executing
> > all of the suspend/resume callbacks.
> > 
> right.
> but I'm afraid it's not easy to find a group of non-leaf devices without any
> dependency.
> 
> > We can easily do such a thing for each phase of suspend/resume
> >  or hibernation
> > without causing any problems to happen IMO, as long as the 'async' drivers
> > really have no dependencies.
> > 
> sure, the proposal is good.
> But my concern is how to find out these async domains? i.e. how to find
> out groups of devices without dependency so that we can suspend/resume
> devices in the same group in parallel?
> 
> You said that ﻿the async domains should span the levels rather than
> branches of the device tree.
> do you mean suspend/resume all the devices in the same level in
> parallel?
> 
> > > are there any prototype patches available?
> > 
> > No, because I didn't have the time to prepare any.  If you give me a couple of
> > days, I can write something.  I think.
> > 
> Sure. don't forget to CC me when you send them out.

OK, the patch below illustrates my idea, but it's only done for "leaf devices
with no dependencies" and "other devices".  It only contains the resume part
which is simpler to implement.

Best,
Rafael

---
 drivers/acpi/battery.c      |    1 
 drivers/base/core.c         |   11 ++++
 drivers/base/power/main.c   |  102 +++++++++++++++++++++++++++++++++++++++-----
 drivers/base/power/power.h  |    1 
 drivers/input/serio/i8042.c |    2 
 include/linux/device.h      |    6 ++
 include/linux/pm.h          |    4 +
 7 files changed, 117 insertions(+), 10 deletions(-)

Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -333,9 +333,13 @@ struct dev_pm_info {
 	pm_message_t		power_state;
 	unsigned		can_wakeup:1;
 	unsigned		should_wakeup:1;
+	unsigned		async_pm:1;
 	enum dpm_state		status;		/* Owned by the PM core */
 #ifdef	CONFIG_PM_SLEEP
 	struct list_head	entry;
+	struct list_head	async_entry;
+	pm_message_t		async_state;
+	int			async_error;
 #endif
 };
 
Index: linux-2.6/include/linux/device.h
===================================================================
--- linux-2.6.orig/include/linux/device.h
+++ linux-2.6/include/linux/device.h
@@ -472,6 +472,11 @@ static inline int device_is_registered(s
 	return dev->kobj.state_in_sysfs;
 }
 
+static inline void device_enable_async_pm(struct device *dev, bool enable)
+{
+	dev->power.async_pm = enable;
+}
+
 void driver_init(void);
 
 /*
@@ -482,6 +487,7 @@ extern void device_unregister(struct dev
 extern void device_initialize(struct device *dev);
 extern int __must_check device_add(struct device *dev);
 extern void device_del(struct device *dev);
+extern bool device_has_children(struct device *dev);
 extern int device_for_each_child(struct device *dev, void *data,
 		     int (*fn)(struct device *dev, void *data));
 extern struct device *device_find_child(struct device *dev, void *data,
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -24,6 +24,7 @@
 #include <linux/resume-trace.h>
 #include <linux/rwsem.h>
 #include <linux/interrupt.h>
+#include <linux/async.h>
 
 #include "../base.h"
 #include "power.h"
@@ -39,6 +40,7 @@
  */
 
 LIST_HEAD(dpm_list);
+static LIST_HEAD(async_pm);
 
 static DEFINE_MUTEX(dpm_list_mtx);
 
@@ -151,6 +153,26 @@ void device_pm_move_last(struct device *
 	list_move_tail(&dev->power.entry, &dpm_list);
 }
 
+static bool async_pm_allowed(struct device *dev)
+{
+	return dev->power.async_pm && !device_has_children(dev);
+}
+
+static int dpm_async_synchronize(void)
+{
+	struct device *dev;
+
+	async_synchronize_full();
+
+	list_for_each_entry(dev, &async_pm, power.async_entry) {
+		dev_info(dev, "PM: async_error = %d\n", dev->power.async_error);
+		if (dev->power.async_error)
+			return dev->power.async_error;
+	}
+
+	return 0;
+}
+
 /**
  *	pm_op - execute the PM operation appropiate for given PM event
  *	@dev:	Device.
@@ -317,13 +339,14 @@ static void pm_dev_err(struct device *de
 /*------------------------- Resume routines -------------------------*/
 
 /**
- *	device_resume_noirq - Power on one device (early resume).
- *	@dev:	Device.
- *	@state: PM transition of the system being carried out.
+ * __device_resume_noirq - Execute an "early resume" callback for given device.
+ * @dev: Device to resume.
+ * @state: PM transition of the system being carried out.
  *
- *	Must be called with interrupts disabled.
+ * The driver of the device won't receive interrupts while this function is
+ * being executed.
  */
-static int device_resume_noirq(struct device *dev, pm_message_t state)
+static int __device_resume_noirq(struct device *dev, pm_message_t state)
 {
 	int error = 0;
 
@@ -342,6 +365,31 @@ static int device_resume_noirq(struct de
 	return error;
 }
 
+static void async_resume_noirq(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error;
+
+	pm_dev_dbg(dev, dev->power.async_state, "async ");
+	error = __device_resume_noirq(dev, dev->power.async_state);
+	if (error)
+		pm_dev_err(dev, dev->power.async_state, " async early", error);
+	dev->power.async_error = error;
+	put_device(dev);
+}
+
+static int device_resume_noirq(struct device *dev, pm_message_t state)
+{
+	if (async_pm_allowed(dev)) {
+		get_device(dev);
+		dev->power.async_state = state;
+		async_schedule(async_resume_noirq, dev);
+		return 0;
+	}
+
+	return __device_resume_noirq(dev, state);
+}
+
 /**
  *	dpm_resume_noirq - Power on all regular (non-sysdev) devices.
  *	@state: PM transition of the system being carried out.
@@ -366,17 +414,18 @@ void dpm_resume_noirq(pm_message_t state
 			if (error)
 				pm_dev_err(dev, state, " early", error);
 		}
+	dpm_async_synchronize();
 	mutex_unlock(&dpm_list_mtx);
 	resume_device_irqs();
 }
 EXPORT_SYMBOL_GPL(dpm_resume_noirq);
 
 /**
- *	device_resume - Restore state for one device.
- *	@dev:	Device.
- *	@state: PM transition of the system being carried out.
+ * __device_resume - Call a "resume" callback for given device.
+ * @dev: Device to resume.
+ * @state: PM transition of the system being carried out.
  */
-static int device_resume(struct device *dev, pm_message_t state)
+static int __device_resume(struct device *dev, pm_message_t state)
 {
 	int error = 0;
 
@@ -422,6 +471,31 @@ static int device_resume(struct device *
 	return error;
 }
 
+static void async_resume(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error;
+
+	pm_dev_dbg(dev, dev->power.async_state, "async ");
+	error = __device_resume(dev, dev->power.async_state);
+	if (error)
+		pm_dev_err(dev, dev->power.async_state, " async", error);
+	dev->power.async_error = error;
+	put_device(dev);
+}
+
+static int device_resume(struct device *dev, pm_message_t state)
+{
+	if (async_pm_allowed(dev)) {
+		get_device(dev);
+		dev->power.async_state = state;
+		async_schedule(async_resume, dev);
+		return 0;
+	}
+
+	return __device_resume(dev, state);
+}
+
 /**
  *	dpm_resume - Resume every device.
  *	@state: PM transition of the system being carried out.
@@ -460,6 +534,7 @@ static void dpm_resume(pm_message_t stat
 		put_device(dev);
 	}
 	list_splice(&list, &dpm_list);
+	dpm_async_synchronize();
 	mutex_unlock(&dpm_list_mtx);
 }
 
@@ -509,6 +584,8 @@ static void dpm_complete(pm_message_t st
 		get_device(dev);
 		if (dev->power.status > DPM_ON) {
 			dev->power.status = DPM_ON;
+			if (async_pm_allowed(dev))
+				list_del_init(&dev->power.async_entry);
 			mutex_unlock(&dpm_list_mtx);
 
 			device_complete(dev, state);
@@ -774,8 +851,13 @@ static int dpm_prepare(pm_message_t stat
 			break;
 		}
 		dev->power.status = DPM_SUSPENDING;
-		if (!list_empty(&dev->power.entry))
+		if (!list_empty(&dev->power.entry)) {
 			list_move_tail(&dev->power.entry, &list);
+			if (async_pm_allowed(dev)) {
+				dev->power.async_error = 0;
+				list_add(&dev->power.async_entry, &async_pm);
+			}
+		}
 		put_device(dev);
 	}
 	list_splice(&list, &dpm_list);
Index: linux-2.6/drivers/base/core.c
===================================================================
--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -1177,6 +1177,17 @@ const char *device_get_nodename(struct d
 	return *tmp;
 }
 
+bool device_has_children(struct device *parent)
+{
+	struct klist_iter i;
+
+	if (!parent->p)
+		return false;
+
+	klist_iter_init(&parent->p->klist_children, &i);
+	return !!next_device(&i);
+}
+
 /**
  * device_for_each_child - device child iterator.
  * @parent: parent struct device.
Index: linux-2.6/drivers/base/power/power.h
===================================================================
--- linux-2.6.orig/drivers/base/power/power.h
+++ linux-2.6/drivers/base/power/power.h
@@ -1,6 +1,7 @@
 static inline void device_pm_init(struct device *dev)
 {
 	dev->power.status = DPM_ON;
+	dev->power.async_pm = false;
 }
 
 #ifdef CONFIG_PM_SLEEP
Index: linux-2.6/drivers/input/serio/i8042.c
===================================================================
--- linux-2.6.orig/drivers/input/serio/i8042.c
+++ linux-2.6/drivers/input/serio/i8042.c
@@ -1289,6 +1289,8 @@ static int __init i8042_init(void)
 	if (err)
 		goto err_free_device;
 
+	device_enable_async_pm(&i8042_platform_device->dev, true);
+
 	panic_blink = i8042_panic_blink;
 
 	return 0;
Index: linux-2.6/drivers/acpi/battery.c
===================================================================
--- linux-2.6.orig/drivers/acpi/battery.c
+++ linux-2.6/drivers/acpi/battery.c
@@ -837,6 +837,7 @@ static int acpi_battery_add(struct acpi_
 		printk(KERN_INFO PREFIX "%s Slot [%s] (battery %s)\n",
 			ACPI_BATTERY_DEVICE_NAME, acpi_device_bid(device),
 			device->status.battery_present ? "present" : "absent");
+		device_enable_async_pm(&device->dev, true);
 	} else {
 #ifdef CONFIG_ACPI_PROCFS_POWER
 		acpi_battery_remove_fs(device);


