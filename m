Return-Path: <linux-kernel-owner+w=401wt.eu-S934782AbYEVKks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934782AbYEVKks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 06:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbYEVKke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 06:40:34 -0400
Received: from mis011-1.exch011.intermedia.net ([64.78.21.128]:36865 "EHLO
	mis011-1.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753172AbYEVKkd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 06:40:33 -0400
From: Amit Shah <amit.shah@qumranet.com>
Organization: Qumranet Inc.
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2 -mm 0/2] x86: per-device dma_mapping_ops
Date: Thu, 22 May 2008 16:13:02 +0530
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, muli@il.ibm.com,
       alexisb@us.ibm.com, andi@firstfloor.org, kvm@vger.kernel.org,
       avi@qumranet.com
References: <1211178689-3507-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1211178689-3507-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200805221613.03686.amit.shah@qumranet.com>
X-OriginalArrivalTime: 22 May 2008 10:40:32.0237 (UTC) FILETIME=[428539D0:01C8BBF8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2008 12:01:27 FUJITA Tomonori wrote:
> This is an updated version of the patchset to add per-device
> dma_mapping_ops support for CONFIG_X86_64 like POWER architecture
> does:
>
> http://lkml.org/lkml/2008/5/13/36
>
> This is against 2.6.26-rc2-mm1 (the changes since the v1 are pretty
> trivial like dropping the change for v850 arch).
>
> This enables us to cleanly fix the Calgary IOMMU issue that some
> devices are not behind the IOMMU [1].
>
> I think that per-device dma_mapping_ops support would be also helpful
> for KVM people to support PCI passthrough but Andi thinks that this
> makes it difficult to support the PCI passthrough (see the above
> thread). So I CC'ed this to KVM camp. Comments are appreciated.

I think what's more useful is a chain with a properly defined order or 
hierarchy (based on what Muli suggested last time we discussed this

http://lkml.org/lkml/2007/11/12/44 )

The suggested order was (in calling order):
pvdma->hardare->nommu/swiotlb

The discussion in the thread pointed to above has details as to why.

> A pointer to dma_mapping_ops to struct dev_archdata is added. If the
> pointer is non NULL, DMA operations in asm/dma-mapping.h use it. If
> it's NULL, the system-wide dma_ops pointer is used as before.


> If it's useful for KVM people, I plan to implement a mechanism to
> register a hook called when a new pci (or dma capable) device is

OK; this sounds helpful. the hook can make a hypercall and confirm with the 
host kernel if the device in question is an assigned physical device. If yes, 
we replace the dma_ops. Though, the original intent of having stackable ops 
is that we might want to go through the swiotlb in the guest even for an 
assigned device if the guest dma addresses are not in the addressable range 
of the guest chipset.

> created (it works with hot plugging). It enables IOMMUs to set up an
> appropriate dma_mapping_ops per device.

>From what we've discussed so far, it looks like stackable dma ops will 
definitely be needed. Does this patchset provide something that stacking 
won't?

> [1] http://lkml.org/lkml/2008/5/8/423

Amit.
