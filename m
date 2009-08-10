Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbZHJNB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbZHJNB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 09:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbZHJNB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 09:01:57 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54252 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbZHJNB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 09:01:56 -0400
Date: Mon, 10 Aug 2009 18:31:42 +0530
From: Dinakar Guniguntala <dino@in.ibm.com>
To: linux-rt-users <linux-rt-users@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH] futex: fix compat_futex to be same as futex for REQUEUE_PI
Message-ID: <20090810130142.GA23619@in.ibm.com>
Reply-To: dino@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinakar Guniguntala <dino@in.ibm.com>

Need to add the REQUEUE_PI checks to the compat_sys_futex API as well to
ensure 32 bit requeue's work fine on a 64 bit system.
Patch is against latest tip

Signed-off-by: Dinakar Guniguntala <dino@in.ibm.com>
CC: Darren Hart <dvhltc@us.ibm.com>

	-Dinakar


 futex_compat.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff -X ignore -Nurp linux-tip/kernel/futex_compat.c linux-tip.mod/kernel/futex_compat.c
--- linux-tip/kernel/futex_compat.c	2009-08-10 05:37:17.000000000 -0700
+++ linux-tip.mod/kernel/futex_compat.c	2009-08-10 05:46:42.000000000 -0700
@@ -180,7 +180,8 @@ asmlinkage long compat_sys_futex(u32 __u
 	int cmd = op & FUTEX_CMD_MASK;
 
 	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
-		      cmd == FUTEX_WAIT_BITSET)) {
+		      cmd == FUTEX_WAIT_BITSET ||
+		      cmd == FUTEX_WAIT_REQUEUE_PI)) {
 		if (get_compat_timespec(&ts, utime))
 			return -EFAULT;
 		if (!timespec_valid(&ts))
@@ -191,7 +192,8 @@ asmlinkage long compat_sys_futex(u32 __u
 			t = ktime_add_safe(ktime_get(), t);
 		tp = &t;
 	}
-	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE)
+	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE ||
+	    cmd == FUTEX_CMP_REQUEUE_PI || cmd == FUTEX_WAKE_OP)
 		val2 = (int) (unsigned long) utime;
 
 	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
