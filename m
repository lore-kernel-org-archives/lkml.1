Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902Ab0AXUIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab0AXUIs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 15:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670Ab0AXUIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 15:08:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45150 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649Ab0AXUIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 15:08:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/8] PM: Asynchronous suspend and resume of devices
Date: Sun, 24 Jan 2010 21:09:15 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       linux-usb@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Nigel Cunningham <ncunningham@crca.org.au>
References: <Pine.LNX.4.44L0.1001241128250.28594-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1001241128250.28594-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001242109.15407.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC list trimmed.]

On Sunday 24 January 2010, Alan Stern wrote:
> On Sun, 24 Jan 2010, Rafael J. Wysocki wrote:
> 
> > The async threads started for different devices as a result of
> > calling async_schedule() are synchronized with each other and with
> > the main suspend/resume thread with the help of completions, in the
> > following way:
> > (1) There is a completion, power.completion, for each device object.
> > (2) Each device's completion is reset before calling async_schedule()
> >     for the device or, in the case of devices with the
> >     power.async_suspend flags unset, before executing the device's
> >     suspend and resume callbacks.
> > (3) During suspend, right before running the bus type, device type
> >     and device class suspend callbacks for the device, the PM core
> >     waits for the completions of all the device's children to be
> >     completed.
> > (4) During resume, right before running the bus type, device type and
> >     device class resume callbacks for the device, the PM core waits
> >     for the completion of the device's parent to be completed.
> > (5) The PM core completes power.completion for each device right
> >     after the bus type, device type and device class suspend (or
> >     resume) callbacks executed for the device have returned.
> 
> ...
> 
> >  /**
> > + * dpm_wait - Wait for a PM operation to complete.
> > + * @dev: Device to wait for.
> > + * @async: If unset, wait only if the device's power.async_suspend flag is set.
> > + */
> > +static void dpm_wait(struct device *dev, bool async)
> > +{
> > +	if (!dev)
> > +		return;
> > +
> > +	if (async || dev->power.async_suspend)
> > +		wait_for_completion(&dev->power.completion);
> > +}
> 
> There needs to be a public interface to this function available for 
> drivers that have non-tree constraints.  The arguments should be the 
> device to wait for and the device doing the waiting (needed only to 
> determine whether the caller is running synchronously or not).

Something like the patch below?

> This will be necessary for USB.  In fact, your current code (with patch 
> 7/8 applied) is subject to a race that will sometimes cause a 
> non-high-speed USB device to fail to resume from hibernation.

That's the kind of information I need at this point.  What exactly should be
added to patch 7/8 to avoid this problem?

Rafael

---
 drivers/base/power/main.c |   11 +++++++++++
 include/linux/pm.h        |    2 ++
 2 files changed, 13 insertions(+)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -1050,3 +1050,14 @@ void __suspend_report_result(const char 
 		printk(KERN_ERR "%s(): %pF returns %d\n", function, fn, ret);
 }
 EXPORT_SYMBOL_GPL(__suspend_report_result);
+
+/**
+ * device_pm_wait_for_dev - Wait for suspend/resume of a device to complete.
+ * @dev: Device to wait for.
+ * @subordinate: Device that needs to wait for @dev.
+ */
+void device_pm_wait_for_dev(struct device *subordinate, struct device *dev)
+{
+	dpm_wait(dev, subordinate->power.async_suspend);
+}
+EXPORT_SYMBOL_GPL(device_pm_wait_for_dev);
Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -512,6 +512,7 @@ extern void __suspend_report_result(cons
 		__suspend_report_result(__func__, fn, ret);		\
 	} while (0)
 
+extern void device_pm_wait_for_dev(struct device *sub, struct device *dev);
 #else /* !CONFIG_PM_SLEEP */
 
 #define device_pm_lock() do {} while (0)
@@ -524,6 +525,7 @@ static inline int dpm_suspend_start(pm_m
 
 #define suspend_report_result(fn, ret)		do {} while (0)
 
+static inline void device_pm_wait_for_dev(struct device *a, struct device *b) {}
 #endif /* !CONFIG_PM_SLEEP */
 
 /* How to reorder dpm_list after device_move() */
