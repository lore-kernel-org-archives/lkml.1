Return-Path: <linux-kernel-owner+w=401wt.eu-S1759691AbYBKS2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759691AbYBKS2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758047AbYBKS1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:27:54 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36567 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759428AbYBKS1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:27:53 -0500
Date: Mon, 11 Feb 2008 20:03:17 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Prevent IDE boot ops on NUMA system in mainline
Message-ID: <20080211190317.GA21824@one.firstfloor.org>
References: <20080211003520.GA32082@basil.nowhere.org> <alpine.LFD.1.00.0802110929230.2920@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802110929230.2920@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 09:33:14AM -0800, Linus Torvalds wrote:
> 
> 
> On Mon, 11 Feb 2008, Andi Kleen wrote:
> > 
> > Without this patch a Opteron test system here oopses at boot with currentg git. 
> > 
> > Calling to_pci_dev() on a NULL pointer gives a negative value so the following NULL 
> > pointer check never triggers and then an illegal address is referenced. Check the 
> > unadjusted original device pointer for NULL instead.
> > 
> > Signed-off-by: Andi Kleen <ak@suse.de>
> > 
> > Index: linux/include/linux/ide.h
> > ===================================================================
> > --- linux.orig/include/linux/ide.h
> > +++ linux/include/linux/ide.h
> > @@ -1294,7 +1294,7 @@ static inline void ide_dump_identify(u8 
> >  static inline int hwif_to_node(ide_hwif_t *hwif)
> >  {
> >  	struct pci_dev *dev = to_pci_dev(hwif->dev);
> > -	return dev ? pcibus_to_node(dev->bus) : -1;
> > +	return hwif->dev ? pcibus_to_node(dev->bus) : -1;
> >  }
> 
> Ok, I applied this, but it causes a *lot* of noise about "unused variable 
> 'dev'" because pcibus_to_node() is defined to be -1 when you don't do any 
> strange NUMA thing (so that "dev->bus" usage thing is never even seen by 
> the compiler.
> 
> So we should probably make pcibus_to_node() be an inline function for that 
> case, or just make that thing be
> 
> 	return hwif->dev ?
> 		pcibus_to_node(to_pci_dev(hwif->dev)->bus)
> 	       :
> 		-1;
> 
> or something. Because now things are really noisy.

Yes sorry; I only checked NUMA builds before sending it off. 
The easiest way is probably just the traditional (void) cast
I fixed most of the topology macros while I was at it.

-Andi

---

Make topology fallback macros reference their arguments.

This avoids warnings with unreferenced variables in the !NUMA case.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/include/asm-generic/topology.h
===================================================================
--- linux.orig/include/asm-generic/topology.h
+++ linux/include/asm-generic/topology.h
@@ -30,19 +30,19 @@
 /* Other architectures wishing to use this simple topology API should fill
    in the below functions as appropriate in their own <asm/topology.h> file. */
 #ifndef cpu_to_node
-#define cpu_to_node(cpu)	(0)
+#define cpu_to_node(cpu)	((void)(cpu),0)
 #endif
 #ifndef parent_node
-#define parent_node(node)	(0)
+#define parent_node(node)	((void)(node),0)
 #endif
 #ifndef node_to_cpumask
-#define node_to_cpumask(node)	(cpu_online_map)
+#define node_to_cpumask(node)	((void)node, cpu_online_map)
 #endif
 #ifndef node_to_first_cpu
-#define node_to_first_cpu(node)	(0)
+#define node_to_first_cpu(node)	((void)(node),0)
 #endif
 #ifndef pcibus_to_node
-#define pcibus_to_node(node)	(-1)
+#define pcibus_to_node(bus)	((void)(bus), -1)
 #endif
 
 #ifndef pcibus_to_cpumask
