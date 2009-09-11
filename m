Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbZIKSss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbZIKSss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbZIKSsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:48:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54030 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904AbZIKSsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:48:42 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090911848.933193846@firstfloor.org>
In-Reply-To: <20090911848.933193846@firstfloor.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [15/21] HWPOISON: Add PR_MCE_KILL prctl to control early kill behaviour per process
Message-Id: <20090911184844.34A54B1757@basil.firstfloor.org>
Date: Fri, 11 Sep 2009 20:48:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This allows processes to override their early/late kill
behaviour on hardware memory errors.

Typically applications which are memory error aware is
better of with early kill (see the error as soon
as possible), all others with late kill (only
see the error when the error is really impacting execution)

There's a global sysctl, but this way an application
can set its specific policy.

We're using two bits, one to signify that the process
stated its intention and that 

I also made the prctl future proof by enforcing
the unused arguments are 0.

The state is inherited to children for now. I've
been considering to reset it on exec, but not done for
now (TBD).

Note this makes us officially run out of process flags
on 32bit, but the next patch can easily add another field.

Manpage patch will be supplied separately.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/prctl.h |    2 ++
 include/linux/sched.h |    2 ++
 kernel/sys.c          |   22 ++++++++++++++++++++++
 3 files changed, 26 insertions(+)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -1675,6 +1675,7 @@ extern cputime_t task_gtime(struct task_
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
 #define PF_VCPU		0x00000010	/* I'm a virtual CPU */
 #define PF_FORKNOEXEC	0x00000040	/* forked but didn't exec */
+#define PF_MCE_PROCESS  0x00000080      /* process policy on mce errors */
 #define PF_SUPERPRIV	0x00000100	/* used super-user privileges */
 #define PF_DUMPCORE	0x00000200	/* dumped core */
 #define PF_SIGNALED	0x00000400	/* killed by a signal */
@@ -1694,6 +1695,7 @@ extern cputime_t task_gtime(struct task_
 #define PF_SPREAD_PAGE	0x01000000	/* Spread page cache over cpuset */
 #define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
 #define PF_THREAD_BOUND	0x04000000	/* Thread bound to specific cpu */
+#define PF_MCE_EARLY    0x08000000      /* Early kill for mce process policy */
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
 #define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezeable */
Index: linux/kernel/sys.c
===================================================================
--- linux.orig/kernel/sys.c
+++ linux/kernel/sys.c
@@ -1528,6 +1528,28 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 				current->timer_slack_ns = arg2;
 			error = 0;
 			break;
+		case PR_MCE_KILL:
+			if (arg4 | arg5)
+				return -EINVAL;
+			switch (arg2) {
+			case 0:
+				if (arg3 != 0)
+					return -EINVAL;
+				current->flags &= ~PF_MCE_PROCESS;
+				break;
+			case 1:
+				current->flags |= PF_MCE_PROCESS;
+				if (arg3 != 0)
+					current->flags |= PF_MCE_EARLY;
+				else
+					current->flags &= ~PF_MCE_EARLY;
+				break;
+			default:
+				return -EINVAL;
+			}
+			error = 0;
+			break;
+
 		default:
 			error = -EINVAL;
 			break;
Index: linux/include/linux/prctl.h
===================================================================
--- linux.orig/include/linux/prctl.h
+++ linux/include/linux/prctl.h
@@ -88,4 +88,6 @@
 #define PR_TASK_PERF_COUNTERS_DISABLE		31
 #define PR_TASK_PERF_COUNTERS_ENABLE		32
 
+#define PR_MCE_KILL	33
+
 #endif /* _LINUX_PRCTL_H */
