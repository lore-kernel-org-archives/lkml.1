Return-Path: <linux-kernel-owner+w=401wt.eu-S1762594AbZFKW7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762594AbZFKW7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 18:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760842AbZFKW71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 18:59:27 -0400
Received: from ozlabs.org ([203.10.76.45]:37882 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760644AbZFKW70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 18:59:26 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 11 Jun 2009 22:59:58 +0930
Subject: [PATCH 6/6] dcdbas: don't play with current's cpumask
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Douglas_Warzecha@dell.com
Message-Id: <20090611225928.31C72DDD1B@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's generally a very bad idea to mug some process's cpumask: it could
legitimately and reasonably be changed by root, which could break us
(if done before our code) or them (if we restore the wrong value).

So we use smp_call_function_single instead of cpumask games.  I hope we
are allowed to trigger the smi from interrupt context.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Douglas_Warzecha@dell.com
---
 drivers/firmware/dcdbas.c |   51 +++++++++++++++++-----------------------------
 1 file changed, 19 insertions(+), 32 deletions(-)

diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -237,34 +237,9 @@ static ssize_t host_control_on_shutdown_
 	return count;
 }
 
-/**
- * dcdbas_smi_request: generate SMI request
- *
- * Called with smi_data_lock.
- */
-int dcdbas_smi_request(struct smi_cmd *smi_cmd)
+static void generate_smi(void *_smi_cmd)
 {
-	cpumask_var_t old_mask;
-	int ret = 0;
-
-	if (smi_cmd->magic != SMI_CMD_MAGIC) {
-		dev_info(&dcdbas_pdev->dev, "%s: invalid magic value\n",
-			 __func__);
-		return -EBADR;
-	}
-
-	/* SMI requires CPU 0 */
-	if (!alloc_cpumask_var(&old_mask, GFP_KERNEL))
-		return -ENOMEM;
-
-	cpumask_copy(old_mask, &current->cpus_allowed);
-	set_cpus_allowed_ptr(current, cpumask_of(0));
-	if (smp_processor_id() != 0) {
-		dev_dbg(&dcdbas_pdev->dev, "%s: failed to get CPU 0\n",
-			__func__);
-		ret = -EBUSY;
-		goto out;
-	}
+	struct smi_cmd *smi_cmd = _smi_cmd;
 
 	/* generate SMI */
 	asm volatile (
@@ -276,14 +251,26 @@ int dcdbas_smi_request(struct smi_cmd *s
 		  "c" (smi_cmd->ecx)
 		: "memory"
 	);
-
-out:
-	set_cpus_allowed_ptr(current, old_mask);
-	free_cpumask_var(old_mask);
-	return ret;
 }
 
 /**
+ * dcdbas_smi_request: generate SMI request
+ *
+ * Called with smi_data_lock.
+ */
+int dcdbas_smi_request(struct smi_cmd *smi_cmd)
+{
+	if (smi_cmd->magic != SMI_CMD_MAGIC) {
+		dev_info(&dcdbas_pdev->dev, "%s: invalid magic value\n",
+			 __func__);
+		return -EBADR;
+	}
+
+	/* SMI requires CPU 0 */
+	smp_call_function_single(0, generate_smi, smi_cmd, 1);
+	return 0;
+}
+/**
  * smi_request_store:
  *
  * The valid values are:

