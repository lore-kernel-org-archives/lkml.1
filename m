Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbYKIXb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbYKIXb6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 18:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbYKIXbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 18:31:49 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:47758 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756442AbYKIXbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 18:31:48 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ri0Ps20jtM5VXpWQHS4W6Xmnjo6iiR2eg5SMelLGmM4/9ghqyAqckXwsDSdOToSLklnheOABd87hl0JVMNEg28XGLUSgv4IsEQoH1TCznVA29wHa/pviOQkBnCUJuKXw+07aWxDE0dI0jIjq8ypT5dIfo9K5Fi7dQdM6gOcGs4k=  ;
X-YMail-OSG: SCSFzpoVM1kobM6u3AqyXigTlfO0k9m5jyPzOMykwbFQd3fGw6RKwVd2jkznXnxcYYEHvnJfpfHf2_wj19AzIjjper1RkgZtWvGEx5JiZi1ESg1_3t82zPn3Zj0n_XZ9obFvVZlvAuKWyu83s04NDoa0IyvXNuUa_twShDfFKvhBCVAQ9II5QIT06ZCh
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk
Subject: [patch 2.6.28-rc3] regulator: add REGULATOR_MODE_OFF
Date: Sun, 9 Nov 2008 15:31:45 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811091531.46003.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

The regulator framework needs to expose an OFF mode for regulators
with a single state machine.  Example:  TWL4030 regulators each
have a status register exposing the current mode, which will be
either ACTIVE, STANDBY, or OFF.  But regulator_ops.get_mode()
currently has no way to report that third (OFF) mode.

Add such an OFF mode, reporting it in the standard ways.

In the spirit of the existing interface, disable() operations are
still used to enter this mode:

 - regulator_set_mode() rejects it; drivers doing runtime power
   management must use regulator_disable().

 - the PM_SUSPEND_* notifier goes down the set_suspend_disable()
   path, not requiring set_suspend_mode() to handle OFF mode.

This doesn't address any other enable/disable issues... like the
way regulator_disable() clobbers state even on failure paths, or
refcounting isssues (e.g. two clients enable, one disables, then
the regulator should stay active.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/regulator/core.c           |   16 +++++++++++++---
 include/linux/regulator/consumer.h |    4 ++++
 2 files changed, 17 insertions(+), 3 deletions(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -272,6 +272,8 @@ static ssize_t regulator_opmode_show(str
 		return sprintf(buf, "idle\n");
 	case REGULATOR_MODE_STANDBY:
 		return sprintf(buf, "standby\n");
+	case REGULATOR_MODE_OFF:
+		return sprintf(buf, "off\n");
 	}
 	return sprintf(buf, "unknown\n");
 }
@@ -411,6 +413,8 @@ static ssize_t suspend_opmode_show(struc
 		return sprintf(buf, "idle\n");
 	case REGULATOR_MODE_STANDBY:
 		return sprintf(buf, "standby\n");
+	case REGULATOR_MODE_OFF:
+		return sprintf(buf, "off\n");
 	}
 	return sprintf(buf, "unknown\n");
 }
@@ -589,7 +593,7 @@ static int suspend_set_state(struct regu
 		return -EINVAL;
 	}
 
-	if (rstate->enabled)
+	if (rstate->enabled && rstate->mode != REGULATOR_MODE_OFF)
 		ret = rdev->desc->ops->set_suspend_enable(rdev);
 	else
 		ret = rdev->desc->ops->set_suspend_disable(rdev);
@@ -668,7 +672,9 @@ static void print_constraints(struct reg
 	if (constraints->valid_modes_mask & REGULATOR_MODE_IDLE)
 		count += sprintf(buf + count, "idle ");
 	if (constraints->valid_modes_mask & REGULATOR_MODE_STANDBY)
-		count += sprintf(buf + count, "standby");
+		count += sprintf(buf + count, "standby ");
+	if (constraints->valid_modes_mask & REGULATOR_MODE_OFF)
+		count += sprintf(buf + count, "off ");
 
 	printk(KERN_INFO "regulator: %s: %s\n", rdev->desc->name, buf);
 }
@@ -1362,7 +1368,8 @@ EXPORT_SYMBOL_GPL(regulator_get_current_
  * @mode: operating mode - one of the REGULATOR_MODE constants
  *
  * Set regulator operating mode to increase regulator efficiency or improve
- * regulation performance.
+ * regulation performance.  You may not pass REGULATOR_MODE_OFF; to achieve
+ * that effect, call regulator_disable().
  *
  * NOTE: Regulator system constraints must be set for this regulator before
  * calling this function otherwise this call will fail.
@@ -1372,6 +1379,9 @@ int regulator_set_mode(struct regulator 
 	struct regulator_dev *rdev = regulator->rdev;
 	int ret;
 
+	if (mode == REGULATOR_MODE_OFF)
+		return -EINVAL;
+
 	mutex_lock(&rdev->mutex);
 
 	/* sanity check */
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -68,6 +68,9 @@
  *             the most noisy and may not be able to handle fast load
  *             switching.
  *
+ *  OFF        Regulator is disabled.  This mode may be observed from
+ *             some hardware after invoking disable() primitives.
+ *
  * NOTE: Most regulators will only support a subset of these modes. Some
  * will only just support NORMAL.
  *
@@ -78,6 +81,7 @@
 #define REGULATOR_MODE_NORMAL			0x2
 #define REGULATOR_MODE_IDLE			0x4
 #define REGULATOR_MODE_STANDBY			0x8
+#define REGULATOR_MODE_OFF			0x10
 
 /*
  * Regulator notifier events.
