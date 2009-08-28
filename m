Return-Path: <linux-kernel-owner+w=401wt.eu-S1752819AbZH1TXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbZH1TXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbZH1TW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:22:59 -0400
Received: from sous-sol.org ([216.99.217.87]:39941 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752158AbZH1TW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:22:58 -0400
Date: Fri, 28 Aug 2009 12:17:14 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yu Zhao <yu.zhao@intel.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, stable@kernel.org
Subject: [PATCH] SR-IOV: correct broken resource alignment calculations
Message-ID: <20090828191714.GI10360@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An SR-IOV capable device includes an SR-IOV PCIe capability which
describes the Virtual Function (VF) BAR requirements.  A typical SR-IOV
device can support multiple VFs whose BARs must be in a contiguous region,
effectively an array of VF BARs.  The BAR reports the size requirement
for a single VF.  We calculate the full range needed by simply multiplying
the VF BAR size with the number of possible VFs and create a resource
spanning the full range.

This all seems sane enough except it artificially inflates the alignment
requirement for the VF BAR.  The VF BAR need only be aligned to the size
of a single BAR not the contiguous range of VF BARs.  This can cause us
to fail to allocate resources for the BAR despite the fact that we
actually have enough space.

This patch adds a support for a new resource alignment type,
IORESOURCE_VSIZEALIGN, and allows struct resource to keep track of the
size requirements of a VF BAR which are smaller than the full resource
size.  This could also be done all within the PCI layer w/out bloating
struct resource or using the last available bit for alignment types.

Comments?

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Yu Zhao <yu.zhao@intel.com>
Cc: stable@kernel.org
---
 drivers/pci/iov.c      |   12 +++++++++++-
 include/linux/ioport.h |    6 ++++++
 kernel/resource.c      |    7 ++++++-
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index e3a8721..c860dc6 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -101,7 +101,9 @@ static int virtfn_add(struct pci_dev *dev, int id, int reset)
 		if (!res->parent)
 			continue;
 		virtfn->resource[i].name = pci_name(virtfn);
-		virtfn->resource[i].flags = res->flags;
+		/* single VF BAR with normal size/alignment */
+		virtfn->resource[i].flags = res->flags & ~IORESOURCE_VSIZEALIGN;
+		virtfn->resource[i].flags |= IORESOURCE_SIZEALIGN;
 		size = resource_size(res);
 		do_div(size, iov->total);
 		virtfn->resource[i].start = res->start + size * id;
@@ -468,6 +470,14 @@ found:
 			rc = -EIO;
 			goto failed;
 		}
+		/*
+		 * VF BAR need only be aligned to size of single BAR, not
+		 * whole contiguous range.  So keep vsize available for
+		 * alignment queries.
+		 */
+		res->flags &= ~IORESOURCE_SIZEALIGN;
+		res->flags |= IORESOURCE_VSIZEALIGN;
+		res->vend = res->end;
 		res->end = res->start + resource_size(res) * total - 1;
 		nres++;
 	}
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 786e7b8..cd30c66 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -18,6 +18,7 @@
 struct resource {
 	resource_size_t start;
 	resource_size_t end;
+	resource_size_t vend;
 	const char *name;
 	unsigned long flags;
 	struct resource *parent, *sibling, *child;
@@ -48,6 +49,7 @@ struct resource_list {
 
 #define IORESOURCE_SIZEALIGN	0x00020000	/* size indicates alignment */
 #define IORESOURCE_STARTALIGN	0x00040000	/* start field is alignment */
+#define IORESOURCE_VSIZEALIGN	0x00080000	/* vsize indicates alignment */
 
 #define IORESOURCE_MEM_64	0x00100000
 
@@ -130,6 +132,10 @@ static inline resource_size_t resource_size(struct resource *res)
 {
 	return res->end - res->start + 1;
 }
+static inline resource_size_t resource_vsize(struct resource *res)
+{
+	return res->vend - res->start + 1;
+}
 static inline unsigned long resource_type(struct resource *res)
 {
 	return res->flags & IORESOURCE_TYPE_BITS;
diff --git a/kernel/resource.c b/kernel/resource.c
index 78b0872..6e24295 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -569,11 +569,16 @@ EXPORT_SYMBOL(adjust_resource);
  */
 resource_size_t resource_alignment(struct resource *res)
 {
-	switch (res->flags & (IORESOURCE_SIZEALIGN | IORESOURCE_STARTALIGN)) {
+	unsigned long mask = (IORESOURCE_SIZEALIGN |
+			      IORESOURCE_STARTALIGN |
+			      IORESOURCE_VSIZEALIGN);
+	switch (res->flags & mask) {
 	case IORESOURCE_SIZEALIGN:
 		return resource_size(res);
 	case IORESOURCE_STARTALIGN:
 		return res->start;
+	case IORESOURCE_VSIZEALIGN:
+		return resource_vsize(res);
 	default:
 		return 0;
 	}
