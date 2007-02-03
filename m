Return-Path: <linux-kernel-owner+w=401wt.eu-S933401AbXBCAcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933401AbXBCAcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 19:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933402AbXBCAcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 19:32:25 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37941 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933401AbXBCAcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 19:32:24 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: <linux-kernel@vger.kernel.org>, "Lu, Yinghai" <yinghai.lu@amd.com>,
       "Luigi Genoni" <luigi.genoni@pirelli.com>, Ingo Molnar <mingo@elte.hu>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>
Subject: [PATCH 1/2] x86_64 irq: Simplfy __assign_irq_vector
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<200702021848.55921.luigi.genoni@pirelli.com>
	<m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>
	<200702021905.39922.luigi.genoni@pirelli.com>
Date: Fri, 02 Feb 2007 17:31:04 -0700
In-Reply-To: <200702021905.39922.luigi.genoni@pirelli.com> (Luigi Genoni's
	message of "Fri, 2 Feb 2007 19:05:39 +0100")
Message-ID: <m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


By precomputing old_mask I remove an extra if statement, remove an
indentation level and make the code slightly easier to read.

This comes before my bugfix in the next patch so the patch and the
resulting code stay readable.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86_64/kernel/io_apic.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86_64/kernel/io_apic.c b/arch/x86_64/kernel/io_apic.c
index 6be6730..d1fcd4b 100644
--- a/arch/x86_64/kernel/io_apic.c
+++ b/arch/x86_64/kernel/io_apic.c
@@ -685,6 +685,7 @@ static int __assign_irq_vector(int irq, cpumask_t mask, cpumask_t *result)
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
 	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
+	cpumask_t old_mask = CPU_MASK_NONE;
 	int old_vector = -1;
 	int cpu;
 
@@ -699,11 +700,12 @@ static int __assign_irq_vector(int irq, cpumask_t mask, cpumask_t *result)
 		cpus_and(*result, irq_domain[irq], mask);
 		if (!cpus_empty(*result))
 			return old_vector;
+		cpus_and(old_mask, irq_domain[irq], cpu_online_map);
 	}
 
 	for_each_cpu_mask(cpu, mask) {
 		cpumask_t domain, new_mask;
-		int new_cpu;
+		int new_cpu, old_cpu;
 		int vector, offset;
 
 		domain = vector_allocation_domain(cpu);
@@ -728,13 +730,8 @@ next:
 		/* Found one! */
 		current_vector = vector;
 		current_offset = offset;
-		if (old_vector >= 0) {
-			cpumask_t old_mask;
-			int old_cpu;
-			cpus_and(old_mask, irq_domain[irq], cpu_online_map);
-			for_each_cpu_mask(old_cpu, old_mask)
-				per_cpu(vector_irq, old_cpu)[old_vector] = -1;
-		}
+		for_each_cpu_mask(old_cpu, old_mask)
+			per_cpu(vector_irq, old_cpu)[old_vector] = -1;
 		for_each_cpu_mask(new_cpu, new_mask)
 			per_cpu(vector_irq, new_cpu)[vector] = irq;
 		irq_vector[irq] = vector;
-- 
1.4.4.1.g278f

