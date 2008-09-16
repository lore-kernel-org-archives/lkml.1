Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbYIPNj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbYIPNj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 09:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbYIPNjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 09:39:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51118 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbYIPNjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 09:39:18 -0400
Date: Tue, 16 Sep 2008 15:43:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: andi@firstfloor.org, mingo@elte.hu, joerg.roedel@amd.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] fix GART to respect device's dma_mask about virtual mappings
Message-ID: <20080916134335.GC25711@one.firstfloor.org>
References: <1221216155-17640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <87hc8grjuf.fsf@basil.nowhere.org> <20080916222032O.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080916222032O.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What the need_iommu() does is seeing if GART needs to do virtual
> mappings or not.
> 
> (After need_iommu() checking) What this patchset does is to guarantee
> that GART provides a virtual address that a device can access to.

Ah you care about masks < 32bit?

Those always are handled elsewhere in the block layer (using the bounce_pfn
mechanism) or in various other ways in other subsystems. e.g. on networking
the rule is that you just don't announce direct SG when you have 
less than 32bit mask. And the others like sound generally don't use 
map_sg()/map_single(), but instead pre allocate something with 
dma_alloc_coherent() or similar.

Also what would you do if it this check fails? There is no suitable
fallback path.

Can you describe a concrete use case your patch fixes? 

Anyways I'm aware the semantics are a little non untuitive (I didn't
invent them, but inherited them from other 64bit IOMMU implementations),
but fully general handling of < 32bit masks would be extremly complicated
because you would always need to have a full arbitary fallback
swiotlb implemention that is able to allocate arbitary low memory.

-Andi
