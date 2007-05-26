Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbXEZD5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbXEZD5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 23:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbXEZD45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 23:56:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbXEZD44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 23:56:56 -0400
Date: Fri, 25 May 2007 23:56:51 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200705260356.l4Q3upEK007514@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix compat futex code for private futexes
Cc: akpm@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When the private futex support was added the compat code wasn't changed.
The result is that code using compat code which fail, e.g., because the
timeout values are not correctly passed.  The following patch should
fix that.

Signed-off-by: Ulrich Drepper <drepper@redhat.com>

--- kernel/futex_compat.c	2007-05-09 15:01:23.000000000 -0700
+++ kernel/futex_compat.c-save	2007-05-25 20:53:35.000000000 -0700
@@ -144,20 +144,21 @@ asmlinkage long compat_sys_futex(u32 __u
 	struct timespec ts;
 	ktime_t t, *tp = NULL;
 	int val2 = 0;
+	int cmd = op & FUTEX_CMD_MASK;
 
-	if (utime && (op == FUTEX_WAIT || op == FUTEX_LOCK_PI)) {
+	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI)) {
 		if (get_compat_timespec(&ts, utime))
 			return -EFAULT;
 		if (!timespec_valid(&ts))
 			return -EINVAL;
 
 		t = timespec_to_ktime(ts);
-		if (op == FUTEX_WAIT)
+		if (cmd == FUTEX_WAIT)
 			t = ktime_add(ktime_get(), t);
 		tp = &t;
 	}
-	if (op == FUTEX_REQUEUE || op == FUTEX_CMP_REQUEUE
-	    || op == FUTEX_CMP_REQUEUE_PI)
+	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE
+	    || cmd == FUTEX_CMP_REQUEUE_PI)
 		val2 = (int) (unsigned long) utime;
 
 	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
