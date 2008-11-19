Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbYKSH66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbYKSH66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 02:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbYKSH6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 02:58:50 -0500
Received: from sh.osrg.net ([192.16.179.4]:51249 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbYKSH6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 02:58:50 -0500
Date: Wed, 19 Nov 2008 16:58:30 +0900
To: jens.axboe@oracle.com
Cc: leon.woestenberg@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       tj@kernel.org
Subject: Re: pci_map_sg() does not coalesce adjacent physical memory? x86
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081119155847U.fujita.tomonori@lab.ntt.co.jp>
References: <20081119142016E.fujita.tomonori@lab.ntt.co.jp>
	<c384c5ea0811182222l7f0e3131tc1cc20ffba5175c@mail.gmail.com>
	<20081119155847U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081119165915A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2008 15:58:12 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Wed, 19 Nov 2008 07:22:31 +0100
> "Leon Woestenberg" <leon.woestenberg@gmail.com> wrote:
> 
> > Hello,
> > 
> > On Wed, Nov 19, 2008 at 6:19 AM, FUJITA Tomonori
> > <fujita.tomonori@lab.ntt.co.jp> wrote:
> > > On Mon, 17 Nov 2008 19:15:32 -0800
> > >> > pci_map_sg() does not coalesce the scattergather list for me on x86.
> > >> [ Marked as Bogus Report ]
> > >>
> > >> > Is this expected? Documentation mentions that coalescing is typically
> > >> > done by pci_map_sg().
> > >
> > > Hm, what document did you read? We might need to fix it.
> > >
> > http://lxr.linux.no/linux+v2.6.27.6/Documentation/DMA-API.txt
> > 
> >  316        pci_map_sg(struct pci_dev *hwdev, struct scatterlist *sg,
> >  317                int nents, int direction)
> >  318
> >  319Maps a scatter gather list from the block layer.
> >  320
> >  321Returns: the number of physical segments mapped (this may be shorter
> >  322than <nents> passed in if the block layer determines that some
> >  323elements of the scatter/gather list are physically adjacent and thus
> >  324may be mapped with a single entry).
> 
> Hmm, the description looks confusing. The block layer coalesces
> physically adjacent entries before pci_map_sg(). pci_map_sg() could
> coalesces physically or virtually adjacent entries.

How about this?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] fix pci_map_sg/dma_map_sg scatterlists handling in DMA-API.txt

- pci_map_sg/dma_map_sg are used with a scatter gather list that
doesn't come from the block layer (e.g. some network drivers do).

- how IOMMUs merge adjacent elements of the scatter/gather list is
independent of how the block layer determines sees elements.


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 Documentation/DMA-API.txt |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index b8e8646..b462bb1 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -316,12 +316,10 @@ reduce current DMA mapping usage or delay and try again later).
 	pci_map_sg(struct pci_dev *hwdev, struct scatterlist *sg,
 		int nents, int direction)
 
-Maps a scatter gather list from the block layer.
-
 Returns: the number of physical segments mapped (this may be shorter
-than <nents> passed in if the block layer determines that some
-elements of the scatter/gather list are physically adjacent and thus
-may be mapped with a single entry).
+than <nents> passed in if some elements of the scatter/gather list are
+physically or virtually adjacent and an IOMMU maps them with a single
+entry).
 
 Please note that the sg cannot be mapped again if it has been mapped once.
 The mapping process is allowed to destroy information in the sg.
-- 
1.5.5.GIT

