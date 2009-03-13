Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbZCMQpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbZCMQpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759302AbZCMQnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:43:14 -0400
Received: from gw.goop.org ([64.81.55.164]:57277 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758371AbZCMQnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:43:11 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 10/17] xen/apic: program the apic triggering and polarity properly
Date: Fri, 13 Mar 2009 09:42:31 -0700
Message-Id: <1236962558-13748-11-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236962558-13748-1-git-send-email-jeremy@goop.org>
References: <1236962558-13748-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

We were passing the ACPI triggering and polarity levels directly into
the apic - but they have reversed values.  The result was that
all the level-triggered interrupts were edge, and vice-versa.
It's surprising that anything worked at all, but now AHCI works
for me.

Thanks for Gerd Hoffmann for noticing this.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/pci.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index d661c74..fb408ce 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -53,7 +53,9 @@ int xen_register_gsi(u32 gsi, int triggering, int polarity)
 	printk(KERN_DEBUG "xen: --> irq=%d\n", irq);
 
 	if (irq > 0)
-		xen_set_io_apic_routing(irq, triggering, polarity);
+		xen_set_io_apic_routing(irq,
+					triggering == ACPI_EDGE_SENSITIVE ? 0 : 1,
+					polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
 
 	return irq;
 }
-- 
1.6.0.6

