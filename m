Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbZAJWil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbZAJWil (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbZAJWic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:38:32 -0500
Received: from relay3.sgi.com ([192.48.171.31]:60577 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753985AbZAJWic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:38:32 -0500
Message-Id: <20090110223819.033438000@polaris-admin.engr.sgi.com>
References: <20090110223818.459493000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 10 Jan 2009 14:38:22 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] kstat: modify kstat_irqs_legacy to be variable sized
Content-Disposition: inline; filename=var-kstat-irqs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: reduce memory usage.

Allocate kstat_irqs_legacy based on nr_cpu_ids to deal with this
memory usage bump when NR_CPUS bumped from 128 to 4096:

     8192   +253952    262144 +3100%  kstat_irqs_legacy(.bss)

This is only when CONFIG_SPARSE_IRQS=y.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/irq/handle.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- linux-2.6-for-ingo.orig/kernel/irq/handle.c
+++ linux-2.6-for-ingo/kernel/irq/handle.c
@@ -124,8 +124,7 @@ static struct irq_desc irq_desc_legacy[N
 	}
 };
 
-/* FIXME: use bootmem alloc ...*/
-static unsigned int kstat_irqs_legacy[NR_IRQS_LEGACY][NR_CPUS];
+static unsigned int *kstat_irqs_legacy;
 
 int __init early_irq_init(void)
 {
@@ -146,9 +145,13 @@ int __init early_irq_init(void)
 	/* allocate irq_desc_ptrs array based on nr_irqs */
 	irq_desc_ptrs = alloc_bootmem(nr_irqs * sizeof(void *));
 
+	/* allocate based on nr_cpu_ids */
+	kstat_irqs_legacy = alloc_bootmem(NR_IRQS_LEGACY * nr_cpu_ids *
+					  sizeof(int));
+
 	for (i = 0; i < legacy_count; i++) {
 		desc[i].irq = i;
-		desc[i].kstat_irqs = kstat_irqs_legacy[i];
+		desc[i].kstat_irqs = kstat_irqs_legacy + i * NR_IRQS_LEGACY;
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
 		init_alloc_desc_masks(&desc[i], 0, true);
 		irq_desc_ptrs[i] = desc + i;

-- 
