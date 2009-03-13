Return-Path: <linux-kernel-owner+w=401wt.eu-S1760320AbZCMQre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760320AbZCMQre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759589AbZCMQna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:43:30 -0400
Received: from gw.goop.org ([64.81.55.164]:57289 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759432AbZCMQn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:43:29 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 14/17] xen: dynamically allocate irq & event structures
Date: Fri, 13 Mar 2009 09:42:35 -0700
Message-Id: <1236962558-13748-15-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236962558-13748-1-git-send-email-jeremy@goop.org>
References: <1236962558-13748-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Impact: reduce memory usage

Dynamically allocate the irq_info and evtchn_to_irq arrays, so that
1) the irq_info array scales to the actual number of possible irqs,
and 2) we don't needlessly increase the static size of the kernel
when we aren't running under Xen.

Derived on patch from Mike Travis <travis@sgi.com>.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/events.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 3cf0a1b..e8f08c0 100644
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
@@ -509,7 +508,7 @@ static int find_irq_by_gsi(unsigned gsi)
 {
 	int irq;
 
-	for(irq = 0; irq < NR_IRQS; irq++) {
+	for(irq = 0; irq < nr_irqs; irq++) {
 		struct irq_info *info = info_for_irq(irq);
 
 		if (info == NULL || info->type != IRQT_PIRQ)
@@ -1174,7 +1173,11 @@ void __init xen_init_IRQ(void)
 	size_t size = nr_cpu_ids * sizeof(struct cpu_evtchn_s);
 
 	cpu_evtchn_mask_p = alloc_bootmem(size);
-	BUG_ON(cpu_evtchn_mask_p == NULL);
+	irq_info = alloc_bootmem(nr_irqs * sizeof(*irq_info));
+
+	evtchn_to_irq = alloc_bootmem(NR_EVENT_CHANNELS * sizeof(*evtchn_to_irq));
+	for(i = 0; i < NR_EVENT_CHANNELS; i++)
+		evtchn_to_irq[i] = -1;
 
 	init_evtchn_cpu_bindings();
 
-- 
1.6.0.6

