Return-Path: <linux-kernel-owner+w=401wt.eu-S1762138AbZFKFrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762138AbZFKFrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 01:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbZFKFqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 01:46:51 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47927 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbZFKFqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 01:46:51 -0400
Date: Thu, 11 Jun 2009 08:46:53 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org,
       yinghai@kernel.org
Subject: [PATCH 2/2] sched: use slab in cpupri_init()
Message-ID: <Pine.LNX.4.64.0906110846330.2617@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Lets not use the bootmem allocator in cpupri_init() as slab is already up when
it is run.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 kernel/sched.c        |    2 +-
 kernel/sched_cpupri.c |    8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 12cc09c..dcf2dc2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7795,7 +7795,7 @@ static int __init_refok init_rootdomain(struct root_domain *rd, bool bootmem)
 	if (!alloc_cpumask_var(&rd->rto_mask, gfp))
 		goto free_online;
 
-	if (cpupri_init(&rd->cpupri, false) != 0)
+	if (cpupri_init(&rd->cpupri, bootmem) != 0)
 		goto free_rto_mask;
 	return 0;
 
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index 344712a..7deffc9 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -154,8 +154,12 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
  */
 int __init_refok cpupri_init(struct cpupri *cp, bool bootmem)
 {
+	gfp_t gfp = GFP_KERNEL;
 	int i;
 
+	if (bootmem)
+		gfp = GFP_NOWAIT;
+
 	memset(cp, 0, sizeof(*cp));
 
 	for (i = 0; i < CPUPRI_NR_PRIORITIES; i++) {
@@ -163,9 +167,7 @@ int __init_refok cpupri_init(struct cpupri *cp, bool bootmem)
 
 		spin_lock_init(&vec->lock);
 		vec->count = 0;
-		if (bootmem)
-			alloc_bootmem_cpumask_var(&vec->mask);
-		else if (!zalloc_cpumask_var(&vec->mask, GFP_KERNEL))
+		if (!zalloc_cpumask_var(&vec->mask, gfp))
 			goto cleanup;
 	}
 
-- 
1.6.0.4

