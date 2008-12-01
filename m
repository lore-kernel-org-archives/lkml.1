Return-Path: <linux-kernel-owner+w=401wt.eu-S1753427AbYLAOLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbYLAOLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 09:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYLAOKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 09:10:52 -0500
Received: from sh.osrg.net ([192.16.179.4]:60064 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbYLAOKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 09:10:51 -0500
Date: Mon, 1 Dec 2008 23:10:33 +0900
To: joro@8bytes.org
Cc: fujita.tomonori@lab.ntt.co.jp, tsbogend@alpha.franken.de,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH v3] Fix dma_mapping_error for 32bit x86
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081201125852.GG26275@8bytes.org>
References: <20081201113451.GA24323@8bytes.org>
	<20081201210110L.fujita.tomonori@lab.ntt.co.jp>
	<20081201125852.GG26275@8bytes.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081201231008O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008 13:58:52 +0100
Joerg Roedel <joro@8bytes.org> wrote:

> On Mon, Dec 01, 2008 at 09:01:06PM +0900, FUJITA Tomonori wrote:
> > On Mon, 1 Dec 2008 12:34:51 +0100
> > Joerg Roedel <joro@8bytes.org> wrote:
> > 
> > > On Sat, Nov 29, 2008 at 01:46:27PM +0100, Thomas Bogendoerfer wrote:
> > > > Devices like b44 ethernet can't dma from addresses above 1GB. The driver
> > > > handles this cases by falling back to GFP_DMA allocation. But for detecting
> > > > the problem it needs to get an indication from dma_mapping_error.
> > > > The bug is triggered by using a VMSPLIT option of 2G/2G.
> > > 
> > > Looks like your system uses swiotlb as the dma_ops backend. Its the only
> > > implementation providing the ops->mapping_error callback and does not
> > > use bad_dma_address as the error value.
> > 
> > I think that you misunderstand the problem.
> > 
> > He uses X86_32 so swiotlb should not be used (which is available on only
> > X86_64 and IA64 for now).
> > 
> > b44 needs an address under 1GB so it sets device->dma_mask to
> > DMA_30BIT_MASK. With VMSPLIT option of 2G/2G, I guess that b44 could
> > get addresses above 1GB from the networking subsystem. In such case,
> > nommu_map_single returns bad_dma_address properly, but on X86_32,
> > dma_mapping_error always returns 0 (success). So b44 wrongly thinks
> > that the address is under 1GB.
> > 
> > This patch fixes dma_mapping_error() to check a passed address
> > properly (compares it with bad_dma_address).
> 
> Ah true, thanks. Anyway, the patch also solved the problem with swiotlb
> on 64bit.

Can you be specific?

swiotlb's dma_mapping_error on X86_64 doesn't have any problem as far
as I know.
