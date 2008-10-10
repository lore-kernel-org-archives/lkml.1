Return-Path: <linux-kernel-owner+w=401wt.eu-S1760766AbYJJOda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbYJJOda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 10:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757425AbYJJOdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 10:33:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43361 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757324AbYJJOdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 10:33:22 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: lrg@slimlogic.co.uk
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Export regulator name via sysfs
Date: Fri, 10 Oct 2008 15:33:20 +0100
Message-Id: <1223649200-14713-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a new file 'name' in the regulator sysfs class with a human
readable name for the regulator for use in applications.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

I've set the kernel version as 2.6.28 in the ABI file - if it doesn't
get merged in this merge window that'll obviously need to be updated.

 Documentation/ABI/testing/sysfs-class-regulator |   13 +++++++++++++
 drivers/regulator/core.c                        |   18 ++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-regulator b/Documentation/ABI/testing/sysfs-class-regulator
index 79a4a75..0731ff2 100644
--- a/Documentation/ABI/testing/sysfs-class-regulator
+++ b/Documentation/ABI/testing/sysfs-class-regulator
@@ -157,6 +157,19 @@ Description:
 		platform code.
 
 
+What:		/sys/class/regulator/.../name
+Date:		October 2008
+KernelVersion:	2.6.28
+Contact:	Liam Girdwood <lrg@slimlogic.co.uk>
+Description:
+		Each regulator directory will contain a field called
+		name. This holds a string identifying the regulator for
+		display purposes.
+
+		NOTE: this will be empty if no suitable name is provided
+		by platform or regulator drivers.
+
+
 What:		/sys/class/regulator/.../num_users
 Date:		April 2008
 KernelVersion:	2.6.26
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 9a6757d..02a7744 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -241,6 +241,22 @@ static ssize_t regulator_uA_show(struct device *dev,
 	return sprintf(buf, "%d\n", _regulator_get_current_limit(rdev));
 }
 
+static ssize_t regulator_name_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
+	const char *name;
+
+	if (rdev->constraints->name)
+		name = rdev->constraints->name;
+	else if (rdev->desc->name)
+		name = rdev->desc->name;
+	else
+		name = "";
+
+	return sprintf(buf, "%s\n", name);
+}
+
 static ssize_t regulator_opmode_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
@@ -473,7 +489,9 @@ static ssize_t regulator_suspend_standby_state_show(struct device *dev,
 	else
 		return sprintf(buf, "disabled\n");
 }
+
 static struct device_attribute regulator_dev_attrs[] = {
+	__ATTR(name, 0444, regulator_name_show, NULL),
 	__ATTR(microvolts, 0444, regulator_uV_show, NULL),
 	__ATTR(microamps, 0444, regulator_uA_show, NULL),
 	__ATTR(opmode, 0444, regulator_opmode_show, NULL),
-- 
1.5.6.5

