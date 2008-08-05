Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbYHEOcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbYHEOcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 10:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755957AbYHEOak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 10:30:40 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:62924 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809AbYHEOai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 10:30:38 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: Paul Mackerras <paulus@samba.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] ibmebus/of_platform: Move "name" sysfs attribute into generic OF devices
User-Agent: KMail/1.8.2
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Paul Mackerras <pmac@au1.ibm.com>,
       Alexander Schmidt <alexschm@de.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Olaf Hering <olaf@aepfle.de>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2967
Date: Tue, 5 Aug 2008 16:30:18 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200808051630.19619.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent of_platform changes made of_bus_type_init() overwrite the bus type's
.dev_attrs list, so move ibmebus' "name" attribute (which is needed by eHCA
userspace support) into generic OF device code. Tested on POWER.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 arch/powerpc/kernel/ibmebus.c |   12 ------------
 drivers/of/device.c           |   10 ++++++++++
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
index 9d42eb5..a063622 100644
--- a/arch/powerpc/kernel/ibmebus.c
+++ b/arch/powerpc/kernel/ibmebus.c
@@ -233,17 +233,6 @@ void ibmebus_free_irq(u32 ist, void *dev_id)
 }
 EXPORT_SYMBOL(ibmebus_free_irq);
 
-static ssize_t name_show(struct device *dev,
-			 struct device_attribute *attr, char *buf)
-{
-	return sprintf(buf, "%s\n", to_of_device(dev)->node->name);
-}
-
-static struct device_attribute ibmebus_dev_attrs[] = {
-	__ATTR_RO(name),
-	__ATTR_NULL
-};
-
 static char *ibmebus_chomp(const char *in, size_t count)
 {
 	char *out = kmalloc(count + 1, GFP_KERNEL);
@@ -327,7 +316,6 @@ static struct bus_attribute ibmebus_bus_attrs[] = {
 
 struct bus_type ibmebus_bus_type = {
 	.uevent    = of_device_uevent,
-	.dev_attrs = ibmebus_dev_attrs,
 	.bus_attrs = ibmebus_bus_attrs
 };
 EXPORT_SYMBOL(ibmebus_bus_type);
diff --git a/drivers/of/device.c b/drivers/of/device.c
index 8a1d93a..51e5214 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -57,6 +57,15 @@ static ssize_t devspec_show(struct device *dev,
 	return sprintf(buf, "%s\n", ofdev->node->full_name);
 }
 
+static ssize_t name_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct of_device *ofdev;
+
+	ofdev = to_of_device(dev);
+	return sprintf(buf, "%s\n", ofdev->node->name);
+}
+
 static ssize_t modalias_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -71,6 +80,7 @@ static ssize_t modalias_show(struct device *dev,
 
 struct device_attribute of_platform_device_attrs[] = {
 	__ATTR_RO(devspec),
+	__ATTR_RO(name),
 	__ATTR_RO(modalias),
 	__ATTR_NULL
 };
-- 
1.5.5





