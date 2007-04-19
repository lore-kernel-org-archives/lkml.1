Return-Path: <linux-kernel-owner+w=401wt.eu-S2993193AbXDSIKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993193AbXDSIKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 04:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993200AbXDSIKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 04:10:08 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33926 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993196AbXDSIJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 04:09:55 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Frank Pavlic <fpavlic@de.ibm.com>
Subject: [PATCH] s390/net/lcs: Convert to the kthread API
Date: Thu, 19 Apr 2007 01:58:40 -0600
Message-Id: <11769695682070-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.1.1.g2de0
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Use kthread_run to start the lcs kernel threads not a
combination of kernel_thread and daemonize.  This makes
the code slightly simpler and more maintainable.

Cc: Frank Pavlic <fpavlic@de.ibm.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/s390/net/lcs.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
index 08a994f..0300d87 100644
--- a/drivers/s390/net/lcs.c
+++ b/drivers/s390/net/lcs.c
@@ -36,6 +36,7 @@
 #include <linux/in.h>
 #include <linux/igmp.h>
 #include <linux/delay.h>
+#include <linux/kthread.h>
 #include <net/arp.h>
 #include <net/ip.h>
 
@@ -1248,7 +1249,6 @@ lcs_register_mc_addresses(void *data)
 	struct in_device *in4_dev;
 
 	card = (struct lcs_card *) data;
-	daemonize("regipm");
 
 	if (!lcs_do_run_thread(card, LCS_SET_MC_THREAD))
 		return 0;
@@ -1728,11 +1728,10 @@ lcs_start_kernel_thread(struct work_struct *work)
 	struct lcs_card *card = container_of(work, struct lcs_card, kernel_thread_starter);
 	LCS_DBF_TEXT(5, trace, "krnthrd");
 	if (lcs_do_start_thread(card, LCS_RECOVERY_THREAD))
-		kernel_thread(lcs_recovery, (void *) card, SIGCHLD);
+		kthread_run(lcs_recovery, card, "lcs_recover");
 #ifdef CONFIG_IP_MULTICAST
 	if (lcs_do_start_thread(card, LCS_SET_MC_THREAD))
-		kernel_thread(lcs_register_mc_addresses,
-				(void *) card, SIGCHLD);
+		kernel_run(lcs_register_mc_addresses, card, "regipm");
 #endif
 }
 
@@ -2232,7 +2231,6 @@ lcs_recovery(void *ptr)
         int rc;
 
 	card = (struct lcs_card *) ptr;
-	daemonize("lcs_recover");
 
 	LCS_DBF_TEXT(4, trace, "recover1");
 	if (!lcs_do_run_thread(card, LCS_RECOVERY_THREAD))
-- 
1.5.0.g53756

