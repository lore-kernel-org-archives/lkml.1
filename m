Return-Path: <linux-kernel-owner+w=401wt.eu-S932564AbXHaD21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbXHaD21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 23:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754934AbXHaD2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 23:28:18 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:54671 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622AbXHaD2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 23:28:17 -0400
Date: Fri, 31 Aug 2007 04:26:50 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alexey Dobriyan <adobriyan@sw.ru>, Alexey Dobriyan <adobriyan@gmail.com>,
       Len Brown <lenb@kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] fix maxcpus=1 oops in show_stat()
In-Reply-To: <20070829072508.GA2707@localhost.sw.ru>
Message-ID: <Pine.LNX.4.64.0708310404210.4873@blonde.wat.veritas.com>
References: <20070828111431.GA27707@localhost.sw.ru>
 <Pine.LNX.4.64.0708290546430.31816@blonde.wat.veritas.com>
 <20070829052331.GB1765@martell.zuzino.mipt.ru> <200708290241.36092.lenb@kernel.org>
 <20070829072508.GA2707@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan reports that maxcpus=1 is still broken in 2.6.23-rc4:
if CONFIG_HOTPLUG_CPU is not set, x86_64 bootup oopses in show_stat() -
for_each_possible_cpu accesses a per-cpu area which was never set up.

Alexey identified commit 61ec7567db103d537329b0db9a887db570431ff4
(ACPI: boot correctly with "nosmp" or "maxcpus=0") as the origin;
but it's not really to blame, just exposes a bug in 2.6.23-rc1's commit
8b3b295502444340dd0701855ac422fbf32e161d (Especially when !CONFIG_HOTPLUG_CPU,
avoid needlessy allocating resources for CPUs that can never become available).

rc1's test for max_cpus < 2 in start_kernel() wasn't working because
max_cpus was still NR_CPUS at that point: until rc4 moved the maxcpus
parsing earlier.  Now it sets cpu_possible_map to 1 before allocating
all possible per-cpu areas; then smp_init() expands cpu_possible_map
to cpu_present_map (0xf in my case) later on.

rc1's commit has good intentions, but expects cpu_present_map to be
limited by maxcpus, which is only the case on i386.  cpus_and(possible,
possible,present) might be good, but needs an audit of cpu_present_map
uses - there may well be assumptions that any cpu present is possible.
So stay safe for now and just revert those #ifndef CONFIG_HOTPLUG_CPU
optimizations in rc1's commit.

Signed-off-by: Hugh Dickins <hugh@veritas.com>

--- 2.6.23-rc4/init/main.c	2007-08-28 04:42:58.000000000 +0100
+++ linux/init/main.c	2007-08-30 20:45:26.000000000 +0100
@@ -397,10 +397,6 @@ static void __init smp_init(void)
 {
 	unsigned int cpu;
 
-#ifndef CONFIG_HOTPLUG_CPU
-	cpu_possible_map = cpu_present_map;
-#endif
-
 	/* FIXME: This should be done in userspace --RR */
 	for_each_present_cpu(cpu) {
 		if (num_online_cpus() >= max_cpus)
@@ -545,10 +541,6 @@ asmlinkage void __init start_kernel(void
 	setup_arch(&command_line);
 	setup_command_line(command_line);
 	unwind_setup();
-#ifndef CONFIG_HOTPLUG_CPU
-	if (max_cpus < 2)
-		cpu_possible_map = cpu_online_map;
-#endif
 	setup_per_cpu_areas();
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
 
