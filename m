Return-Path: <linux-kernel-owner+w=401wt.eu-S1762151AbYCXStP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762151AbYCXStP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757570AbYCXStA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:49:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756560AbYCXStA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:49:00 -0400
Date: Mon, 24 Mar 2008 11:47:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Timur Tabi <timur@freescale.com>
Cc: yorksun@freescale.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, galak@kernel.crashing.org,
       linux-fbdev-devel@lists.sourceforge.net, a.p.zijlstra@chello.nl
Subject: Re: [PATCH 1/2 v2] Driver for Freescale 8610 and 5121 DIU
Message-Id: <20080324114740.337509d3.akpm@linux-foundation.org>
In-Reply-To: <47E7C05C.2000001@freescale.com>
References: <12059526271941-git-send-email-yorksun@freescale.com>
	<12059526274026-git-send-email-yorksun@freescale.com>
	<20080320152708.23c6c734.akpm@linux-foundation.org>
	<47E3DE6E.2050801@freescale.com>
	<20080321111228.95a7d9ab.akpm@linux-foundation.org>
	<47E7C05C.2000001@freescale.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2008 09:53:16 -0500
Timur Tabi <timur@freescale.com> wrote:

> Andrew Morton wrote:
> 
> >>> GFP_DMA implies GFP_ATOMIC, but it's appropriate for documentation purposes.
> >> So does that mean that "GFP_DMA | GFP_KERNEL" is always wrong?
> > 
> > No, that's OK too.  It's just that GFP_DMA|GFP_ATOMIC is a bit redundant
> > and misleading.  GFP_DMA is already atomic; the only effect of adding
> > GFP_ATOMIC to GFP_DMA is to add __GFP_HIGH.
> > 
> > Don't wory about it ;)
> 
> Well, maybe we don't want GFP_ATOMIC then, because I don't think we want
> __GFP_HIGH.  Looking at the code, it appears the __GFP_HIGH has nothing to do
> with HIGHMEM (which on PowerPC is the not 1-to-1 mapping memory from 0xF000000
> to 0xFFFFFFFF).  Further examination of the cools shows the __GFP_HIGH says to
> try access the "emergency pool", and I see this code snippet:
> 
> 	if (alloc_flags & ALLOC_HIGH)
> 		min -= min / 2;
> 
> I guess this means that we reduce the amount of memory that can be available in
> order for the allocate to succeed.
> 
> Considering that the amount of memory that we allocate is in the order of
> megabytes, and it really isn't that important, I would think that we don't want
> to touch the emergency pool.  Does that sound right?

yup.  The absence of __GFP_WAIT already causes the page allocator to try a
bit harder.  Adding __GFP_HIGH would make it try harder still.

You do need to be sure that the driver will robustly and correctly recover
from an allocation failure here.

