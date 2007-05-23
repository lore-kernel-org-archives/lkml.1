Return-Path: <linux-kernel-owner+w=401wt.eu-S1760803AbXEWW6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760803AbXEWW6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 18:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756540AbXEWW6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 18:58:25 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2877 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981AbXEWW6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 18:58:24 -0400
Date: Wed, 23 May 2007 23:58:12 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Christoph Lameter <clameter@sgi.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: Define CONFIG_BOUNCE to avoid useless inclusion of bounce buffer logic.
Message-ID: <20070523225812.GE1976@flint.arm.linux.org.uk>
Mail-Followup-To: Christoph Lameter <clameter@sgi.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	jens.axboe@oracle.com
References: <Pine.LNX.4.64.0705212100420.24947@schroedinger.engr.sgi.com> <20070522133906.ae9c362a.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0705212225590.25388@schroedinger.engr.sgi.com> <20070523140702.GA16972@flint.arm.linux.org.uk> <Pine.LNX.4.64.0705231011000.19822@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705231011000.19822@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 10:15:10AM -0700, Christoph Lameter wrote:
> On Wed, 23 May 2007, Russell King wrote:
> 
> > > That is wrong. ppc should have ZONE_NORMAL and no ZONE_DMA.
> > > Otherwise you cannot switch off ZONE_DMA and you cannot switch off 
> > > bounce. ZONE_DMA is a zone for exceptional allocs. If you do not have 
> > > those then you only have normal allocs -> ZONE_NORMAL.
> > 
> > That sounds very wrong to me.  Since about 1995 ARM has always placed
> > all DMA-able memory in the DMA zone, and none in the normal zone.
> > 
> > The reason for doing this is that normal allocations fall back to DMA
> > allocations when the normal zone becomes full/empty.  However, DMA
> > allocations can never be satisfied by allocations from the normal zone.
> 
> Usually DMA is done via ZONE_NORMAL allocations. GFP_DMA allocs and 
> ZONE_DMA are for devices that cannot performa DMA to all of memory.
> 
> There is no need to fall back if you do not have such devices. So no need 
> for ZONE_DMA.

While that is true, that assertion does not hold everywhere.

> > Moreover, special casing the "doesn't use __GFP_DMA allocations on this
> > machine so places all memory in ZONE_NORMAL" is just too complicated -
> > I've no idea which of the 100+ ARM machine support currently merged
> > into the Linux kernel uses __GFP_DMA allocations and which don't.
> 
> GFP_DMA allocations are an exception and that exception can be removed 
> from the core VM by not defining ZONE_DMA. You cannot switch off the 
> NORMAL zone.

I'd like to be able to switch off the normal and highmem zones and leave
just the DMA zone behind.  The normal and highmem zones are just a waste
of space on ARM.

> > The DMA zone is for memory allocations _for_ _DMA_.  If all your memory
> > is DMA-able then it belongs in the DMA zone.
> 
> Nope. The DMA zone is for crappy DMA devices that can only use a portion 
> of memory.

I'm sorry, we're going to have to agree to disagree then.

As for your assertion that it's "crappy DMA devices" there are modern
PCI based platforms being produced by Marvell (which were designed by
Intel) which can only DMA from 64MB of memory, inspite of the PCI
device having full PCI busmastering capabilities.

At the end of the day, it is _far_ simpler from an architectural point
of view for memory to live in the DMA zone and disable the normal and
highmem zones than it is to selectively populate the normal zone
depending on whether device X is configured, and then also have to hack
around various drivers which decide they want to use __GFP_DMA because
of some antequated x86ism which doesn't apply on non-x86.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
