Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbYFKCNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbYFKCNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 22:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755235AbYFKCM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 22:12:59 -0400
Received: from sh.osrg.net ([192.16.179.4]:42305 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272AbYFKCM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 22:12:56 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH -mm] add a helper function to test if an object is on the stack
Date: Wed, 11 Jun 2008 11:14:45 +0900
Message-Id: <1213150485-25584-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lib/debugobjects.c has a function to test if an object is on the
stack. The block layer and ide needs it (they need to avoid DMA
from/to stack buffers). This patch moves the function to
include/linux/sched.h so that everyone can use it.

lib/debugobjects.c uses current->stack but this patch uses a
task_stack_page() accessor, which is a preferable way to access to
stack.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/sched.h |    7 +++++++
 lib/debugobjects.c    |    4 +---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4efb39b..799bbdd 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1978,6 +1978,13 @@ static inline unsigned long *end_of_stack(struct task_struct *p)
 
 #endif
 
+static inline int object_is_on_stack(void *obj)
+{
+	void *stack = task_stack_page(current);
+
+	return (obj >= stack) && (obj < (stack + THREAD_SIZE));
+}
+
 extern void thread_info_cache_init(void);
 
 #ifdef CONFIG_DEBUG_STACK_USAGE
diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index a76a5e1..2afddde 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -231,15 +231,13 @@ debug_object_fixup(int (*fixup)(void *addr, enum debug_obj_state state),
 
 static void debug_object_is_on_stack(void *addr, int onstack)
 {
-	void *stack = current->stack;
 	int is_on_stack;
 	static int limit;
 
 	if (limit > 4)
 		return;
 
-	is_on_stack = (addr >= stack && addr < (stack + THREAD_SIZE));
-
+	is_on_stack = object_is_on_stack(addr);
 	if (is_on_stack == onstack)
 		return;
 
-- 
1.5.5.GIT

