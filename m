Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbZHJNwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbZHJNwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 09:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbZHJNwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 09:52:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:41832 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786AbZHJNwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 09:52:32 -0400
Date: Mon, 10 Aug 2009 13:51:35 GMT
From: tip-bot for Dinakar Guniguntala <dino@in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, dino@in.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, dino@in.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090810130142.GA23619@in.ibm.com>
References: <20090810130142.GA23619@in.ibm.com>
Subject: [tip:core/urgent] futex: Fix compat_futex to be same as futex for REQUEUE_PI
Message-ID: <tip-4dc88029fd916b860ef063c40180aa604ce93494@git.kernel.org>
Git-Commit-ID: 4dc88029fd916b860ef063c40180aa604ce93494
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 10 Aug 2009 13:51:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4dc88029fd916b860ef063c40180aa604ce93494
Gitweb:     http://git.kernel.org/tip/4dc88029fd916b860ef063c40180aa604ce93494
Author:     Dinakar Guniguntala <dino@in.ibm.com>
AuthorDate: Mon, 10 Aug 2009 18:31:42 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 10 Aug 2009 15:41:12 +0200

futex: Fix compat_futex to be same as futex for REQUEUE_PI

Need to add the REQUEUE_PI checks to the compat_sys_futex API
as well to ensure 32 bit requeue's work fine on a 64 bit
system. Patch is against latest tip

Signed-off-by: Dinakar Guniguntala <dino@in.ibm.com>
Cc: Darren Hart <dvhltc@us.ibm.com>
LKML-Reference: <20090810130142.GA23619@in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/futex_compat.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index d607a5b..2357165 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -180,7 +180,8 @@ asmlinkage long compat_sys_futex(u32 __user *uaddr, int op, u32 val,
 	int cmd = op & FUTEX_CMD_MASK;
 
 	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
-		      cmd == FUTEX_WAIT_BITSET)) {
+		      cmd == FUTEX_WAIT_BITSET ||
+		      cmd == FUTEX_WAIT_REQUEUE_PI)) {
 		if (get_compat_timespec(&ts, utime))
 			return -EFAULT;
 		if (!timespec_valid(&ts))
@@ -191,7 +192,8 @@ asmlinkage long compat_sys_futex(u32 __user *uaddr, int op, u32 val,
 			t = ktime_add_safe(ktime_get(), t);
 		tp = &t;
 	}
-	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE)
+	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE ||
+	    cmd == FUTEX_CMP_REQUEUE_PI || cmd == FUTEX_WAKE_OP)
 		val2 = (int) (unsigned long) utime;
 
 	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
