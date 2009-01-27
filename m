Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbZA0VT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbZA0VT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZA0VTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:19:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33634 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbZA0VTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:19:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Linux 2.6.29-rc2] BUG: using smp_processor_id() in preemptible
Date: Tue, 27 Jan 2009 22:18:38 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: =?iso-8859-1?q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <8db1092f0901170058k325dc6ddtddb42deea1ddd098@mail.gmail.com> <200901271628.54037.rjw@sisk.pl> <20090127154946.GA28209@elte.hu>
In-Reply-To: <20090127154946.GA28209@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901272218.39608.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 January 2009, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > In fact whatever check you put in it's _always_ going to be 
> > > fundamentally more fragile than direct instrumentation: you cannot 
> > > possibly check all possible places that enable interrupts. (they could 
> > > be disabling interrupts as a _restore_irqs() sequence for example)
> > 
> > In this particular case, I'm not really interested in that.  What I'm 
> > interested in is which driver's ->suspend_late() or ->resume_early() (or 
> > the equivalents for sysdevs) has enabled interrupts, which is quite easy 
> > to check directly.
> 
> But this is exactly what it does - without any need for debug checks 
> spread around!
> 
> You'll get a _full stack dump_ from the very driver that is enabling 
> interrupts! You dont get a trace - you get a stack dump of the very place 
> that is buggy. It does not get any better than that.

I'm not going to argue.

Nevertheless, IMO something like the patch below should be sufficient to catch
these bugs.

Thanks,
Rafael


---
 drivers/base/power/main.c |   12 ++++++++++++
 drivers/base/sys.c        |   21 ++++++++++++++++-----
 include/linux/pm.h        |   18 ++++++++++++++++++
 3 files changed, 46 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -186,12 +186,14 @@ static int pm_noirq_op(struct device *de
 		if (ops->suspend_noirq) {
 			error = ops->suspend_noirq(dev);
 			suspend_report_result(ops->suspend_noirq, error);
+			pm_check_irqs_after(ops->suspend_noirq);
 		}
 		break;
 	case PM_EVENT_RESUME:
 		if (ops->resume_noirq) {
 			error = ops->resume_noirq(dev);
 			suspend_report_result(ops->resume_noirq, error);
+			pm_check_irqs_after(ops->resume_noirq);
 		}
 		break;
 #endif /* CONFIG_SUSPEND */
@@ -201,12 +203,14 @@ static int pm_noirq_op(struct device *de
 		if (ops->freeze_noirq) {
 			error = ops->freeze_noirq(dev);
 			suspend_report_result(ops->freeze_noirq, error);
+			pm_check_irqs_after(ops->freeze_noirq);
 		}
 		break;
 	case PM_EVENT_HIBERNATE:
 		if (ops->poweroff_noirq) {
 			error = ops->poweroff_noirq(dev);
 			suspend_report_result(ops->poweroff_noirq, error);
+			pm_check_irqs_after(ops->poweroff_noirq);
 		}
 		break;
 	case PM_EVENT_THAW:
@@ -214,12 +218,14 @@ static int pm_noirq_op(struct device *de
 		if (ops->thaw_noirq) {
 			error = ops->thaw_noirq(dev);
 			suspend_report_result(ops->thaw_noirq, error);
+			pm_check_irqs_after(ops->thaw_noirq);
 		}
 		break;
 	case PM_EVENT_RESTORE:
 		if (ops->restore_noirq) {
 			error = ops->restore_noirq(dev);
 			suspend_report_result(ops->restore_noirq, error);
+			pm_check_irqs_after(ops->restore_noirq);
 		}
 		break;
 #endif /* CONFIG_HIBERNATION */
@@ -292,6 +298,7 @@ static int resume_device_noirq(struct de
 	} else if (dev->bus->resume_early) {
 		pm_dev_dbg(dev, state, "legacy EARLY ");
 		error = dev->bus->resume_early(dev);
+		pm_check_irqs_after(dev->bus->resume_early);
 	}
  End:
 	TRACE_RESUME(error);
@@ -311,6 +318,8 @@ static void dpm_power_up(pm_message_t st
 {
 	struct device *dev;
 
+	pm_check_irqs();
+
 	list_for_each_entry(dev, &dpm_list, power.entry)
 		if (dev->power.status > DPM_OFF) {
 			int error;
@@ -551,6 +560,7 @@ static int suspend_device_noirq(struct d
 		pm_dev_dbg(dev, state, "legacy LATE ");
 		error = dev->bus->suspend_late(dev, state);
 		suspend_report_result(dev->bus->suspend_late, error);
+		pm_check_irqs_after(dev->bus->suspend_late);
 	}
 	return error;
 }
@@ -569,6 +579,8 @@ int device_power_down(pm_message_t state
 	struct device *dev;
 	int error = 0;
 
+	pm_check_irqs();
+
 	list_for_each_entry_reverse(dev, &dpm_list, power.entry) {
 		error = suspend_device_noirq(dev, state);
 		if (error) {
Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -396,6 +396,20 @@ extern void __suspend_report_result(cons
 		__suspend_report_result(__func__, fn, ret);		\
 	} while (0)
 
+#define pm_check_irqs()							\
+	do {								\
+		WARN_ONCE(!irqs_disabled(),				\
+			"PM: Interrupts enabled in %s\n",		\
+			__FUNCTION__);					\
+	} while (0)
+
+#define pm_check_irqs_after(callback)					\
+	do {								\
+		WARN_ONCE(!irqs_disabled(),				\
+			"PM: Interrupts enabled by %pF\n",		\
+			(callback));					\
+	} while (0)
+
 #else /* !CONFIG_PM_SLEEP */
 
 static inline int device_suspend(pm_message_t state)
@@ -405,6 +419,10 @@ static inline int device_suspend(pm_mess
 
 #define suspend_report_result(fn, ret)		do {} while (0)
 
+#define pm_check_irqs()				do {} while (0)
+
+#define pm_check_irqs_after(callback)		do {} while (0)
+
 #endif /* !CONFIG_PM_SLEEP */
 
 /*
Index: linux-2.6/drivers/base/sys.c
===================================================================
--- linux-2.6.orig/drivers/base/sys.c
+++ linux-2.6/drivers/base/sys.c
@@ -341,14 +341,17 @@ static void __sysdev_resume(struct sys_d
 	struct sysdev_driver *drv;
 
 	/* First, call the class-specific one */
-	if (cls->resume)
+	if (cls->resume) {
 		cls->resume(dev);
+		pm_check_irqs_after(cls->resume);
+	}
 
 	/* Call auxillary drivers next. */
-	list_for_each_entry(drv, &cls->drivers, entry) {
-		if (drv->resume)
+	list_for_each_entry(drv, &cls->drivers, entry)
+		if (drv->resume) {
 			drv->resume(dev);
-	}
+			pm_check_irqs_after(drv->resume);
+		}
 }
 
 /**
@@ -373,6 +376,8 @@ int sysdev_suspend(pm_message_t state)
 
 	pr_debug("Suspending System Devices\n");
 
+	pm_check_irqs();
+
 	list_for_each_entry_reverse(cls, &system_kset->list, kset.kobj.entry) {
 		pr_debug("Suspending type '%s':\n",
 			 kobject_name(&cls->kset.kobj));
@@ -384,6 +389,7 @@ int sysdev_suspend(pm_message_t state)
 			list_for_each_entry(drv, &cls->drivers, entry) {
 				if (drv->suspend) {
 					ret = drv->suspend(sysdev, state);
+					pm_check_irqs_after(drv->suspend);
 					if (ret)
 						goto aux_driver;
 				}
@@ -392,6 +398,7 @@ int sysdev_suspend(pm_message_t state)
 			/* Now call the generic one */
 			if (cls->suspend) {
 				ret = cls->suspend(sysdev, state);
+				pm_check_irqs_after(cls->suspend);
 				if (ret)
 					goto cls_driver;
 			}
@@ -411,8 +418,10 @@ aux_driver:
 	list_for_each_entry(err_drv, &cls->drivers, entry) {
 		if (err_drv == drv)
 			break;
-		if (err_drv->resume)
+		if (err_drv->resume) {
 			err_drv->resume(sysdev);
+			pm_check_irqs_after(err_drv->resume);
+		}
 	}
 
 	/* resume other sysdevs in current class */
@@ -449,6 +458,8 @@ int sysdev_resume(void)
 
 	pr_debug("Resuming System Devices\n");
 
+	pm_check_irqs();
+
 	list_for_each_entry(cls, &system_kset->list, kset.kobj.entry) {
 		struct sys_device * sysdev;
 

