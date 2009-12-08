Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbZLHMe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbZLHMe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 07:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbZLHMeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 07:34:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46907 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331AbZLHMem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 07:34:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
Date: Tue, 8 Dec 2009 13:35:01 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912072225390.4179-100000@netrider.rowland.org> <200912081323.50606.rjw@sisk.pl>
In-Reply-To: <200912081323.50606.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912081335.01969.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 December 2009, Rafael J. Wysocki wrote:
> On Tuesday 08 December 2009, Alan Stern wrote:
> > On Tue, 8 Dec 2009, Rafael J. Wysocki wrote:
> > 
> > > However, the parent can be on a different bus type than the children, so it
> > > looks like we can only start the asynchronous path at the core level.
> > 
> > Agreed.
> > 
> > > > Unless you want to do _all_ of the async logic in generic code and 
> > > > re-introduce the "dev->async_suspend" flag.
> > > 
> > > Quite frankly, I would like to.
> > > 
> > > > I would be ok with that now that the infrastructure seems so simple.
> > > 
> > > Well, perhaps I should dig out my original async suspend/resume patches
> > > that didn't contain all of the non-essential stuff and post them here for
> > > discussion, after all ...
> > 
> > That seems like a very good idea.  IIRC they were quite similar to what 
> > we have been discussing.
> 
> There you go.

Below is the suspend part.  It contains some extra code for rolling back the
suspend if one of the asynchronous callbacks returns error code, but apart
from this it's completely analogous to the resume part.

[This patch has only been slightly tested.]

---
 drivers/base/power/main.c |  113 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 104 insertions(+), 9 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -202,6 +202,17 @@ static void dpm_wait(struct device *dev,
                wait_event(dev->power.wait_queue, !!dev->power.op_complete);
 }
 
+static int device_pm_wait_fn(struct device *dev, void *async_ptr)
+{
+	dpm_wait(dev, *((bool *)async_ptr));
+	return 0;
+}
+
+static void dpm_wait_for_children(struct device *dev, bool async)
+{
+	device_for_each_child(dev, &async, device_pm_wait_fn);
+}
+
 /**
  * dpm_synchronize - Wait for PM callbacks of all devices to complete.
  */
@@ -638,6 +649,8 @@ static void dpm_complete(pm_message_t st
 	mutex_unlock(&dpm_list_mtx);
 }
 
+static int async_error;
+
 /**
  * dpm_resume_end - Execute "resume" callbacks and complete system transition.
  * @state: PM transition of the system being carried out.
@@ -685,20 +698,52 @@ static pm_message_t resume_event(pm_mess
  * The driver of @dev will not receive interrupts while this function is being
  * executed.
  */
-static int device_suspend_noirq(struct device *dev, pm_message_t state)
+static int __device_suspend_noirq(struct device *dev, pm_message_t state)
 {
 	int error = 0;
 
-	if (!dev->bus)
-		return 0;
-
-	if (dev->bus->pm) {
+	if (dev->bus && dev->bus->pm) {
 		pm_dev_dbg(dev, state, "LATE ");
 		error = pm_noirq_op(dev, dev->bus->pm, state);
 	}
+
+	dpm_finish(dev);
+
 	return error;
 }
 
+static void async_suspend_noirq(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error = async_error;
+
+	if (error)
+		return;
+
+	dpm_wait_for_children(dev, true);
+	error = __device_suspend_noirq(dev, pm_transition);
+	if (error) {
+		pm_dev_err(dev, pm_transition, " async LATE", error);
+		dev->power.status = DPM_OFF;
+	}
+	put_device(dev);
+
+	if (error && !async_error)
+		async_error = error;
+}
+
+static int device_suspend_noirq(struct device *dev)
+{
+	if (dev->power.async_suspend) {
+		get_device(dev);
+		async_schedule(async_suspend_noirq, dev);
+		return 0;
+	}
+
+	dpm_wait_for_children(dev, false);
+	return __device_suspend_noirq(dev, pm_transition);
+}
+
 /**
  * dpm_suspend_noirq - Execute "late suspend" callbacks for non-sysdev devices.
  * @state: PM transition of the system being carried out.
@@ -713,14 +758,21 @@ int dpm_suspend_noirq(pm_message_t state
 
 	suspend_device_irqs();
 	mutex_lock(&dpm_list_mtx);
+	pm_transition = state;
 	list_for_each_entry_reverse(dev, &dpm_list, power.entry) {
-		error = device_suspend_noirq(dev, state);
+		dev->power.status = DPM_OFF_IRQ;
+		error = device_suspend_noirq(dev);
 		if (error) {
 			pm_dev_err(dev, state, " late", error);
+			dev->power.status = DPM_OFF;
+			break;
+		}
+		if (async_error) {
+			error = async_error;
 			break;
 		}
-		dev->power.status = DPM_OFF_IRQ;
 	}
+	dpm_synchronize();
 	mutex_unlock(&dpm_list_mtx);
 	if (error)
 		dpm_resume_noirq(resume_event(state));
@@ -733,7 +785,7 @@ EXPORT_SYMBOL_GPL(dpm_suspend_noirq);
  * @dev: Device to handle.
  * @state: PM transition of the system being carried out.
  */
-static int device_suspend(struct device *dev, pm_message_t state)
+static int __device_suspend(struct device *dev, pm_message_t state)
 {
 	int error = 0;
 
@@ -773,10 +825,45 @@ static int device_suspend(struct device 
 	}
  End:
 	up(&dev->sem);
+	dpm_finish(dev);
 
 	return error;
 }
 
+static void async_suspend(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error = async_error;
+
+	if (error)
+		goto End;
+
+	dpm_wait_for_children(dev, true);
+	error = __device_suspend(dev, pm_transition);
+	if (error) {
+		pm_dev_err(dev, pm_transition, " async", error);
+
+		dev->power.status = DPM_SUSPENDING;
+		if (!async_error)
+			async_error = error;
+	}
+
+ End:
+	put_device(dev);
+}
+
+static int device_suspend(struct device *dev, pm_message_t state)
+{
+	if (dev->power.async_suspend) {
+		get_device(dev);
+		async_schedule(async_suspend, dev);
+		return 0;
+	}
+
+	dpm_wait_for_children(dev, false);
+	return __device_suspend(dev, pm_transition);
+}
+
 /**
  * dpm_suspend - Execute "suspend" callbacks for all non-sysdev devices.
  * @state: PM transition of the system being carried out.
@@ -788,10 +875,12 @@ static int dpm_suspend(pm_message_t stat
 
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
+	pm_transition = state;
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.prev);
 
 		get_device(dev);
+		dev->power.status = DPM_OFF;
 		mutex_unlock(&dpm_list_mtx);
 
 		error = device_suspend(dev, state);
@@ -799,16 +888,21 @@ static int dpm_suspend(pm_message_t stat
 		mutex_lock(&dpm_list_mtx);
 		if (error) {
 			pm_dev_err(dev, state, "", error);
+			dev->power.status = DPM_SUSPENDING;
 			put_device(dev);
 			break;
 		}
-		dev->power.status = DPM_OFF;
 		if (!list_empty(&dev->power.entry))
 			list_move(&dev->power.entry, &list);
 		put_device(dev);
+		if (async_error)
+			break;
 	}
 	list_splice(&list, dpm_list.prev);
+	dpm_synchronize();
 	mutex_unlock(&dpm_list_mtx);
+	if (!error)
+		error = async_error;
 	return error;
 }
 
@@ -867,6 +961,7 @@ static int dpm_prepare(pm_message_t stat
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
 	transition_started = true;
+	async_error = 0;
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.next);
 
