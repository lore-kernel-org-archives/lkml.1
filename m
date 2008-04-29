Return-Path: <linux-kernel-owner+w=401wt.eu-S1763224AbYD2NP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763224AbYD2NP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757540AbYD2NPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:15:37 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:30149 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756261AbYD2NPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:15:36 -0400
To: Amit Shah <amit.shah@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, chrisw@redhat.com, allen.m.kay@intel.com,
       linux-kernel@vger.kernel.org, gcosta@redhat.com, avi@qumranet.com,
       virtualization@lists.linux-foundation.org, BENAMI@il.ibm.com
Subject: Re: [PATCH] x86 DMA: Handle devices assigned to the guest by the host
From: Andi Kleen <andi@firstfloor.org>
References: <1209465451-3758-1-git-send-email-amit.shah@qumranet.com>
	<1209465451-3758-2-git-send-email-amit.shah@qumranet.com>
Date: Tue, 29 Apr 2008 15:14:23 +0200
In-Reply-To: <1209465451-3758-2-git-send-email-amit.shah@qumranet.com> (Amit Shah's message of "Tue, 29 Apr 2008 13:37:29 +0300")
Message-ID: <87wsmghkgg.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Apr 2008 13:07:30.0678 (UTC) FILETIME=[FB384960:01C8A9F9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Shah <amit.shah@qumranet.com> writes:
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index 388b113..678cafb 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -443,6 +443,17 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
>  		memset(memory, 0, size);
>  		if (!mmu) {
>  			*dma_handle = bus;
> +			if (unlikely(dma_ops->is_pv_device) &&
> +			    unlikely(dma_ops->is_pv_device(dev, dev->bus_id))) {

First double unlikely in a condition is useless. Just drop them.

And then ->is_xyz() in a generic vops interface is about as ugly
and non generic as you can get. dma_alloc_coherent is not performance
critical, so you should rather change the interface that ->alloc_coherent
is always called and the other handlers handle the !mmu case correctly.
In fact they need that already I guess (e.g. on DMAR there is not really
a nommu case) 

-Andi

