Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbZFJU5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbZFJU5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 16:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbZFJU5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 16:57:17 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33529 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774AbZFJU5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 16:57:17 -0400
Date: Wed, 10 Jun 2009 23:57:17 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, hannes@cmpxchg.org, mingo@elte.hu,
       mpm@selenic.com, npiggin@suse.de, yinghai@kernel.org
Subject: Re: [GIT PULL] Early boot SLAB for 2.6.31
In-Reply-To: <alpine.LFD.2.01.0906101332440.6847@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0906102356030.30927@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI>
 <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain>
 <alpine.LFD.2.01.0906101332440.6847@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, 10 Jun 2009, Linus Torvalds wrote:
> > Hmm. Are there any reasons why the scheduler fixups can't go in this 
> > series? Do they depend on other things in -tip?
> 
> [ .. because otherwise we'll inevitably just get unnecessary bug-reports 
>   about this all - harmless or not, that message would be annoying and 
>   certainly cause people to panic. ]

OK, so I merged and pushed these two patches to 'for-linus' branch of my 
tree and I don't see any more warnings on boot.

			Pekka

>From b38af0a398ec80c04769eb322dc92e1833481483 Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Wed, 10 Jun 2009 23:42:36 +0300
Subject: [PATCH] sched: use kzalloc() instead of the bootmem allocator

Now that kmem_cache_init() happens before sched_init(), we should use kzalloc()
and not the bootmem allocator.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 kernel/sched.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 26efa47..cb01c5c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -68,7 +68,6 @@
 #include <linux/pagemap.h>
 #include <linux/hrtimer.h>
 #include <linux/tick.h>
-#include <linux/bootmem.h>
 #include <linux/debugfs.h>
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
@@ -7525,21 +7524,18 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 
 static int __init_refok init_rootdomain(struct root_domain *rd, bool bootmem)
 {
+	gfp_t gfp = GFP_KERNEL;
+
 	memset(rd, 0, sizeof(*rd));
 
-	if (bootmem) {
-		alloc_bootmem_cpumask_var(&def_root_domain.span);
-		alloc_bootmem_cpumask_var(&def_root_domain.online);
-		alloc_bootmem_cpumask_var(&def_root_domain.rto_mask);
-		cpupri_init(&rd->cpupri, true);
-		return 0;
-	}
+	if (bootmem)
+		gfp = GFP_NOWAIT;
 
-	if (!alloc_cpumask_var(&rd->span, GFP_KERNEL))
+	if (!alloc_cpumask_var(&rd->span, gfp))
 		goto out;
-	if (!alloc_cpumask_var(&rd->online, GFP_KERNEL))
+	if (!alloc_cpumask_var(&rd->online, gfp))
 		goto free_span;
-	if (!alloc_cpumask_var(&rd->rto_mask, GFP_KERNEL))
+	if (!alloc_cpumask_var(&rd->rto_mask, gfp))
 		goto free_online;
 
 	if (cpupri_init(&rd->cpupri, false) != 0)
@@ -8865,7 +8861,7 @@ void __init sched_init(void)
 	 * we use alloc_bootmem().
 	 */
 	if (alloc_size) {
-		ptr = (unsigned long)alloc_bootmem(alloc_size);
+		ptr = (unsigned long)kzalloc(alloc_size, GFP_NOWAIT);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 		init_task_group.se = (struct sched_entity **)ptr;
-- 
1.6.0.4

>From dbf86f2ba459e3b070c6d74aad1e6b115171dd47 Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Wed, 10 Jun 2009 23:53:37 +0300
Subject: [PATCH] vt: use kzalloc() instead of the bootmem allocator

Now that kmem_cache_init() happens before console_init(), we should use
kzalloc() and not the bootmem allocator.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/char/vt.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 08151d4..c796a86 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -95,7 +95,6 @@
 #include <linux/timer.h>
 #include <linux/interrupt.h>
 #include <linux/workqueue.h>
-#include <linux/bootmem.h>
 #include <linux/pm.h>
 #include <linux/font.h>
 #include <linux/bitops.h>
@@ -2875,14 +2874,11 @@ static int __init con_init(void)
 		mod_timer(&console_timer, jiffies + blankinterval);
 	}
 
-	/*
-	 * kmalloc is not running yet - we use the bootmem allocator.
-	 */
 	for (currcons = 0; currcons < MIN_NR_CONSOLES; currcons++) {
-		vc_cons[currcons].d = vc = alloc_bootmem(sizeof(struct vc_data));
+		vc_cons[currcons].d = vc = kzalloc(sizeof(struct vc_data), GFP_NOWAIT);
 		INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
 		visual_init(vc, currcons, 1);
-		vc->vc_screenbuf = (unsigned short *)alloc_bootmem(vc->vc_screenbuf_size);
+		vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size, GFP_NOWAIT);
 		vc->vc_kmalloced = 0;
 		vc_init(vc, vc->vc_rows, vc->vc_cols,
 			currcons || !vc->vc_sw->con_save_screen);
-- 
1.6.0.4

