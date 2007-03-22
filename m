Return-Path: <linux-kernel-owner+w=401wt.eu-S933367AbXCVPzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367AbXCVPzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 11:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933460AbXCVPzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 11:55:22 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:31160 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933367AbXCVPzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 11:55:21 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: rolandd@cisco.com, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: [PATCH] eHCA: Make scaling code also work without CPU hotplug
Date: Thu, 22 Mar 2007 16:52:13 +0100
User-Agent: KMail/1.6.2
Cc: hnguyen@de.ibm.com
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703221652.13216.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

eHCA scaling code must not depend on register_cpu_notifier() if
CONFIG_HOTPLUG_CPU is not set, so put all related code into #ifdefs.


Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---


 ehca_irq.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index 20f36bf..f284be1 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -66,7 +66,9 @@ #define ERROR_DATA_TYPE        EHCA_BMAS
 static void queue_comp_task(struct ehca_cq *__cq);
 
 static struct ehca_comp_pool* pool;
+#ifdef CONFIG_HOTPLUG_CPU
 static struct notifier_block comp_pool_callback_nb;
+#endif
 
 static inline void comp_event_callback(struct ehca_cq *cq)
 {
@@ -733,6 +735,7 @@ static void take_over_work(struct ehca_c
 
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
 static int comp_pool_callback(struct notifier_block *nfb,
 			      unsigned long action,
 			      void *hcpu)
@@ -775,6 +778,7 @@ static int comp_pool_callback(struct not
 
 	return NOTIFY_OK;
 }
+#endif
 
 int ehca_create_comp_pool(void)
 {
@@ -805,9 +809,11 @@ int ehca_create_comp_pool(void)
 		}
 	}
 
+#ifdef CONFIG_HOTPLUG_CPU
 	comp_pool_callback_nb.notifier_call = comp_pool_callback;
 	comp_pool_callback_nb.priority =0;
 	register_cpu_notifier(&comp_pool_callback_nb);
+#endif
 
 	printk(KERN_INFO "eHCA scaling code enabled\n");
 
@@ -821,7 +827,9 @@ void ehca_destroy_comp_pool(void)
 	if (!ehca_scaling_code)
 		return;
 
+#ifdef CONFIG_HOTPLUG_CPU
 	unregister_cpu_notifier(&comp_pool_callback_nb);
+#endif
 
 	for (i = 0; i < NR_CPUS; i++) {
 		if (cpu_online(i))

