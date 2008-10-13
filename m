Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbYJMLKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbYJMLKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 07:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758590AbYJMLKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 07:10:39 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48527 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409AbYJMLKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 07:10:37 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: Roland Dreier <rolandd@cisco.com>, general@lists.openfabrics.org,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH]IB/ehca:reject dynamic memory add/remove
Date: Mon, 13 Oct 2008 13:10:32 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: hnguyen@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810131310.34413.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the ehca device driver does not support dynamic memory add and remove
operations, the driver must explicitly reject such requests in order to prevent
unpredictable behaviors related to memory regions already occupied and being
used by InfiniBand applications.
The solution is to add a memory notifier to the ehca device driver and if a request
for dynamic memory add or remove comes in, ehca will always reject it.

Signed-off-by: Stefan Roscher <stefan.roscher@de.ibm.com>
---

diff -Nurp linux-2.6.27-rc6-7/drivers/infiniband/hw/ehca/ehca_main.c linux-2.6.27-rc6-7.new/drivers/infiniband/hw/ehca/ehca_main.c
--- linux-2.6.27-rc6-7/drivers/infiniband/hw/ehca/ehca_main.c	2008-09-16 18:19:27.000000000 +0200
+++ linux-2.6.27-rc6-7.new/drivers/infiniband/hw/ehca/ehca_main.c	2008-10-03 13:52:50.000000000 +0200
@@ -44,6 +44,8 @@
 #include <linux/slab.h>
 #endif
 
+#include <linux/notifier.h>
+#include <linux/memory.h>
 #include "ehca_classes.h"
 #include "ehca_iverbs.h"
 #include "ehca_mrmw.h"
@@ -964,6 +966,41 @@ void ehca_poll_eqs(unsigned long data)
 	spin_unlock(&shca_list_lock);
 }
 
+static int ehca_mem_notifier(struct notifier_block *nb,
+                             unsigned long action, void *data)
+{
+	static unsigned long ehca_dmem_warn_time;
+
+	switch (action) {
+	case MEM_CANCEL_OFFLINE:
+	case MEM_CANCEL_ONLINE:
+	case MEM_ONLINE:
+	case MEM_OFFLINE:
+		return NOTIFY_OK;
+	case MEM_GOING_ONLINE:
+	case MEM_GOING_OFFLINE:
+		/* only ok if no hca is attached to the lpar */
+		spin_lock(&shca_list_lock);
+		if (list_empty(&shca_list)) {
+			spin_unlock(&shca_list_lock);
+			return NOTIFY_OK;
+		} else {
+			spin_unlock(&shca_list_lock);
+			if (printk_timed_ratelimit(&ehca_dmem_warn_time,
+						   30 * 1000))
+				ehca_gen_err("DMEM operations are not allowed"
+					     "as long as an ehca adapter is"
+					     "attached to the LPAR");
+			return NOTIFY_BAD;
+		}
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block ehca_mem_nb = {
+	.notifier_call = ehca_mem_notifier,
+};
+
 static int __init ehca_module_init(void)
 {
 	int ret;
@@ -991,6 +1028,12 @@ static int __init ehca_module_init(void)
 		goto module_init2;
 	}
 
+	ret = register_memory_notifier(&ehca_mem_nb);
+	if (ret) {
+		ehca_gen_err("Failed registering memory add/remove notifier");
+		goto module_init3;
+	}
+
 	if (ehca_poll_all_eqs != 1) {
 		ehca_gen_err("WARNING!!!");
 		ehca_gen_err("It is possible to lose interrupts.");
@@ -1003,6 +1046,9 @@ static int __init ehca_module_init(void)
 
 	return 0;
 
+module_init3:
+	ibmebus_unregister_driver(&ehca_driver);
+
 module_init2:
 	ehca_destroy_slab_caches();
 
@@ -1018,6 +1064,8 @@ static void __exit ehca_module_exit(void
 
 	ibmebus_unregister_driver(&ehca_driver);
 
+	unregister_memory_notifier(&ehca_mem_nb);
+
 	ehca_destroy_slab_caches();
 
 	ehca_destroy_comp_pool();
