Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbYLBUYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbYLBUYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbYLBUYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:24:21 -0500
Received: from 8bytes.org ([88.198.83.132]:55757 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbYLBUYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:24:21 -0500
Date: Tue, 2 Dec 2008 21:24:18 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH] x86: fix broken flushing in GART nofullflush path
Message-ID: <20081202202417.GM29705@8bytes.org>
References: <1228245363-14909-1-git-send-email-joerg.roedel@amd.com> <20081202192759.GD15342@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202192759.GD15342@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 08:27:59PM +0100, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > In the non-default nofullflush case the GART is only flushed when
> > next_bit wraps around. But it can happen that an unmap operation unmaps
> > memory which is behind the current next_bit location. If these addresses
> > are reused it may result in stale GART IO/TLB entries. Fix this by
> > setting the GART next_bit always behind an unmapped location.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/kernel/pci-gart_64.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> applied to tip/x86/iommu, thanks Joerg!
> 
> a stale iotlb should not cause any problems in this particular GART case, 
> right? It might be a security leak in a security-domain enforcing iotlb 
> case, but the GART is a DMA bouncing helper in essence. Can you see any 
> failure mode of this bug?

It can cause data corruption because the GART redirects the IO to a
wrong address because of a stale entry in its TLB. I found this bug
after I fixed the same issue in the AMD IOMMU code (commit 80be308d).

The reason this was not found earlier is that lazy flushing is not the
default in GART. But I didn't try to trigger the bug.

Joerg
