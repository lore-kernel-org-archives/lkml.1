Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbYKPXFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbYKPXFZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 18:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbYKPXFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 18:05:10 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:40663 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753832AbYKPXFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 18:05:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=pdZYHzkjpkyyfm6n4dvKDIayX+6A9VfG1a6NTtiCEIA2IhC2kL3rdr74cb3f9a/LJBrOeqXkoORngOxOIE8/XVA87KXKrG9+xvmDw7/ZokLZfhtj8kYtw1ZjmNdJgRFXYSZn3/rRHhcYOEeqTnwioyhYLsBDTSwxHdUDczMhSbs=  ;
X-YMail-OSG: Hr_1IEIVM1lrsPN20ifDAmwn4FLYdkFaFoHt8kkxhOEXN4v2phwjZYjGa2VNsdSD5zIvC5Ga9_XfDrqOhhpX6Qo5lfIftp7zwK6NjT.1ifjnd1MKmTbgVAjj8gm.CjHon0XuaVCI6n3tGWKtjDWRjuWTjYqqeVZOYxKB6d9vvunZ3sivu3ackYYYrQDb
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [patch 2.6.28-rc5] regulator: enable/disable refcounting
Date: Sun, 16 Nov 2008 11:44:46 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>, Mark Brown <broonie@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811161144.46582.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Make the <linux/regulator.h> framework treat enable/disable call
pairs like the <linux/clk.h> and <linux/interrupt.h> frameworks do:
they're refcounted, so that different parts of a driver don't need
to put work into coordination that frameworks normally handle.
It's a minor object code shrink.

It also makes the regulator_is_disabled() kerneldoc say what it's
actually returning:  return value is not a refcount, and may report
an error (e.g. I/O error from I2C).

It also fixes some minor regulator_put() goofage:  removing unlocked
access to the enable state.  (But still not making regulator put/get
match the refcounting pattern they invoke.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/regulator/core.c |   71 ++++++++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 35 deletions(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -79,7 +79,7 @@ struct regulator {
 	int uA_load;
 	int min_uV;
 	int max_uV;
-	int enabled; /* client has called enabled */
+	int enabled; /* count of client enables */
 	char *supply_name;
 	struct device_attribute dev_attr;
 	struct regulator_dev *rdev;
@@ -933,16 +933,13 @@ void regulator_put(struct regulator *reg
 	if (regulator == NULL || IS_ERR(regulator))
 		return;
 
-	if (regulator->enabled) {
-		printk(KERN_WARNING "Releasing supply %s while enabled\n",
-		       regulator->supply_name);
-		WARN_ON(regulator->enabled);
-		regulator_disable(regulator);
-	}
-
 	mutex_lock(&regulator_list_mutex);
 	rdev = regulator->rdev;
 
+	if (WARN(regulator->enabled, "Releasing supply %s while enabled\n",
+			       regulator->supply_name))
+		_regulator_disable(rdev);
+
 	/* remove any sysfs entries */
 	if (regulator->dev) {
 		sysfs_remove_link(&rdev->dev.kobj, regulator->supply_name);
@@ -1012,21 +1009,17 @@ static int _regulator_enable(struct regu
  */
 int regulator_enable(struct regulator *regulator)
 {
-	int ret;
-
-	if (regulator->enabled) {
-		printk(KERN_CRIT "Regulator %s already enabled\n",
-		       regulator->supply_name);
-		WARN_ON(regulator->enabled);
-		return 0;
-	}
+	struct regulator_dev *rdev = regulator->rdev;
+	int ret = 0;
 
-	mutex_lock(&regulator->rdev->mutex);
-	regulator->enabled = 1;
-	ret = _regulator_enable(regulator->rdev);
-	if (ret != 0)
-		regulator->enabled = 0;
-	mutex_unlock(&regulator->rdev->mutex);
+	mutex_lock(&rdev->mutex);
+	if (regulator->enabled == 0)
+		ret = _regulator_enable(rdev);
+	else if (regulator->enabled < 0)
+		ret = -EIO;
+	if (ret == 0)
+		regulator->enabled++;
+	mutex_unlock(&rdev->mutex);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_enable);
@@ -1078,19 +1071,21 @@ static int _regulator_disable(struct reg
  */
 int regulator_disable(struct regulator *regulator)
 {
-	int ret;
-
-	if (!regulator->enabled) {
-		printk(KERN_ERR "%s: not in use by this consumer\n",
-			__func__);
-		return 0;
-	}
+	struct regulator_dev *rdev = regulator->rdev;
+	int ret = 0;
 
-	mutex_lock(&regulator->rdev->mutex);
-	regulator->enabled = 0;
-	regulator->uA_load = 0;
-	ret = _regulator_disable(regulator->rdev);
-	mutex_unlock(&regulator->rdev->mutex);
+	mutex_lock(&rdev->mutex);
+	if (regulator->enabled == 1) {
+		ret = _regulator_disable(rdev);
+		if (ret == 0)
+			regulator->uA_load = 0;
+	} else if (WARN(regulator->enabled <= 0,
+			"unbalanced disables for supply %s\n",
+			regulator->supply_name))
+		ret = -EIO;
+	if (ret == 0)
+		regulator->enabled--;
+	mutex_unlock(&rdev->mutex);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_disable);
@@ -1166,7 +1161,13 @@ out:
  * regulator_is_enabled - is the regulator output enabled
  * @regulator: regulator source
  *
- * Returns zero for disabled otherwise return number of enable requests.
+ * Returns positive if the regulator driver backing the source/client
+ * has requested that the device be enabled, zero if it hasn't, else a
+ * negative errno code.
+ *
+ * Note that the device backing this regulator handle can have multiple
+ * users, so it might be enabled even if regulator_enable() was never
+ * called for this particular source.
  */
 int regulator_is_enabled(struct regulator *regulator)
 {
