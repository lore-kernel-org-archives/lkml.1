Return-Path: <linux-kernel-owner+w=401wt.eu-S1763664AbXJRKp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763664AbXJRKp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 06:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760971AbXJRKpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 06:45:20 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56826 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755494AbXJRKpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:45:19 -0400
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Dinakar Guniguntala <dino@in.ibm.com>, Cliff Wickman <cpw@sgi.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>, Paul Jackson <pj@sgi.com>,
       Ingo Molnar <mingo@elte.hu>
Date: Thu, 18 Oct 2007 03:45:16 -0700
Message-Id: <20071018104516.9811.903.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH] cpuset sched_load_balance sched domain confusion fix
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Fix a bug in the cpuset code that recalculates dynamic sched domains.

For sufficiently complex cpuset configurations, the recalc code
could get confused, due to overwriting some state then using the
overwritten values as if they still held the previous value.  This
could result in kernel oops and other random chaos, overwriting
memory.

The fix stashes the two values of interest, apn and bpn, in separate
local variables, to keep them separate from what will be overwritten.

Besides the fix, also:
 1) this confusion is easy to detect -- in the event that there are
    or ever come to be any more such bugs, notice when out of bounds
    and 'continue' past it, resulting in overly simplified sched
    domain setups, rather than oops or memory trashing, and
 2) in that case, print something out with a few clues, the first
    ten times this happens on a boot, so that someone might notice
    someday and chase the problem down.

Signed-off-by: Paul Jackson <pj@sgi.com>

---

This is a needed fix for the *-mm patch:
    cpuset-sched_load_balance-flag.patch

 kernel/cpuset.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- 2.6.23-mm1.orig/kernel/cpuset.c	2007-10-17 18:56:09.814604327 -0700
+++ 2.6.23-mm1/kernel/cpuset.c	2007-10-18 01:56:23.863274785 -0700
@@ -631,16 +631,18 @@ restart:
 	/* Find the best partition (set of sched domains) */
 	for (i = 0; i < csn; i++) {
 		struct cpuset *a = csa[i];
+		int apn = a->pn;
 
 		for (j = 0; j < csn; j++) {
 			struct cpuset *b = csa[j];
+			int bpn = b->pn;
 
-			if (a->pn != b->pn && cpusets_overlap(a, b)) {
+			if (apn != bpn && cpusets_overlap(a, b)) {
 				for (k = 0; k < csn; k++) {
 					struct cpuset *c = csa[k];
 
-					if (c->pn == b->pn)
-						c->pn = a->pn;
+					if (c->pn == bpn)
+						c->pn = apn;
 				}
 				ndoms--;	/* one less element */
 				goto restart;
@@ -660,6 +662,19 @@ restart:
 		if (apn >= 0) {
 			cpumask_t *dp = doms + nslot;
 
+			if (nslot == ndoms) {
+				static int warnings = 10;
+				if (warnings) {
+					printk(KERN_WARNING
+					 "rebuild_sched_domains confused:"
+					  " nslot %d, ndoms %d, csn %d, i %d,"
+					  " apn %d\n",
+					  nslot, ndoms, csn, i, apn);
+					warnings--;
+				}
+				continue;
+			}
+
 			cpus_clear(*dp);
 			for (j = i; j < csn; j++) {
 				struct cpuset *b = csa[j];

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
