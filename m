Return-Path: <linux-kernel-owner+w=401wt.eu-S1752917AbZGZITv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbZGZITv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbZGZITt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:19:49 -0400
Received: from www.tglx.de ([62.245.132.106]:57944 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbZGZITq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:19:46 -0400
Message-Id: <20090726081555.202765397@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:18:19 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: [Patch RFC 15/37] bluetooth: Convert hdev->req_lock to mutex
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline;
	filename=bluetooth-convert-semaphore-to-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hdev->req_lock is used as mutex so make it a mutex.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Marcel Holtmann <marcel@holtmann.org>
---
 include/net/bluetooth/hci_core.h |    6 +++---
 net/bluetooth/hci_core.c         |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6-tip/include/net/bluetooth/hci_core.h
===================================================================
--- linux-2.6-tip.orig/include/net/bluetooth/hci_core.h
+++ linux-2.6-tip/include/net/bluetooth/hci_core.h
@@ -117,7 +117,7 @@ struct hci_dev {
 	struct sk_buff		*sent_cmd;
 	struct sk_buff		*reassembly[3];
 
-	struct semaphore	req_lock;
+	struct mutex		req_lock;
 	wait_queue_head_t	req_wait_q;
 	__u32			req_status;
 	__u32			req_result;
@@ -700,8 +700,8 @@ struct hci_sec_filter {
 #define HCI_REQ_PEND	  1
 #define HCI_REQ_CANCELED  2
 
-#define hci_req_lock(d)		down(&d->req_lock)
-#define hci_req_unlock(d)	up(&d->req_lock)
+#define hci_req_lock(d)		mutex_lock(&d->req_lock)
+#define hci_req_unlock(d)	mutex_unlock(&d->req_lock)
 
 void hci_req_complete(struct hci_dev *hdev, int result);
 
Index: linux-2.6-tip/net/bluetooth/hci_core.c
===================================================================
--- linux-2.6-tip.orig/net/bluetooth/hci_core.c
+++ linux-2.6-tip/net/bluetooth/hci_core.c
@@ -911,7 +911,7 @@ int hci_register_dev(struct hci_dev *hde
 		hdev->reassembly[i] = NULL;
 
 	init_waitqueue_head(&hdev->req_wait_q);
-	init_MUTEX(&hdev->req_lock);
+	mutex_init(&hdev->req_lock);
 
 	inquiry_cache_init(hdev);
 


