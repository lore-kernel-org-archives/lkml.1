Return-Path: <linux-kernel-owner+w=401wt.eu-S1762029AbXGFKgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762029AbXGFKgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 06:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110AbXGFKfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 06:35:54 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:49384 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbXGFKfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 06:35:54 -0400
Subject: [PATCH] lockdep debugging: give stacktrace for init_error
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 05 Jul 2007 16:06:03 +0200
Message-Id: <1183644363.3818.53.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When I started adding support for lockdep to 64-bit powerpc, I got a
lockdep_init_error and with this patch was able to pinpoint why and
where to put lockdep_init(). Let's support this generally for others
adding lockdep support to their architecture.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 kernel/lockdep.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- linux-2.6-git.orig/kernel/lockdep.c	2007-07-05 15:48:17.390241118 +0200
+++ linux-2.6-git/kernel/lockdep.c	2007-07-05 15:58:20.334168396 +0200
@@ -291,6 +291,11 @@ unsigned int max_recursion_depth;
  * about it later on, in lockdep_info().
  */
 static int lockdep_init_error;
+static unsigned long lockdep_init_trace_data[20];
+static struct stack_trace lockdep_init_trace = {
+	.max_entries = ARRAY_SIZE(lockdep_init_trace_data),
+	.entries = lockdep_init_trace_data,
+};
 
 /*
  * Various lockdep statistics:
@@ -1170,6 +1175,7 @@ look_up_lock_class(struct lockdep_map *l
 	if (unlikely(!lockdep_initialized)) {
 		lockdep_init();
 		lockdep_init_error = 1;
+		save_stack_trace(&lockdep_init_trace);
 	}
 #endif
 
@@ -2636,8 +2642,11 @@ void __init lockdep_info(void)
 		sizeof(struct held_lock) * MAX_LOCK_DEPTH);
 
 #ifdef CONFIG_DEBUG_LOCKDEP
-	if (lockdep_init_error)
-		printk("WARNING: lockdep init error! Arch code didnt call lockdep_init() early enough?\n");
+	if (lockdep_init_error) {
+		printk("WARNING: lockdep init error! Arch code didn't call lockdep_init() early enough?\n");
+		printk("Call stack leading to lockdep invocation was:\n");
+		print_stack_trace(&lockdep_init_trace, 0);
+	}
 #endif
 }
 


