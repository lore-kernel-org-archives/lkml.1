Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbYLJQ3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbYLJQ3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbYLJQ26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:28:58 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:36245 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178AbYLJQ24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:28:56 -0500
Date: Wed, 10 Dec 2008 17:28:51 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 5/28] drivers/hwmon: Drop return value from platform_driver
 remove functions
Message-ID: <Pine.LNX.4.64.0812101728240.21998@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The return value of the remove function of a driver structure, and thus of
a platform_driver structure, is ultimately ignored, and is thus
unnecessary.  This patch removes the return value for the remove function
stored in a platform_driver structure.  For the files in this patch, the
return values are always 0.

A simplified version of the semantic patch that makes this change is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r@
struct platform_driver I;
identifier a,f;
position p;
@@
I.remove = \(f@p\|a(f@p)\);

@void_called@
identifier r.f;
position p;
@@
f@p(...);

@called@
identifier r.f;
position p1 != void_called.p;
@@
f@p1(...)

@localfn@
identifier r.f;
@@
static int f(...) { ... }

@depends on !called && localfn@
struct platform_driver I;
identifier a,f;
position r.p;
@@

I.
- remove
+ remove_new
   = \(f@p\|a(f@p)\);

@depends on !called && localfn@
identifier r.f,i;
constant C;
expression E;
@@

- int
+ void
       f(...) {
  <...
(
-  return \(C\|i\);
+  return;
|
-  return E;
+  E;
+  return;
)
  ...>
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/hwmon/abituguru.c  |    6 ++----
 drivers/hwmon/abituguru3.c |    6 ++----
 drivers/hwmon/coretemp.c   |    5 ++---
 drivers/hwmon/f71882fg.c   |    8 +++-----
 drivers/hwmon/i5k_amb.c    |    5 ++---
 drivers/hwmon/it87.c       |    8 +++-----
 drivers/hwmon/lm78.c       |    8 +++-----
 drivers/hwmon/sis5595.c    |    8 +++-----
 drivers/hwmon/via686a.c    |    8 +++-----
 drivers/hwmon/w83627ehf.c  |    6 ++----
 drivers/hwmon/w83627hf.c   |    8 +++-----
 drivers/hwmon/w83781d.c    |    6 ++----
 12 files changed, 30 insertions(+), 52 deletions(-)

diff --git a/drivers/hwmon/abituguru.c b/drivers/hwmon/abituguru.c
index 4dbdb81..a7ecf27 100644
--- a/drivers/hwmon/abituguru.c
+++ b/drivers/hwmon/abituguru.c
@@ -1303,7 +1303,7 @@ abituguru_probe_error:
 	return res;
 }
 
-static int __devexit abituguru_remove(struct platform_device *pdev)
+static void __devexit abituguru_remove(struct platform_device *pdev)
 {
 	int i;
 	struct abituguru_data *data = platform_get_drvdata(pdev);
@@ -1316,8 +1316,6 @@ static int __devexit abituguru_remove(struct platform_device *pdev)
 			&abituguru_sysfs_attr[i].dev_attr);
 	platform_set_drvdata(pdev, NULL);
 	kfree(data);
-
-	return 0;
 }
 
 static struct abituguru_data *abituguru_update_device(struct device *dev)
@@ -1409,7 +1407,7 @@ static struct platform_driver abituguru_driver = {
 		.name	= ABIT_UGURU_NAME,
 	},
 	.probe		= abituguru_probe,
-	.remove		= __devexit_p(abituguru_remove),
+	.remove_new	= __devexit_p(abituguru_remove),
 	.suspend	= abituguru_suspend,
 	.resume		= abituguru_resume,
 };
diff --git a/drivers/hwmon/abituguru3.c b/drivers/hwmon/abituguru3.c
index 70bb854..ea0fec9 100644
--- a/drivers/hwmon/abituguru3.c
+++ b/drivers/hwmon/abituguru3.c
@@ -1021,7 +1021,7 @@ abituguru3_probe_error:
 	return res;
 }
 
-static int __devexit abituguru3_remove(struct platform_device *pdev)
+static void __devexit abituguru3_remove(struct platform_device *pdev)
 {
 	int i;
 	struct abituguru3_data *data = platform_get_drvdata(pdev);
@@ -1034,8 +1034,6 @@ static int __devexit abituguru3_remove(struct platform_device *pdev)
 		device_remove_file(&pdev->dev,
 			&abituguru3_sysfs_attr[i].dev_attr);
 	kfree(data);
-
-	return 0;
 }
 
 static struct abituguru3_data *abituguru3_update_device(struct device *dev)
@@ -1117,7 +1115,7 @@ static struct platform_driver abituguru3_driver = {
 		.name	= ABIT_UGURU3_NAME,
 	},
 	.probe	= abituguru3_probe,
-	.remove	= __devexit_p(abituguru3_remove),
+	.remove_new = __devexit_p(abituguru3_remove),
 	.suspend = abituguru3_suspend,
 	.resume = abituguru3_resume
 };
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 93c1722..4400952 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -288,7 +288,7 @@ exit:
 	return err;
 }
 
-static int __devexit coretemp_remove(struct platform_device *pdev)
+static void __devexit coretemp_remove(struct platform_device *pdev)
 {
 	struct coretemp_data *data = platform_get_drvdata(pdev);
 
@@ -297,7 +297,6 @@ static int __devexit coretemp_remove(struct platform_device *pdev)
 	device_remove_file(&pdev->dev, &sensor_dev_attr_temp1_max.dev_attr);
 	platform_set_drvdata(pdev, NULL);
 	kfree(data);
-	return 0;
 }
 
 static struct platform_driver coretemp_driver = {
@@ -306,7 +305,7 @@ static struct platform_driver coretemp_driver = {
 		.name = DRVNAME,
 	},
 	.probe = coretemp_probe,
-	.remove = __devexit_p(coretemp_remove),
+	.remove_new = __devexit_p(coretemp_remove),
 };
 
 struct pdev_entry {
diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
index 67067e9..e4ea3ba 100644
--- a/drivers/hwmon/f71882fg.c
+++ b/drivers/hwmon/f71882fg.c
@@ -168,7 +168,7 @@ static ssize_t show_name(struct device *dev, struct device_attribute *devattr,
 	char *buf);
 
 static int __devinit f71882fg_probe(struct platform_device * pdev);
-static int __devexit f71882fg_remove(struct platform_device *pdev);
+static void __devexit f71882fg_remove(struct platform_device *pdev);
 static int __init f71882fg_init(void);
 static int __init f71882fg_find(int sioaddr, unsigned short *address);
 static int __init f71882fg_device_add(unsigned short address);
@@ -180,7 +180,7 @@ static struct platform_driver f71882fg_driver = {
 		.name	= DRVNAME,
 	},
 	.probe		= f71882fg_probe,
-	.remove		= __devexit_p(f71882fg_remove),
+	.remove_new	= __devexit_p(f71882fg_remove),
 };
 
 static struct device_attribute f71882fg_dev_attr[] =
@@ -803,7 +803,7 @@ exit_unregister_sysfs:
 	return err;
 }
 
-static int __devexit f71882fg_remove(struct platform_device *pdev)
+static void __devexit f71882fg_remove(struct platform_device *pdev)
 {
 	int i;
 	struct f71882fg_data *data = platform_get_drvdata(pdev);
@@ -822,8 +822,6 @@ static int __devexit f71882fg_remove(struct platform_device *pdev)
 		device_remove_file(&pdev->dev, &f71882fg_fan_attr[i].dev_attr);
 
 	kfree(data);
-
-	return 0;
 }
 
 static int __init f71882fg_find(int sioaddr, unsigned short *address)
diff --git a/drivers/hwmon/i5k_amb.c b/drivers/hwmon/i5k_amb.c
index 2ede938..a3c25d9 100644
--- a/drivers/hwmon/i5k_amb.c
+++ b/drivers/hwmon/i5k_amb.c
@@ -552,7 +552,7 @@ err:
 	return res;
 }
 
-static int __devexit i5k_amb_remove(struct platform_device *pdev)
+static void __devexit i5k_amb_remove(struct platform_device *pdev)
 {
 	int i;
 	struct i5k_amb_data *data = platform_get_drvdata(pdev);
@@ -566,7 +566,6 @@ static int __devexit i5k_amb_remove(struct platform_device *pdev)
 	release_mem_region(data->amb_base, data->amb_len);
 	platform_set_drvdata(pdev, NULL);
 	kfree(data);
-	return 0;
 }
 
 static struct platform_driver i5k_amb_driver = {
@@ -575,7 +574,7 @@ static struct platform_driver i5k_amb_driver = {
 		.name = DRVNAME,
 	},
 	.probe = i5k_amb_probe,
-	.remove = __devexit_p(i5k_amb_remove),
+	.remove_new = __devexit_p(i5k_amb_remove),
 };
 
 static int __init i5k_amb_init(void)
diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
index b74c957..b66bb98 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -286,7 +286,7 @@ static inline int has_16bit_fans(const struct it87_data *data)
 }
 
 static int it87_probe(struct platform_device *pdev);
-static int __devexit it87_remove(struct platform_device *pdev);
+static void __devexit it87_remove(struct platform_device *pdev);
 
 static int it87_read_value(struct it87_data *data, u8 reg);
 static void it87_write_value(struct it87_data *data, u8 reg, u8 value);
@@ -301,7 +301,7 @@ static struct platform_driver it87_driver = {
 		.name	= DRVNAME,
 	},
 	.probe	= it87_probe,
-	.remove	= __devexit_p(it87_remove),
+	.remove_new = __devexit_p(it87_remove),
 };
 
 static ssize_t show_in(struct device *dev, struct device_attribute *attr,
@@ -1257,7 +1257,7 @@ ERROR0:
 	return err;
 }
 
-static int __devexit it87_remove(struct platform_device *pdev)
+static void __devexit it87_remove(struct platform_device *pdev)
 {
 	struct it87_data *data = platform_get_drvdata(pdev);
 
@@ -1268,8 +1268,6 @@ static int __devexit it87_remove(struct platform_device *pdev)
 	release_region(data->addr, IT87_EC_EXTENT);
 	platform_set_drvdata(pdev, NULL);
 	kfree(data);
-
-	return 0;
 }
 
 /* Must be called with data->update_lock held, except during initialization.
diff --git a/drivers/hwmon/lm78.c b/drivers/hwmon/lm78.c
index b5e3b28..99f51c6 100644
--- a/drivers/hwmon/lm78.c
+++ b/drivers/hwmon/lm78.c
@@ -149,7 +149,7 @@ static int lm78_i2c_probe(struct i2c_client *client,
 static int lm78_i2c_remove(struct i2c_client *client);
 
 static int __devinit lm78_isa_probe(struct platform_device *pdev);
-static int __devexit lm78_isa_remove(struct platform_device *pdev);
+static void __devexit lm78_isa_remove(struct platform_device *pdev);
 
 static int lm78_read_value(struct lm78_data *data, u8 reg);
 static int lm78_write_value(struct lm78_data *data, u8 reg, u8 value);
@@ -182,7 +182,7 @@ static struct platform_driver lm78_isa_driver = {
 		.name	= "lm78",
 	},
 	.probe		= lm78_isa_probe,
-	.remove		= lm78_isa_remove,
+	.remove_new	= lm78_isa_remove,
 };
 
 
@@ -735,7 +735,7 @@ static int __devinit lm78_isa_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int __devexit lm78_isa_remove(struct platform_device *pdev)
+static void __devexit lm78_isa_remove(struct platform_device *pdev)
 {
 	struct lm78_data *data = platform_get_drvdata(pdev);
 	struct resource *res;
@@ -747,8 +747,6 @@ static int __devexit lm78_isa_remove(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 	release_region(res->start + LM78_ADDR_REG_OFFSET, 2);
-
-	return 0;
 }
 
 /* The SMBus locks itself, but ISA access must be locked explicitly! 
diff --git a/drivers/hwmon/sis5595.c b/drivers/hwmon/sis5595.c
index a276806..a13f936 100644
--- a/drivers/hwmon/sis5595.c
+++ b/drivers/hwmon/sis5595.c
@@ -187,7 +187,7 @@ struct sis5595_data {
 static struct pci_dev *s_bridge;	/* pointer to the (only) sis5595 */
 
 static int sis5595_probe(struct platform_device *pdev);
-static int __devexit sis5595_remove(struct platform_device *pdev);
+static void __devexit sis5595_remove(struct platform_device *pdev);
 
 static int sis5595_read_value(struct sis5595_data *data, u8 reg);
 static void sis5595_write_value(struct sis5595_data *data, u8 reg, u8 value);
@@ -200,7 +200,7 @@ static struct platform_driver sis5595_driver = {
 		.name	= "sis5595",
 	},
 	.probe		= sis5595_probe,
-	.remove		= __devexit_p(sis5595_remove),
+	.remove_new	= __devexit_p(sis5595_remove),
 };
 
 /* 4 Voltages */
@@ -600,7 +600,7 @@ exit:
 	return err;
 }
 
-static int __devexit sis5595_remove(struct platform_device *pdev)
+static void __devexit sis5595_remove(struct platform_device *pdev)
 {
 	struct sis5595_data *data = platform_get_drvdata(pdev);
 
@@ -612,8 +612,6 @@ static int __devexit sis5595_remove(struct platform_device *pdev)
 	release_region(data->addr, SIS5595_EXTENT);
 	platform_set_drvdata(pdev, NULL);
 	kfree(data);
-
-	return 0;
 }
 
 
diff --git a/drivers/hwmon/via686a.c b/drivers/hwmon/via686a.c
index f1ee5e7..6e7ccb5 100644
--- a/drivers/hwmon/via686a.c
+++ b/drivers/hwmon/via686a.c
@@ -314,7 +314,7 @@ struct via686a_data {
 static struct pci_dev *s_bridge;	/* pointer to the (only) via686a */
 
 static int via686a_probe(struct platform_device *pdev);
-static int __devexit via686a_remove(struct platform_device *pdev);
+static void __devexit via686a_remove(struct platform_device *pdev);
 
 static inline int via686a_read_value(struct via686a_data *data, u8 reg)
 {
@@ -618,7 +618,7 @@ static struct platform_driver via686a_driver = {
 		.name	= "via686a",
 	},
 	.probe		= via686a_probe,
-	.remove		= __devexit_p(via686a_remove),
+	.remove_new	= __devexit_p(via686a_remove),
 };
 
 
@@ -672,7 +672,7 @@ exit_release:
 	return err;
 }
 
-static int __devexit via686a_remove(struct platform_device *pdev)
+static void __devexit via686a_remove(struct platform_device *pdev)
 {
 	struct via686a_data *data = platform_get_drvdata(pdev);
 
@@ -682,8 +682,6 @@ static int __devexit via686a_remove(struct platform_device *pdev)
 	release_region(data->addr, VIA686A_EXTENT);
 	platform_set_drvdata(pdev, NULL);
 	kfree(data);
-
-	return 0;
 }
 
 static void __devinit via686a_init_device(struct via686a_data *data)
diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index 075164d..14430f2 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -1412,7 +1412,7 @@ exit:
 	return err;
 }
 
-static int __devexit w83627ehf_remove(struct platform_device *pdev)
+static void __devexit w83627ehf_remove(struct platform_device *pdev)
 {
 	struct w83627ehf_data *data = platform_get_drvdata(pdev);
 
@@ -1421,8 +1421,6 @@ static int __devexit w83627ehf_remove(struct platform_device *pdev)
 	release_region(data->addr, IOREGION_LENGTH);
 	platform_set_drvdata(pdev, NULL);
 	kfree(data);
-
-	return 0;
 }
 
 static struct platform_driver w83627ehf_driver = {
@@ -1431,7 +1429,7 @@ static struct platform_driver w83627ehf_driver = {
 		.name	= DRVNAME,
 	},
 	.probe		= w83627ehf_probe,
-	.remove		= __devexit_p(w83627ehf_remove),
+	.remove_new	= __devexit_p(w83627ehf_remove),
 };
 
 /* w83627ehf_find() looks for a '627 in the Super-I/O config space */
diff --git a/drivers/hwmon/w83627hf.c b/drivers/hwmon/w83627hf.c
index b30e579..a59e210 100644
--- a/drivers/hwmon/w83627hf.c
+++ b/drivers/hwmon/w83627hf.c
@@ -385,7 +385,7 @@ struct w83627hf_sio_data {
 
 
 static int w83627hf_probe(struct platform_device *pdev);
-static int __devexit w83627hf_remove(struct platform_device *pdev);
+static void __devexit w83627hf_remove(struct platform_device *pdev);
 
 static int w83627hf_read_value(struct w83627hf_data *data, u16 reg);
 static int w83627hf_write_value(struct w83627hf_data *data, u16 reg, u16 value);
@@ -399,7 +399,7 @@ static struct platform_driver w83627hf_driver = {
 		.name	= DRVNAME,
 	},
 	.probe		= w83627hf_probe,
-	.remove		= __devexit_p(w83627hf_remove),
+	.remove_new	= __devexit_p(w83627hf_remove),
 };
 
 static ssize_t
@@ -1446,7 +1446,7 @@ static int __devinit w83627hf_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int __devexit w83627hf_remove(struct platform_device *pdev)
+static void __devexit w83627hf_remove(struct platform_device *pdev)
 {
 	struct w83627hf_data *data = platform_get_drvdata(pdev);
 	struct resource *res;
@@ -1460,8 +1460,6 @@ static int __devexit w83627hf_remove(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 	release_region(res->start, WINB_REGION_SIZE);
-
-	return 0;
 }
 
 
diff --git a/drivers/hwmon/w83781d.c b/drivers/hwmon/w83781d.c
index fc12bd4..a67a2cb 100644
--- a/drivers/hwmon/w83781d.c
+++ b/drivers/hwmon/w83781d.c
@@ -1785,7 +1785,7 @@ w83781d_isa_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int __devexit
+static void __devexit
 w83781d_isa_remove(struct platform_device *pdev)
 {
 	struct w83781d_data *data = platform_get_drvdata(pdev);
@@ -1796,8 +1796,6 @@ w83781d_isa_remove(struct platform_device *pdev)
 	device_remove_file(&pdev->dev, &dev_attr_name);
 	release_region(data->isa_addr + W83781D_ADDR_REG_OFFSET, 2);
 	kfree(data);
-
-	return 0;
 }
 
 static struct platform_driver w83781d_isa_driver = {
@@ -1806,7 +1804,7 @@ static struct platform_driver w83781d_isa_driver = {
 		.name = "w83781d",
 	},
 	.probe = w83781d_isa_probe,
-	.remove = __devexit_p(w83781d_isa_remove),
+	.remove_new = __devexit_p(w83781d_isa_remove),
 };
 
 /* return 1 if a supported chip is found, 0 otherwise */
