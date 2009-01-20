Return-Path: <linux-kernel-owner+w=401wt.eu-S1760430AbZATMHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760430AbZATMHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 07:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbZATMHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 07:07:03 -0500
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:51003 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbZATMHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 07:07:01 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4975BE69.5040106@cam.ac.uk>
Date: Tue, 20 Jan 2009 12:07:05 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Mark Brown <broonie@sirena.org.uk>, Liam Girdwood <lrg@kernel.org>
Subject: regulator: Add always off to constraints.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

There are cases where particular ldo's aren't actually connected
to anything and currently there is no easy way of disabling them
if the pmic brings them up by default.  I propose adding an always
off parameter to the constraints to allow a minimal way of specifying
this within board configs.  I haven't submitted this as a formal
patch as it is currently based on top of the patch pushing
locks out of _notifier_call_chain which I posted yesterday.

If people are happy I can produce a version not dependent on that.

Problems I can see with this small change are:

1) interaction between always on and always off.  Obviously it's
a bit odd if both are set. Currently I'm giving always on preference.

2) Doesn't really make sense to have regulators that are always
disabled available under sysfs etc.  Perhaps there is a lower
level way of doing this that I'm missing?  There is not easy
way of permanently saving this stuff on the da9030 that I'm
using and moving it into the bootloader would be a pain.

There's actually no problem with leaving these regs running
and unmanaged except for the small amount of power being wasted
and a desire for tidiness ;)

---
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 245eee1..d11b5cf 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -722,6 +722,16 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 			rdev->constraints = NULL;
 			goto out;
 		}
+	} else if (constraints->always_off && ops->disable &&
+		   ((ops->is_enabled && ops->is_enabled(rdev)) ||
+		    (!ops->is_enabled && constraints->boot_on))) {
+		ret = ops->disable(rdev);
+		if (ret < 0) {
+			printk(KERN_ERR "%s: failed to disable %s\n",
+			       __func__, name);
+			rdev->constraints = NULL;
+			goto out;
+		}
 	}
 
 	print_constraints(rdev);
@@ -1002,7 +1012,7 @@ static int _regulator_enable(struct regulator_dev *rdev)
 	}
 
 	/* check voltage and requested load before enabling */
-	if (rdev->desc->ops->enable) {
+	if (rdev->desc->ops->enable && !rdev->constraints->always_off) {
 
 		if (rdev->constraints &&
 			(rdev->constraints->valid_ops_mask &
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index 3794773..56bbb89 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -113,6 +113,7 @@ struct regulation_constraints {
 
 	/* constriant flags */
 	unsigned always_on:1;	/* regulator never off when system is on */
+	unsigned always_off:1;	/* regulator never on under any circumstances */
 	unsigned boot_on:1;	/* bootloader/firmware enabled regulator */
 	unsigned apply_uV:1;	/* apply uV constraint iff min == max */
 };
