Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbYGJEaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbYGJEaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 00:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYGJEaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 00:30:00 -0400
Received: from sh.osrg.net ([192.16.179.4]:47481 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbYGJE37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 00:29:59 -0400
Date: Thu, 10 Jul 2008 13:25:26 +0900
To: akpm@linux-foundation.org
Cc: joerg.roedel@amd.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 17/34] AMD IOMMU: add generic defines and structures
 for mapping code
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080709190140.ab662def.akpm@linux-foundation.org>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	<1214508490-29683-18-git-send-email-joerg.roedel@amd.com>
	<20080709190140.ab662def.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080710132508N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2008 19:01:40 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 26 Jun 2008 21:27:53 +0200 Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > This patch adds generic stuff used by the mapping and unmapping code for the
> > AMD IOMMU.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/kernel/amd_iommu.c |   40 ++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 40 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/x86/kernel/amd_iommu.c
> > 
> > diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> > new file mode 100644
> > index 0000000..90392c7
> > --- /dev/null
> > +++ b/arch/x86/kernel/amd_iommu.c
> > @@ -0,0 +1,40 @@
> > +/*
> > + * Copyright (C) 2007-2008 Advanced Micro Devices, Inc.
> > + * Author: Joerg Roedel <joerg.roedel@amd.com>
> > + *         Leo Duran <leo.duran@amd.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms of the GNU General Public License version 2 as published
> > + * by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
> > + */
> > +
> > +#include <linux/pci.h>
> > +#include <linux/gfp.h>
> > +#include <linux/bitops.h>
> > +#include <linux/scatterlist.h>
> > +#include <linux/iommu-helper.h>
> > +#include <asm/proto.h>
> > +#include <asm/gart.h>
> > +#include <asm/amd_iommu_types.h>
> > +
> > +#define CMD_SET_TYPE(cmd, t) ((cmd)->data[1] |= ((t) << 28))
> 
> Doesn't need to be implemented in a macro, hence should be implemented in C,
> please.
> 
> > +#define to_pages(addr, size) \
> > +	 (round_up(((addr) & ~PAGE_MASK) + (size), PAGE_SIZE) >> PAGE_SHIFT)
> 
> Does this patchset add any comments *at all*?  Is it really all so obvious
> that this was justifiable?
> 
> I don't know what this function does, but it shouldn't be doing it here. 
> Either it duplicates an existing helper or it should be implemented in mm.h

I think that this calculates the number of IOMMU pages for a
request. Every IOMMUs has a similar function so it might be better to
add a helper function to include/linux/iommu-helper.h.

Someone except for IOMMU need this? If so, it would be better to add
this to a different header file.


diff --git a/include/linux/iommu-helper.h b/include/linux/iommu-helper.h
index c975caf..9c29e65 100644
--- a/include/linux/iommu-helper.h
+++ b/include/linux/iommu-helper.h
@@ -8,3 +8,14 @@ extern unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
 				      unsigned long align_mask);
 extern void iommu_area_free(unsigned long *map, unsigned long start,
 			    unsigned int nr);
+
+static inline unsigned long iommu_num_pages(unsigned long addr,
+					    unsigned long len)
+{
+	unsigned long npages;
+
+	npages = ALIGN(addr + len, 1UL << IOMMU_PAGE_SHIFT) -
+		(addr & ~((1UL << IOMMU_PAGE_SHIFT) - 1));
+
+	return (npages >> IOMMU_PAGE_SHIFT);
+}
