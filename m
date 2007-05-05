Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbXEEJYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbXEEJYl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 05:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbXEEJYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 05:24:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49180 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556AbXEEJYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 05:24:40 -0400
Date: Sat, 5 May 2007 11:24:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Linus Torvalds <torvalds@osdl.org>,
       linux-pm@lists.osdl.org
Subject: Re: [patch] suspend/resume debugging: device filter
Message-ID: <20070505092425.GA23125@elte.hu>
References: <20070125110501.GA25151@elte.hu> <20070126015536.GA14917@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070126015536.GA14917@suse.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <gregkh@suse.de> wrote:

> Here's a (compile tested only) patch that does this on a per-device 
> basis, which is smaller, and should work just as well as your patch.
> 
> It creates a new file in the power/ directory for every device called 
> "can_suspend".  Write a '0' to it to prevent that device from being 
> suspended.
> 
> Does this work for you?

yeah, i was able to use this too to debug suspend/resume problems. But 
i've added the check to the resume path too - for example sw-suspend 
does a resume of devices during its suspend cycle, cutting off much of 
the netconsole output.

which makes the can_suspend flag mis-named - perhaps rename it to 
exclude_pm ?

updated patch below, against v2.6.21. Could we get this into v2.6.22 
please? It's a real time-saver.

	Ingo

---
 drivers/base/power/resume.c  |    6 ++++++
 drivers/base/power/suspend.c |    2 +-
 drivers/base/power/sysfs.c   |   30 ++++++++++++++++++++++++++++++
 include/linux/device.h       |    1 +
 4 files changed, 38 insertions(+), 1 deletion(-)

Index: linux/drivers/base/power/resume.c
===================================================================
--- linux.orig/drivers/base/power/resume.c
+++ linux/drivers/base/power/resume.c
@@ -24,6 +24,9 @@ int resume_device(struct device * dev)
 {
 	int error = 0;
 
+	if (dev->no_suspend)
+		return 0;
+
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 	down(&dev->sem);
@@ -52,6 +55,9 @@ static int resume_device_early(struct de
 {
 	int error = 0;
 
+	if (dev->no_suspend)
+		return 0;
+
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 	if (dev->bus && dev->bus->resume_early) {
Index: linux/drivers/base/power/suspend.c
===================================================================
--- linux.orig/drivers/base/power/suspend.c
+++ linux/drivers/base/power/suspend.c
@@ -78,7 +78,7 @@ int suspend_device(struct device * dev, 
 		suspend_report_result(dev->class->suspend, error);
 	}
 
-	if (!error && dev->bus && dev->bus->suspend && !dev->power.power_state.event) {
+	if (!error && !dev->no_suspend && dev->bus && dev->bus->suspend && !dev->power.power_state.event) {
 		dev_dbg(dev, "%s%s\n",
 			suspend_verb(state.event),
 			((state.event == PM_EVENT_SUSPEND)
Index: linux/drivers/base/power/sysfs.c
===================================================================
--- linux.orig/drivers/base/power/sysfs.c
+++ linux/drivers/base/power/sysfs.c
@@ -141,12 +141,42 @@ wake_store(struct device * dev, struct d
 
 static DEVICE_ATTR(wakeup, 0644, wake_show, wake_store);
 
+static ssize_t can_suspend_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%s\n", dev->no_suspend ? "no" : "yes");
+}
+
+static ssize_t can_suspend_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t n)
+{
+	if (!n)
+		return -EINVAL;
+
+	switch (buf[0]) {
+	case 'y':
+	case 'Y':
+	case '1':
+		dev->no_suspend = 0;
+		break;
+	case 'n':
+	case 'N':
+	case '0':
+		dev->no_suspend = 1;
+		break;
+	}
+
+	return n;
+}
+static DEVICE_ATTR(can_suspend, 0644, can_suspend_show, can_suspend_store);
 
 static struct attribute * power_attrs[] = {
 #ifdef	CONFIG_PM_SYSFS_DEPRECATED
 	&dev_attr_state.attr,
 #endif
 	&dev_attr_wakeup.attr,
+	&dev_attr_can_suspend.attr,
 	NULL,
 };
 static struct attribute_group pm_attr_group = {
Index: linux/include/linux/device.h
===================================================================
--- linux.orig/include/linux/device.h
+++ linux/include/linux/device.h
@@ -402,6 +402,7 @@ struct device {
 	char	bus_id[BUS_ID_SIZE];	/* position on parent bus */
 	struct device_type	*type;
 	unsigned		is_registered:1;
+	unsigned		no_suspend:1;
 	struct device_attribute uevent_attr;
 	struct device_attribute *devt_attr;
 
