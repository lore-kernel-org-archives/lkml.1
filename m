Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbZLBJMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbZLBJMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 04:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbZLBJMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 04:12:30 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:52562 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbZLBJM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 04:12:29 -0500
X-IronPort-AV: E=Sophos;i="4.47,327,1257138000"; 
   d="scan'208";a="9793387"
Subject: [PATCH] driver i2c-core: i2c bus should support PM entries in
	struct dev_pm_ops.
From: sonic zhang <sonic.adi@gmail.com>
To: khali@linux-fr.org
CC: linux-i2c@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 2 Dec 2009 17:08:40 +0800
Message-ID: <1259744920.25505.2.camel@eight.analog.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Struct dev_pm_ops is not configured in current i2c bus type. i2c drivers
only depends on suspend/resume entries in struct dev_pm_ops are not
informed of PM suspend and resume events by i2c framework.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/i2c/i2c-core.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 2965043..9713c0d 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -155,6 +155,39 @@ static void i2c_device_shutdown(struct device *dev)
 		driver->shutdown(client);
 }
 
+#ifdef CONFIG_SUSPEND
+static int i2c_device_pm_suspend(struct device *dev)
+{
+	struct i2c_driver *driver;
+	struct dev_pm_ops *pm;
+
+	if (!dev->driver)
+		return 0;
+	driver = to_i2c_driver(dev->driver);
+	pm = driver->driver.pm;
+	if (!pm || !pm->suspend)
+		return 0;
+	return pm->suspend(dev);
+}
+
+static int i2c_device_pm_resume(struct device *dev)
+{
+	struct i2c_driver *driver;
+	struct dev_pm_ops *pm;
+
+	if (!dev->driver)
+		return 0;
+	driver = to_i2c_driver(dev->driver);
+	pm = driver->driver.pm;
+	if (!pm || !pm->resume)
+		return 0;
+	return pm->resume(dev);
+}
+#else
+# define i2c_device_pm_suspend	NULL
+# define i2c_device_pm_resume	NULL
+#endif
+
 static int i2c_device_suspend(struct device *dev, pm_message_t mesg)
 {
 	struct i2c_client *client = i2c_verify_client(dev);
@@ -219,6 +252,11 @@ static const struct attribute_group *i2c_dev_attr_groups[] = {
 	NULL
 };
 
+static struct dev_pm_ops i2c_device_pm_ops = {
+	.suspend = i2c_device_pm_suspend,
+	.resume = i2c_device_pm_resume,
+};
+
 struct bus_type i2c_bus_type = {
 	.name		= "i2c",
 	.match		= i2c_device_match,
@@ -227,6 +265,7 @@ struct bus_type i2c_bus_type = {
 	.shutdown	= i2c_device_shutdown,
 	.suspend	= i2c_device_suspend,
 	.resume		= i2c_device_resume,
+	.pm		= &i2c_device_pm_ops,
 };
 EXPORT_SYMBOL_GPL(i2c_bus_type);
 
-- 
1.6.0



