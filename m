Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbZG1RTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbZG1RTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbZG1RS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:18:58 -0400
Received: from sg2ehsobe004.messaging.microsoft.com ([207.46.51.78]:31028 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755151AbZG1RSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:46 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h87h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DP-03-BLY-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 09/26] oprofile: Remove oprofile_multiplexing_init()
Date: Tue, 28 Jul 2009 19:07:09 +0200
Message-ID: <1248800846-25422-10-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:48.0494 (UTC) FILETIME=[547D66E0:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oprofile_multiplexing_init() can be removed when moving the
initialization of oprofile_time_slice to oprofile_create_files().

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/oprof.c          |   14 --------------
 drivers/oprofile/oprofile_files.c |    2 ++
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index 2b33de7..fa6cccd 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -33,7 +33,6 @@ static DEFINE_MUTEX(start_mutex);
 
 static void switch_worker(struct work_struct *work);
 static DECLARE_DELAYED_WORK(switch_work, switch_worker);
-#define TIME_SLICE_DEFAULT		1
 
 #endif
 
@@ -248,23 +247,10 @@ out:
 	return err;
 }
 
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-
-static void __init oprofile_multiplexing_init(void)
-{
-	oprofile_time_slice = msecs_to_jiffies(TIME_SLICE_DEFAULT);
-}
-
-#endif
-
 static int __init oprofile_init(void)
 {
 	int err;
 
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-	oprofile_multiplexing_init();
-#endif
-
 	err = oprofile_arch_init(&oprofile_ops);
 
 	if (err < 0 || timer) {
diff --git a/drivers/oprofile/oprofile_files.c b/drivers/oprofile/oprofile_files.c
index 4c5b947..bbd7516 100644
--- a/drivers/oprofile/oprofile_files.c
+++ b/drivers/oprofile/oprofile_files.c
@@ -18,6 +18,7 @@
 #define BUFFER_SIZE_DEFAULT		131072
 #define CPU_BUFFER_SIZE_DEFAULT		8192
 #define BUFFER_WATERSHED_DEFAULT	32768	/* FIXME: tune */
+#define TIME_SLICE_DEFAULT		1
 
 unsigned long oprofile_buffer_size;
 unsigned long oprofile_cpu_buffer_size;
@@ -170,6 +171,7 @@ void oprofile_create_files(struct super_block *sb, struct dentry *root)
 	oprofile_buffer_size =		BUFFER_SIZE_DEFAULT;
 	oprofile_cpu_buffer_size =	CPU_BUFFER_SIZE_DEFAULT;
 	oprofile_buffer_watershed =	BUFFER_WATERSHED_DEFAULT;
+	oprofile_time_slice =		msecs_to_jiffies(TIME_SLICE_DEFAULT);
 
 	oprofilefs_create_file(sb, root, "enable", &enable_fops);
 	oprofilefs_create_file_perm(sb, root, "dump", &dump_fops, 0666);
-- 
1.6.3.3


