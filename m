Return-Path: <linux-kernel-owner+w=401wt.eu-S1758340AbYJWCN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340AbYJWCN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbYJWCIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:08:40 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43362 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754121AbYJWCI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:29 -0400
Message-Id: <20081023020829.490197000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:08:42 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 16/35] percpu: fix percpu accessors to potentially !cpu_possible() cpus From: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline; filename=cpumask:fix-impossible-percpu-accesses.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Percpu areas are only allocated for possible cpus.  In general, you
shouldn't access random cpu's percpu areas: you're corrupting memory.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/m32r/kernel/smpboot.c          |    2 +-
 arch/x86/mach-voyager/voyager_smp.c |    2 +-
 drivers/pnp/pnpbios/bioscalls.c     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.28.orig/arch/m32r/kernel/smpboot.c
+++ linux-2.6.28/arch/m32r/kernel/smpboot.c
@@ -592,7 +592,7 @@ int setup_profiling_timer(unsigned int m
 	 * accounting. At that time they also adjust their APIC timers
 	 * accordingly.
 	 */
-	for (i = 0; i < NR_CPUS; ++i)
+	for_each_possible_cpu(i)
 		per_cpu(prof_multiplier, i) = multiplier;
 
 	return 0;
--- linux-2.6.28.orig/arch/x86/mach-voyager/voyager_smp.c
+++ linux-2.6.28/arch/x86/mach-voyager/voyager_smp.c
@@ -1216,7 +1216,7 @@ int setup_profiling_timer(unsigned int m
 	 * new values until the next timer interrupt in which they do process
 	 * accounting.
 	 */
-	for (i = 0; i < NR_CPUS; ++i)
+	for_each_possible_cpu(i)
 		per_cpu(prof_multiplier, i) = multiplier;
 
 	return 0;
--- linux-2.6.28.orig/drivers/pnp/pnpbios/bioscalls.c
+++ linux-2.6.28/drivers/pnp/pnpbios/bioscalls.c
@@ -481,7 +481,7 @@ void pnpbios_calls_init(union pnp_bios_i
 
 	set_base(bad_bios_desc, __va((unsigned long)0x40 << 4));
 	_set_limit((char *)&bad_bios_desc, 4095 - (0x40 << 4));
-	for (i = 0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		struct desc_struct *gdt = get_cpu_gdt_table(i);
 		if (!gdt)
 			continue;

-- 
