Return-Path: <linux-kernel-owner+w=401wt.eu-S1762310AbXGYWmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762310AbXGYWmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 18:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757040AbXGYWlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 18:41:53 -0400
Received: from 41.150.104.212.access.eclipse.net.uk ([212.104.150.41]:50201
	"EHLO localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756641AbXGYWlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 18:41:52 -0400
Date: Wed, 25 Jul 2007 23:41:46 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steve Fox <drfickle@us.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: 2.6.23-rc1-mm1 -- mostly fails to build
Message-ID: <20070725224143.GA668@shadowen.org>
References: <20070725040304.111550f4.akpm@linux-foundation.org> <46A77C28.1050807@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A77C28.1050807@shadowen.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 05:36:56PM +0100, Andy Whitcroft wrote:

> Will investigate the NUMA-Q explosion and report on that separatly.

Ok, I've been looking at the NUMA-Q boot panic below:

BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
c111689f
*pdpt = 0000000001387001
*pde = 0000000000000000
Oops: 0000 [#1]
SMP
Modules linked in:
CPU:    0
EIP:    0060:[<c111689f>]    Not tainted VLI
EFLAGS: 00010286   (2.6.23-rc1-mm1-gc8131905-dirty #251)
EIP is at pci_create_bus+0x11b/0x277
eax: 00000000   ebx: c9352e00   ecx: c9073e94   edx: c9325400
esi: c9325400   edi: c932559c   ebp: 00000002   esp: c9073e90
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process swapper (pid: 1, ti=c9072000 task=c9070030 task.ti=c9072000)
Stack: c12adc4f c9325400 00000000 00000002 00000000 00000000 00000000 c934c800
       000000d6 00000000 c1116a09 00000000 c9073ed5 c11b178a 00000000 c934c940
       00000000 02fffff4 c12bd8ac c934c800 c12bd8b4 c9325000 c1119825 c934c800
Call Trace:
 [<c1116a09>] pci_scan_bus_parented+0xe/0x21
 [<c11b178a>] pci_fixup_i450nx+0xa7/0x101
 [<c1119825>] pci_do_fixups+0x2d/0x38
 [<c111665c>] pci_device_add+0x48/0x77
 [<c11166a5>] pci_scan_single_device+0x1a/0x1f
 [<c11166bf>] pci_scan_slot+0x15/0x47
 [<c111670a>] pci_scan_child_bus+0x19/0x7c
 [<c1116a14>] pci_scan_bus_parented+0x19/0x21
 [<c11b259d>] pcibios_scan_root+0x75/0x7e
 [<c1369ee3>] pci_numa_init+0x2c/0xe4
 [<c1354b87>] kernel_init+0x0/0xa1
 [<c1354a15>] do_initcalls+0x73/0x1a3
 [<c109032c>] proc_register+0xa0/0xa7
 [<c10905cd>] create_proc_entry+0x73/0x86
 [<c103a5c9>] register_irq_proc+0x75/0x92
 [<c1354b87>] kernel_init+0x0/0xa1
 [<c1354be6>] kernel_init+0x5f/0xa1
 [<c10031c3>] kernel_thread_helper+0x7/0x10
 =======================
Code: ff 8b 83 84 00 00 00 c7 04 24 4f dc 2a c1 89 44 24 04 e8 f8 42 f0 ff 83 7c 24 14 00 75 15 8b 93 84 00 00 00 85 d2 74 0b 8b 43 44 <8b> 00 89 82 50 01 00 00 c7 44 24 04 9a 04 00 00 8d bb 88 00 00
EIP: [<c111689f>] pci_create_bus+0x11b/0x277 SS:ESP 0068:c9073e90
Kernel panic - not syncing: Attempted to kill init!

This seems to have been caused by the introduction of the following
code fragment into pci_create_bus:

        if (!parent)
                set_dev_node(b->bridge, pcibus_to_node(b));

This has come as part of the -mm patch below:

    try-parent-numa_node-at-first-before-using-default-v2.patch

This patch does not seem to be wrong in and of itself.  It does
expose the fact that we are building busses with NULL sysdata.
This has come up at least three times now.  Below is the patch
proposed the last couple of times.  It is needed to allow any machine
with i450nx quirk, plus for NUMA-Q systems.

Andrew please could you add this to -mm again.

-apw

===
pci device ensure sysdata initialised v3

We have been seeing panic's on NUMA systems in pci_call_probe() in
2.6.19-rc1-mm1 and later.  This is related to the changes introduced
in the commit below:

    [x86, PCI] Switch pci_bus::sysdata from NUMA node integer to a pointer
    0a247a58fc3e2ecfc17654301033e8b8d08df2a2

In this change the sysdata has changed from directly representing
a value (the node number in NUMA) to a pointer to a structure.
However, it seems that we do not always initialise this sysdata
before we probe the device.

Prior to the changes above the node was defaulted to 'NULL'
allocating the devices to node 0 unconditionally.  This patch adds
a default sysdata entry (pci_default_sysdata), this is then used
where 'NULL' was used previously.  pci_default_sysdata defaults
the node to unknown (-1).  This is a more accurate assignment,
mirroring the value returned where no topology support is provided
and no locality information is available.

There are only two uses of this value in the affected architectures
(x86, x86_64) and generic code:

1) in x86_64, dma_alloc_pages() looks up the node in order to
   allocate node local memory.  Here if the node is invalid we
   will default to the first online node.  Behaviour here should
   be unchanged.
2) in generic, pci_call_probe() looks up the node in order to
   restrict execution of the probe on the card local node, to
   favor node local allocation.  Where this is unknown previously
   we would force execution (and thereby allocation) to node 0,
   this is arguably wrong and using -1 releases this restriction.

In an ideal world we should be supplying a sysdata for the
appropriate node where it is known.  Where it is not known defaulting
to -1 seems a better course, and would help us where node 0 is
short of memory.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
---
diff --git a/arch/i386/pci/common.c b/arch/i386/pci/common.c
index 85503de..362b7b4 100644
--- a/arch/i386/pci/common.c
+++ b/arch/i386/pci/common.c
@@ -27,6 +27,8 @@ unsigned long pirq_table_addr;
 struct pci_bus *pci_root_bus;
 struct pci_raw_ops *raw_pci_ops;
 
+struct pci_sysdata pci_default_sysdata = { .node = -1 };
+
 static int pci_read(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *value)
 {
 	return raw_pci_ops->read(0, bus->number, devfn, where, size, value);
diff --git a/arch/i386/pci/fixup.c b/arch/i386/pci/fixup.c
index e7306db..80365ac 100644
--- a/arch/i386/pci/fixup.c
+++ b/arch/i386/pci/fixup.c
@@ -25,9 +25,11 @@ static void __devinit pci_fixup_i450nx(struct pci_dev *d)
 		pci_read_config_byte(d, reg++, &subb);
 		DBG("i450NX PXB %d: %02x/%02x/%02x\n", pxb, busno, suba, subb);
 		if (busno)
-			pci_scan_bus(busno, &pci_root_ops, NULL);	/* Bus A */
+			pci_scan_bus(busno, &pci_root_ops,
+					&pci_default_sysdata);	/* Bus A */
 		if (suba < subb)
-			pci_scan_bus(suba+1, &pci_root_ops, NULL);	/* Bus B */
+			pci_scan_bus(suba+1, &pci_root_ops,
+					&pci_default_sysdata);	/* Bus B */
 	}
 	pcibios_last_bus = -1;
 }
@@ -42,7 +44,7 @@ static void __devinit pci_fixup_i450gx(struct pci_dev *d)
 	u8 busno;
 	pci_read_config_byte(d, 0x4a, &busno);
 	printk(KERN_INFO "PCI: i440KX/GX host bridge %s: secondary bus %02x\n", pci_name(d), busno);
-	pci_scan_bus(busno, &pci_root_ops, NULL);
+	pci_scan_bus(busno, &pci_root_ops, &pci_default_sysdata);
 	pcibios_last_bus = -1;
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82454GX, pci_fixup_i450gx);
diff --git a/arch/i386/pci/legacy.c b/arch/i386/pci/legacy.c
index 149a958..b076b25 100644
--- a/arch/i386/pci/legacy.c
+++ b/arch/i386/pci/legacy.c
@@ -26,7 +26,8 @@ static void __devinit pcibios_fixup_peer_bridges(void)
 			    l != 0x0000 && l != 0xffff) {
 				DBG("Found device at %02x:%02x [%04x]\n", n, devfn, l);
 				printk(KERN_INFO "PCI: Discovered peer bus %02x\n", n);
-				pci_scan_bus(n, &pci_root_ops, NULL);
+				pci_scan_bus(n, &pci_root_ops, 
+						&pci_default_sysdata);
 				break;
 			}
 		}
diff --git a/arch/i386/pci/numa.c b/arch/i386/pci/numa.c
index adbe17a..8d2fd6c 100644
--- a/arch/i386/pci/numa.c
+++ b/arch/i386/pci/numa.c
@@ -97,9 +97,11 @@ static void __devinit pci_fixup_i450nx(struct pci_dev *d)
 		pci_read_config_byte(d, reg++, &subb);
 		DBG("i450NX PXB %d: %02x/%02x/%02x\n", pxb, busno, suba, subb);
 		if (busno)
-			pci_scan_bus(QUADLOCAL2BUS(quad,busno), &pci_root_ops, NULL);	/* Bus A */
+			pci_scan_bus(QUADLOCAL2BUS(quad,busno), &pci_root_ops,
+					&pci_default_sysdata);	/* Bus A */
 		if (suba < subb)
-			pci_scan_bus(QUADLOCAL2BUS(quad,suba+1), &pci_root_ops, NULL);	/* Bus B */
+			pci_scan_bus(QUADLOCAL2BUS(quad,suba+1), &pci_root_ops,
+					&pci_default_sysdata);	/* Bus B */
 	}
 	pcibios_last_bus = -1;
 }
@@ -124,7 +126,7 @@ static int __init pci_numa_init(void)
 			printk("Scanning PCI bus %d for quad %d\n", 
 				QUADLOCAL2BUS(quad,0), quad);
 			pci_scan_bus(QUADLOCAL2BUS(quad,0), 
-				&pci_root_ops, NULL);
+				&pci_root_ops, &pci_default_sysdata);
 		}
 	return 0;
 }
diff --git a/arch/i386/pci/visws.c b/arch/i386/pci/visws.c
index f1b486d..2539371 100644
--- a/arch/i386/pci/visws.c
+++ b/arch/i386/pci/visws.c
@@ -101,8 +101,8 @@ static int __init pcibios_init(void)
 		"bridge B (PIIX4) bus: %u\n", pci_bus1, pci_bus0);
 
 	raw_pci_ops = &pci_direct_conf1;
-	pci_scan_bus(pci_bus0, &pci_root_ops, NULL);
-	pci_scan_bus(pci_bus1, &pci_root_ops, NULL);
+	pci_scan_bus(pci_bus0, &pci_root_ops, &pci_default_sysdata);
+	pci_scan_bus(pci_bus1, &pci_root_ops, &pci_default_sysdata);
 	pci_fixup_irqs(visws_swizzle, visws_map_irq);
 	pcibios_resource_survey();
 	return 0;
diff --git a/include/asm-i386/pci.h b/include/asm-i386/pci.h
index d790343..7003604 100644
--- a/include/asm-i386/pci.h
+++ b/include/asm-i386/pci.h
@@ -7,6 +7,7 @@
 struct pci_sysdata {
 	int		node;		/* NUMA node */
 };
+extern struct pci_sysdata pci_default_sysdata;
 
 #include <linux/mm.h>		/* for struct page */
 
diff --git a/include/asm-x86_64/pci.h b/include/asm-x86_64/pci.h
index 88926eb..2c2b092 100644
--- a/include/asm-x86_64/pci.h
+++ b/include/asm-x86_64/pci.h
@@ -9,6 +9,7 @@ struct pci_sysdata {
 	int		node;		/* NUMA node */
 	void*		iommu;		/* IOMMU private data */
 };
+extern struct pci_sysdata pci_default_sysdata;
 
 #ifdef CONFIG_CALGARY_IOMMU
 static inline void* pci_iommu(struct pci_bus *bus)
