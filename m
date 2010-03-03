Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab0CCX3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 18:29:06 -0500
Received: from sh.osrg.net ([192.16.179.4]:57575 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712Ab0CCX27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 18:28:59 -0500
Date: Thu, 4 Mar 2010 08:28:54 +0900
To: rdunlap@xenotime.net
Cc: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] replace DECLARE_DMA_UNMAP_ADD_{ADDR,LEN} with
 DEFINE_DMA_UNMAP_ADD_{ADDR,LEN}
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4B8EEDB5.7060700@xenotime.net>
References: <20100303134947G.fujita.tomonori@lab.ntt.co.jp>
	<4B8EEDB5.7060700@xenotime.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100304082837J.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 04 Mar 2010 08:28:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Mar 2010 15:16:05 -0800
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On 03/02/10 20:50, FUJITA Tomonori wrote:
> > Seems that you missed the following patch?
> > 
> > http://lkml.org/lkml/2010/2/13/2
> > 
> > This can be fold into dma-mappingh-add-the-dma_unmap-state-api.patch.
> > 
> > Thanks,
> > 
> > =
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Subject: [PATCH -mm] replace DECLARE_DMA_UNMAP_ADD_{ADDR,LEN} with DEFINE_DMA_UNMAP_ADD_{ADDR,LEN}
> > 
> > Andrew pointed out:
> > 
> > - adding the semicolons at the end of DECLARE_DMA_UNMAP_{ADDR|LEN}
> >   confuses people.
> 
> Hm.  I'm (still) confused.  Why does this patch add semi-colons at the end
> of DECLARE_PCI_UNMAP_{ADDR|LEN} below then?  (other than it is spelled with
> letters "PCI" instead of "DMA")

Are you taking about this part, right?

+#define DECLARE_PCI_UNMAP_ADDR	(ADDR_NAME) DEFINE_DMA_UNMAP_ADDR(ADDR_NAME);
+#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)   DEFINE_DMA_UNMAP_LEN(LEN_NAME);

Currently, we have:

#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	dma_addr_t ADDR_NAME;

And PCI-DMA-mapping.txt says:

	struct ring_state {
		struct sk_buff *skb;
		DECLARE_PCI_UNMAP_ADDR(mapping)
		DECLARE_PCI_UNMAP_LEN(len)
	};

   NOTE: DO NOT put a semicolon at the end of the DECLARE_*()
         macro.

However, this confuses people. Some drivers already use this macro
with a semicolon like, DECLARE_PCI_UNMAP_ADDR(mapping);

To avoid the above confusion, the new DEFINE_DMA_ macros doesn't have
a semicolon (users need to use a semicolon):

#define DEFINE_DMA_UNMAP_ADDR(ADDR_NAME)        dma_addr_t ADDR_NAME
#define DEFINE_DMA_UNMAP_LEN(LEN_NAME)          __u32 LEN_NAME

So we need to define DECLARE_PCI_* macro in the following way
(otherwise we break the existing drivers):

#define DECLARE_PCI_UNMAP_ADDR	(ADDR_NAME) DEFINE_DMA_UNMAP_ADDR(ADDR_NAME);
#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)   DEFINE_DMA_UNMAP_LEN(LEN_NAME);


In the long term, I'll remove DECLARE_PCI_* macros.



> > - they are "definitions", not "declarations".
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  Documentation/DMA-API.txt   |    8 +++-----
> >  include/linux/dma-mapping.h |    8 ++++----
> >  include/linux/pci-dma.h     |   12 ++++++------
> >  3 files changed, 13 insertions(+), 15 deletions(-)
> > 
> > diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
> > index d7d9eef..0fc5728 100644
> > --- a/Documentation/DMA-API.txt
> > +++ b/Documentation/DMA-API.txt
> > @@ -494,7 +494,7 @@ portable API) the following facilities are provided.
> >  Actually, instead of describing the macros one by one, we'll
> >  transform some example code.
> >  
> > -1) Use DECLARE_DMA_UNMAP_{ADDR,LEN} in state saving structures.
> > +1) Use DEFINE_DMA_UNMAP_{ADDR,LEN} in state saving structures.
> >     Example, before:
> >  
> >  	struct ring_state {
> > @@ -507,12 +507,10 @@ transform some example code.
> >  
> >  	struct ring_state {
> >  		struct sk_buff *skb;
> > -		DECLARE_DMA_UNMAP_ADDR(mapping)
> > -		DECLARE_DMA_UNMAP_LEN(len)
> > +		DEFINE_DMA_UNMAP_ADDR(mapping);
> > +		DEFINE_DMA_UNMAP_LEN(len);
> >  	};
> >  
> > -NOTE: DO NOT put a semicolon at the end of the DECLARE_*() macro.
> > -
> >  2) Use dma_unmap_{addr,len}_set to set these values.
> >     Example, before:
> >  
> > diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> > index 599d8e4..e00c5c9 100644
> > --- a/include/linux/dma-mapping.h
> > +++ b/include/linux/dma-mapping.h
> > @@ -241,15 +241,15 @@ struct dma_attrs;
> >  #endif /* CONFIG_HAVE_DMA_ATTRS */
> >  
> >  #ifdef CONFIG_NEED_DMA_MAP_STATE
> > -#define DECLARE_DMA_UNMAP_ADDR(ADDR_NAME)        dma_addr_t ADDR_NAME;
> > -#define DECLARE_DMA_UNMAP_LEN(LEN_NAME)          __u32 LEN_NAME;
> > +#define DEFINE_DMA_UNMAP_ADDR(ADDR_NAME)        dma_addr_t ADDR_NAME
> > +#define DEFINE_DMA_UNMAP_LEN(LEN_NAME)          __u32 LEN_NAME
> >  #define dma_unmap_addr(PTR, ADDR_NAME)           ((PTR)->ADDR_NAME)
> >  #define dma_unmap_addr_set(PTR, ADDR_NAME, VAL)  (((PTR)->ADDR_NAME) = (VAL))
> >  #define dma_unmap_len(PTR, LEN_NAME)             ((PTR)->LEN_NAME)
> >  #define dma_unmap_len_set(PTR, LEN_NAME, VAL)    (((PTR)->LEN_NAME) = (VAL))
> >  #else
> > -#define DECLARE_DMA_MAP_ADDR(ADDR_NAME)
> > -#define DECLARE_DMA_UNMAP_LEN(LEN_NAME)
> > +#define DEFINE_DMA_MAP_ADDR(ADDR_NAME)
> > +#define DEFINE_DMA_UNMAP_LEN(LEN_NAME)
> >  #define dma_unmap_addr(PTR, ADDR_NAME)           (0)
> >  #define dma_unmap_addr_set(PTR, ADDR_NAME, VAL)  do { } while (0)
> >  #define dma_unmap_len(PTR, LEN_NAME)             (0)
> > diff --git a/include/linux/pci-dma.h b/include/linux/pci-dma.h
> > index 235a61e..549a041 100644
> > --- a/include/linux/pci-dma.h
> > +++ b/include/linux/pci-dma.h
> > @@ -1,11 +1,11 @@
> >  #ifndef _LINUX_PCI_DMA_H
> >  #define _LINUX_PCI_DMA_H
> >  
> > -#define DECLARE_PCI_UNMAP_ADDR    DECLARE_DMA_UNMAP_ADDR
> > -#define DECLARE_PCI_UNMAP_LEN     DECLARE_DMA_UNMAP_LEN
> > -#define pci_unmap_addr            dma_unmap_addr
> > -#define pci_unmap_addr_set        dma_unmap_addr_set
> > -#define pci_unmap_len             dma_unmap_len
> > -#define pci_unmap_len_set         dma_unmap_len_set
> > +#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME) DEFINE_DMA_UNMAP_ADDR(ADDR_NAME);
> > +#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)   DEFINE_DMA_UNMAP_LEN(LEN_NAME);
> > +#define pci_unmap_addr             dma_unmap_addr
> > +#define pci_unmap_addr_set         dma_unmap_addr_set
> > +#define pci_unmap_len              dma_unmap_len
> > +#define pci_unmap_len_set          dma_unmap_len_set
> >  
> >  #endif
> 
> 
> -- 
> ~Randy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
