Return-Path: <linux-kernel-owner+w=401wt.eu-S1762618AbZCNBfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762618AbZCNBfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZCNBUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:20:44 -0400
Received: from kroah.org ([198.145.64.141]:35166 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753379AbZCNBUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:24 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:37 2009
Message-Id: <20090314011037.610595405@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 042/114] Fix fixpoint divide exception in acct_update_integrals
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=fix-fixpoint-divide-exception-in-acct_update_integrals.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 6d5b5acca9e566515ef3f1ed617e7295c4f94345 upstream.

Frans Pop reported the crash below when running an s390 kernel under Hercules:

  Kernel BUG at 000738b4  verbose debug info unavailable!
  fixpoint divide exception: 0009  #1! SMP
  Modules linked in: nfs lockd nfs_acl sunrpc ctcm fsm tape_34xx
     cu3088 tape ccwgroup tape_class ext3 jbd mbcache dm_mirror dm_log dm_snapshot
     dm_mod dasd_eckd_mod dasd_mod
  CPU: 0 Not tainted 2.6.27.19 #13
  Process awk (pid: 2069, task: 0f9ed9b8, ksp: 0f4f7d18)
  Krnl PSW : 070c1000 800738b4 (acct_update_integrals+0x4c/0x118)
             R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:1 PM:0
  Krnl GPRS: 00000000 000007d0 7fffffff fffff830
             00000000 ffffffff 00000002 0f9ed9b8
             00000000 00008ca0 00000000 0f9ed9b8
             0f9edda4 8007386e 0f4f7ec8 0f4f7e98
  Krnl Code: 800738aa: a71807d0         lhi     %r1,2000
             800738ae: 8c200001         srdl    %r2,1
             800738b2: 1d21             dr      %r2,%r1
            >800738b4: 5810d10e         l       %r1,270(%r13)
             800738b8: 1823             lr      %r2,%r3
             800738ba: 4130f060         la      %r3,96(%r15)
             800738be: 0de1             basr    %r14,%r1
             800738c0: 5800f060         l       %r0,96(%r15)
  Call Trace:
  ( <000000000004fdea>! blocking_notifier_call_chain+0x1e/0x2c)
    <0000000000038502>! do_exit+0x106/0x7c0
    <0000000000038c36>! do_group_exit+0x7a/0xb4
    <0000000000038c8e>! SyS_exit_group+0x1e/0x30
    <0000000000021c28>! sysc_do_restart+0x12/0x16
    <0000000077e7e924>! 0x77e7e924

Reason for this is that cpu time accounting usually only happens from
interrupt context, but acct_update_integrals gets also called from
process context with interrupts enabled.

So in acct_update_integrals we may end up with the following scenario:

Between reading tsk->stime/tsk->utime and tsk->acct_timexpd an interrupt
happens which updates accouting values.  This causes acct_timexpd to be
greater than the former stime + utime.  The subsequent calculation of

	dtime = cputime_sub(time, tsk->acct_timexpd);

will be negative and the division performed by

	cputime_to_jiffies(dtime)

will generate an exception since the result won't fit into a 32 bit
register.

In order to fix this just always disable interrupts while accessing any
of the accounting values.

Reported by: Frans Pop <elendil@planet.nl>
Tested by: Frans Pop <elendil@planet.nl>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/tsacct.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -120,8 +120,10 @@ void acct_update_integrals(struct task_s
 	if (likely(tsk->mm)) {
 		cputime_t time, dtime;
 		struct timeval value;
+		unsigned long flags;
 		u64 delta;
 
+		local_irq_save(flags);
 		time = tsk->stime + tsk->utime;
 		dtime = cputime_sub(time, tsk->acct_timexpd);
 		jiffies_to_timeval(cputime_to_jiffies(dtime), &value);
@@ -129,10 +131,12 @@ void acct_update_integrals(struct task_s
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
 


