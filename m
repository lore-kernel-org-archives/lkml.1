Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbXKMRBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbXKMRBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 12:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbXKMRA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 12:00:57 -0500
Received: from cantor.suse.de ([195.135.220.2]:48679 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754826AbXKMRA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 12:00:56 -0500
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: DMA descriptor alignment
From: Andi Kleen <andi@firstfloor.org>
References: <4737EF9C.4010207@lwfinger.net>
Date: Tue, 13 Nov 2007 18:00:54 +0100
In-Reply-To: <4737EF9C.4010207@lwfinger.net> (Larry Finger's message of "Mon\, 12 Nov 2007 00\:15\:56 -0600")
Message-ID: <p731wauyta1.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> For those variants of BCM43xx cards that use 64-bit DMA, there is a requirement that all descriptor
> rings must be aligned on an 8K boundary and must fit within an 8K page. On the x86_64 architecture
> where the page size is 4K, I was getting addresses like 0x67AF000 when using dma_alloc_coherent
> calls.

Normally x86-64 dma_alloc_coherent calls the buddy allocator which gives
you always naturally aligned blocks. But there is a fallback calling
into swiotlb and swiotlb uses best fit allocation which only guarantees
single page alignment. That is probably what you're seeing.

My dma zone rework would remove that fallback case and should make it work.

> From the description of the dma_pool_create and dma_pool_allocate routines, I thought they
> would fix my problems; however, even with a dma_pool_create(name, dev, 8192, 8192, 8192) call, I'm
> still getting 4K rather than 8K alignment, which results in DMA errors.

They cannot give you more alignment than the underlying allocator.

> Is there a bug in these routines, am I using them incorrectly, or do I have a misunderstanding of
> what it takes to get this kind of alignment?

My suggestion as a short term workaround would be to first allocate 
8K using dma_alloc_coherent and if that has the wrong alignment get 16K 
and align yourself. When the driver is loaded later that might be unreliable,
but near boot or with enough free memory using order 2 should usually work.
 
With the dma zone rework that could be removed later.

-Andi
