Return-Path: <linux-kernel-owner+w=401wt.eu-S1760976AbXIJTXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760976AbXIJTXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933249AbXIJTWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:22:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63326 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932942AbXIJTWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:22:19 -0400
Message-Id: <20070910191648.868241883@arndb.de>
References: <20070910191324.847651727@arndb.de>
User-Agent: quilt/0.46-1
Date: Mon, 10 Sep 2007 21:13:27 +0200
From: arnd@arndb.de
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: [patch 3/3] futex_compat: update to match native version
Content-Disposition: inline; filename=futex_compat_clean.diff
X-Provags-ID: V01U2FsdGVkX1/6H2KB4Qu8RiAiQ7mCGoFKN69rv7j+xv0/coc
 y0YONt9ITZD0uodQdharYMD7GjSJaNA9etfhZThbcTEb3Y81dx
 D96+vKgL+nfyp1h3WAEqA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A few changes have gone into the futex code but not into
the futex_compat code, the most significant one being a
fix for FUTEX_WAKE_OP in commit
f54f098612d7f86463b5fb4763d03533d634de73.

This brings both versions in sync again.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Index: linux-2.6/kernel/futex_compat.c
===================================================================
--- linux-2.6.orig/kernel/futex_compat.c
+++ linux-2.6/kernel/futex_compat.c
@@ -62,8 +62,10 @@ void compat_exit_robust_list(struct task
 	 */
 	if (fetch_robust_entry(&pending, &head->list_op_pending, &pip))
 		return;
+
 	if (pending)
-		handle_futex_death((void __user *)pending + futex_offset, curr, pip);
+		handle_futex_death((void __user *)pending + futex_offset,
+				   curr, pip);
 
 	while (entry != &head->list) {
 		/*
@@ -142,7 +144,7 @@ asmlinkage long compat_sys_futex(u32 __u
 {
 	struct timespec ts;
 	ktime_t t, *tp = NULL;
-	int val2 = 0;
+	u32 val2 = 0;
 	int cmd = op & FUTEX_CMD_MASK;
 
 	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI)) {
@@ -156,8 +158,13 @@ asmlinkage long compat_sys_futex(u32 __u
 			t = ktime_add(ktime_get(), t);
 		tp = &t;
 	}
-	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE)
-		val2 = (int) (unsigned long) utime;
+	/*
+	 * requeue parameter in 'utime' if cmd == FUTEX_REQUEUE.
+	 * number of waiters to wake in 'utime' if cmd == FUTEX_WAKE_OP.
+	 */
+	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE ||
+	    cmd == FUTEX_WAKE_OP)
+		val2 = (u32) (unsigned long) utime;
 
 	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
 }

-- 

