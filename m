Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbZAVNQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbZAVNQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 08:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZAVNPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 08:15:50 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:55324 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751161AbZAVNPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 08:15:49 -0500
X-BigFish: VPS-6(zz936eQzzzzz32i43j)
X-WSS-ID: 0KDVJHW-03-K3T-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: [PATCH] cpumask: modifiy oprofile initialization
Date: Thu, 22 Jan 2009 14:14:14 +0100
Message-ID: <1232630055-32451-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <20090122131153.GP21604@erda.amd.com>
References: <20090122131153.GP21604@erda.amd.com>
X-OriginalArrivalTime: 22 Jan 2009 13:15:33.0193 (UTC) FILETIME=[81873B90:01C97C93]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delta patch to f7df8ed164996cd2c6aca9674388be6ef78d8b37 for
tip/cpus4096.

Moved initialization to sync_start()/sync_stop(). No changes needed in
buffer_sync.h and oprof.c anymore.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/buffer_sync.c |   20 ++++++--------------
 drivers/oprofile/buffer_sync.h |    4 ----
 drivers/oprofile/oprof.c       |    9 +--------
 3 files changed, 7 insertions(+), 26 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index c3ea5fa..8574622 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -154,6 +154,10 @@ int sync_start(void)
 {
 	int err;
 
+	if (!alloc_cpumask_var(&marked_cpus, GFP_KERNEL))
+		return -ENOMEM;
+	cpumask_clear(marked_cpus);
+
 	start_cpu_work();
 
 	err = task_handoff_register(&task_free_nb);
@@ -179,6 +183,7 @@ out2:
 	task_handoff_unregister(&task_free_nb);
 out1:
 	end_sync();
+	free_cpumask_var(marked_cpus);
 	goto out;
 }
 
@@ -190,6 +195,7 @@ void sync_stop(void)
 	profile_event_unregister(PROFILE_TASK_EXIT, &task_exit_nb);
 	task_handoff_unregister(&task_free_nb);
 	end_sync();
+	free_cpumask_var(marked_cpus);
 }
 
 
@@ -565,20 +571,6 @@ void sync_buffer(int cpu)
 	mutex_unlock(&buffer_mutex);
 }
 
-int __init buffer_sync_init(void)
-{
-	if (!alloc_cpumask_var(&marked_cpus, GFP_KERNEL))
-		return -ENOMEM;
-
-	cpumask_clear(marked_cpus);
-		return 0;
-}
-
-void __exit buffer_sync_cleanup(void)
-{
-	free_cpumask_var(marked_cpus);
-}
-
 /* The function can be used to add a buffer worth of data directly to
  * the kernel buffer. The buffer is assumed to be a circular buffer.
  * Take the entries from index start and end at index end, wrapping
diff --git a/drivers/oprofile/buffer_sync.h b/drivers/oprofile/buffer_sync.h
index 0ebf5db..3110732 100644
--- a/drivers/oprofile/buffer_sync.h
+++ b/drivers/oprofile/buffer_sync.h
@@ -19,8 +19,4 @@ void sync_stop(void);
 /* sync the given CPU's buffer */
 void sync_buffer(int cpu);
 
-/* initialize/destroy the buffer system. */
-int buffer_sync_init(void);
-void buffer_sync_cleanup(void);
-
 #endif /* OPROFILE_BUFFER_SYNC_H */
diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index ced39f6..3cffce9 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -183,10 +183,6 @@ static int __init oprofile_init(void)
 {
 	int err;
 
-	err = buffer_sync_init();
-	if (err)
-		return err;
-
 	err = oprofile_arch_init(&oprofile_ops);
 
 	if (err < 0 || timer) {
@@ -195,10 +191,8 @@ static int __init oprofile_init(void)
 	}
 
 	err = oprofilefs_register();
-	if (err) {
+	if (err)
 		oprofile_arch_exit();
-		buffer_sync_cleanup();
-	}
 
 	return err;
 }
@@ -208,7 +202,6 @@ static void __exit oprofile_exit(void)
 {
 	oprofilefs_unregister();
 	oprofile_arch_exit();
-	buffer_sync_cleanup();
 }
 
 
-- 
1.6.1


