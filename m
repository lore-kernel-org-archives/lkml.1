Return-Path: <linux-kernel-owner+w=401wt.eu-S1762029AbXEVXbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762029AbXEVXbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 19:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756397AbXEVXbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 19:31:25 -0400
Received: from outbound-mail-44.bluehost.com ([69.89.18.13]:48872 "HELO
	outbound-mail-44.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756332AbXEVXbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 19:31:24 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Wayne Sherman <wsherman@gmail.com>
Subject: Re: PCI device problem - MMCONFIG, cannot allocate resource region, resource collisions
Date: Tue, 22 May 2007 16:31:22 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
References: <46524A6D.5050601@gmail.com> <200705220858.51604.jbarnes@virtuousgeek.org> <46537ADE.1060103@gmail.com>
In-Reply-To: <46537ADE.1060103@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_K13UGe9McXulusw"
Message-Id: <200705221631.22456.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_K13UGe9McXulusw
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday, May 22, 2007, Wayne Sherman wrote:
> So these devices are already occupying the space that the D-Link wants:
>
> 00:01.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge
> 01:05.0 VGA compatible controller: ATI Technologies Inc RS482 [Radeon
> Xpress 200]
>
> But, the D-Link NIC is behind the bridge at
> 	ff500000-ff5fffff : PCI Bus #02
>
> Is a PCI device behind a bridge supposed to be mapped into memory that
> its bridge encompasses?

Yes.

> If so, the D-Link is not being mapped into the 
> right region, and the bridge it is behind does not have enough memory
> assigned to it (ff500000-ff5fffff : PCI Bus #02).

Sounds familiar.  There are lots of cases where bridge windows aren't 
allocated properly so devices behind them are invisible or can't work.  
Check out the attached patch from Ivan, if you 
pass 'pci=assign-bus-resources' to your kernel at boot time, the code will 
try to reallocate bridge space for you if needed.

Jesse

--Boundary-00=_K13UGe9McXulusw
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="pci-bridge-allocation.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="pci-bridge-allocation.patch"

=46rom ink@jurassic.park.msu.ru Tue May 15 15:39:53 2007
Received: from virtuous by box128.bluehost.com with local-bsmtp (Exim 4.63)
	(envelope-from <linux-kernel-owner+jbarnes=3D40virtuousgeek.org-S1759714Ab=
XEOWja@vger.kernel.org>)
	id 1Ho5gr-0001rh-22
	for jbarnes@virtuousgeek.org; Tue, 15 May 2007 16:40:21 -0600
X-Spam-Checker-Version: SpamAssassin 3.2.0 (2007-05-01) on box128.bluehost.=
com
X-Spam-Level:=20
X-Spam-Status: No, score=3D-2.6 required=3D5.0 tests=3DAWL,BAYES_00 autolea=
rn=3Dno
	version=3D3.2.0
Received: from vger.kernel.org ([209.132.176.167])
	by box128.bluehost.com with esmtp (Exim 4.63)
	(envelope-from <linux-kernel-owner+jbarnes=3D40virtuousgeek.org-S1759714Ab=
XEOWja@vger.kernel.org>)
	id 1Ho5gq-0001rT-HJ
	for jbarnes@virtuousgeek.org; Tue, 15 May 2007 16:40:20 -0600
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759714AbXEOWja (ORCPT <rfc822;jbarnes@virtuousgeek.org>);
	Tue, 15 May 2007 18:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbXEOWjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 18:39:20 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:4396 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838AbXEOWjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 18:39:19 -0400
Received: by jurassic.park.msu.ru (Postfix, from userid 500)
	id 424A411E9A1; Wed, 16 May 2007 02:39:53 +0400 (MSD)
Date:	Wed, 16 May 2007 02:39:53 +0400
=46rom:	Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 Greg KH <gregkh@suse.de>,
 Adam Jackson <ajackson@redhat.com>,
 linux-kernel@vger.kernel.org
Subject: Re: PCI bridge range sizing bug
Message-ID: <20070516023953.A7394@jurassic.park.msu.ru>
References: <1175812632.17147.12.camel@localhost.localdomain> <alpine.LFD.0=
=2E98.0704201102000.9964@woody.linux-foundation.org> <20070421003020.A21503=
@jurassic.park.msu.ru> <200705141045.44059.jesse.barnes@intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset=3Dus-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <200705141045.44059.jesse.barnes@intel.com>; from jesse.barnes=
@intel.com on Mon, May 14, 2007 at 10:45:43AM -0700
Precedence: bulk
X-Mailing-List:	linux-kernel@vger.kernel.org
X-Length: 8940
X-UID: 118711

On Mon, May 14, 2007 at 10:45:43AM -0700, Jesse Barnes wrote:
> Any update on this, Ivan?  Maybe I missed your post, but I haven't seen=20
> anything yet...

No, I didn't post anything, sorry. This turned out to be not as trivial
as I thought - I've played with that code on amd64, and results were rather
discouraging. For example, I forced reassignment of video card resources
and initially this failed because of the way how pci/setup-* allocates ROM
addresses: ROMs are obviously prefetchable, so we're always trying to put
them in prefetchable windows of the bridge. Technically, this is correct,
but leads to the waste of PCI address space due to size/alignment
requirements, especially when ROM is assigned to the same window as
a prefetchable framebuffer resource (typically 64-256M).
On the other hand, we could allocate ROMs in non-prefetch ranges just
for free, as minimal memory window of the bridges is 1M and both MMIO
register blocks and ROMs are usually much smaller.=20
Probably we need some global variable to control this (and some other thing=
s)
in pci/setup-*, just like pci_probe on i386...

Another funny thing found on x86_64 - if we ran out of PCI address space=20
below 4G, resources get happily assigned above 4G, even if respective BARs
are 32-bit.

Anyway, here's what I have so far, though I doubt that it's a breakthrough
for Adam...

Ivan.

=2D-- orig/arch/i386/pci/common.c	Sat Apr 21 21:55:30 2007
+++ linux/arch/i386/pci/common.c	Sat Apr 21 21:55:33 2007
@@ -290,6 +290,12 @@ static struct dmi_system_id __devinitdat
 	{}
 };
=20
+static struct resource pci_mem32 =3D {
+	.name	=3D "PCI 32-bit memory space",
+	.end	=3D 0xffffffff,
+	.flags	=3D IORESOURCE_MEM,
+};
+
 struct pci_bus * __devinit pcibios_scan_root(int busnum)
 {
 	struct pci_bus *bus =3D NULL;
@@ -305,7 +311,13 @@ struct pci_bus * __devinit pcibios_scan_
=20
 	printk(KERN_DEBUG "PCI: Probing PCI hardware (bus %02x)\n", busnum);
=20
=2D	return pci_scan_bus_parented(NULL, busnum, &pci_root_ops, NULL);
+	bus =3D pci_scan_bus_parented(NULL, busnum, &pci_root_ops, NULL);
+	if (bus && bus->resource[1] =3D=3D &iomem_resource) {
+		pci_mem32.start =3D pci_mem_start;
+		if (insert_resource(&iomem_resource, &pci_mem32) =3D=3D 0)
+			bus->resource[1] =3D &pci_mem32;
+	}
+	return bus;
 }
=20
 extern u8 pci_cache_line_size;
@@ -418,6 +418,9 @@ char * __devinit  pcibios_setup(char *st
 	} else if (!strcmp(str, "routeirq")) {
 		pci_routeirq =3D 1;
 		return NULL;
+	} else if (!strcmp(str, "assign-bus-resources")) {
+		pci_probe |=3D PCI_ASSIGN_BUS_RESOURCES;
+		return NULL;
 	}
 	return str;
 }
=2D-- orig/arch/i386/pci/pci.h	Sat Apr 21 21:55:30 2007
+++ linux/arch/i386/pci/pci.h	Sat Apr 21 21:55:33 2007
@@ -26,6 +26,7 @@
 #define PCI_ASSIGN_ROMS		0x1000
 #define PCI_BIOS_IRQ_SCAN	0x2000
 #define PCI_ASSIGN_ALL_BUSSES	0x4000
+#define PCI_ASSIGN_BUS_RESOURCES	0x8000
=20
 extern unsigned int pci_probe;
 extern unsigned long pirq_table_addr;
=2D-- orig/arch/i386/pci/i386.c	Sat Apr 21 21:55:30 2007
+++ linux/arch/i386/pci/i386.c	Sat Apr 21 21:56:39 2007
@@ -60,6 +60,67 @@ pcibios_align_resource(void *data, struc
 	}
 }
=20
+static int __init
+pcibios_estimate_bus_space(struct pci_dev *bridge, resource_size_t *mem,
+			   resource_size_t *pref)
+{
+	int i;
+	struct resource *r;
+	struct pci_dev *dev;
+
+	if (!bridge->subordinate ||
+	    (bridge->class >> 8) !=3D PCI_CLASS_BRIDGE_PCI)
+		return 0;
+	list_for_each_entry(dev, &bridge->subordinate->devices, bus_list) {
+		for (i =3D 0; i <=3D PCI_ROM_RESOURCE; i++) {
+			r =3D &dev->resource[i];
+			if (r->flags & IORESOURCE_PREFETCH)
+				*pref +=3D r->end + 1 - r->start;
+			else if (r->flags & IORESOURCE_MEM)
+				*mem +=3D r->end + 1 - r->start;
+		}
+		pcibios_estimate_bus_space(dev, mem, pref);
+	}
+	return 1;
+}
+
+static void __init
+pcibios_validate_bus_ranges(struct pci_dev *bridge)
+{
+	resource_size_t memory =3D 0, prefetch =3D 0, bridge_mem, bridge_pref;
+	struct resource *bmem =3D &bridge->resource[PCI_BRIDGE_RESOURCES + 1];
+	struct resource *bpref =3D &bridge->resource[PCI_BRIDGE_RESOURCES + 2];
+
+	if (!(pci_probe & PCI_ASSIGN_BUS_RESOURCES) ||
+	    !pcibios_estimate_bus_space(bridge, &memory, &prefetch))
+		return;
+	bridge_mem =3D bmem->end + 1 - bmem->start;
+	bridge_pref =3D bpref->end + 1 - bpref->start;
+	/* First, check if bridge memory window can hold all the memory
+	   resources on the secondary buses. */
+	if (bridge_mem >=3D memory) {
+		/* Yes, it seems to be large enough and probably can hold
+		   [some of] prefetchable memory also. */
+		if (bridge_mem - memory < prefetch)
+			prefetch -=3D bridge_mem - memory;
+		else
+			prefetch =3D 0;
+	} else {
+		printk(KERN_INFO "PCI: MEM window of bridge %s too small "
+		       "(%llx, at least %llx required), will be reassigned\n",
+		       pci_name(bridge), (unsigned long long)bridge_mem,
+		       (unsigned long long)memory);
+		bmem->flags =3D 0;
+	}
+	/* Check the prefetchable memory window. */
+	if (bridge_pref < prefetch) {
+		printk(KERN_INFO "PCI: PREFETCH window of bridge %s too small, "
+		       "(%llx, at least %llx required), will be reassigned\n",
+		       pci_name(bridge), (unsigned long long)bridge_pref,
+		       (unsigned long long)prefetch);
+		bpref->flags =3D 0;
+	}
+}
=20
 /*
  *  Handle resources of PCI devices.  If the world were perfect, we could
@@ -104,6 +165,7 @@ static void __init pcibios_allocate_bus_
 	/* Depth-First Search on bus tree */
 	list_for_each_entry(bus, bus_list, node) {
 		if ((dev =3D bus->self)) {
+			pcibios_validate_bus_ranges(dev);
 			for (idx =3D PCI_BRIDGE_RESOURCES;
 			    idx < PCI_NUM_RESOURCES; idx++) {
 				r =3D &dev->resource[idx];
=2D-- orig/drivers/pci/setup-bus.c	Tue Apr 10 11:33:39 2007
+++ linux/drivers/pci/setup-bus.c	Sat Apr 21 19:56:28 2007
@@ -347,9 +347,12 @@ pbus_size_mem(struct pci_bus *bus, unsig
 	=09
 		for (i =3D 0; i < PCI_NUM_RESOURCES; i++) {
 			struct resource *r =3D &dev->resource[i];
=2D			unsigned long r_size;
+			unsigned long r_size, r_flags =3D r->flags;
=20
=2D			if (r->parent || (r->flags & mask) !=3D type)
+			if (i =3D=3D PCI_ROM_RESOURCE)
+				r_flags &=3D ~IORESOURCE_PREFETCH;
+
+			if (r->parent || (r_flags & mask) !=3D type)
 				continue;
 			r_size =3D r->end - r->start + 1;
 			/* For bridges size !=3D alignment */
=2D
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/



--Boundary-00=_K13UGe9McXulusw--
