Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbZG1RSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbZG1RSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbZG1RSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:18:32 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:35481 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbZG1RSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:05 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h87h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DO-04-A2J-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 08/26] oprofile: Rename variable timeout_jiffies and move to oprofile_files.c
Date: Tue, 28 Jul 2009 19:07:08 +0200
Message-ID: <1248800846-25422-9-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:48.0322 (UTC) FILETIME=[54632820:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames timeout_jiffies into an oprofile specific name. The
macro MULTIPLEXING_TIMER_DEFAULT is changed too.

Also, since this variable is controlled using oprofilefs, its
definition is moved to oprofile_files.c.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/oprof.c          |    9 ++++-----
 drivers/oprofile/oprof.h          |    3 ++-
 drivers/oprofile/oprofile_files.c |    5 +++--
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index 42c9c76..2b33de7 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -33,8 +33,7 @@ static DEFINE_MUTEX(start_mutex);
 
 static void switch_worker(struct work_struct *work);
 static DECLARE_DELAYED_WORK(switch_work, switch_worker);
-unsigned long timeout_jiffies;
-#define MULTIPLEXING_TIMER_DEFAULT 1
+#define TIME_SLICE_DEFAULT		1
 
 #endif
 
@@ -102,7 +101,7 @@ out:
 
 static void start_switch_worker(void)
 {
-	schedule_delayed_work(&switch_work, timeout_jiffies);
+	schedule_delayed_work(&switch_work, oprofile_time_slice);
 }
 
 static void switch_worker(struct work_struct *work)
@@ -216,7 +215,7 @@ int oprofile_set_timeout(unsigned long val_msec)
 		goto out;
 	}
 
-	timeout_jiffies = time_slice;
+	oprofile_time_slice = time_slice;
 
 out:
 	mutex_unlock(&start_mutex);
@@ -253,7 +252,7 @@ out:
 
 static void __init oprofile_multiplexing_init(void)
 {
-	timeout_jiffies = msecs_to_jiffies(MULTIPLEXING_TIMER_DEFAULT);
+	oprofile_time_slice = msecs_to_jiffies(TIME_SLICE_DEFAULT);
 }
 
 #endif
diff --git a/drivers/oprofile/oprof.h b/drivers/oprofile/oprof.h
index ee38abc..cb92f5c 100644
--- a/drivers/oprofile/oprof.h
+++ b/drivers/oprofile/oprof.h
@@ -24,10 +24,11 @@ struct oprofile_operations;
 extern unsigned long oprofile_buffer_size;
 extern unsigned long oprofile_cpu_buffer_size;
 extern unsigned long oprofile_buffer_watershed;
+extern unsigned long oprofile_time_slice;
+
 extern struct oprofile_operations oprofile_ops;
 extern unsigned long oprofile_started;
 extern unsigned long oprofile_backtrace_depth;
-extern unsigned long timeout_jiffies;
 
 struct super_block;
 struct dentry;
diff --git a/drivers/oprofile/oprofile_files.c b/drivers/oprofile/oprofile_files.c
index 468ec3e..4c5b947 100644
--- a/drivers/oprofile/oprofile_files.c
+++ b/drivers/oprofile/oprofile_files.c
@@ -22,14 +22,15 @@
 unsigned long oprofile_buffer_size;
 unsigned long oprofile_cpu_buffer_size;
 unsigned long oprofile_buffer_watershed;
+unsigned long oprofile_time_slice;
 
 #ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
 
 static ssize_t timeout_read(struct file *file, char __user *buf,
 		size_t count, loff_t *offset)
 {
-	return oprofilefs_ulong_to_user(jiffies_to_msecs(timeout_jiffies),
-				buf, count, offset);
+	return oprofilefs_ulong_to_user(jiffies_to_msecs(oprofile_time_slice),
+					buf, count, offset);
 }
 
 
-- 
1.6.3.3


