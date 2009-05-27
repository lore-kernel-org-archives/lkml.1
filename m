Return-Path: <linux-kernel-owner+w=401wt.eu-S1764616AbZE0Hpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764616AbZE0Hpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762289AbZE0Hmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:42:47 -0400
Received: from claw.goop.org ([74.207.240.146]:48136 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932175AbZE0Hmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:42:46 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 14/17] xen: dynamically allocate irq & event structures
Date: Wed, 27 May 2009 00:37:27 -0700
Message-Id: <1243409850-21577-15-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1243409850-21577-1-git-send-email-jeremy@goop.org>
References: <1243409850-21577-1-git-send-email-jeremy@goop.org>
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

