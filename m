Return-Path: <linux-kernel-owner+w=401wt.eu-S934328AbZGQJiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934328AbZGQJiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 05:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934316AbZGQJiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 05:38:15 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:61808 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934315AbZGQJiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 05:38:14 -0400
Subject: [RFC PATCH] kmemleak: Scan all thread stacks
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 17 Jul 2009 10:38:12 +0100
Message-ID: <20090717093359.8288.45464.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc1-4-ge6bc-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jul 2009 09:38:12.0920 (UTC) FILETIME=[4D9F7B80:01CA06C2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the for_each_process() loop with the
do_each_thread()/while_each_thread() pair. It also replaces the
read_lock(&tasklist_lock) with rcu_read_lock() and task_lock(p).

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---

My questions:

1. Is it correct that for_each_process() used currently by kmemleak may
   not loop through all the possible kernel thread stacks?

2. Is it safe to use rcu_read_lock() and task_lock() when scanning the
   corresponding kernel stack (thread_info structure)? The loop doesn't
   do any modification to the task list. The reason for this is to
   allow kernel preemption when scanning the stacks.

Alternatively, I can hook kmemleak callbacks into the
alloc_thread_info/free_thread_info structures but many of these are
architecture-specific.

Thanks,

Catalin


 mm/kmemleak.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 983f3f6..a933128 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1064,7 +1064,6 @@ static void kmemleak_scan(void)
 {
 	unsigned long flags;
 	struct kmemleak_object *object, *tmp;
-	struct task_struct *task;
 	int i;
 	int new_leaks = 0;
 	int gray_list_pass = 0;
@@ -1135,12 +1134,16 @@ static void kmemleak_scan(void)
 	 * not enabled by default.
 	 */
 	if (kmemleak_stack_scan) {
-		read_lock(&tasklist_lock);
-		for_each_process(task)
-			scan_block(task_stack_page(task),
-				   task_stack_page(task) + THREAD_SIZE,
-				   NULL, 0);
-		read_unlock(&tasklist_lock);
+		struct task_struct *p, *g;
+
+		rcu_read_lock();
+		do_each_thread(g, p) {
+			task_lock(p);
+			scan_block(task_stack_page(p), task_stack_page(p) +
+				   THREAD_SIZE, NULL, 0);
+			task_unlock(p);
+		} while_each_thread(g, p);
+		rcu_read_unlock();
 	}
 
 	/*

