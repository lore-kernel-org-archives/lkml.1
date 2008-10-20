Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbYJTRE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbYJTRE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbYJTRDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:03:32 -0400
Received: from relay1.sgi.com ([192.48.171.29]:55242 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753395AbYJTRDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:03:23 -0400
Message-Id: <20081020170321.816821000@polaris-admin.engr.sgi.com>
References: <20081020170319.539427000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 20 Oct 2008 10:03:35 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, davej@codemonkey.org.uk,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       peterz@infradead.org, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>, IA64 <linux-ia64@vger.kernel.org>,
       PowerPC <linuxppc-dev@ozlabs.org>, S390 <linux-s390@vger.kernel.org>,
       SPARC <sparclinux@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 16/35] percpu: fix percpu accessors to potentially !cpu_possible() cpus
Content-Disposition: inline; filename=cpumask:fix-impossible-percpu-accesses.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Percpu areas are only allocated for possible cpus.  In general, you
shouldn't access random cpu's percpu areas: you're corrupting memory.

From: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/m32r/kernel/smpboot.c          |    2 +-
 arch/x86/mach-voyager/voyager_smp.c |    2 +-
 drivers/pnp/pnpbios/bioscalls.c     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- test-compile.orig/arch/m32r/kernel/smpboot.c
+++ test-compile/arch/m32r/kernel/smpboot.c
@@ -598,7 +598,7 @@ int setup_profiling_timer(unsigned int m
 	 * accounting. At that time they also adjust their APIC timers
 	 * accordingly.
 	 */
-	for (i = 0; i < NR_CPUS; ++i)
+	for_each_possible_cpu(i)
 		per_cpu(prof_multiplier, i) = multiplier;
 
 	return 0;
--- test-compile.orig/arch/x86/mach-voyager/voyager_smp.c
+++ test-compile/arch/x86/mach-voyager/voyager_smp.c
@@ -1223,7 +1223,7 @@ int setup_profiling_timer(unsigned int m
 	 * new values until the next timer interrupt in which they do process
 	 * accounting.
 	 */
-	for (i = 0; i < NR_CPUS; ++i)
+	for_each_possible_cpu(i)
 		per_cpu(prof_multiplier, i) = multiplier;
 
 	return 0;
--- test-compile.orig/drivers/pnp/pnpbios/bioscalls.c
+++ test-compile/drivers/pnp/pnpbios/bioscalls.c
@@ -481,7 +481,7 @@ void pnpbios_calls_init(union pnp_bios_i
 
 	set_base(bad_bios_desc, __va((unsigned long)0x40 << 4));
 	_set_limit((char *)&bad_bios_desc, 4095 - (0x40 << 4));
-	for (i = 0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		struct desc_struct *gdt = get_cpu_gdt_table(i);
 		if (!gdt)
 			continue;

-- 
