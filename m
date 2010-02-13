Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367Ab0BMGON (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 01:14:13 -0500
Received: from sh.osrg.net ([192.16.179.4]:50712 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab0BMGOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 01:14:11 -0500
Date: Sat, 13 Feb 2010 15:13:50 +0900
To: akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       James.Bottomley@suse.de, davem@davemloft.net, jbarnes@virtuousgeek.org,
       arnd@arndb.de
Subject: Re: [PATCH -mm] dma-mapping.h: add the dma_unmap state API
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100212204405.a7f45db3.akpm@linux-foundation.org>
References: <20100212115157.02124608.akpm@linux-foundation.org>
	<20100213114842D.fujita.tomonori@lab.ntt.co.jp>
	<20100212204405.a7f45db3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100213151255Q.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 13 Feb 2010 15:13:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010 20:44:05 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 13 Feb 2010 11:49:09 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > On Fri, 12 Feb 2010 11:51:57 -0800
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > > -#ifdef CONFIG_NEED_DMA_MAP_STATE
> > > > -#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)        dma_addr_t ADDR_NAME;
> > > > -#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)          __u32 LEN_NAME;
> > > 
> > > But we already screwed up the semicolon thing.  If you grep the tree you'll
> > > see that about half of the users of this macro added their own semicolon:
> > 
> > Yeah, I know. PCI-DMA-mapping.txt says:
> > 
> > NOTE: DO NOT put a semicolon at the end of the DECLARE_*() macro.
> > 
> > 
> > But there are some other DECLARE_ macros that don't have the
> > semicolons so users could be easily confused.
> 
> yup.  Users already got confused.
> 
> > #define DEFINE_DMA_MAP_ADDR(ADDR_NAME) dma_addr_t ADDR_NAME
> > 
> > looks better?
> 
> yes.  People expect to have to put the semicolon in there, so they do.

Ok, how about this instead of the previous patch?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH -mm v2] dma-mapping.h: add the dma_unmap state API

Adds the following macros:

DEFINE_DMA_UNMAP_ADDR(ADDR_NAME)
DEFINE_DMA_UNMAP_LEN(LEN_NAME)
dma_unmap_addr(PTR, ADDR_NAME)
dma_unmap_addr_set(PTR, ADDR_NAME, VAL)
dma_unmap_len(PTR, LEN_NAME)
dma_unmap_len_set(PTR, LEN_NAME, VAL)

The API corresponds to the pci_unmap state API. We'll move to this new
generic API from the PCI specific API in the long term. As
include/asm-generic/pci-dma-compat.h does, the pci_unmap API simply
calls the new generic API for some time.

Note that DEFINE_DMA_UNMAP_ADDR and DEFINE_DMA_UNMAP_LEN are slightly
different from DECLARE_PCI_UNMAP_ADDR and
DECLARE_PCI_UNMAP_LEN. Unlike DECLARE_PCI_UNMAP_ADDR and
DECLARE_PCI_UNMAP_LEN, DEFINE_DMA_UNMAP_ADDR and DEFINE_DMA_UNMAP_LEN
need a semicolon at the end of the macros. It looks more
straightforward.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@suse.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 Documentation/DMA-API.txt   |   58 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/dma-mapping.h |   16 ++++++++++++
 include/linux/pci-dma.h     |   21 ++++-----------
 3 files changed, 80 insertions(+), 15 deletions(-)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index db20b37..0fc5728 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -482,6 +482,64 @@ void whizco_dma_map_sg_attrs(struct device *dev, dma_addr_t dma_addr,
 	....
 
 
+Part Ie - Optimizing Unmap State Space Consumption
+--------------------------------
+
+On some platforms, dma_unmap_{single,page}() is simply a nop.
+Therefore, keeping track of the mapping address and length is a waste
+of space. Instead of filling your drivers up with ifdefs and the like
+to "work around" this (which would defeat the whole purpose of a
+portable API) the following facilities are provided.
+
+Actually, instead of describing the macros one by one, we'll
+transform some example code.
+
+1) Use DEFINE_DMA_UNMAP_{ADDR,LEN} in state saving structures.
+   Example, before:
+
+	struct ring_state {
+		struct sk_buff *skb;
+		dma_addr_t mapping;
+		__u32 len;
+	};
+
+   after:
+
+	struct ring_state {
+		struct sk_buff *skb;
+		DEFINE_DMA_UNMAP_ADDR(mapping);
+		DEFINE_DMA_UNMAP_LEN(len);
+	};
+
+2) Use dma_unmap_{addr,len}_set to set these values.
+   Example, before:
+
+	ringp->mapping = FOO;
+	ringp->len = BAR;
+
+   after:
+
+	dma_unmap_addr_set(ringp, mapping, FOO);
+	dma_unmap_len_set(ringp, len, BAR);
+
+3) Use dma_unmap_{addr,len} to access these values.
+   Example, before:
+
+	dma_unmap_single(dev, ringp->mapping, ringp->len,
+			 DMA_FROM_DEVICE);
+
+   after:
+
+	dma_unmap_single(dev,
+			 dma_unmap_addr(ringp, mapping),
+			 dma_unmap_len(ringp, len),
+			 DMA_FROM_DEVICE);
+
+It really should be self-explanatory.  We treat the ADDR and LEN
+separately, because it is possible for an implementation to only
+need the address in order to perform the unmap operation.
+
+
 Part II - Advanced dma_ usage
 -----------------------------
 
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 8357721..e00c5c9 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -240,4 +240,20 @@ struct dma_attrs;
 
 #endif /* CONFIG_HAVE_DMA_ATTRS */
 
+#ifdef CONFIG_NEED_DMA_MAP_STATE
+#define DEFINE_DMA_UNMAP_ADDR(ADDR_NAME)        dma_addr_t ADDR_NAME
+#define DEFINE_DMA_UNMAP_LEN(LEN_NAME)          __u32 LEN_NAME
+#define dma_unmap_addr(PTR, ADDR_NAME)           ((PTR)->ADDR_NAME)
+#define dma_unmap_addr_set(PTR, ADDR_NAME, VAL)  (((PTR)->ADDR_NAME) = (VAL))
+#define dma_unmap_len(PTR, LEN_NAME)             ((PTR)->LEN_NAME)
+#define dma_unmap_len_set(PTR, LEN_NAME, VAL)    (((PTR)->LEN_NAME) = (VAL))
+#else
+#define DEFINE_DMA_MAP_ADDR(ADDR_NAME)
+#define DEFINE_DMA_UNMAP_LEN(LEN_NAME)
+#define dma_unmap_addr(PTR, ADDR_NAME)           (0)
+#define dma_unmap_addr_set(PTR, ADDR_NAME, VAL)  do { } while (0)
+#define dma_unmap_len(PTR, LEN_NAME)             (0)
+#define dma_unmap_len_set(PTR, LEN_NAME, VAL)    do { } while (0)
+#endif
+
 #endif
diff --git a/include/linux/pci-dma.h b/include/linux/pci-dma.h
index cfd63ab..549a041 100644
--- a/include/linux/pci-dma.h
+++ b/include/linux/pci-dma.h
@@ -1,20 +1,11 @@
 #ifndef _LINUX_PCI_DMA_H
 #define _LINUX_PCI_DMA_H
 
-#ifdef CONFIG_NEED_DMA_MAP_STATE
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)        dma_addr_t ADDR_NAME;
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)          __u32 LEN_NAME;
-#define pci_unmap_addr(PTR, ADDR_NAME)           ((PTR)->ADDR_NAME)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)  (((PTR)->ADDR_NAME) = (VAL))
-#define pci_unmap_len(PTR, LEN_NAME)             ((PTR)->LEN_NAME)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)    (((PTR)->LEN_NAME) = (VAL))
-#else
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)
-#define pci_unmap_addr(PTR, ADDR_NAME)           (0)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)  do { } while (0)
-#define pci_unmap_len(PTR, LEN_NAME)             (0)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)    do { } while (0)
-#endif
+#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME) DEFINE_DMA_UNMAP_ADDR(ADDR_NAME);
+#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)   DEFINE_DMA_UNMAP_LEN(LEN_NAME);
+#define pci_unmap_addr             dma_unmap_addr
+#define pci_unmap_addr_set         dma_unmap_addr_set
+#define pci_unmap_len              dma_unmap_len
+#define pci_unmap_len_set          dma_unmap_len_set
 
 #endif
-- 
1.5.6.5

