Return-Path: <linux-kernel-owner+w=401wt.eu-S1758622AbZELXaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622AbZELXaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756712AbZELXZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:25:33 -0400
Received: from 75-149-38-2-SFBA.hfc.comcastbusiness.net ([75.149.38.2]:36200
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753963AbZELXZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:25:26 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 14/17] xen: dynamically allocate irq & event structures
Date: Tue, 12 May 2009 16:25:21 -0700
Message-Id: <1242170724-13349-15-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242170724-13349-1-git-send-email-jeremy@goop.org>
References: <1242170724-13349-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Dynamically allocate the irq_info and evtchn_to_irq arrays, so that
1) the irq_info array scales to the actual number of possible irqs,
and 2) we don't needlessly increase the static size of the kernel
when we aren't running under Xen.

Derived on patch from Mike Travis <travis@sgi.com>.

[ Impact: reduce memory usage ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/events.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 968e927..e6ddf78 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/bootmem.h>
+#include <linux/irqnr.h>
 
 #include <asm/ptrace.h>
 #include <asm/irq.h>
@@ -91,11 +92,9 @@ struct irq_info
 };
 #define PIRQ_NEEDS_EOI	(1 << 0)
 
-static struct irq_info irq_info[NR_IRQS];
+static struct irq_info *irq_info;
 
-static int evtchn_to_irq[NR_EVENT_CHANNELS] = {
-	[0 ... NR_EVENT_CHANNELS-1] = -1
-};
+static int *evtchn_to_irq;
 struct cpu_evtchn_s {
 	unsigned long bits[NR_EVENT_CHANNELS/BITS_PER_LONG];
 };
@@ -515,7 +514,7 @@ static int find_irq_by_gsi(unsigned gsi)
 {
 	int irq;
 
-	for (irq = 0; irq < NR_IRQS; irq++) {
+	for (irq = 0; irq < nr_irqs; irq++) {
 		struct irq_info *info = info_for_irq(irq);
 
 		if (info == NULL || info->type != IRQT_PIRQ)
@@ -1180,7 +1179,11 @@ void __init xen_init_IRQ(void)
 	size_t size = nr_cpu_ids * sizeof(struct cpu_evtchn_s);
 
 	cpu_evtchn_mask_p = alloc_bootmem(size);
-	BUG_ON(cpu_evtchn_mask_p == NULL);
+	irq_info = alloc_bootmem(nr_irqs * sizeof(*irq_info));
+
+	evtchn_to_irq = alloc_bootmem(NR_EVENT_CHANNELS * sizeof(*evtchn_to_irq));
+	for (i = 0; i < NR_EVENT_CHANNELS; i++)
+		evtchn_to_irq[i] = -1;
 
 	init_evtchn_cpu_bindings();
 
-- 
1.6.0.6

