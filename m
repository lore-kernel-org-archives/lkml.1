Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbZGUFvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbZGUFvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 01:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbZGUFvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 01:51:42 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:56052 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbZGUFvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 01:51:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Q1mARw8dR1+Tc10j5YmD+IhdGaz3+x2tZQi+ey4qLnfLOBMFKOreId60E1FgEVuWUu
         lwyl5iBQgrXwqcAFNZAoHHA39VBAokt6D5fnfgX+6MCZGKz5l8SuYXyOWv7m0RNd8pMC
         pAM7GXBDRsr2QT6bwMLrtJ1uX1bkPnGJS81Tk=
Date: Mon, 20 Jul 2009 22:51:37 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] Driver core: make pm operations a const pointer
Message-ID: <20090721055136.GB4671@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

They are not supposed to be modified by drivers, so make them const.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/base/platform.c   |    2 +-
 drivers/base/power/main.c |    8 +++++---
 drivers/pci/pci-driver.c  |   16 ++++++++--------
 include/linux/device.h    |    9 +++++----
 4 files changed, 19 insertions(+), 16 deletions(-)


diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 81cb01b..c4b3fce 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -925,7 +925,7 @@ static int platform_pm_restore_noirq(struct device *dev)
 
 #endif /* !CONFIG_HIBERNATION */
 
-static struct dev_pm_ops platform_dev_pm_ops = {
+static const struct dev_pm_ops platform_dev_pm_ops = {
 	.prepare = platform_pm_prepare,
 	.complete = platform_pm_complete,
 	.suspend = platform_pm_suspend,
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 58a3e57..1b1a786 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -157,8 +157,9 @@ void device_pm_move_last(struct device *dev)
  *	@ops:	PM operations to choose from.
  *	@state:	PM transition of the system being carried out.
  */
-static int pm_op(struct device *dev, struct dev_pm_ops *ops,
-			pm_message_t state)
+static int pm_op(struct device *dev,
+		 const struct dev_pm_ops *ops,
+		 pm_message_t state)
 {
 	int error = 0;
 
@@ -220,7 +221,8 @@ static int pm_op(struct device *dev, struct dev_pm_ops *ops,
  *	The operation is executed with interrupts disabled by the only remaining
  *	functional CPU in the system.
  */
-static int pm_noirq_op(struct device *dev, struct dev_pm_ops *ops,
+static int pm_noirq_op(struct device *dev,
+			const struct dev_pm_ops *ops,
 			pm_message_t state)
 {
 	int error = 0;
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index d76c4c8..0c2ea44 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -575,7 +575,7 @@ static void pci_pm_complete(struct device *dev)
 static int pci_pm_suspend(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_suspend(dev, PMSG_SUSPEND);
@@ -613,7 +613,7 @@ static int pci_pm_suspend(struct device *dev)
 static int pci_pm_suspend_noirq(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_suspend_late(dev, PMSG_SUSPEND);
@@ -672,7 +672,7 @@ static int pci_pm_resume_noirq(struct device *dev)
 static int pci_pm_resume(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int error = 0;
 
 	/*
@@ -711,7 +711,7 @@ static int pci_pm_resume(struct device *dev)
 static int pci_pm_freeze(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_suspend(dev, PMSG_FREEZE);
@@ -780,7 +780,7 @@ static int pci_pm_thaw_noirq(struct device *dev)
 static int pci_pm_thaw(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int error = 0;
 
 	if (pci_has_legacy_pm_support(pci_dev))
@@ -799,7 +799,7 @@ static int pci_pm_thaw(struct device *dev)
 static int pci_pm_poweroff(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_suspend(dev, PMSG_HIBERNATE);
@@ -872,7 +872,7 @@ static int pci_pm_restore_noirq(struct device *dev)
 static int pci_pm_restore(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int error = 0;
 
 	/*
@@ -910,7 +910,7 @@ static int pci_pm_restore(struct device *dev)
 
 #endif /* !CONFIG_HIBERNATION */
 
-struct dev_pm_ops pci_dev_pm_ops = {
+const struct dev_pm_ops pci_dev_pm_ops = {
 	.prepare = pci_pm_prepare,
 	.complete = pci_pm_complete,
 	.suspend = pci_pm_suspend,
diff --git a/include/linux/device.h b/include/linux/device.h
index aebb810..a286429 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -62,7 +62,7 @@ struct bus_type {
 	int (*suspend)(struct device *dev, pm_message_t state);
 	int (*resume)(struct device *dev);
 
-	struct dev_pm_ops *pm;
+	const struct dev_pm_ops *pm;
 
 	struct bus_type_private *p;
 };
@@ -132,7 +132,7 @@ struct device_driver {
 	int (*resume) (struct device *dev);
 	struct attribute_group **groups;
 
-	struct dev_pm_ops *pm;
+	const struct dev_pm_ops *pm;
 
 	struct driver_private *p;
 };
@@ -200,7 +200,8 @@ struct class {
 	int (*suspend)(struct device *dev, pm_message_t state);
 	int (*resume)(struct device *dev);
 
-	struct dev_pm_ops *pm;
+	const struct dev_pm_ops *pm;
+
 	struct class_private *p;
 };
 
@@ -291,7 +292,7 @@ struct device_type {
 	char *(*nodename)(struct device *dev);
 	void (*release)(struct device *dev);
 
-	struct dev_pm_ops *pm;
+	const struct dev_pm_ops *pm;
 };
 
 /* interface for exporting device attributes */
-- 
Dmitry
