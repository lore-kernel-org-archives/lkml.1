Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbYE3BUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbYE3BUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 21:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYE3BUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 21:20:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:33199 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751183AbYE3BUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 21:20:10 -0400
X-Authenticated: #329476
X-Provags-ID: V01U2FsdGVkX1/Tr7oSEkzT36lfvlrVzHltnvDxJz6C13MgSPM0id
	6E+VFEy4ukjWry
Date: Fri, 30 May 2008 03:20:05 +0200
From: Bertram Felgenhauer <int-e@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Add workaround for bug in ASUS A7V600 BIOS (rev 1005)
Message-ID: <20080530012005.GA9514@zombie.inf.tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This BIOS claims the VIA 8237 south bridge to be compatible with VIA 586,
which it is not.

Signed-off-by: Bertram Felgenhauer <int-e@gmx.de>
---
Without this patch, I get the following warning while booting,
among others,

| PCI: Using IRQ router VIA [1106/3227] at 0000:00:11.0
| ------------[ cut here ]------------
| WARNING: at arch/x86/pci/irq.c:265 pirq_via586_get+0x4a/0x60()
| Modules linked in:
| Pid: 1, comm: swapper Not tainted 2.6.26-rc4-00015-g1ec7d99 #1
|  [<c0119fd4>] warn_on_slowpath+0x54/0x70
|  [<c02246e0>] ? vt_console_print+0x210/0x2b0
|  [<c02244d0>] ? vt_console_print+0x0/0x2b0
|  [<c011a413>] ? __call_console_drivers+0x43/0x60
|  [<c011a482>] ? _call_console_drivers+0x52/0x80
|  [<c011aa89>] ? release_console_sem+0x1c9/0x200
|  [<c0291d21>] ? raw_pci_read+0x41/0x70
|  [<c0291e8f>] ? pci_read+0x2f/0x40
|  [<c029151a>] pirq_via586_get+0x4a/0x60
|  [<c02914d0>] ? pirq_via586_get+0x0/0x60
|  [<c029178d>] pcibios_lookup_irq+0x15d/0x430
|  [<c03b895a>] pcibios_irq_init+0x17a/0x3e0
|  [<c03a66f0>] ? kernel_init+0x0/0x250
|  [<c03a6763>] kernel_init+0x73/0x250
|  [<c03b87e0>] ? pcibios_irq_init+0x0/0x3e0
|  [<c0114d00>] ? schedule_tail+0x10/0x40
|  [<c0102dee>] ? ret_from_fork+0x6/0x1c
|  [<c03a66f0>] ? kernel_init+0x0/0x250
|  [<c03a66f0>] ? kernel_init+0x0/0x250
|  [<c010324b>] kernel_thread_helper+0x7/0x1c
|  =======================
| ---[ end trace 4eaa2a86a8e2da22 ]---

and IRQ trouble later,

| irq 10: nobody cared (try booting with the "irqpoll" option)

Now that's an VIA 8237 chip, so pirq_via586_get shouldn't be called
at all; adding this workaround to via_router_probe() fixes the
problem for me.

Amazingly I have a 2.6.23.8 kernel that somehow works fine ... I'll
never understand why.

The patch is against Linus' tree.

Please CC me in replies.

Thanks,

Bertram

 arch/x86/pci/irq.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index 0908fca..ca8df9c 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -621,6 +621,13 @@ static __init int via_router_probe(struct irq_router *r,
 			 */
 			device = PCI_DEVICE_ID_VIA_8235;
 			break;
+		case PCI_DEVICE_ID_VIA_8237:
+			/**
+			 * Asus a7v600 bios wrongly reports 8237
+			 * as 586-compatible
+			 */
+			device = PCI_DEVICE_ID_VIA_8237;
+			break;
 		}
 	}
 
-- 
1.5.3

