Return-Path: <linux-kernel-owner+w=401wt.eu-S965381AbXCPQFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965381AbXCPQFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965397AbXCPQFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:05:10 -0400
Received: from rnd-off.balt.net ([195.14.167.137]:43172 "EHLO barclay.balt.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965381AbXCPQFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:05:07 -0400
Subject: Re: LOCKDEP warning if CONFIG_DETECT_SOFTLOCKUP=y
From: Zilvinas Valinskas <zilvinas@wilibox.com>
Reply-To: zilvinas@wilibox.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1174056925.17967.15.camel@zv.wilibox.com>
References: <1174056925.17967.15.camel@zv.wilibox.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 16 Mar 2007 18:05:05 +0200
Message-Id: <1174061105.17967.24.camel@zv.wilibox.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

I think I've found a solution for a problem. Is this sane thing to do ?
At least lockdep is happy now, does not complain anymore. It seems that
->pi_lock was not register with lockdep correctly (something about
classes ... 8). 

diff --git a/kernel/fork.c b/kernel/fork.c
index d154cc7..6af959c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -933,8 +933,8 @@ asmlinkage long sys_set_tid_address(int __user *tidptr)
 
 static inline void rt_mutex_init_task(struct task_struct *p)
 {
-#ifdef CONFIG_RT_MUTEXES
 	spin_lock_init(&p->pi_lock);
+#ifdef CONFIG_RT_MUTEXES
 	plist_head_init(&p->pi_waiters, &p->pi_lock);
 	p->pi_blocked_on = NULL;
 #endif




On Fri, 2007-03-16 at 16:55 +0200, Zilvinas Valinskas wrote:
> Hello lkml, 
> 
> Booting ixp4xx/ARM/BE  with lockdep enabled to test my code, I got a
> lockdep warning (see below). Does it mean that soft-lockup detector is
> started too early ?  Any advice how to approach and fix the problem are
> appreciated very much. If CONFIG_DETECT_SOFTLOCKUP=n, lockdep does not
> complain.
> 
> Kernel is vanilla 2.6.21-rc4 + lockdep-stacktrace.diff from
> http://svn.wantstofly.org/kernel/ repository.
> 
> 
> [    0.000000] Linux version 2.6.21-rc4 (zilvinas@zv) (gcc version 4.2.0 20070207 (prerelease) (http://www.wilibox.com)) #12 Fri Mar 16 16:05:39 EET 2007
> [    0.000000] CPU: XScale-IXP42x Family [690541f1] revision 1 (ARMv5TE), cr=000039ff
> [    0.000000] Machine: Intel IXDP425 Development Platform
> [    0.000000] Memory policy: ECC disabled, Data cache writeback
> ...
> 
> [    0.000000] Built 1 zonelists.  Total pages: 16256
> [    0.000000] Kernel command line: initcall_debug loglevel=8 i2c_debug=9 root=/dev/mtdblock2 console=ttyS0,115200 ro init=/linuxrc
> [    0.000000] PID hash table entries: 256 (order: 8, 1024 bytes)
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:    8
> [    0.000000] ... MAX_LOCK_DEPTH:          30
> [    0.000000] ... MAX_LOCKDEP_KEYS:        2048
> [    0.000000] ... CLASSHASH_SIZE:           1024
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     8192
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      16384
> [    0.000000] ... CHAINHASH_SIZE:          8192
> [    0.000000]  memory used by lock dependency info: 1096 kB
> [    0.000000]  per task-struct memory footprint: 1200 bytes
> [    0.000000] ------------------------
> [    0.000000] | Locking API testsuite:
> 
> ... <skiped> ...
> 
> [    0.590000] -------------------------------------------------------
> [    0.590000] Good, all 218 testcases passed! |
> [    0.590000] ---------------------------------
> [    0.590000] Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
> [    0.600000] Calibrating delay loop... 265.42 BogoMIPS (lpj=1327104)
> [    0.840000] Mount-cache hash table entries: 512
> [    0.840000] CPU: Testing write buffer coherency: ok
> [    0.840000] INFO: trying to register non-static key.
> [    0.840000] the code is fine but needs lockdep annotation.
> [    0.840000] turning off the locking correctness validator.
> 
> Don't know how to fix that.
> 
> [    0.840000] [<c0021018>] (dump_stack+0x0/0x14) from [<c0052ccc>] (__lock_acquire+0x640/0x1110)
> [    0.840000] [<c005268c>] (__lock_acquire+0x0/0x1110) from [<c0053820>] (lock_acquire+0x84/0x98)
> [    0.840000] [<c005379c>] (lock_acquire+0x0/0x98) from [<c01858b4>] (_spin_lock_irqsave+0x48/0x5c)
> [    0.840000] [<c018586c>] (_spin_lock_irqsave+0x0/0x5c) from [<c002f358>] (sched_setscheduler+0xd4/0x2a8)
> [    0.840000]  r6 = C04D6000  r5 = C04D1820  r4 = 00000001 
> [    0.840000] [<c002f284>] (sched_setscheduler+0x0/0x2a8) from [<c0058848>] (watchdog+0x30/0x6c)
> [    0.840000] [<c0058818>] (watchdog+0x0/0x6c) from [<c00494ec>] (kthread+0x108/0x118)
> [    0.840000]  r4 = 00000000 
> [    0.840000] [<c00493e4>] (kthread+0x0/0x118) from [<c0036098>] (do_exit+0x0/0x894)
> [    0.840000]  r7 = 00000000  r6 = 00000000  r5 = 00000000  r4 = 00000000
> [    0.840000] Calling initcall 0xc0009980: ptrace_break_init+0x0/0x2c()
> 
> With gdb it points to *__task_rq_lock(struct task_struct *p)
> 
> (gdb) l *sched_setscheduler+0xd4
> 0x1644 is in sched_setscheduler (kernel/sched.c:395).
> 390     {
> 391             struct rq *rq;
> 392
> 393     repeat_lock_task:
> 394             rq = task_rq(p);
> 395             spin_lock(&rq->lock);
> 396             if (unlikely(rq != task_rq(p))) {
> 397                     spin_unlock(&rq->lock);
> 398                     goto repeat_lock_task;
> 399             }
> (gdb) 
> 
> I think it is really about ->pi_lock, on line 4134, that lockdep doesn't know 
> anything about.
> 
> 4130         /*
> 4131          * make sure no PI-waiters arrive (or leave) while we are
> 4132          * changing the priority of the task:
> 4133          */
> 4134         spin_lock_irqsave(&p->pi_lock, flags);
> 4135         /*
> 4136          * To be able to change p->policy safely, the apropriate
> 4137          * runqueue lock must be held.
> 4138          */
> 4139         rq = __task_rq_lock(p);
> 
> 
> Best regards,
> Žilvinas Valinskas
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

