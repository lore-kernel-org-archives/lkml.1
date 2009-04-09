Return-Path: <linux-kernel-owner+w=401wt.eu-S1763506AbZDIFmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763506AbZDIFmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 01:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761246AbZDIFiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 01:38:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58087
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755396AbZDIFiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 01:38:05 -0400
Date: Wed, 08 Apr 2009 22:37:55 -0700 (PDT)
Message-Id: <20090408.223755.06231218.davem@davemloft.net>
To: tj@kernel.org
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/12]: sparc64: Only allocate per-cpu areas for possible
 cpus.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This gets us real close to the generic implementation of
setup_per_cpu_areas() except:

1) We store the per-cpu offset into the trap_block[], whereas
   the generic code has it's own static array.

2) We have to initialize the %g5 register to hold the boot cpu's
   per-cpu area offset.

3) The OBP/MDESC cpu info scan is performed at the end.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/kernel/smp_64.c |   22 ++++++----------------
 1 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index af0b28e..168025f 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -1373,27 +1373,17 @@ void smp_send_stop(void)
 
 void __init setup_per_cpu_areas(void)
 {
-	unsigned long base, shift, goal, size, i;
+	unsigned long size, i, nr_possible_cpus = num_possible_cpus();
 	char *ptr;
 
 	/* Copy section for each CPU (we discard the original) */
-	goal = PERCPU_ENOUGH_ROOM;
+	size = ALIGN(PERCPU_ENOUGH_ROOM, PAGE_SIZE);
+	ptr = alloc_bootmem_pages(size * nr_possible_cpus);
 
-	shift = PAGE_SHIFT;
-	for (size = PAGE_SIZE; size < goal; size <<= 1UL)
-		shift++;
-
-	ptr = __alloc_bootmem(size * NR_CPUS, PAGE_SIZE, 0);
-	if (!ptr) {
-		prom_printf("Cannot allocate per-cpu memory.\n");
-		prom_halt();
-	}
-
-	base = ptr - __per_cpu_start;
-
-	for (i = 0; i < NR_CPUS; i++, ptr += size) {
-		__per_cpu_offset(i) = base + (i * size);
+	for_each_possible_cpu(i) {
+		__per_cpu_offset(i) = ptr - __per_cpu_start;
 		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
+		ptr += size;
 	}
 
 	/* Setup %g5 for the boot cpu.  */
-- 
1.6.2.2

