Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbYLAThT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbYLAThT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 14:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYLAThG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 14:37:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54635 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529AbYLAThE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 14:37:04 -0500
Date: Mon, 1 Dec 2008 20:36:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joro@8bytes.org, tsbogend@alpha.franken.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Fix dma_mapping_error for 32bit x86
Message-ID: <20081201193656.GB17250@elte.hu>
References: <20081201125501.GC21534@elte.hu> <20081201230926Q.fujita.tomonori@lab.ntt.co.jp> <20081201143534.GB32565@elte.hu> <20081202021638K.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202021638K.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Mon, 1 Dec 2008 15:35:34 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > 
> > > On Mon, 1 Dec 2008 13:55:01 +0100
> > > Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > 
> > > > * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > > > 
> > > > > On Mon, 1 Dec 2008 12:34:51 +0100
> > > > > Joerg Roedel <joro@8bytes.org> wrote:
> > > > > 
> > > > > > On Sat, Nov 29, 2008 at 01:46:27PM +0100, Thomas Bogendoerfer wrote:
> > > > > > > Devices like b44 ethernet can't dma from addresses above 1GB. The driver
> > > > > > > handles this cases by falling back to GFP_DMA allocation. But for detecting
> > > > > > > the problem it needs to get an indication from dma_mapping_error.
> > > > > > > The bug is triggered by using a VMSPLIT option of 2G/2G.
> > > > > > 
> > > > > > Looks like your system uses swiotlb as the dma_ops backend. Its the only
> > > > > > implementation providing the ops->mapping_error callback and does not
> > > > > > use bad_dma_address as the error value.
> > > > > 
> > > > > I think that you misunderstand the problem.
> > > > > 
> > > > > He uses X86_32 so swiotlb should not be used (which is available on 
> > > > > only X86_64 and IA64 for now).
> > > > > 
> > > > > b44 needs an address under 1GB so it sets device->dma_mask to 
> > > > > DMA_30BIT_MASK. With VMSPLIT option of 2G/2G, I guess that b44 could 
> > > > > get addresses above 1GB from the networking subsystem. In such case, 
> > > > > nommu_map_single returns bad_dma_address properly, but on X86_32, 
> > > > > dma_mapping_error always returns 0 (success). So b44 wrongly thinks 
> > > > > that the address is under 1GB.
> > > > > 
> > > > > This patch fixes dma_mapping_error() to check a passed address
> > > > > properly (compares it with bad_dma_address).
> > > > > 
> > > > > As I already wrote, the current git needs a patch modified slightly:
> > > > > 
> > > > > http://marc.info/?l=linux-kernel&m=122797163405377&w=2
> > > > 
> > > > i have i queued up in x86/urgent, see below.
> > > 
> > > As I wrote, just removing #ifdef is better since:
> > > 
> > > 1) Xen people want swiotlb on X86_32. swiotlb uses ops->mapping_error
> > > so X86_32 also needs to check ops->mapping_error.
> > > 
> > > 2) Removing #ifdef hack is always good.
> > > 
> > > 
> > > But this patch fixes the bug and it works for now. And I think that 
> > > Thomas tested it. So it's fine to commit this patch by me.
> > 
> > yeah, i included the tested patch.
> > 
> > > I'll send a patch to remove the ifdef on the top of this patch after 
> > > this patch goes into mainline.
> > 
> > sure - or you can send it against tip/master straight away.
> 
> Ok, here you are.
> 
> Note that this is for 2.6.29 (not 2.6.28).

thanks, applied to tip/x86/iommu.

	Ingo
