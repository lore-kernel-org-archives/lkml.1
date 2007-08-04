Return-Path: <linux-kernel-owner+w=401wt.eu-S932302AbXHDQd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302AbXHDQd5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 12:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932092AbXHDQdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 12:33:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33098 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763745AbXHDQds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 12:33:48 -0400
Date: Sat, 4 Aug 2007 09:32:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: Chuck Ebbert <cebbert@redhat.com>, Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, riku.seppala@kymp.net,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: Oops in 2.6.23-rc1-git9,
 arch/x86_64/pci/k8-bus.c::fill_mp_bus_to_cpumask()
Message-Id: <20070804093222.f0d7f3c7.akpm@linux-foundation.org>
In-Reply-To: <200708041130.42038.ak@suse.de>
References: <46B3A7BB.9000102@redhat.com>
	<20070803155035.1fb11c9a.akpm@linux-foundation.org>
	<200708041130.42038.ak@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Aug 2007 11:30:41 +0200 Andi Kleen <ak@suse.de> wrote:

> On Saturday 04 August 2007 00:50, Andrew Morton wrote:
> > On Fri, 03 Aug 2007 18:10:03 -0400
> >
> > Chuck Ebbert <cebbert@redhat.com> wrote:
> > > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=250859
> > >
> > > at line 74:
> > >
> > > muli@62829:
> > > muli@62829: 					sd = bus->sysdata;
> > > muli@62829: 					sd->node = node;   <=====
> > >
> > > bus->sysdata is NULL.
> > >
> > > Last changed by this hunk of
> > > "x86-64: introduce struct pci_sysdata to facilitate sharing of
> > > ->sysdata":
> 
> Hmm, will double check. Perhaps Muli's conversion was incomplete.

hm.

> > > @@ -67,7 +69,9 @@ fill_mp_bus_to_cpumask(void)
> > >  						continue;
> > >  					if (!node_online(node))
> > >  						node = 0;
> > > -					bus->sysdata = (void *)node;
> > > +
> > > +					sd = bus->sysdata;
> > > +					sd->node = node;
> > >  				}
> > >  			}
> > >  		}
> >
> > Andy keeps trotting out a patch which will probably fix this,
> 
> What patch do you mean? I don't have anything sysdata related
> left over.
> 

"pci device ensure sysdata initialised", now at version 4.



From: Andy Whitcroft <apw@shadowen.org>

We have been seeing panic's on NUMA systems in pci_call_probe() in
2.6.19-rc1-mm1 and later.  This is related to the changes introduced in the
commit below:

    [x86, PCI] Switch pci_bus::sysdata from NUMA node integer to a pointer
    0a247a58fc3e2ecfc17654301033e8b8d08df2a2

In this change the sysdata has changed from directly representing a value
(the node number in NUMA) to a pointer to a structure.  However, it seems
that we do not always initialise this sysdata before we probe the device.

Prior to the changes above the node was defaulted to 'NULL' allocating the
devices to node 0 unconditionally.  This patch adds a default sysdata entry
(pci_default_sysdata), this is then used where 'NULL' was used previously. 
pci_default_sysdata defaults the node to unknown (-1).  This is a more
accurate assignment, mirroring the value returned where no topology support
is provided and no locality information is available.

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
Acked-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/common.c   |    2 ++
 arch/i386/pci/fixup.c    |    8 +++++---
 arch/i386/pci/numa.c     |    8 +++++---
 arch/i386/pci/visws.c    |    4 ++--
 include/asm-i386/pci.h   |    1 +
 include/asm-x86_64/pci.h |    1 +
 6 files changed, 16 insertions(+), 8 deletions(-)

diff -puN arch/i386/pci/common.c~pci-device-ensure-sysdata-initialised-v4 arch/i386/pci/common.c
--- a/arch/i386/pci/common.c~pci-device-ensure-sysdata-initialised-v4
+++ a/arch/i386/pci/common.c
@@ -27,6 +27,8 @@ unsigned long pirq_table_addr;
 struct pci_bus *pci_root_bus;
 struct pci_raw_ops *raw_pci_ops;
 
+struct pci_sysdata pci_default_sysdata = { .node = -1 };
+
 static int pci_read(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *value)
 {
 	return raw_pci_ops->read(0, bus->number, devfn, where, size, value);
diff -puN arch/i386/pci/fixup.c~pci-device-ensure-sysdata-initialised-v4 arch/i386/pci/fixup.c
--- a/arch/i386/pci/fixup.c~pci-device-ensure-sysdata-initialised-v4
+++ a/arch/i386/pci/fixup.c
@@ -25,9 +25,11 @@ static void __devinit pci_fixup_i450nx(s
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
@@ -42,7 +44,7 @@ static void __devinit pci_fixup_i450gx(s
 	u8 busno;
 	pci_read_config_byte(d, 0x4a, &busno);
 	printk(KERN_INFO "PCI: i440KX/GX host bridge %s: secondary bus %02x\n", pci_name(d), busno);
-	pci_scan_bus(busno, &pci_root_ops, NULL);
+	pci_scan_bus(busno, &pci_root_ops, &pci_default_sysdata);
 	pcibios_last_bus = -1;
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82454GX, pci_fixup_i450gx);
diff -puN arch/i386/pci/numa.c~pci-device-ensure-sysdata-initialised-v4 arch/i386/pci/numa.c
--- a/arch/i386/pci/numa.c~pci-device-ensure-sysdata-initialised-v4
+++ a/arch/i386/pci/numa.c
@@ -97,9 +97,11 @@ static void __devinit pci_fixup_i450nx(s
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
diff -puN arch/i386/pci/visws.c~pci-device-ensure-sysdata-initialised-v4 arch/i386/pci/visws.c
--- a/arch/i386/pci/visws.c~pci-device-ensure-sysdata-initialised-v4
+++ a/arch/i386/pci/visws.c
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
diff -puN include/asm-i386/pci.h~pci-device-ensure-sysdata-initialised-v4 include/asm-i386/pci.h
--- a/include/asm-i386/pci.h~pci-device-ensure-sysdata-initialised-v4
+++ a/include/asm-i386/pci.h
@@ -7,6 +7,7 @@
 struct pci_sysdata {
 	int		node;		/* NUMA node */
 };
+extern struct pci_sysdata pci_default_sysdata;
 
 #include <linux/mm.h>		/* for struct page */
 
diff -puN include/asm-x86_64/pci.h~pci-device-ensure-sysdata-initialised-v4 include/asm-x86_64/pci.h
--- a/include/asm-x86_64/pci.h~pci-device-ensure-sysdata-initialised-v4
+++ a/include/asm-x86_64/pci.h
@@ -9,6 +9,7 @@ struct pci_sysdata {
 	int		node;		/* NUMA node */
 	void*		iommu;		/* IOMMU private data */
 };
+extern struct pci_sysdata pci_default_sysdata;
 
 #ifdef CONFIG_CALGARY_IOMMU
 static inline void* pci_iommu(struct pci_bus *bus)
_

