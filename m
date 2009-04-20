Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbZDTWc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbZDTWc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 18:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756141AbZDTWcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 18:32:47 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:38675 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbZDTWcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 18:32:46 -0400
Date: Tue, 21 Apr 2009 02:33:05 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
Message-ID: <20090420223305.GA15340@jurassic.park.msu.ru>
References: <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org> <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <49E99054.6050208@kernel.org> <alpine.LFD.2.00.0904181142530.4042@localhost.localdomain> <49EA57C4.1000603@kernel.org> <alpine.LFD.2.00.0904181602030.2199@localhost.localdomain> <alpine.LFD.2.00.0904182149240.2199@localhost.localdomain> <20090419090208.GA30211@elte.hu> <20090419090615.GA30631@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090419090615.GA30631@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 19, 2009 at 11:06:15AM +0200, Ingo Molnar wrote:
> Hm, there's one patch in that lot that does:
> 
>  drivers/pci/bus.c	 |    8 +++++++-
>  drivers/pci/probe.c     |    8 ++++++--
>  drivers/pci/setup-bus.c |   40 +++++++++++++++++++++++++++++++---------
>  3 files changed, 44 insertions(+), 12 deletions(-)
> 
> Which should go via the PCI tree.

Here is a replacement for that patch which doesn't touch
the generic code.

Ivan.

---
x86 pci: first cut on 64-bit resource allocation

I believe that we should consider PCI memory above 4G as yet another
type of address space. This actually makes sense, as even accesses to that
memory are physically different - Dual Address Cycle (DAC) vs. 32-bit
Single Address Cycle (SAC).

So, platform that can deal with 64-bit allocations would set up an
additional root bus resource and mark it with IORESOURCE_MEM64 flag.

The main problem here is how the kernel would detect that hardware can
actually access a DAC memory (I know for a fact that a lot of Intel chipsets
cannot access MMIO >4G, even though subordinate p2p bridges are 64-bit
capable).
On the other hand, there are PCI devices with 64-bit BARs that do not
work properly being placed above 4G boundary. For example, some
radeon cards have 64-bit BAR for video RAM, but allocating that BAR in
the DAC area doesn't work for various reasons, like video-BIOS
limitations or drivers not taking into account that GPU is 32-bit.

So moving stuff into MEM64 area should be considered as generally unsafe
operation, and the best default policy is to not enable MEM64 resource
unless we find that BIOS has allocated something there.
At the same time, MEM64 can be easily enabled/disabled based on host
bridge PCI IDs, kernel command line options and so on.

Here is a basic implementation of the above for x86. I think it's
reasonably good starting point for PCI64 work - the next step would
be to teach pci_bus_alloc_resource() about IORESOURCE_MEM64: logic is
similar to prefetch vs non-prefetch case - MEM can hold MEM64 resource,
but not vice versa. And eventually bridge sizing code will be updated
for reasonable 64-bit allocations (it's a non-trivial task, though).

This patch alone should fix cardbus >4G allocations and similar
nonsense.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/x86/include/asm/pci.h |    8 ++++++++
 arch/x86/pci/Makefile      |    2 ++
 arch/x86/pci/dac_64bit.c   |   44 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/pci/i386.c        |   10 ++++++++++
 include/linux/ioport.h     |    2 ++
 5 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index b51a1e8..5a9c54e 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -86,6 +86,14 @@ static inline void early_quirks(void) { }
 
 extern void pci_iommu_alloc(void);
 
+#ifdef CONFIG_ARCH_PHYS_ADDR_T_64BIT
+extern void pcibios_pci64_setup(void);
+extern void pcibios_pci64_verify(void);
+#else
+static inline void pcibios_pci64_setup(void) { }
+static inline void pcibios_pci64_verify(void) { }
+#endif
+
 /* MSI arch hook */
 #define arch_setup_msi_irqs arch_setup_msi_irqs
 
diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index d49202e..1b6c576 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -13,5 +13,7 @@ obj-$(CONFIG_X86_VISWS)		+= visws.o
 
 obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 
+obj-$(CONFIG_ARCH_PHYS_ADDR_T_64BIT)	+= dac_64bit.o
+
 obj-y				+= common.o early.o
 obj-y				+= amd_bus.o
diff --git a/arch/x86/pci/dac_64bit.c b/arch/x86/pci/dac_64bit.c
new file mode 100644
index 0000000..ee03c4a
--- /dev/null
+++ b/arch/x86/pci/dac_64bit.c
@@ -0,0 +1,44 @@
+/*
+ * Set up the 64-bit bus resource for allocations > 4G if the hardware
+ * is capable of generating Dual Address Cycle (DAC).
+ */
+
+#include <linux/pci.h>
+
+static struct resource mem64 = {
+	.name	= "PCI mem64",
+	.start	= (resource_size_t)1 << 32,	/* 4Gb */
+	.end	= -1,
+	.flags	= IORESOURCE_MEM,
+};
+
+void pcibios_pci64_setup(void)
+{
+	struct resource *r64 = &mem64, *root = &iomem_resource;
+	struct pci_bus *b;
+
+	if (insert_resource(root, r64)) {
+		printk(KERN_WARNING "PCI: Failed to allocate PCI64 space\n");
+		return;
+	}
+
+	list_for_each_entry(b, &pci_root_buses, node) {
+		/* Is this a "standard" root bus created by pci_create_bus? */
+		if (b->resource[1] != root || b->resource[2])
+			continue;
+		b->resource[2] = r64;	/* create DAC resource */
+	}
+}
+
+void pcibios_pci64_verify(void)
+{
+	struct pci_bus *b;
+
+	if (mem64.flags & IORESOURCE_MEM64)
+		return;		/* presumably DAC works */
+	list_for_each_entry(b, &pci_root_buses, node) {
+		if (b->resource[2] == &mem64)
+			b->resource[2] = NULL;
+	}
+	printk(KERN_INFO "PCI: allocations above 4G disabled\n");
+}
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index f1817f7..bf8eb75 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -137,6 +137,10 @@ static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
 					 * range.
 					 */
 					r->flags = 0;
+				} else {
+					/* Successful allocation */
+					if (upper_32_bits(r->start))
+						pr->flags |= IORESOURCE_MEM64;
 				}
 			}
 		}
@@ -174,6 +178,10 @@ static void __init pcibios_allocate_resources(int pass)
 					/* We'll assign a new address later */
 					r->end -= r->start;
 					r->start = 0;
+				} else {
+					/* Successful allocation */
+					if (upper_32_bits(r->start))
+						pr->flags |= IORESOURCE_MEM64;
 				}
 			}
 		}
@@ -225,9 +233,11 @@ static int __init pcibios_assign_resources(void)
 void __init pcibios_resource_survey(void)
 {
 	DBG("PCI: Allocating resources\n");
+	pcibios_pci64_setup();
 	pcibios_allocate_bus_resources(&pci_root_buses);
 	pcibios_allocate_resources(0);
 	pcibios_allocate_resources(1);
+	pcibios_pci64_verify();
 
 	e820_reserve_resources_late();
 }
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 32e4b2f..30403b3 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -49,6 +49,8 @@ struct resource_list {
 #define IORESOURCE_SIZEALIGN	0x00020000	/* size indicates alignment */
 #define IORESOURCE_STARTALIGN	0x00040000	/* start field is alignment */
 
+#define IORESOURCE_MEM64	0x00080000	/* 64-bit addressing, >4G */
+
 #define IORESOURCE_EXCLUSIVE	0x08000000	/* Userland may not map this resource */
 #define IORESOURCE_DISABLED	0x10000000
 #define IORESOURCE_UNSET	0x20000000
