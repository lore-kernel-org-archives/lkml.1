Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbZCWSGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbZCWSGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758594AbZCWSEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:04:30 -0400
Received: from adsl-69-107-72-54.dsl.pltn13.pacbell.net ([69.107.72.54]:35005
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757806AbZCWSE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:04:26 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 10/11] xen: use device model for suspending xenbus devices
Date: Mon, 23 Mar 2009 10:55:10 -0700
Message-Id: <1237830911-6249-11-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <49C45238.7050007@zytor.com>
References: <49C45238.7050007@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/manage.c              |    9 ++++-----
 drivers/xen/xenbus/xenbus_probe.c |   37 +++++++++----------------------------
 drivers/xen/xenbus/xenbus_xs.c    |    2 ++
 include/xen/xenbus.h              |    2 +-
 4 files changed, 16 insertions(+), 34 deletions(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 3ccd348..0489ea2 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -104,9 +104,8 @@ static void do_suspend(void)
 		goto out;
 	}
 
-	printk("suspending xenbus...\n");
-	/* XXX use normal device tree? */
-	xenbus_suspend();
+	printk(KERN_DEBUG "suspending xenstore...\n");
+	xs_suspend();
 
 	err = stop_machine(xen_suspend, &cancelled, cpumask_of(0));
 	if (err) {
@@ -116,9 +115,9 @@ static void do_suspend(void)
 
 	if (!cancelled) {
 		xen_arch_resume();
-		xenbus_resume();
+		xs_resume();
 	} else
-		xenbus_suspend_cancel();
+		xs_suspend_cancel();
 
 	device_resume(PMSG_RESUME);
 
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index bd20361..4649213 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -71,6 +71,9 @@ static int xenbus_probe_frontend(const char *type, const char *name);
 
 static void xenbus_dev_shutdown(struct device *_dev);
 
+static int xenbus_dev_suspend(struct device *dev, pm_message_t state);
+static int xenbus_dev_resume(struct device *dev);
+
 /* If something in array of ids matches this device, return it. */
 static const struct xenbus_device_id *
 match_device(const struct xenbus_device_id *arr, struct xenbus_device *dev)
@@ -188,6 +191,9 @@ static struct xen_bus_type xenbus_frontend = {
 		.remove    = xenbus_dev_remove,
 		.shutdown  = xenbus_dev_shutdown,
 		.dev_attrs = xenbus_dev_attrs,
+
+		.suspend   = xenbus_dev_suspend,
+		.resume    = xenbus_dev_resume,
 	},
 };
 
@@ -669,7 +675,7 @@ static struct xenbus_watch fe_watch = {
 	.callback = frontend_changed,
 };
 
-static int suspend_dev(struct device *dev, void *data)
+static int xenbus_dev_suspend(struct device *dev, pm_message_t state)
 {
 	int err = 0;
 	struct xenbus_driver *drv;
@@ -682,14 +688,14 @@ static int suspend_dev(struct device *dev, void *data)
 	drv = to_xenbus_driver(dev->driver);
 	xdev = container_of(dev, struct xenbus_device, dev);
 	if (drv->suspend)
-		err = drv->suspend(xdev);
+		err = drv->suspend(xdev, state);
 	if (err)
 		printk(KERN_WARNING
 		       "xenbus: suspend %s failed: %i\n", dev_name(dev), err);
 	return 0;
 }
 
-static int resume_dev(struct device *dev, void *data)
+static int xenbus_dev_resume(struct device *dev)
 {
 	int err;
 	struct xenbus_driver *drv;
@@ -734,31 +740,6 @@ static int resume_dev(struct device *dev, void *data)
 	return 0;
 }
 
-void xenbus_suspend(void)
-{
-	DPRINTK("");
-
-	bus_for_each_dev(&xenbus_frontend.bus, NULL, NULL, suspend_dev);
-	xenbus_backend_suspend(suspend_dev);
-	xs_suspend();
-}
-EXPORT_SYMBOL_GPL(xenbus_suspend);
-
-void xenbus_resume(void)
-{
-	xb_init_comms();
-	xs_resume();
-	bus_for_each_dev(&xenbus_frontend.bus, NULL, NULL, resume_dev);
-	xenbus_backend_resume(resume_dev);
-}
-EXPORT_SYMBOL_GPL(xenbus_resume);
-
-void xenbus_suspend_cancel(void)
-{
-	xs_suspend_cancel();
-}
-EXPORT_SYMBOL_GPL(xenbus_suspend_cancel);
-
 /* A flag to determine if xenstored is 'ready' (i.e. has started) */
 int xenstored_ready = 0;
 
diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index e325eab..eab33f1 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -673,6 +673,8 @@ void xs_resume(void)
 	struct xenbus_watch *watch;
 	char token[sizeof(watch) * 2 + 1];
 
+	xb_init_comms();
+
 	mutex_unlock(&xs_state.response_mutex);
 	mutex_unlock(&xs_state.request_mutex);
 	up_write(&xs_state.transaction_mutex);
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index 0836772..b9763ba 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -91,7 +91,7 @@ struct xenbus_driver {
 	void (*otherend_changed)(struct xenbus_device *dev,
 				 enum xenbus_state backend_state);
 	int (*remove)(struct xenbus_device *dev);
-	int (*suspend)(struct xenbus_device *dev);
+	int (*suspend)(struct xenbus_device *dev, pm_message_t state);
 	int (*resume)(struct xenbus_device *dev);
 	int (*uevent)(struct xenbus_device *, char **, int, char *, int);
 	struct device_driver driver;
-- 
1.6.0.6

