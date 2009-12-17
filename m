Return-Path: <linux-kernel-owner+w=401wt.eu-S936139AbZLQBsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936139AbZLQBsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936128AbZLQBsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:48:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60201 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936125AbZLQBsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:48:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Thu, 17 Dec 2009 02:49:00 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <alpine.LFD.2.00.0912161255080.3556@localhost.localdomain> <200912162257.00771.rjw@sisk.pl>
In-Reply-To: <200912162257.00771.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912170249.00676.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 December 2009, Rafael J. Wysocki wrote:
> On Wednesday 16 December 2009, Linus Torvalds wrote:
> > 
> > On Wed, 16 Dec 2009, Rafael J. Wysocki wrote:
> > > > 
> > > > Do you have any sample timing output with devices listed?
> > > 
> > > I'm going to generate one shortly.
> 
> I've just put the first set of data, for the HP nx6325 at:
> http://www.sisk.pl/kernel/data/nx6325/

As I said in a message to Alan, the data were incomplete, because the original
Arjan's patch only covers bus types and device classes converted to
dev_pm_ops, which I only noticed earlier today.  So I added the appended patch
on top of the async tree and I applied a one-liner adding the name of the
parent to each device line during (regular) suspend and resume.

The new data sets are at:

http://www.sisk.pl/kernel/data/nx6325/
http://www.sisk.pl/kernel/data/wind/

and the format is the same as described below.

> The *-dmesg.log files contain full dmesg outputs starting from a cold boot and
> including one suspend-resume cycle in each case, with debug_initcall enabled.
> 
> The *-suspend.log files are excerpts from the *-dmesg.log files containing
> the suspend messages only, and analogously for *-resume.log.
> 
> The *-times.txt files contain suspend/resume time for every device sorted
> in the decreasing order.
> 
> > From my bootup timings, I have this memory of SATA link bringup being 
> > noticeable. I wonder if that is the case on resume too...

That actually is correct.  On the nx6325 suspend is totally dominated by disk
spindown, almost everything else is negligible compared to it (well, except for
the audio), so we can't go down below 1 s during suspend on this box.

On the Wind, disk spindown time is comparable with serio suspend time,
so at least in principle we should be able to get .5 s suspend on this box - 
if the disk spindown in async.

In turn, the resume on the Wind is dominated by disk spinup, so we can't
go below 1.5 s on this box during resume (notice that the "async+extra"
approach brings us close to this limit, although we could save .5 s more in
principle by making more devices async).

Resume on the nx6325 is a different story, though, as it is dominated by USB
and PCI devices, so marking those as async would probably bring us close to
the limit.

[Surprisingly enough to me some ACPI devices appear to take quite noticeable
amounts of time to resume on both boxes.]

Tomorrow I'll try to mark as many devices as reasonably possible as async
and see how the total suspend-resume times change.

Rafael

---
 drivers/base/power/main.c |   97 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 77 insertions(+), 20 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -165,6 +165,32 @@ void device_pm_move_last(struct device *
 	list_move_tail(&dev->power.entry, &dpm_list);
 }
 
+static ktime_t initcall_debug_start(struct device *dev)
+{
+	ktime_t calltime = ktime_set(0, 0);
+
+	if (initcall_debug) {
+		pr_info("calling  %s_i+ @ %i\n",
+				dev_name(dev), task_pid_nr(current));
+		calltime = ktime_get();
+	}
+
+	return calltime;
+}
+
+static void initcall_debug_report(struct device *dev, ktime_t calltime,
+				  int error)
+{
+	ktime_t delta, rettime;
+
+	if (initcall_debug) {
+		rettime = ktime_get();
+		delta = ktime_sub(rettime, calltime);
+		pr_info("call %s+ returned %d after %Ld usecs\n", dev_name(dev),
+			error, (unsigned long long)ktime_to_ns(delta) >> 10);
+	}
+}
+
 /**
  * dpm_wait - Wait for a PM operation to complete.
  * @dev: Device to wait for.
@@ -201,13 +227,9 @@ static int pm_op(struct device *dev,
 		 pm_message_t state)
 {
 	int error = 0;
-	ktime_t calltime, delta, rettime;
+	ktime_t calltime;
 
-	if (initcall_debug) {
-		pr_info("calling  %s+ @ %i\n",
-				dev_name(dev), task_pid_nr(current));
-		calltime = ktime_get();
-	}
+	calltime = initcall_debug_start(dev);
 
 	switch (state.event) {
 #ifdef CONFIG_SUSPEND
@@ -256,12 +278,7 @@ static int pm_op(struct device *dev,
 		error = -EINVAL;
 	}
 
-	if (initcall_debug) {
-		rettime = ktime_get();
-		delta = ktime_sub(rettime, calltime);
-		pr_info("call %s+ returned %d after %Ld usecs\n", dev_name(dev),
-			error, (unsigned long long)ktime_to_ns(delta) >> 10);
-	}
+	initcall_debug_report(dev, calltime, error);
 
 	return error;
 }
@@ -338,8 +355,9 @@ static int pm_noirq_op(struct device *de
 	if (initcall_debug) {
 		rettime = ktime_get();
 		delta = ktime_sub(rettime, calltime);
-		printk("initcall %s_i+ returned %d after %Ld usecs\n", dev_name(dev),
-			error, (unsigned long long)ktime_to_ns(delta) >> 10);
+		printk("initcall %s_i+ returned %d after %Ld usecs\n",
+			dev_name(dev), error,
+			(unsigned long long)ktime_to_ns(delta) >> 10);
 	}
 
 	return error;
@@ -456,6 +474,26 @@ void dpm_resume_noirq(pm_message_t state
 EXPORT_SYMBOL_GPL(dpm_resume_noirq);
 
 /**
+ * legacy_resume - Execute a legacy (bus or class) resume callback for device.
+ * dev: Device to resume.
+ * cb: Resume callback to execute.
+ */
+static int legacy_resume(struct device *dev, int (*cb)(struct device *dev))
+{
+	int error;
+	ktime_t calltime;
+
+	calltime = initcall_debug_start(dev);
+
+	error = cb(dev);
+	suspend_report_result(cb, error);
+
+	initcall_debug_report(dev, calltime, error);
+
+	return error;
+}
+
+/**
  * __device_resume - Execute "resume" callbacks for given device.
  * @dev: Device to handle.
  * @state: PM transition of the system being carried out.
@@ -477,7 +515,7 @@ static int __device_resume(struct device
 			error = pm_op(dev, dev->bus->pm, state);
 		} else if (dev->bus->resume) {
 			pm_dev_dbg(dev, state, "legacy ");
-			error = dev->bus->resume(dev);
+			error = legacy_resume(dev, dev->bus->resume);
 		}
 		if (error)
 			goto End;
@@ -498,7 +536,7 @@ static int __device_resume(struct device
 			error = pm_op(dev, dev->class->pm, state);
 		} else if (dev->class->resume) {
 			pm_dev_dbg(dev, state, "legacy class ");
-			error = dev->class->resume(dev);
+			error = legacy_resume(dev, dev->class->resume);
 		}
 	}
  End:
@@ -734,6 +772,27 @@ EXPORT_SYMBOL_GPL(dpm_suspend_noirq);
 static int async_error;
 
 /**
+ * legacy_suspend - Execute a legacy (bus or class) suspend callback for device.
+ * dev: Device to suspend.
+ * cb: Suspend callback to execute.
+ */
+static int legacy_suspend(struct device *dev, pm_message_t state,
+			  int (*cb)(struct device *dev, pm_message_t state))
+{
+	int error;
+	ktime_t calltime;
+
+	calltime = initcall_debug_start(dev);
+
+	error = cb(dev, state);
+	suspend_report_result(cb, error);
+
+	initcall_debug_report(dev, calltime, error);
+
+	return error;
+}
+
+/**
  * device_suspend - Execute "suspend" callbacks for given device.
  * @dev: Device to handle.
  * @state: PM transition of the system being carried out.
@@ -755,8 +814,7 @@ static int __device_suspend(struct devic
 			error = pm_op(dev, dev->class->pm, state);
 		} else if (dev->class->suspend) {
 			pm_dev_dbg(dev, state, "legacy class ");
-			error = dev->class->suspend(dev, state);
-			suspend_report_result(dev->class->suspend, error);
+			error = legacy_suspend(dev, state, dev->class->suspend);
 		}
 		if (error)
 			goto End;
@@ -777,8 +835,7 @@ static int __device_suspend(struct devic
 			error = pm_op(dev, dev->bus->pm, state);
 		} else if (dev->bus->suspend) {
 			pm_dev_dbg(dev, state, "legacy ");
-			error = dev->bus->suspend(dev, state);
-			suspend_report_result(dev->bus->suspend, error);
+			error = legacy_suspend(dev, state, dev->bus->suspend);
 		}
 	}
 
