Return-Path: <linux-kernel-owner+w=401wt.eu-S1759963AbXG2DtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963AbXG2DtZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 23:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbXG2DtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 23:49:16 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:17034 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618AbXG2DtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 23:49:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAAqrq0arR7O6/2dsb2JhbAA
X-IronPort-AV: i="4.19,194,1183359600"; 
   d="scan'208"; a="190499691:sNHT27883224"
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] bsg: Fix warning with CONFIG_BLK_DEV_BSG=n
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Sat, 28 Jul 2007 20:49:14 -0700
Message-ID: <ada6443vphh.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Jul 2007 03:49:14.0799 (UTC) FILETIME=[6E8583F0:01C7D193]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The current stub definitions of bsg_register_queue() and
bsg_unregister_queue() as macros leads to

    drivers/scsi/scsi_sysfs.c: In function 'scsi_sysfs_add_sdev':
    drivers/scsi/scsi_sysfs.c:718: warning: unused variable 'rq'

because the first parameter of bsg_register_queue() is completely
discarded.  As akpm says, "program in C, not in cpp."  We might as
well get a little bit better type-checking when we fix this by
converting the stubs to empty inline functions.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 include/linux/bsg.h |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index f415f89..69e23e1 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -60,8 +60,13 @@ struct bsg_class_device {
 extern int bsg_register_queue(struct request_queue *, struct device *, const char *);
 extern void bsg_unregister_queue(struct request_queue *);
 #else
-#define bsg_register_queue(disk, dev, name)		(0)
-#define bsg_unregister_queue(disk)	do { } while (0)
+static inline int bsg_register_queue(struct request_queue *q, struct device *gdev,
+				     const char *name)
+{
+	return 0;
+}
+
+static inline void bsg_unregister_queue(struct request_queue *q) { }
 #endif
 
 #endif /* __KERNEL__ */
