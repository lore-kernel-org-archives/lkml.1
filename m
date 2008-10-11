Return-Path: <linux-kernel-owner+w=401wt.eu-S1759213AbYJKGmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213AbYJKGmV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbYJKGhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:37:32 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:50828 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbYJKGhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:14 -0400
Date: Sat, 11 Oct 2008 02:36:31 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 71/85] acer-wmi: Remove private workqueue
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Len Brown <len.brown@intel.com>
Message-id: <ae3a1b46099aa87f1662621580c985432ca1c9d9.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carlos Corbacho <carlos@strangeworlds.co.uk>

As per Dmitry Torokhov's suggestion, acer-wmi doesn't need a private
workqueue, so remove it.

Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/misc/acer-wmi.c |   18 ++----------------
 1 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/misc/acer-wmi.c b/drivers/misc/acer-wmi.c
index 8708d31..cf4c39f 100644
--- a/drivers/misc/acer-wmi.c
+++ b/drivers/misc/acer-wmi.c
@@ -930,8 +930,6 @@ static void acer_backlight_exit(void)
 /*
  * Rfkill devices
  */
-static struct workqueue_struct *rfkill_workqueue;
-
 static void acer_rfkill_update(struct work_struct *ignored);
 static DECLARE_DELAYED_WORK(acer_rfkill_work, acer_rfkill_update);
 static void acer_rfkill_update(struct work_struct *ignored)
@@ -952,8 +950,7 @@ static void acer_rfkill_update(struct work_struct *ignored)
 				RFKILL_STATE_SOFT_BLOCKED);
 	}
 
-	queue_delayed_work(rfkill_workqueue, &acer_rfkill_work,
-		round_jiffies_relative(HZ));
+	schedule_delayed_work(&acer_rfkill_work, round_jiffies_relative(HZ));
 }
 
 static int acer_rfkill_set(void *data, enum rfkill_state state)
@@ -1018,17 +1015,7 @@ static int acer_rfkill_init(struct device *dev)
 		}
 	}
 
-	rfkill_workqueue = create_singlethread_workqueue("rfkill_workqueue");
-	if (!rfkill_workqueue) {
-		if (has_cap(ACER_CAP_BLUETOOTH)) {
-			kfree(bluetooth_rfkill->data);
-			rfkill_unregister(bluetooth_rfkill);
-		}
-		kfree(wireless_rfkill->data);
-		rfkill_unregister(wireless_rfkill);
-		return -ENOMEM;
-	}
-	queue_delayed_work(rfkill_workqueue, &acer_rfkill_work, HZ);
+	schedule_delayed_work(&acer_rfkill_work, round_jiffies_relative(HZ));
 
 	return 0;
 }
@@ -1036,7 +1023,6 @@ static int acer_rfkill_init(struct device *dev)
 static void acer_rfkill_exit(void)
 {
 	cancel_delayed_work_sync(&acer_rfkill_work);
-	destroy_workqueue(rfkill_workqueue);
 	kfree(wireless_rfkill->data);
 	rfkill_unregister(wireless_rfkill);
 	if (has_cap(ACER_CAP_BLUETOOTH)) {
-- 
1.5.5.1

