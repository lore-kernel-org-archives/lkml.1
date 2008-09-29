Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbYI2SDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbYI2SDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbYI2SCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:02:55 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36448 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753954AbYI2SCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:51 -0400
Message-Id: <20080929180250.966574000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:02:56 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 06/31] cpumask: new lib/cpumask.c
Content-Disposition: inline; filename=lib-cpumask
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 lib/cpumask.c |   36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

--- struct-cpumasks.orig/lib/cpumask.c
+++ struct-cpumasks/lib/cpumask.c
@@ -3,34 +3,40 @@
 #include <linux/cpumask.h>
 #include <linux/module.h>
 
-int __first_cpu(const cpumask_t *srcp)
+int cpus_first(const_cpumask_t srcp)
 {
-	return find_first_bit(srcp->bits, NR_CPUS);
+	return find_first_bit(srcp->bits, nr_cpu_ids);
 }
-EXPORT_SYMBOL(__first_cpu);
+EXPORT_SYMBOL(cpus_first);
 
-int __next_cpu(int n, const cpumask_t *srcp)
+int cpus_next(int n, const_cpumask_t srcp)
 {
-	return find_next_bit(srcp->bits, NR_CPUS, n+1);
+	return find_next_bit(srcp->bits, nr_cpu_ids, n+1);
 }
-EXPORT_SYMBOL(__next_cpu);
+EXPORT_SYMBOL(cpus_next);
 
-#if NR_CPUS > 64
-int __next_cpu_nr(int n, const cpumask_t *srcp)
+int cpus_next_in(int n, const_cpumask_t srcp, const_cpumask_t andp)
 {
-	return find_next_bit(srcp->bits, nr_cpu_ids, n+1);
+	int cpu;
+
+	for (cpu = n + 1; cpu < nr_cpu_ids; cpu++) {
+		cpu = find_next_bit(srcp->bits, nr_cpu_ids, cpu);
+
+		if (cpu < nr_cpu_ids && cpu_isset(cpu, andp))
+			return cpu;
+	}
+	return nr_cpu_ids;
 }
-EXPORT_SYMBOL(__next_cpu_nr);
-#endif
+EXPORT_SYMBOL(cpus_next_in);
 
-int __any_online_cpu(const cpumask_t *mask)
+int any_cpu_in(const_cpumask_t mask, const_cpumask_t andmask)
 {
 	int cpu;
 
-	for_each_cpu_mask(cpu, *mask) {
-		if (cpu_online(cpu))
+	for_each_cpu(cpu, mask) {
+		if (cpu_isset(cpu, andmask))
 			break;
 	}
 	return cpu;
 }
-EXPORT_SYMBOL(__any_online_cpu);
+EXPORT_SYMBOL(any_cpu_in);

-- 
