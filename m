Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbXLXOpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbXLXOpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463AbXLXOpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:45:19 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:37011 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106AbXLXOpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:45:16 -0500
Date: Mon, 24 Dec 2007 15:45:03 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: marcel@holtmann.org, maxk@qualcomm.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 29/38] net/bluetooth: Use time_before, time_before_eq, etc.
Message-ID: <Pine.LNX.4.64.0712241544390.23999@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The functions time_before, time_before_eq, time_after, and time_after_eq
are more robust for comparing jiffies against other values.

A simplified version of the semantic patch making this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ change_compare_np @
expression E;
@@

(
- jiffies <= E
+ time_before_eq(jiffies,E)
|
- jiffies >= E
+ time_after_eq(jiffies,E)
|
- jiffies < E
+ time_before(jiffies,E)
|
- jiffies > E
+ time_after(jiffies,E)
)

@ include depends on change_compare_np @
@@

#include <linux/jiffies.h>

@ no_include depends on !include && change_compare_np @
@@

  #include <linux/...>
+ #include <linux/jiffies.h>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -r -u -p a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
--- a/net/bluetooth/hci_core.c	2007-11-01 10:30:44.000000000 +0100
+++ b/net/bluetooth/hci_core.c	2007-12-23 20:44:22.000000000 +0100
@@ -38,6 +38,7 @@
 #include <linux/skbuff.h>
 #include <linux/interrupt.h>
 #include <linux/notifier.h>
+#include <linux/jiffies.h>
 #include <net/sock.h>
 
 #include <asm/system.h>
@@ -1321,7 +1322,8 @@ static inline void hci_sched_acl(struct 
 	if (!test_bit(HCI_RAW, &hdev->flags)) {
 		/* ACL tx timeout must be longer than maximum
 		 * link supervision timeout (40.9 seconds) */
-		if (!hdev->acl_cnt && (jiffies - hdev->acl_last_tx) > (HZ * 45))
+		if (!hdev->acl_cnt &&
+		    time_after(jiffies, hdev->acl_last_tx + HZ * 45))
 			hci_acl_tx_to(hdev);
 	}
 
@@ -1543,7 +1545,8 @@ static void hci_cmd_task(unsigned long a
 
 	BT_DBG("%s cmd %d", hdev->name, atomic_read(&hdev->cmd_cnt));
 
-	if (!atomic_read(&hdev->cmd_cnt) && (jiffies - hdev->cmd_last_tx) > HZ) {
+	if (!atomic_read(&hdev->cmd_cnt) &&
+	    time_after(jiffies, hdev->cmd_last_tx + HZ)) {
 		BT_ERR("%s command tx timeout", hdev->name);
 		atomic_set(&hdev->cmd_cnt, 1);
 	}
