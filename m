Return-Path: <linux-kernel-owner+w=401wt.eu-S2993162AbXDSIFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993162AbXDSIFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 04:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993177AbXDSIEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 04:04:42 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45767 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993162AbXDSIDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 04:03:42 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Frank Pavlic <fpavlic@de.ibm.com>
Subject: [PATCH] s390 qeth: Convert to use the kthread API
Date: Thu, 19 Apr 2007 01:58:41 -0600
Message-Id: <11769695702829-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.1.1.g2de0
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

This patch modifies the qeth_recover thread to be started
with kthread_run not a combination of kernel_thread and
daemonize.  Resulting in slightly simpler and more maintainable
code.

Cc: Frank Pavlic <fpavlic@de.ibm.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/s390/net/qeth_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/net/qeth_main.c b/drivers/s390/net/qeth_main.c
index ad7792d..8234846 100644
--- a/drivers/s390/net/qeth_main.c
+++ b/drivers/s390/net/qeth_main.c
@@ -50,6 +50,7 @@
 #include <linux/mii.h>
 #include <linux/rcupdate.h>
 #include <linux/ethtool.h>
+#include <linux/kthread.h>
 
 #include <net/arp.h>
 #include <net/ip.h>
@@ -957,7 +958,6 @@ qeth_recover(void *ptr)
 	int rc = 0;
 
 	card = (struct qeth_card *) ptr;
-	daemonize("qeth_recover");
 	QETH_DBF_TEXT(trace,2,"recover1");
 	QETH_DBF_HEX(trace, 2, &card, sizeof(void *));
 	if (!qeth_do_run_thread(card, QETH_RECOVER_THREAD))
@@ -1014,7 +1014,7 @@ qeth_start_kernel_thread(struct work_struct *work)
 	    card->write.state != CH_STATE_UP)
 		return;
 	if (qeth_do_start_thread(card, QETH_RECOVER_THREAD))
-		kernel_thread(qeth_recover, (void *) card, SIGCHLD);
+		kthread_run(qeth_recover, card, "qeth_recover");
 }
 
 
-- 
1.5.0.g53756

