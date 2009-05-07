Return-Path: <linux-kernel-owner+w=401wt.eu-S932183AbZEHAY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbZEHAY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758560AbZEHAKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:34 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52725
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754199AbZEHAKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:10:05 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Gerd Hoffmann <kraxel@xeni.home.kraxel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 14/18] xen: set pirq name to something useful.
Date: Thu,  7 May 2009 14:14:39 -0700
Message-Id: <1241730883-4917-15-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241730883-4917-1-git-send-email-jeremy@goop.org>
References: <1241730883-4917-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerd Hoffmann <kraxel@xeni.home.kraxel.org>

Impact: cleanup

Make pirq show useful information in /proc/interrupts

Signed-off-by: Gerd Hoffmann <kraxel@xeni.home.kraxel.org>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/pci.c   |    3 ++-
 drivers/xen/events.c |    4 ++--
 include/xen/events.h |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index 502ff5f..fb3ada9 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -48,7 +48,8 @@ int xen_register_gsi(u32 gsi, int triggering, int polarity)
 	printk(KERN_DEBUG "xen: registering gsi %u triggering %d polarity %d\n",
 	       gsi, triggering, polarity);
 
-	irq = xen_allocate_pirq(gsi);
+	irq = xen_allocate_pirq(gsi, (triggering == ACPI_EDGE_SENSITIVE)
+				     ? "ioapic-edge" : "ioapic-level");
 
 	printk(KERN_DEBUG "xen: --> irq=%d\n", irq);
 
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 64200a0..b8fd514 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -532,7 +532,7 @@ static int find_irq_by_gsi(unsigned gsi)
  * event channel until the irq actually started up.  Return an
  * existing irq if we've already got one for the gsi.
  */
-int xen_allocate_pirq(unsigned gsi)
+int xen_allocate_pirq(unsigned gsi, char *name)
 {
 	int irq;
 	struct physdev_irq irq_op;
@@ -554,7 +554,7 @@ int xen_allocate_pirq(unsigned gsi)
 		irq = find_unbound_irq();
 
 	set_irq_chip_and_handler_name(irq, &xen_pirq_chip,
-				      handle_level_irq, "pirq");
+				      handle_level_irq, name);
 
 	irq_op.irq = irq;
 	if (HYPERVISOR_physdev_op(PHYSDEVOP_alloc_irq_vector, &irq_op)) {
diff --git a/include/xen/events.h b/include/xen/events.h
index 6fe4863..4b19b9c 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -61,7 +61,7 @@ unsigned irq_from_evtchn(unsigned int evtchn);
 /* Allocate an irq for a physical interrupt, given a gsi.  "Legacy"
    GSIs are identity mapped; others are dynamically allocated as
    usual. */
-int xen_allocate_pirq(unsigned gsi);
+int xen_allocate_pirq(unsigned gsi, char *name);
 
 /* Return vector allocated to pirq */
 int xen_vector_from_irq(unsigned pirq);
-- 
1.6.0.6

