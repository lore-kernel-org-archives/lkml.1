Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbZANOep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbZANOep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbZANOeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:34:36 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:60410 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbZANOef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:34:35 -0500
Date: Wed, 14 Jan 2009 17:34:46 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, Jay Estabrook <jay.estabrook@hp.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] alpha: nautilus - fix hang on boot
Message-ID: <20090114143446.GC10788@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently introduced generic pci_common_swizzle() relies on bus->self
being NULL for the root PCI bus. But on nautilus bus->self points to
the host bridge device, which is necessary as we do a root bus sizing
on this system. As a result, pci_common_swizzle() loops infinitely.
This worked until 2.6.29-rc1 because the alpha-specific swizzle routine
checked for bus->parent == NULL (instead of bus->self).

Fixed by clearing bus->self after bus sizing is done.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/alpha/kernel/sys_nautilus.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/kernel/sys_nautilus.c b/arch/alpha/kernel/sys_nautilus.c
index a7f23b5..99c0f46 100644
--- a/arch/alpha/kernel/sys_nautilus.c
+++ b/arch/alpha/kernel/sys_nautilus.c
@@ -245,6 +245,10 @@ nautilus_init_pci(void)
 		IRONGATE0->pci_mem = pci_mem;
 
 	pci_bus_assign_resources(bus);
+
+	/* pci_common_swizzle() relies on bus->self being NULL
+	   for the root bus, so just clear it. */
+	bus->self = NULL;
 	pci_fixup_irqs(alpha_mv.pci_swizzle, alpha_mv.pci_map_irq);
 }
 
