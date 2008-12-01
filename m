Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbYLAIa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbYLAIa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 03:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYLAIat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 03:30:49 -0500
Received: from ozlabs.org ([203.10.76.45]:51562 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbYLAIas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 03:30:48 -0500
To: Douglas_Warzecha@dell.com
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 1 Dec 2008 19:00:42 +1030
Subject: [PATCH] work_on_cpu: use on drivers/firmware/dcdbas.c
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011900.43852.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use work_on_cpu instead of cpumask games.

Doug: note one subtle change.  If we can't get to CPU 0 for some
reason, the return will be -EINVAL not -EBUSY.

Doug: want me to fix this in the caller?  ie:

	return work_on_cpu(0, generate_smi, smi_cmd) == 0 ? 0 : -EBUSY;

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Douglas_Warzecha@dell.com
---
 drivers/firmware/dcdbas.c |   46 +++++++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 27 deletions(-)

diff -r 155c7f2e2e30 drivers/firmware/dcdbas.c
--- a/drivers/firmware/dcdbas.c	Thu Oct 23 11:22:04 2008 +1100
+++ b/drivers/firmware/dcdbas.c	Thu Oct 23 11:23:38 2008 +1100
@@ -237,31 +237,9 @@ static ssize_t host_control_on_shutdown_
 	return count;
 }
 
-/**
- * smi_request: generate SMI request
- *
- * Called with smi_data_lock.
- */
-static int smi_request(struct smi_cmd *smi_cmd)
+static long generate_smi(void *_smi_cmd)
 {
-	cpumask_t old_mask;
-	int ret = 0;
-
-	if (smi_cmd->magic != SMI_CMD_MAGIC) {
-		dev_info(&dcdbas_pdev->dev, "%s: invalid magic value\n",
-			 __func__);
-		return -EBADR;
-	}
-
-	/* SMI requires CPU 0 */
-	old_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(0));
-	if (smp_processor_id() != 0) {
-		dev_dbg(&dcdbas_pdev->dev, "%s: failed to get CPU 0\n",
-			__func__);
-		ret = -EBUSY;
-		goto out;
-	}
+	struct smi_cmd *smi_cmd = _smi_cmd;
 
 	/* generate SMI */
 	asm volatile (
@@ -273,10 +251,24 @@ static int smi_request(struct smi_cmd *s
 		  "c" (smi_cmd->ecx)
 		: "memory"
 	);
+	return 0;
+}
 
-out:
-	set_cpus_allowed_ptr(current, &old_mask);
-	return ret;
+/**
+ * smi_request: generate SMI request
+ *
+ * Called with smi_data_lock.
+ */
+static int smi_request(struct smi_cmd *smi_cmd)
+{
+	if (smi_cmd->magic != SMI_CMD_MAGIC) {
+		dev_info(&dcdbas_pdev->dev, "%s: invalid magic value\n",
+			 __func__);
+		return -EBADR;
+	}
+
+	/* SMI requires CPU 0 */
+	return work_on_cpu(0, generate_smi, smi_cmd);
 }
 
 /**


