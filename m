Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbYCHCh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbYCHCh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 21:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbYCHChv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 21:37:51 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55430 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754972AbYCHChv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 21:37:51 -0500
Date: Fri, 7 Mar 2008 18:37:28 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [8/13] Enable the mask allocator for x86
In-Reply-To: <20080307090718.A609E1B419C@basil.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0803071832500.12220@schroedinger.engr.sgi.com>
References: <200803071007.493903088@firstfloor.org>
 <20080307090718.A609E1B419C@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008, Andi Kleen wrote:

> - Disable old ZONE_DMA
> No fixed size ZONE_DMA now anymore. All existing users of __GFP_DMA rely 
> on the compat call to the maskable allocator in alloc/free_pages
> - Call maskable allocator initialization functions at boot
> - Add TRAD_DMA_MASK for the compat functions 
> - Remove dma_reserve call

This looks okay for the disabling part. But note that there are various 
uses of MAX_DMA_ADDRESS (sparsemem, bootmem allocator) that are currently 
suboptimal because they set a boundary at 16MB for allocation of 
potentially large operating system structures. That boundary continues to 
exist despite the removal of ZONE_DMA?

It would be better to remove ZONE_DMA32 instead and enlarge ZONE_DMA so 
that it can take over the role of ZONE_DMA. Set the boundary for 
MAX_DMA_ADDRESS to the boundary for ZONE_DMA32. Then the 
allocations for sparse and bootmem will be allocated above 4GB which 
leaves lots of the lower space available for 32 bit DMA capable devices.

Removal of ZONE_DMA32 would allow us to remove support for that zone from 
the kernel in general since x86_64 is the only user of that zone.

Trouble is likely that there are existing users that have the expectation 
of a 4GB boundary on ZONE_DMA32 and 16MB on ZONE_DMA (particularly old 
drivers). Could we not clean that up?


