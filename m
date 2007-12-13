Return-Path: <linux-kernel-owner+w=401wt.eu-S1761695AbXLMHMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761695AbXLMHMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:12:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762596AbXLMG5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:57:39 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55494 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761474AbXLMG5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:57:37 -0500
Date: Wed, 12 Dec 2007 22:52:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel Drake <dsd@gentoo.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [patch 38/60] create /sys/.../power when CONFIG_PM is set
Message-ID: <20071213065255.GN6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="create-sys-...-power-when-config_pm-is-set.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Daniel Drake <dsd@gentoo.org>

patch dec13c15445fec29ca9087890895718450e80b95 in mainline.

The CONFIG_SUSPEND changes in 2.6.23 caused a regression under certain
configuration conditions (SUSPEND=n, USB_AUTOSUSPEND=y) where all USB
device attributes in sysfs (idVendor, idProduct, ...) silently disappeared,
causing udev breakage and more.

The cause of this is that the /sys/.../power subdirectory is now only
created when CONFIG_PM_SLEEP is set, however, it should be created whenever
CONFIG_PM is set to handle the above situation.  The following patch fixes
the regression.

Signed-off-by: Daniel Drake <dsd@gentoo.org>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: stable <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/core.c         |    4 +++-
 drivers/base/power/Makefile |    3 ++-
 drivers/base/power/main.c   |    8 +-------
 drivers/base/power/power.h  |   25 ++++++++++++++++++-------
 4 files changed, 24 insertions(+), 16 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -814,9 +814,10 @@ int device_add(struct device *dev)
 	error = device_add_attrs(dev);
 	if (error)
 		goto AttrsError;
-	error = device_pm_add(dev);
+	error = dpm_sysfs_add(dev);
 	if (error)
 		goto PMError;
+	device_pm_add(dev);
 	error = bus_add_device(dev);
 	if (error)
 		goto BusError;
@@ -841,6 +842,7 @@ int device_add(struct device *dev)
 	return error;
  BusError:
 	device_pm_remove(dev);
+	dpm_sysfs_remove(dev);
  PMError:
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->bus_notifier,
--- a/drivers/base/power/Makefile
+++ b/drivers/base/power/Makefile
@@ -1,5 +1,6 @@
 obj-y			:= shutdown.o
-obj-$(CONFIG_PM_SLEEP)	+= main.o suspend.o resume.o sysfs.o
+obj-$(CONFIG_PM)	+= sysfs.o
+obj-$(CONFIG_PM_SLEEP)	+= main.o suspend.o resume.o
 obj-$(CONFIG_PM_TRACE)	+= trace.o
 
 ifeq ($(CONFIG_DEBUG_DRIVER),y)
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -33,20 +33,14 @@ DEFINE_MUTEX(dpm_list_mtx);
 
 int (*platform_enable_wakeup)(struct device *dev, int is_on);
 
-int device_pm_add(struct device *dev)
+void device_pm_add(struct device *dev)
 {
-	int error;
-
 	pr_debug("PM: Adding info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
 	mutex_lock(&dpm_list_mtx);
 	list_add_tail(&dev->power.entry, &dpm_active);
-	error = dpm_sysfs_add(dev);
-	if (error)
-		list_del(&dev->power.entry);
 	mutex_unlock(&dpm_list_mtx);
-	return error;
 }
 
 void device_pm_remove(struct device *dev)
--- a/drivers/base/power/power.h
+++ b/drivers/base/power/power.h
@@ -34,14 +34,26 @@ static inline struct dev_pm_info * to_pm
 	return container_of(entry, struct dev_pm_info, entry);
 }
 
-static inline struct device * to_device(struct list_head * entry)
+static inline struct device *to_device(struct list_head *entry)
 {
 	return container_of(to_pm_info(entry), struct device, power);
 }
 
-extern int device_pm_add(struct device *);
+extern void device_pm_add(struct device *);
 extern void device_pm_remove(struct device *);
 
+#else /* CONFIG_PM_SLEEP */
+
+static inline void device_pm_add(struct device *dev)
+{
+}
+
+static inline void device_pm_remove(struct device *dev)
+{
+}
+#endif
+
+#ifdef CONFIG_PM
 /*
  * sysfs.c
  */
@@ -62,16 +74,15 @@ extern int resume_device(struct device *
  */
 extern int suspend_device(struct device *, pm_message_t);
 
-#else /* CONFIG_PM_SLEEP */
-
+#else /* CONFIG_PM */
 
-static inline int device_pm_add(struct device * dev)
+static inline int dpm_sysfs_add(struct device *dev)
 {
 	return 0;
 }
-static inline void device_pm_remove(struct device * dev)
-{
 
+static inline void dpm_sysfs_remove(struct device *dev)
+{
 }
 
 #endif

-- 
