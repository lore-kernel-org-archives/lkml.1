Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbYLAM7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbYLAM7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbYLAM6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:58:54 -0500
Received: from 8bytes.org ([88.198.83.132]:34268 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbYLAM6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:58:54 -0500
Date: Mon, 1 Dec 2008 13:58:52 +0100
From: Joerg Roedel <joro@8bytes.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tsbogend@alpha.franken.de, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH v3] Fix dma_mapping_error for 32bit x86
Message-ID: <20081201125852.GG26275@8bytes.org>
References: <20081129124627.F2ABDFA8C8@solo.franken.de> <20081201113451.GA24323@8bytes.org> <20081201210110L.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081201210110L.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 09:01:06PM +0900, FUJITA Tomonori wrote:
> On Mon, 1 Dec 2008 12:34:51 +0100
> Joerg Roedel <joro@8bytes.org> wrote:
> 
> > On Sat, Nov 29, 2008 at 01:46:27PM +0100, Thomas Bogendoerfer wrote:
> > > Devices like b44 ethernet can't dma from addresses above 1GB. The driver
> > > handles this cases by falling back to GFP_DMA allocation. But for detecting
> > > the problem it needs to get an indication from dma_mapping_error.
> > > The bug is triggered by using a VMSPLIT option of 2G/2G.
> > 
> > Looks like your system uses swiotlb as the dma_ops backend. Its the only
> > implementation providing the ops->mapping_error callback and does not
> > use bad_dma_address as the error value.
> 
> I think that you misunderstand the problem.
> 
> He uses X86_32 so swiotlb should not be used (which is available on only
> X86_64 and IA64 for now).
> 
> b44 needs an address under 1GB so it sets device->dma_mask to
> DMA_30BIT_MASK. With VMSPLIT option of 2G/2G, I guess that b44 could
> get addresses above 1GB from the networking subsystem. In such case,
> nommu_map_single returns bad_dma_address properly, but on X86_32,
> dma_mapping_error always returns 0 (success). So b44 wrongly thinks
> that the address is under 1GB.
> 
> This patch fixes dma_mapping_error() to check a passed address
> properly (compares it with bad_dma_address).

Ah true, thanks. Anyway, the patch also solved the problem with swiotlb
on 64bit.

Joerg
