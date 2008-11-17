Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbYKQDtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbYKQDtx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 22:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756199AbYKQDtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 22:49:16 -0500
Received: from sh.osrg.net ([192.16.179.4]:50286 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756106AbYKQDtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 22:49:14 -0500
Date: Mon, 17 Nov 2008 12:48:53 +0900
To: jeremy@goop.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       x86@kernel.org, ian.campbell@citrix.com
Subject: Re: [PATCH 18 of 38] x86: unify pci iommu setup and allow swiotlb
 to	compile for 32 bit
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <e918eb1b71515e7c2f99.1226603416@abulafia.goop.org>
References: <patchbomb.1226603398@abulafia.goop.org>
	<e918eb1b71515e7c2f99.1226603416@abulafia.goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081117124857Z.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008 11:10:16 -0800
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> swiotlb on 32 bit will be used by Xen domain 0 support.

If you want swiotlb on 32 bit, you need more modifications, I think.

For example, the following code assumes that the mask needs to be
64 bits.

static void *
map_single(struct device *hwdev, char *buffer, size_t size, int dir)
{
	unsigned long flags;
	char *dma_addr;
	unsigned int nslots, stride, index, wrap;
	int i;
	unsigned long start_dma_addr;
	unsigned long mask;
	unsigned long offset_slots;
	unsigned long max_slots;

	mask = dma_get_seg_boundary(hwdev);
	start_dma_addr = virt_to_bus(io_tlb_start) & mask;

	offset_slots = ALIGN(start_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
	max_slots = mask + 1
		    ? ALIGN(mask + 1, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT
		    : 1UL << (BITS_PER_LONG - IO_TLB_SHIFT);

