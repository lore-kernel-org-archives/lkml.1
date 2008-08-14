Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbYHNA4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbYHNA4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 20:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbYHNAzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 20:55:49 -0400
Received: from sh.osrg.net ([192.16.179.4]:47081 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbYHNAzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 20:55:48 -0400
Date: Thu, 14 Aug 2008 09:55:22 +0900
To: stefanr@s5r6.in-berlin.de
Cc: fujita.tomonori@lab.ntt.co.jp, grundler@google.com,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH update] ieee1394: sbp2: enforce s/g segment size limit
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <tkrat.a77de871a8213efc@s5r6.in-berlin.de>
References: <da824cf30808121004w1ea59dc9rd805e2ae4d9f47a7@mail.gmail.com>
	<20080813084514K.fujita.tomonori@lab.ntt.co.jp>
	<tkrat.a77de871a8213efc@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080814095549S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 12:19:59 +0200 (CEST)
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> On 13 Aug, FUJITA Tomonori wrote:
> > On Tue, 12 Aug 2008 10:04:14 -0700
> > "Grant Grundler" <grundler@google.com> wrote:
> > 
> >> On Sat, Aug 9, 2008 at 11:20 AM, Stefan Richter
> >> <stefanr@s5r6.in-berlin.de> wrote:
> >> >  drivers/ieee1394/sbp2.c |  106 +++++++++++++---------------------------
> >> >  drivers/ieee1394/sbp2.h |   37 +++++--------
> >> >  2 files changed, 52 insertions(+), 91 deletions(-)
> >> ...
> >> > +               for_each_sg(sg, sg, sg_count, i) {
> >> > +                       len = sg_dma_len(sg);
> >> > +                       if (len == 0)
> >> > +                               continue;
> >> >
> >> > -               orb->misc |= ORB_SET_DATA_SIZE(sg_count);
> >> > +                       pt[j].high = cpu_to_be32(len << 16);
> >> > +                       pt[j].low = cpu_to_be32(sg_dma_address(sg));
> >> > +                       j++;
> >> > +               }
> >> 
> >> While this code will probably work correctly, I believe if the
> >> sg_dma_len() returns 0, one has walked off the end of the
> >> "bus address" list.
> >>
> >> pci_map_sg() returns how many DMA addr/len pairs are used
> >> and that count could (should?) be used when pulling the
> >> dma_len/addr pairs out of the sg list.
> > 
> > Yeah, from a quick look, seems that this patch wrongly handles
> > sg_count.
> > 
> > This patch sets scsi_sg_count(sc) to sg_count, right?
> 
> Well, I keep the original scsi_sg_count to call dma_unmap_sg with it
> later.

You need to keep it? You can access to it via scsi_sg_count when
calling dma_unmap_sg? Seems that firewire code does.


> According to Corbet/ Rubini/ Kroah-Hartman: LDD3, dma_unmap_sg
> is to be called with the number of s/g elements before DMA-mapping.

Are you talking about?

=
To unmap a scatterlist, just call:

	pci_unmap_sg(pdev, sglist, nents, direction);

Again, make sure DMA activity has already finished.

PLEASE NOTE:  The 'nents' argument to the pci_unmap_sg call must be
              the _same_ one you passed into the pci_map_sg call,
	      it should _NOT_ be the 'count' value _returned_ from the
              pci_map_sg call.


This is from Documentation/DMA-mapping.txt


> From a quick look at some dma_unmap_sg implementations, this seems still
> to be the case; or it doesn't actually matter.

I think that all the IOMMUs are fine even if you call dma_unmap_sg
with a 'nents' value that dma_map_sg returned. But, well, it's against
the rule.
