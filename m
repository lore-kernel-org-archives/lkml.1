Return-Path: <linux-kernel-owner+w=401wt.eu-S1760803AbYBNPm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760803AbYBNPm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbYBNPjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:39:32 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:49930 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753384AbYBNPjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:39:14 -0500
From: =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: bluez-devel@lists.sourceforge.net,
       =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
Subject: [PATCH 14/14] net/bluetooth/hci_core.c: Use time_* macros
Date: Thu, 14 Feb 2008 17:36:52 +0200
Message-Id: <1203003412-11594-15-git-send-email-caglar@pardus.org.tr>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: y
References: y
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions time_before, time_before_eq, time_after, and time_after_eq are more robust for comparing jiffies against other values.

So following patch implements usage of the time_after() macro, defined at linux/jiffies.h, which deals with wrapping correctly

Cc: bluez-devel@lists.sf.net
Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
---
 net/bluetooth/hci_core.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 372b0d3..930b58e 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -24,6 +24,7 @@
 
 /* Bluetooth HCI core. */
 
+#include <linux/jiffies.h>
 #include <linux/module.h>
 #include <linux/kmod.h>
 
@@ -1321,7 +1322,7 @@ static inline void hci_sched_acl(struct hci_dev *hdev)
 	if (!test_bit(HCI_RAW, &hdev->flags)) {
 		/* ACL tx timeout must be longer than maximum
 		 * link supervision timeout (40.9 seconds) */
-		if (!hdev->acl_cnt && (jiffies - hdev->acl_last_tx) > (HZ * 45))
+		if (!hdev->acl_cnt && time_after(jiffies, hdev->acl_last_tx + HZ * 45))
 			hci_acl_tx_to(hdev);
 	}
 
@@ -1543,7 +1544,7 @@ static void hci_cmd_task(unsigned long arg)
 
 	BT_DBG("%s cmd %d", hdev->name, atomic_read(&hdev->cmd_cnt));
 
-	if (!atomic_read(&hdev->cmd_cnt) && (jiffies - hdev->cmd_last_tx) > HZ) {
+	if (!atomic_read(&hdev->cmd_cnt) && time_after(jiffies, hdev->cmd_last_tx + HZ)) {
 		BT_ERR("%s command tx timeout", hdev->name);
 		atomic_set(&hdev->cmd_cnt, 1);
 	}
-- 
1.5.3.7

