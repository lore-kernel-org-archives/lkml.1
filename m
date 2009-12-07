Return-Path: <linux-kernel-owner+w=401wt.eu-S1758609AbZLGAN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbZLGAN4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758440AbZLGANt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:49 -0500
Received: from kroah.org ([198.145.64.141]:34611 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758539AbZLGANg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:36 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:54 2009
Message-Id: <20091207000654.821385285@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [080/119] sched: Fix boot crash by zalloc()ing most of the cpu masks
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=sched-fix-boot-crash-by-zalloc-ing-most-of-the-cpu-masks.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Rusty Russell <rusty@rustcorp.com.au>

commit 49557e620339cb134127b5bfbcfecc06b77d0232 upstream.

I got a boot crash when forcing cpumasks offstack on 32 bit,
because find_new_ilb() returned 3 on my UP system (nohz.cpu_mask
wasn't zeroed).

AFAICT the others need to be zeroed too: only
nohz.ilb_grp_nohz_mask is initialized before use.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <200911022037.21282.rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9383,13 +9383,13 @@ void __init sched_init(void)
 	current->sched_class = &fair_sched_class;
 
 	/* Allocate the nohz_cpu_mask if CONFIG_CPUMASK_OFFSTACK */
-	alloc_cpumask_var(&nohz_cpu_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&nohz_cpu_mask, GFP_NOWAIT);
 #ifdef CONFIG_SMP
 #ifdef CONFIG_NO_HZ
-	alloc_cpumask_var(&nohz.cpu_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&nohz.cpu_mask, GFP_NOWAIT);
 	alloc_cpumask_var(&nohz.ilb_grp_nohz_mask, GFP_NOWAIT);
 #endif
-	alloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
+	zalloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
 #endif /* SMP */
 
 	perf_counter_init();


