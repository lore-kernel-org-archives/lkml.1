Return-Path: <linux-kernel-owner+w=401wt.eu-S1758063AbXJCLoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbXJCLoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 07:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755847AbXJCLoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 07:44:06 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38856 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755068AbXJCLoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 07:44:05 -0400
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: nickpiggin@yahoo.com.au, Randy Dunlap <randy.dunlap@oracle.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Dinakar Guniguntala <dino@in.ibm.com>, Paul Jackson <pj@sgi.com>,
       cpw@sgi.com, Ingo Molnar <mingo@elte.hu>
Date: Wed, 03 Oct 2007 04:44:01 -0700
Message-Id: <20071003114401.32194.73464.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH] cpuset and sched domains: sched_load_balance flag fixes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Thanks to Randy Dunlap for the review that caught
some of the following.

Some bug fixes and coding style fixes:
 1) only one statement per line, please.
 2) don't need to guard kfree() calls with a NULL check
 3) use kfifo_free, not kfree, if it came from kfifo_alloc
 4) a pair of curly brackets got lost along the way
 5) missing .read, .write callbacks for sched_load_balance

Without (3), one kfifo buffer memory was leaked each time
one rebuilt scheduler domains

Without (4), the current task was summarily killed each
time one tried to rebuild scheduler domains

Without (5), every read or write system call on a per-cpuset
special file 'sched_load_balance' failed, EINVAL.

Signed-off-by: Paul Jackson <pj@sgi.com>

---

Andrew,

  These fixes go right after the patch they fix:
    [PATCH] cpuset and sched domains: sched_load_balance flag

 kernel/cpuset.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- 2.6.23-rc8-mm1.orig/kernel/cpuset.c	2007-10-02 21:29:51.245156939 -0700
+++ 2.6.23-rc8-mm1/kernel/cpuset.c	2007-10-02 21:26:56.000000000 -0700
@@ -579,7 +579,9 @@ static void rebuild_sched_domains(void)
 	int ndoms;		/* number of sched domains in result */
 	int nslot;		/* next empty doms[] cpumask_t slot */
 
-	q = NULL; csa = NULL; doms = NULL;
+	q = NULL;
+	csa = NULL;
+	doms = NULL;
 
 	/* Special case for the 99% of systems with one, full, sched domain */
 	if (is_sched_load_balance(&top_cpuset)) {
@@ -604,9 +606,10 @@ static void rebuild_sched_domains(void)
 		struct cpuset *child;   /* scans child cpusets of cp */
 		if (is_sched_load_balance(cp))
 			csa[csn++] = cp;
-		list_for_each_entry(cont, &cp->css.cgroup->children, sibling)
+		list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
 			child = cgroup_cs(cont);
 			__kfifo_put(q, (void *)&child, sizeof(cp));
+		}
   	}
 
 	for (i = 0; i < csn; i++)
@@ -668,9 +671,8 @@ rebuild:
 
 done:
 	if (q && !IS_ERR(q))
-		kfree(q);
-	if (csa)
-		kfree(csa);
+		kfifo_free(q);
+	kfree(csa);
 	/* Don't kfree(doms) -- partition_sched_domains() does that. */
 }
 
@@ -1358,6 +1360,8 @@ static struct cftype cft_mem_exclusive =
 
 static struct cftype cft_sched_load_balance = {
 	.name = "sched_load_balance",
+	.read = cpuset_common_file_read,
+	.write = cpuset_common_file_write,
 	.private = FILE_SCHED_LOAD_BALANCE,
 };
 

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
