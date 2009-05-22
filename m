Return-Path: <linux-kernel-owner+w=401wt.eu-S1757169AbZEVL5C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169AbZEVL5C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 07:57:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbZEVL4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 07:56:54 -0400
Received: from sh.osrg.net ([192.16.179.4]:34456 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbZEVL4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 07:56:53 -0400
Date: Fri, 22 May 2009 20:55:22 +0900
To: Ian.Campbell@eu.citrix.com, mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, jeremy@goop.org, beckyb@kernel.crashing.org,
       okir@suse.de, gregkh@suse.de, xendevel@lists.xensource.com,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: swiotlb: remove __weak hooks in favour of
	architecture-specific functions
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1242992596.22654.273.camel@zakaz.uk.xensource.com>
References: <1242922528-5982-1-git-send-email-ian.campbell@citrix.com>
	<20090522201325I.fujita.tomonori@lab.ntt.co.jp>
	<1242992596.22654.273.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090522205533P.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 22 May 2009 20:55:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009 12:43:16 +0100
Ian Campbell <Ian.Campbell@eu.citrix.com> wrote:

> On Fri, 2009-05-22 at 07:13 -0400, FUJITA Tomonori wrote:
> > On Thu, 21 May 2009 17:15:21 +0100
> > Ian Campbell <ian.campbell@citrix.com> wrote:
> > Please go with the following way (that I posted yesterday):
> > 
> > http://marc.info/?l=xen-devel&m=124292666214380&w=2
> > 
> > 
> > Export the core feature of swiotlb, managing iotlb buffer and
> > implement the Xen mapping functions.
> 
> I feel that should be a last resort, before we go down that path we
> should try and find a way for us to use the generic code in a clean way
> which makes everyone happy.
>
> We have had several attempts at this and admittedly have not yet come up
> with something that satisfies everyone but I don't really think we have
> gotten to the point of admitting defeat and just duplicating the code.

There should not be much duplication.


> I think the proposal to use a dma_map_range-like function which I sent a
> few minutes ago I think gets us closer to something which satisfies
> everyone's requirements, including yours for a clean abstraction.

Seems you don't understand the point; with dom0, we can't cleanly use
arch/*/include/asm/.

You need to insert Xen's hook like this:


+++ b/arch/x86/include/asm/dma-mapping.h
@@ -309,4 +309,20 @@ static inline void dma_free_coherent(struct device *dev, size_t size,
 		ops->free_coherent(dev, size, vaddr, bus);
 }
 
+static inline dma_addr_t dma_map_range(struct device *dev, u64 mask,
+				       phys_addr_t addr, size_t size)
+{
+	dma_addr_t dma_addr;
+#ifdef CONFIG_XEN
+	extern int xen_range_needs_mapping(phys_addr_t paddr, size_t size);
+	if (xen_pv_domain() && xen_range_needs_mapping(addr, size))
+		return 0;
+#endif
+
+	dma_addr = swiotlb_phys_to_bus(dev, addr);
+	if (dma_addr + size <= mask)
+		return 0;
+	return dma_addr;
+}

Or you need to use a function pointer in a strange way.

--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -315,4 +315,13 @@ static inline int is_buffer_dma_capable(struct device *dev, u64 mask,
 	return addr + size <= mask;
 }
 
+extern int (*x86_swiotlb_force_mapping)(phys_addr_t paddr, size_t size);
+
+static inline int swiotlb_force_mapping(phys_addr_t paddr, size_t size)
+{
+	if (x86_swiotlb_force_mapping)
+		return x86_swiotlb_force_mapping(paddr, size);
+	return 0;
+}
+

Or you could invent something more.


As you said in another mail, it's up to the x86 maintainer :

> This case is internal to the x86 arch code and I'd really like to hear
> the x86 maintainer's opinion of the general approach.


But the above code looks really ugly to me.


> >  With that approach, there is not
> > much code duplication and there is no need for ugly hooks for dom0;
> > the phys/bus address conversion and address checking.
> 
> The phys/bus address conversion is also needed for powerpc.
> 
> I think the two address checking functions can be collapsed into a
> single one which satisfies the needs of both Xen and powerpc.
> 
> What dom0 specific "ugly" hooks does that leave? The alloc one? I've
> discussed that in another mail.

See above. POWERPC can use arch/*/include/asm/ cleanly for the
phys/bus address conversion while dom0 can't. That's what I said again
and again.
