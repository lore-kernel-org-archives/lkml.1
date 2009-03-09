Return-Path: <linux-kernel-owner+w=401wt.eu-S1751284AbZCIMdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284AbZCIMdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 08:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbZCIMc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 08:32:58 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:36711 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbZCIMc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 08:32:57 -0400
Date: Mon, 9 Mar 2009 13:31:59 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Frans Pop <elendil@planet.nl>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] Fix fixpoint divide exception in acct_update_integrals
Message-ID: <20090309133159.1ef09c7b@osiris.boeblingen.de.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Frans Pop reported the crash below when running an s390 kernel under Hercules:

 17180168.889947! Kernel BUG at 000738b4  verbose debug info unavailable!
 17180168.890213! fixpoint divide exception: 0009  #1! SMP
 17180168.890487! Modules linked in: nfs lockd nfs_acl sunrpc ctcm fsm tape_34xx
    cu3088 tape ccwgroup tape_class ext3 jbd mbcache dm_mirror dm_log dm_snapshot
    dm_mod dasd_eckd_mod dasd_mod
 17180168.891891! CPU: 0 Not tainted 2.6.27.19 #13
 17180168.892116! Process awk (pid: 2069, task: 0f9ed9b8, ksp: 0f4f7d18)
 17180168.892371! Krnl PSW : 070c1000 800738b4 (acct_update_integrals+0x4c/0x118)
 17180168.892830!            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:1 PM:0
 17180168.893115! Krnl GPRS: 00000000 000007d0 7fffffff fffff830
 17180168.893376!            00000000 ffffffff 00000002 0f9ed9b8
 17180168.893621!            00000000 00008ca0 00000000 0f9ed9b8
 17180168.893873!            0f9edda4 8007386e 0f4f7ec8 0f4f7e98
 17180168.894881! Krnl Code: 800738aa: a71807d0         lhi     %r1,2000
 17180168.895245!            800738ae: 8c200001         srdl    %r2,1
 17180168.895563!            800738b2: 1d21             dr      %r2,%r1
 17180168.895936!           >800738b4: 5810d10e         l       %r1,270(%r13)
 17180168.896246!            800738b8: 1823             lr      %r2,%r3
 17180168.896598!            800738ba: 4130f060         la      %r3,96(%r15)
 17180168.896913!            800738be: 0de1             basr    %r14,%r1
 17180168.897283!            800738c0: 5800f060         l       %r0,96(%r15)
 17180168.897517! Call Trace:
 17180168.897656! ( <000000000004fdea>! blocking_notifier_call_chain+0x1e/0x2c)
 17180168.897987!   <0000000000038502>! do_exit+0x106/0x7c0
 17180168.898275!   <0000000000038c36>! do_group_exit+0x7a/0xb4
 17180168.898570!   <0000000000038c8e>! SyS_exit_group+0x1e/0x30
 17180168.898869!   <0000000000021c28>! sysc_do_restart+0x12/0x16
 17180168.899173!   <0000000077e7e924>! 0x77e7e924

Reason for this is that cpu time accounting usually only happens from
interrupt context, but acct_update_integrals gets also called from
process context with interrupts enabled.

So in acct_update_integrals we may end up with the following scenario:

Between reading tsk->stime/tsk->utime and tsk->acct_timexpd an interrupt
happens which updates accouting values. This causes acct_timexpd to be
greater than the former stime + utime.
The subsequent calculation of

dtime = cputime_sub(time, tsk->acct_timexpd);

will be negative and the division performed by

cputime_to_jiffies(dtime)

will generate an exception since the result won't fit into a 32 bit
register.

In order to fix this just always disable interrupts while accessing any
of the accounting values.

Reported by: Frans Pop <elendil@planet.nl>
Tested by: Frans Pop <elendil@planet.nl>
Cc: stable@kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/tsacct.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/tsacct.c
===================================================================
--- linux-2.6.orig/kernel/tsacct.c
+++ linux-2.6/kernel/tsacct.c
@@ -122,8 +122,10 @@ void acct_update_integrals(struct task_s
 	if (likely(tsk->mm)) {
 		cputime_t time, dtime;
 		struct timeval value;
+		unsigned long flags;
 		u64 delta;
 
+		local_irq_save(flags);
 		time = tsk->stime + tsk->utime;
 		dtime = cputime_sub(time, tsk->acct_timexpd);
 		jiffies_to_timeval(cputime_to_jiffies(dtime), &value);
@@ -131,10 +133,12 @@ void acct_update_integrals(struct task_s
 		delta = delta * USEC_PER_SEC + value.tv_usec;
 
 		if (delta == 0)
-			return;
+			goto out;
 		tsk->acct_timexpd = time;
 		tsk->acct_rss_mem1 += delta * get_mm_rss(tsk->mm);
 		tsk->acct_vm_mem1 += delta * tsk->mm->total_vm;
+	out:
+		local_irq_restore(flags);
 	}
 }
 
