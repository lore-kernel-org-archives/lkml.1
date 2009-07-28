Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbZG1RSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbZG1RSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbZG1RSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:18:47 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:31666
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753716AbZG1RSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:17 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h87h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DT-03-BM9-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 23/26] oprofile: Adding switch counter to oprofile statistic variables
Date: Tue, 28 Jul 2009 19:07:23 +0200
Message-ID: <1248800846-25422-24-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:51.0353 (UTC) FILETIME=[5631A690:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the multiplexing switch counter from x86 code to
common oprofile statistic variables. Now the value will be available
and usable for all architectures. The initialization and
incrementation also moved to common code.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c       |    7 -------
 drivers/oprofile/oprof.c          |    7 +++++--
 drivers/oprofile/oprofile_stats.c |    9 ++-------
 drivers/oprofile/oprofile_stats.h |    1 +
 4 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index da6d2ab..7b3362f 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -34,11 +34,6 @@ static DEFINE_PER_CPU(unsigned long, saved_lvtpc);
 /* 0 == registered but off, 1 == registered and on */
 static int nmi_enabled = 0;
 
-
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-extern atomic_t multiplex_counter;
-#endif
-
 struct op_counter_config counter_config[OP_MAX_COUNTER];
 
 /* common functions */
@@ -253,8 +248,6 @@ static int nmi_switch_event(void)
 
 	on_each_cpu(nmi_cpu_switch, NULL, 1);
 
-	atomic_inc(&multiplex_counter);
-
 	return 0;
 }
 
diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index a48294a..dc8a042 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -107,8 +107,11 @@ static void stop_switch_worker(void)
 
 static void switch_worker(struct work_struct *work)
 {
-	if (!oprofile_ops.switch_events())
-		start_switch_worker();
+	if (oprofile_ops.switch_events())
+		return;
+
+	atomic_inc(&oprofile_stats.multiplex_counter);
+	start_switch_worker();
 }
 
 /* User inputs in ms, converts to jiffies */
diff --git a/drivers/oprofile/oprofile_stats.c b/drivers/oprofile/oprofile_stats.c
index 77a57a6..61689e8 100644
--- a/drivers/oprofile/oprofile_stats.c
+++ b/drivers/oprofile/oprofile_stats.c
@@ -16,9 +16,6 @@
 #include "cpu_buffer.h"
 
 struct oprofile_stat_struct oprofile_stats;
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-atomic_t multiplex_counter;
-#endif
 
 void oprofile_reset_stats(void)
 {
@@ -37,9 +34,7 @@ void oprofile_reset_stats(void)
 	atomic_set(&oprofile_stats.sample_lost_no_mapping, 0);
 	atomic_set(&oprofile_stats.event_lost_overflow, 0);
 	atomic_set(&oprofile_stats.bt_lost_no_mapping, 0);
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-	atomic_set(&multiplex_counter, 0);
-#endif
+	atomic_set(&oprofile_stats.multiplex_counter, 0);
 }
 
 
@@ -84,6 +79,6 @@ void oprofile_create_stats_files(struct super_block *sb, struct dentry *root)
 		&oprofile_stats.bt_lost_no_mapping);
 #ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
 	oprofilefs_create_ro_atomic(sb, dir, "multiplex_counter",
-		&multiplex_counter);
+		&oprofile_stats.multiplex_counter);
 #endif
 }
diff --git a/drivers/oprofile/oprofile_stats.h b/drivers/oprofile/oprofile_stats.h
index 3da0d08..0b54e46 100644
--- a/drivers/oprofile/oprofile_stats.h
+++ b/drivers/oprofile/oprofile_stats.h
@@ -17,6 +17,7 @@ struct oprofile_stat_struct {
 	atomic_t sample_lost_no_mapping;
 	atomic_t bt_lost_no_mapping;
 	atomic_t event_lost_overflow;
+	atomic_t multiplex_counter;
 };
 
 extern struct oprofile_stat_struct oprofile_stats;
-- 
1.6.3.3


