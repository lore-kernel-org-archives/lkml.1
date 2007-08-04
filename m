Return-Path: <linux-kernel-owner+w=401wt.eu-S1765348AbXHDRpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765348AbXHDRpm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 13:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764844AbXHDRpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 13:45:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:5011 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758276AbXHDRpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 13:45:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=snp7ZEmtgt1tsN26/1VMCrj66Y37g2keT4qe4+OPQbdyRHYKpe1JQFlvF8aPcfYAY7Wm8J+fyThR6BZVHMz4N+EwxdP3BpNqNv0+8RvGp7HjTGmDqDZgF2NXobUdxR96ojpel6d/vXJXXwjWsfCimNGmTpWxqUZ4ZtWLjPBIsCg=
Message-ID: <86802c440708041045gd4a70fejf54f8532ff1a46f6@mail.gmail.com>
Date: Sat, 4 Aug 2007 10:45:31 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Oops in 2.6.23-rc1-git9, arch/x86_64/pci/k8-bus.c::fill_mp_bus_to_cpumask()
Cc: "Andi Kleen" <ak@suse.de>, "Chuck Ebbert" <cebbert@redhat.com>,
       "Muli Ben-Yehuda" <muli@il.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, riku.seppala@kymp.net,
       "Andy Whitcroft" <apw@shadowen.org>
In-Reply-To: <20070804093222.f0d7f3c7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46B3A7BB.9000102@redhat.com>
	 <20070803155035.1fb11c9a.akpm@linux-foundation.org>
	 <200708041130.42038.ak@suse.de>
	 <20070804093222.f0d7f3c7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/4/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sat, 4 Aug 2007 11:30:41 +0200 Andi Kleen <ak@suse.de> wrote:
>
> > On Saturday 04 August 2007 00:50, Andrew Morton wrote:
> > > On Fri, 03 Aug 2007 18:10:03 -0400
> > >
> > > Chuck Ebbert <cebbert@redhat.com> wrote:
> > > > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=250859
> > > >
> > > > at line 74:
> > > >
> > > > muli@62829:
> > > > muli@62829:                                       sd = bus->sysdata;
> > > > muli@62829:                                       sd->node = node;   <=====
> > > >
> > > > bus->sysdata is NULL.
> > > >
> > > > Last changed by this hunk of
> > > > "x86-64: introduce struct pci_sysdata to facilitate sharing of
> > > > ->sysdata":
> >
> > Hmm, will double check. Perhaps Muli's conversion was incomplete.
>
> hm.
>
> > > > @@ -67,7 +69,9 @@ fill_mp_bus_to_cpumask(void)
> > > >                                           continue;
> > > >                                   if (!node_online(node))
> > > >                                           node = 0;
> > > > -                                 bus->sysdata = (void *)node;
> > > > +
> > > > +                                 sd = bus->sysdata;
> > > > +                                 sd->node = node;
> > > >                           }
> > > >                   }
> > > >           }
> > >
> > > Andy keeps trotting out a patch which will probably fix this,
> >
> > What patch do you mean? I don't have anything sysdata related
> > left over.
> >
>
> "pci device ensure sysdata initialised", now at version 4.
>
>
>
> From: Andy Whitcroft <apw@shadowen.org>
>
> We have been seeing panic's on NUMA systems in pci_call_probe() in
> 2.6.19-rc1-mm1 and later.  This is related to the changes introduced in the
> commit below:
>
>     [x86, PCI] Switch pci_bus::sysdata from NUMA node integer to a pointer
>     0a247a58fc3e2ecfc17654301033e8b8d08df2a2
>
> In this change the sysdata has changed from directly representing a value
> (the node number in NUMA) to a pointer to a structure.  However, it seems
> that we do not always initialise this sysdata before we probe the device.
>
> Prior to the changes above the node was defaulted to 'NULL' allocating the
> devices to node 0 unconditionally.  This patch adds a default sysdata entry
> (pci_default_sysdata), this is then used where 'NULL' was used previously.
> pci_default_sysdata defaults the node to unknown (-1).  This is a more
> accurate assignment, mirroring the value returned where no topology support
> is provided and no locality information is available.
>
> There are only two uses of this value in the affected architectures
> (x86, x86_64) and generic code:
>
> 1) in x86_64, dma_alloc_pages() looks up the node in order to
>    allocate node local memory.  Here if the node is invalid we
>    will default to the first online node.  Behaviour here should
>    be unchanged.
> 2) in generic, pci_call_probe() looks up the node in order to
>    restrict execution of the probe on the card local node, to
>    favor node local allocation.  Where this is unknown previously
>    we would force execution (and thereby allocation) to node 0,
>    this is arguably wrong and using -1 releases this restriction.
>
> In an ideal world we should be supplying a sysdata for the
> appropriate node where it is known.  Where it is not known defaulting
> to -1 seems a better course, and would help us where node 0 is
> short of memory.
>
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>
> Acked-by: Yinghai Lu <yinghai.lu@sun.com>
> Cc: Andi Kleen <ak@suse.de>
> Cc: Jeff Garzik <jeff@garzik.org>
> Cc: Greg KH <greg@kroah.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Andrew,

still need
x86_64-get-mp_bus_to_node-as-early-v2.patch in the -mm
it fix
diff -puN arch/i386/pci/irq.c~x86_64-get-mp_bus_to_node-as-early-v2
arch/i386/pci/irq.c
--- a/arch/i386/pci/irq.c~x86_64-get-mp_bus_to_node-as-early-v2
+++ a/arch/i386/pci/irq.c
@@ -136,10 +136,26 @@ static void __init pirq_peer_trick(void)
               busmap[e->bus] = 1;
       }
       for(i = 1; i < 256; i++) {
+               struct pci_bus *bus = NULL;
+               struct pci_sysdata *sd;
               if (!busmap[i] || pci_find_bus(0, i))
                       continue;
-               if (pci_scan_bus(i, &pci_root_ops, NULL))
+               /* Allocate per-root-bus (not per bus) arch-specific data.
+                * TODO: leak; this memory is never freed.
+                * It's arguable whether it's worth the trouble to care.
+                */
+               sd = kzalloc(sizeof(*sd), GFP_KERNEL);
+               if (!sd) {
+                       printk(KERN_ERR "PCI: OOM, not probing PCI bus %02x\n",
+                               i);
+                       continue;
+               }
+               sd->node = get_mp_bus_to_node(i);
+               bus = pci_scan_bus(i, &pci_root_ops, sd);
+               if (bus)
                       printk(KERN_INFO "PCI: Discovered primary peer
bus %02x [IRQ]\n", i);
+               else
+                       kfree(sd);
       }
       pcibios_last_bus = -1;
 }
diff -puN arch/i386/pci/legacy.c~x86_64-get-mp_bus_to_node-as-early-v2
arch/i386/pci/legacy.c
--- a/arch/i386/pci/legacy.c~x86_64-get-mp_bus_to_node-as-early-v2
+++ a/arch/i386/pci/legacy.c
@@ -12,6 +12,9 @@
 static void __devinit pcibios_fixup_peer_bridges(void)
 {
       int n, devfn;
+       struct pci_bus *bus = NULL;
+       struct pci_sysdata *sd;
+       long node;

       if (pcibios_last_bus <= 0 || pcibios_last_bus >= 0xff)
               return;
@@ -21,12 +24,29 @@ static void __devinit pcibios_fixup_peer
               u32 l;
               if (pci_find_bus(0, n))
                       continue;
+               node = get_mp_bus_to_node(n);
               for (devfn = 0; devfn < 256; devfn += 8) {
                       if (!raw_pci_ops->read(0, n, devfn,
PCI_VENDOR_ID, 2, &l) &&
                           l != 0x0000 && l != 0xffff) {
                               DBG("Found device at %02x:%02x
[%04x]\n", n, devfn, l);
                               printk(KERN_INFO "PCI: Discovered peer
bus %02x\n", n);
-                               pci_scan_bus(n, &pci_root_ops, NULL);
+                               /* Allocate per-root-bus (not per bus)
+                                * arch-specific data.
+                                * TODO: leak; this memory is never freed.
+                                * It's arguable whether it's worth the trouble
+                                * to care.
+                                */
+                               sd = kzalloc(sizeof(*sd), GFP_KERNEL);
+                               if (!sd) {
+                                       printk(KERN_ERR
+                                       "PCI: OOM, not probing PCI bus %02x\n",
+                                                n);
+                                       break;
+                               }
+                               sd->node = node;
+                               bus = pci_scan_bus(n, &pci_root_ops, sd);
+                               if (!bus)
+                                       kfree(sd);
                               break;
                       }
               }

YH
