Return-Path: <linux-kernel-owner+w=401wt.eu-S1761764AbZE0HlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761764AbZE0HlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760943AbZE0HiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:38:05 -0400
Received: from claw.goop.org ([74.207.240.146]:41718 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761648AbZE0HiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:38:03 -0400
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
       Jeremy Fitzhardinge <jeremy@f9-builder (none)>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 07/17] xen/apic: identity map gsi->irqs
Date: Wed, 27 May 2009 00:37:20 -0700
Message-Id: <1243409850-21577-8-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1243409850-21577-1-git-send-email-jeremy@goop.org>
References: <1243409850-21577-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy@f9-builder.(none)>

Reserve the lower irq range for use for hardware interrupts so we
can identity-map them.

[ Impact: preserve compat with native ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/events.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index fd98c19..88395bb 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -31,6 +31,7 @@
 #include <asm/ptrace.h>
 #include <asm/irq.h>
 #include <asm/idle.h>
+#include <asm/io_apic.h>
 #include <asm/sync_bitops.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
@@ -40,9 +41,6 @@
 #include <xen/interface/xen.h>
 #include <xen/interface/event_channel.h>
 
-/* Leave low irqs free for identity mapping */
-#define LEGACY_IRQS	16
-
 /*
  * This lock protects updates to the following mapping and reference-count
  * arrays. The lock does not need to be acquired to read the mapping tables.
@@ -344,12 +342,24 @@ static void unmask_evtchn(int port)
 	put_cpu();
 }
 
+static int get_nr_hw_irqs(void)
+{
+	int ret = 1;
+
+#ifdef CONFIG_X86_IO_APIC
+	ret = get_nr_irqs_gsi();
+#endif
+
+	return ret;
+}
+
 static int find_unbound_irq(void)
 {
 	int irq;
 	struct irq_desc *desc;
+	int start = get_nr_hw_irqs();
 
-	for (irq = LEGACY_IRQS; irq < nr_irqs; irq++)
+	for (irq = start; irq < nr_irqs; irq++)
 		if (irq_info[irq].type == IRQT_UNBOUND)
 			break;
 
@@ -367,8 +377,8 @@ static int find_unbound_irq(void)
 
 static bool identity_mapped_irq(unsigned irq)
 {
-	/* only identity map legacy irqs */
-	return irq < LEGACY_IRQS;
+	/* identity map all the hardware irqs */
+	return irq < get_nr_hw_irqs();
 }
 
 static void pirq_unmask_notify(int irq)
@@ -537,6 +547,7 @@ int xen_allocate_pirq(unsigned gsi)
 
 	if (identity_mapped_irq(gsi)) {
 		irq = gsi;
+		irq_to_desc_alloc_cpu(irq, 0);
 		dynamic_irq_init(irq);
 	} else
 		irq = find_unbound_irq();
-- 
1.6.0.6

