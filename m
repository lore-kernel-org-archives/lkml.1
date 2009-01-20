Return-Path: <linux-kernel-owner+w=401wt.eu-S1761631AbZATNTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761631AbZATNTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 08:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbZATNTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 08:19:38 -0500
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:50389 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbZATNTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 08:19:38 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4975CF70.5080802@gmail.com>
Date: Tue, 20 Jan 2009 13:19:44 +0000
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Mark Brown <broonie@sirena.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Liam Girdwood <lrg@kernel.org>
Subject: regulator: Add disable_on_boot flag to constraints.
References: <4975BE69.5040106@cam.ac.uk> <20090120124338.GA31521@sirena.org.uk> <4975CAF5.9090607@cam.ac.uk>
In-Reply-To: <4975CAF5.9090607@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>

regulator: Add disable_on_boot flag to constraints.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>

---
Changes in response to Mark Browns comments.

Patch changed to disable_on_boot for more flexibility.
This only really involved removing the check in the enable code
found in the previous patch.

This is intended to allow the disabling of regulators during
registration.  Typical use case is regulators that aren't
actually connected to anything.

This is against a clean 2.6.29-rc2-git1 tree.

 drivers/regulator/core.c          |   19 ++++++++++++++++++-
 include/linux/regulator/machine.h |    7 ++++---
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f511a40..7d57338 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -709,7 +709,14 @@ static int set_machine_constraints(struct
regulator_dev *rdev,
             goto out;
         }
     }
-
+    /* Sanity check */
+    if (constraints->always_on && constraints->disable_on_boot) {
+        printk(KERN_ERR "%s: always on and disable at boot both set for
%s\n",
+               __func__, name);
+        rdev->constraints = NULL;
+        ret = -EINVAL;
+        goto out;
+    }
     /* if always_on is set then turn the regulator on if it's not
      * already on. */
     if (constraints->always_on && ops->enable &&
@@ -722,6 +729,16 @@ static int set_machine_constraints(struct
regulator_dev *rdev,
             rdev->constraints = NULL;
             goto out;
         }
+    } else if (constraints->disable_on_boot && ops->disable &&
+           ((ops->is_enabled && ops->is_enabled(rdev)) ||
+            (!ops->is_enabled && constraints->boot_on))) {
+        ret = ops->disable(rdev);
+        if (ret < 0) {
+            printk(KERN_ERR "%s: failed to disable %s\n",
+                   __func__, name);
+            rdev->constraints = NULL;
+            goto out;
+        }
     }
 
     print_constraints(rdev);
diff --git a/include/linux/regulator/machine.h
b/include/linux/regulator/machine.h
index 3794773..fc0a641 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -112,10 +112,10 @@ struct regulation_constraints {
     suspend_state_t initial_state; /* suspend state to set at init */
 
     /* constriant flags */
-    unsigned always_on:1;    /* regulator never off when system is on */
-    unsigned boot_on:1;    /* bootloader/firmware enabled regulator */
-    unsigned apply_uV:1;    /* apply uV constraint iff min == max */
+    unsigned always_on:1;        /* regulator never off when system on */
+    unsigned boot_on:1;        /* bootloader/firmware enabled reg */
+    unsigned disable_on_boot:1;    /* regulator to be disabled at boot */
+    unsigned apply_uV:1;        /* apply uV constraint iff min == max */
 };
 
 /**



