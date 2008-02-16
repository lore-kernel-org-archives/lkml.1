Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbYBPRTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbYBPRTy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 12:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757340AbYBPRTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 12:19:24 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:33384 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756503AbYBPRTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 12:19:22 -0500
Date: Sat, 16 Feb 2008 20:22:54 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] simplify cpu_hotplug_begin()/put_online_cpus()
Message-ID: <20080216172254.GA18521@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_hotplug_begin() must be always called under cpu_add_remove_lock, this means
that only one process can be cpu_hotplug.active_writer. So we don't need the
cpu_hotplug.writer_queue, we can wake up the ->active_writer directly.

Also, fix the comment.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/cpu.c~1_CPU_HP_LOCK	2008-02-15 16:59:17.000000000 +0300
+++ 25/kernel/cpu.c	2008-02-16 18:36:37.000000000 +0300
@@ -33,17 +33,13 @@ static struct {
 	 * an ongoing cpu hotplug operation.
 	 */
 	int refcount;
-	wait_queue_head_t writer_queue;
 } cpu_hotplug;
 
-#define writer_exists() (cpu_hotplug.active_writer != NULL)
-
 void __init cpu_hotplug_init(void)
 {
 	cpu_hotplug.active_writer = NULL;
 	mutex_init(&cpu_hotplug.lock);
 	cpu_hotplug.refcount = 0;
-	init_waitqueue_head(&cpu_hotplug.writer_queue);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -65,11 +61,8 @@ void put_online_cpus(void)
 	if (cpu_hotplug.active_writer == current)
 		return;
 	mutex_lock(&cpu_hotplug.lock);
-	cpu_hotplug.refcount--;
-
-	if (unlikely(writer_exists()) && !cpu_hotplug.refcount)
-		wake_up(&cpu_hotplug.writer_queue);
-
+	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
+		wake_up_process(cpu_hotplug.active_writer);
 	mutex_unlock(&cpu_hotplug.lock);
 
 }
@@ -98,8 +91,8 @@ void cpu_maps_update_done(void)
  * Note that during a cpu-hotplug operation, the new readers, if any,
  * will be blocked by the cpu_hotplug.lock
  *
- * Since cpu_maps_update_begin is always called after invoking
- * cpu_maps_update_begin, we can be sure that only one writer is active.
+ * Since cpu_hotplug_begin() is always called after invoking
+ * cpu_maps_update_begin(), we can be sure that only one writer is active.
  *
  * Note that theoretically, there is a possibility of a livelock:
  * - Refcount goes to zero, last reader wakes up the sleeping
@@ -115,19 +108,16 @@ void cpu_maps_update_done(void)
  */
 static void cpu_hotplug_begin(void)
 {
-	DECLARE_WAITQUEUE(wait, current);
-
-	mutex_lock(&cpu_hotplug.lock);
-
 	cpu_hotplug.active_writer = current;
-	add_wait_queue_exclusive(&cpu_hotplug.writer_queue, &wait);
-	while (cpu_hotplug.refcount) {
-		set_current_state(TASK_UNINTERRUPTIBLE);
+
+	for (;;) {
+		mutex_lock(&cpu_hotplug.lock);
+		if (likely(!cpu_hotplug.refcount))
+			break;
+		__set_current_state(TASK_UNINTERRUPTIBLE);
 		mutex_unlock(&cpu_hotplug.lock);
 		schedule();
-		mutex_lock(&cpu_hotplug.lock);
 	}
-	remove_wait_queue_locked(&cpu_hotplug.writer_queue, &wait);
 }
 
 static void cpu_hotplug_done(void)

