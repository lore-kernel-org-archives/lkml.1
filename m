Return-Path: <linux-kernel-owner+w=401wt.eu-S1763592AbZB1CRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763592AbZB1CRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 21:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757121AbZB1COT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 21:14:19 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:46157
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754522AbZB1COM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 21:14:12 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@f9-builder (none)>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 06/10] xen/apic: identity map gsi->irqs
Date: Fri, 27 Feb 2009 18:14:04 -0800
Message-Id: <1235787248-18184-7-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235787248-18184-1-git-send-email-jeremy@goop.org>
References: <1235787248-18184-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy@f9-builder.(none)>

Reserve the lower irq range for use for hardware interrupts so we
can identity-map them.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/events.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 81726e8..3477998 100644
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
@@ -338,12 +336,24 @@ static void unmask_evtchn(int port)
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
 
@@ -361,8 +371,8 @@ static int find_unbound_irq(void)
 
 static bool identity_mapped_irq(unsigned irq)
 {
-	/* only identity map legacy irqs */
-	return irq < LEGACY_IRQS;
+	/* identity map all the hardware irqs */
+	return irq < get_nr_hw_irqs();
 }
 
 static void pirq_unmask_notify(int irq)
@@ -531,6 +541,7 @@ int xen_allocate_pirq(unsigned gsi)
 
 	if (identity_mapped_irq(gsi)) {
 		irq = gsi;
+		irq_to_desc_alloc_cpu(irq, 0);
 		dynamic_irq_init(irq);
 	} else
 		irq = find_unbound_irq();
-- 
1.6.0.6

