Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbYKLBk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbYKLBk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 20:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbYKLBkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 20:40:04 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:31367 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752131AbYKLBkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 20:40:01 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:To:Subject:Cc:Content-Disposition:From:Date:MIME-Version:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=Ug7axtAl6dyvv1YCdY9wBvdb8xPt8DcI+gBHJlMqFox6J1xe0c0BcUdEDf2G0JmhIChUwDZDGh5LMpRaIQ3wmnGXrfA0RQODsfemVuOEp22BLUNFKet8L4VV5ymttUJcmtMsT/2S5ajGU+Nq6/K/pFku4Qg5/w7Aaai7WeU2O/Q=  ;
X-YMail-OSG: ApboXn8VM1m74Fu9yL3qeLENgGQi4Nn7spEZpZDzv7nDRFx2rVyuJBOgWDrfLUhi_iLAf2Sd0X5dmkiennk2DpLy3ucU6.VSaATmzyrmlKrLslE0gudD3hJyCvfgUhEbKrQO1cGcpVW.5EHAo_OV8zMBASkyXInHMbq2Rquq3kBjSq6zhk0pUmFEF36y
X-Yahoo-Newman-Property: ymail-3
To: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk
Subject: [patch 2.6.28-rc4 3/3] regulator: add REGULATOR_MODE_OFF (v2)
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: David Brownell <david-b@pacbell.net>
Date: Tue, 11 Nov 2008 17:39:08 -0800
MIME-Version: 1.0
Message-Id: <200811111739.08737.david-b@pacbell.net>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

The regulator framework needs to better distinguish actual hardware
state reported by regulator_ops.get_mode() from whatever Linux last
requested.  Some examples:

  - Overcurrent events can turn regulators off, and even if
    there's a notification, Linux may not have received it.

  - TWL4030 regulator state is effectively the result of a vote
    among three parties; the Linux vote can be overridden.
 
This patch:

  - Updates the sysfs documentation to match the regulator_get_mode()
    description, clarifing that the "opmode" attribute exposes what
    the regulator driver reports.

  - Adds a new "requested_opmode" attribute matching the previous
    documented semantics for "opmode":  report what Linux last
    requested.  (Those semantics still seem dubious to me ...)

  - Adds REGULATOR_MODE_OFF which can be reported by hardware,
    but not is not used in regulator_ops mode setting methods.
    (The disable methods are still exclusively used for that.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Difference from V1: add new sysfs attribute and the state
it tracks; update syfs docs; refocus patch description on
the distinction betwen Linux' view and the hardware state.

 Documentation/ABI/testing/sysfs-class-regulator |   42 +++++++++++++++++++---
 drivers/regulator/core.c                        |   40 +++++++++++++++++---
 include/linux/regulator/consumer.h              |    7 +++
 3 files changed, 77 insertions(+), 12 deletions(-)

--- a/Documentation/ABI/testing/sysfs-class-regulator
+++ b/Documentation/ABI/testing/sysfs-class-regulator
@@ -23,7 +23,9 @@ Description:
 		the reported state is invalid.
 
 		NOTE: this field can be used in conjunction with microvolts
-		and microamps to determine regulator output levels.
+		and microamps to determine regulator output levels requested
+		by Linux.  Use "opmode" to determine actual regulator state,
+		which can reflect actions not controlled by Linux.
 
 
 What:		/sys/class/regulator/.../type
@@ -95,13 +97,20 @@ Description:
 		'normal'
 		'idle'
 		'standby'
-		'unknown'
+		'off'
+		'unknown' (reported state is invalid)
 
 		The modes are described in include/linux/regulator/consumer.h
 
-		NOTE: This value should not be used to determine the regulator
-		output operating mode as this value is the same regardless of
-		whether the regulator is enabled or disabled.
+		NOTE: this is the actual hardware state reported by the
+		regulator driver.  In contrast to "requested_opmode"
+		(see below), this can reflect actions not controlled by
+		Linux software.
+
+		For example, another system component may have asked the
+		regulator to enter "normal" mode although Linux-controlled
+		devices can suffice with "standby" (or even "off") levels.
+		Or an overcurrent event might have shut the regulator down.
 
 
 What:		/sys/class/regulator/.../min_microvolts
@@ -187,6 +196,29 @@ Description:
 		have called regulator_enable() on this regulator.
 
 
+What:		/sys/class/regulator/.../requested_opmode
+Date:		November 2008
+KernelVersion:	2.6.28
+Description:
+		Some regulator directories will contain a field called
+		requested_opmode. This reports the last requested regulator
+		operating mode, for regulators which can change that mode.
+
+		The opmode value can be one of the following strings:
+
+		'fast'
+		'normal'
+		'idle'
+		'standby'
+
+		The modes are described in include/linux/regulator/consumer.h
+
+		NOTE: This value should not be used to determine the regulator
+		output operating mode as this value is the same regardless of
+		whether the regulator is enabled or disabled, and regardless
+		of what non-Linux components may have done.
+
+
 What:		/sys/class/regulator/.../requested_microamps
 Date:		April 2008
 KernelVersion:	2.6.26
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -37,6 +37,7 @@ static LIST_HEAD(regulator_map_list);
 struct regulator_dev {
 	struct regulator_desc *desc;
 	int use_count;
+	int requested_mode;
 
 	/* lists we belong to */
 	struct list_head list; /* list of all regulators */
@@ -270,6 +271,8 @@ static ssize_t regulator_print_opmode(ch
 		return sprintf(buf, "idle\n");
 	case REGULATOR_MODE_STANDBY:
 		return sprintf(buf, "standby\n");
+	case REGULATOR_MODE_OFF:
+		return sprintf(buf, "off\n");
 	}
 	return sprintf(buf, "unknown\n");
 }
@@ -283,6 +286,15 @@ static ssize_t regulator_opmode_show(str
 }
 static DEVICE_ATTR(opmode, 0444, regulator_opmode_show, NULL);
 
+static ssize_t regulator_requested_mode_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
+
+	return regulator_print_opmode(buf, rdev->requested_mode);
+}
+static DEVICE_ATTR(requested_opmode, 0444, regulator_requested_mode_show, NULL);
+
 static ssize_t regulator_print_state(char *buf, int state)
 {
 	if (state > 0)
@@ -542,8 +554,10 @@ static void drms_uA_update(struct regula
 
 	/* check the new mode is allowed */
 	err = regulator_check_mode(rdev, mode);
-	if (err == 0)
-		rdev->desc->ops->set_mode(rdev, mode);
+	if (err == 0) {
+		if (rdev->desc->ops->set_mode(rdev, mode) > 0)
+			rdev->requested_mode = mode;
+	}
 }
 
 static int suspend_set_state(struct regulator_dev *rdev,
@@ -559,7 +573,7 @@ static int suspend_set_state(struct regu
 		return -EINVAL;
 	}
 
-	if (rstate->enabled)
+	if (rstate->enabled && rstate->mode != REGULATOR_MODE_OFF)
 		ret = rdev->desc->ops->set_suspend_enable(rdev);
 	else
 		ret = rdev->desc->ops->set_suspend_disable(rdev);
@@ -638,7 +652,9 @@ static void print_constraints(struct reg
 	if (constraints->valid_modes_mask & REGULATOR_MODE_IDLE)
 		count += sprintf(buf + count, "idle ");
 	if (constraints->valid_modes_mask & REGULATOR_MODE_STANDBY)
-		count += sprintf(buf + count, "standby");
+		count += sprintf(buf + count, "standby ");
+	if (constraints->valid_modes_mask & REGULATOR_MODE_OFF)
+		count += sprintf(buf + count, "off ");
 
 	printk(KERN_INFO "regulator: %s: %s\n", rdev->desc->name, buf);
 }
@@ -1332,7 +1348,8 @@ EXPORT_SYMBOL_GPL(regulator_get_current_
  * @mode: operating mode - one of the REGULATOR_MODE constants
  *
  * Set regulator operating mode to increase regulator efficiency or improve
- * regulation performance.
+ * regulation performance.  You may not pass REGULATOR_MODE_OFF; to achieve
+ * that effect, call regulator_disable().
  *
  * NOTE: Regulator system constraints must be set for this regulator before
  * calling this function otherwise this call will fail.
@@ -1342,6 +1359,9 @@ int regulator_set_mode(struct regulator 
 	struct regulator_dev *rdev = regulator->rdev;
 	int ret;
 
+	if (mode == REGULATOR_MODE_OFF)
+		return -EINVAL;
+
 	mutex_lock(&rdev->mutex);
 
 	/* sanity check */
@@ -1356,6 +1376,8 @@ int regulator_set_mode(struct regulator 
 		goto out;
 
 	ret = rdev->desc->ops->set_mode(rdev, mode);
+	if (ret > 0)
+		rdev->requested_mode = mode;
 out:
 	mutex_unlock(&rdev->mutex);
 	return ret;
@@ -1475,7 +1497,8 @@ int regulator_set_optimum_mode(struct re
 		printk(KERN_ERR "%s: failed to set optimum mode %x for %s\n",
 			__func__, mode, rdev->desc->name);
 		goto out;
-	}
+	} else
+		rdev->requested_mode = mode;
 	ret = mode;
 out:
 	mutex_unlock(&rdev->mutex);
@@ -1709,6 +1732,11 @@ static int add_regulator_attributes(stru
 		if (status < 0)
 			return status;
 	}
+	if (ops->set_mode) {
+		status = device_create_file(dev, &dev_attr_requested_opmode);
+		if (status < 0)
+			return status;
+	}
 	if (ops->is_enabled) {
 		status = device_create_file(dev, &dev_attr_state);
 		if (status < 0)
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -68,16 +68,21 @@
  *             the most noisy and may not be able to handle fast load
  *             switching.
  *
+ *  OFF        Regulator is disabled.  This mode may be observed from
+ *             some hardware after invoking disable() primitives, or
+ *             after events not controlled by Linux.
+ *
  * NOTE: Most regulators will only support a subset of these modes. Some
  * will only just support NORMAL.
  *
- * These modes can be OR'ed together to make up a mask of valid register modes.
+ * These modes can be OR'ed together to make up a mask of valid modes.
  */
 
 #define REGULATOR_MODE_FAST			0x1
 #define REGULATOR_MODE_NORMAL			0x2
 #define REGULATOR_MODE_IDLE			0x4
 #define REGULATOR_MODE_STANDBY			0x8
+#define REGULATOR_MODE_OFF			0x10
 
 /*
  * Regulator notifier events.
