Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbYKKGKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbYKKGKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 01:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYKKGKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 01:10:15 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48089 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbYKKGKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 01:10:13 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch 7/7] cpu alloc: page allocator conversion
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, travis@sgi.com,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Vegard Nossum <vegard.nossum@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0811071242560.5387@quilx.com>
References: <20081107093137.F84D.KOSAKI.MOTOHIRO@jp.fujitsu.com> <Pine.LNX.4.64.0811071242560.5387@quilx.com>
Message-Id: <20081111150654.617F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 11 Nov 2008 15:10:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 7 Nov 2008, KOSAKI Motohiro wrote:
> 
> > However, if cpu-unplug happend, any pages in pcp should flush to buddy (I think).
> 
> Right. They are not?
> 

Doh, I really silly.
yes, pcp dropping is processed by another function.
I missed it.

very sorry.


In addition, I think cleanup is better.
I made the patch.



===========================================================
Now, page_alloc_init() doesn't have page allocator stuff and there are the cpu unplug processing for pcp
in two place (pageset_cpuup_callback() and page_alloc_init()).
it isn't reasonable nor easy readable.

cleanup here.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 init/main.c     |    1 
 mm/page_alloc.c |   60 +++++++++++++++++++++++++-------------------------------
 2 files changed, 27 insertions(+), 34 deletions(-)

Index: b/mm/page_alloc.c
===================================================================
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2765,6 +2765,28 @@ static void __cpuinit process_zones(int 
 }
 
 #ifdef CONFIG_SMP
+static void drain_pages_and_fold_stats(int cpu)
+{
+	drain_pages(cpu);
+
+	/*
+	 * Spill the event counters of the dead processor
+	 * into the current processors event counters.
+	 * This artificially elevates the count of the current
+	 * processor.
+	 */
+	vm_events_fold_cpu(cpu);
+
+	/*
+	 * Zero the differential counters of the dead processor
+	 * so that the vm statistics are consistent.
+	 *
+	 * This is only okay since the processor is dead and cannot
+	 * race with what we are doing.
+	 */
+	refresh_cpu_vm_stats(cpu);
+}
+
 static int __cpuinit pageset_cpuup_callback(struct notifier_block *nfb,
 		unsigned long action,
 		void *hcpu)
@@ -2777,6 +2799,11 @@ static int __cpuinit pageset_cpuup_callb
 	case CPU_UP_PREPARE_FROZEN:
 		process_zones(cpu);
 		break;
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		drain_pages_and_fold_stats(cpu);
+		break;
+
 	default:
 		break;
 	}
@@ -4092,39 +4119,6 @@ void __init free_area_init(unsigned long
 			__pa(PAGE_OFFSET) >> PAGE_SHIFT, NULL);
 }
 
-static int page_alloc_cpu_notify(struct notifier_block *self,
-				 unsigned long action, void *hcpu)
-{
-	int cpu = (unsigned long)hcpu;
-
-	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
-		drain_pages(cpu);
-
-		/*
-		 * Spill the event counters of the dead processor
-		 * into the current processors event counters.
-		 * This artificially elevates the count of the current
-		 * processor.
-		 */
-		vm_events_fold_cpu(cpu);
-
-		/*
-		 * Zero the differential counters of the dead processor
-		 * so that the vm statistics are consistent.
-		 *
-		 * This is only okay since the processor is dead and cannot
-		 * race with what we are doing.
-		 */
-		refresh_cpu_vm_stats(cpu);
-	}
-	return NOTIFY_OK;
-}
-
-void __init page_alloc_init(void)
-{
-	hotcpu_notifier(page_alloc_cpu_notify, 0);
-}
-
 /*
  * calculate_totalreserve_pages - called when sysctl_lower_zone_reserve_ratio
  *	or min_free_kbytes changes.
Index: b/init/main.c
===================================================================
--- a/init/main.c
+++ b/init/main.c
@@ -619,7 +619,6 @@ asmlinkage void __init start_kernel(void
 	 */
 	preempt_disable();
 	build_all_zonelists();
-	page_alloc_init();
 	printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);
 	parse_early_param();
 	parse_args("Booting kernel", static_command_line, __start___param,


