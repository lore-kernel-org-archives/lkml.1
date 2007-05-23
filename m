Return-Path: <linux-kernel-owner+w=401wt.eu-S933815AbXEWOH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933815AbXEWOH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 10:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756514AbXEWOHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 10:07:16 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3865 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397AbXEWOHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 10:07:14 -0400
Date: Wed, 23 May 2007 15:07:02 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Christoph Lameter <clameter@sgi.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: Define CONFIG_BOUNCE to avoid useless inclusion of bounce buffer logic.
Message-ID: <20070523140702.GA16972@flint.arm.linux.org.uk>
Mail-Followup-To: Christoph Lameter <clameter@sgi.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	jens.axboe@oracle.com
References: <Pine.LNX.4.64.0705212100420.24947@schroedinger.engr.sgi.com> <20070522133906.ae9c362a.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0705212225590.25388@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705212225590.25388@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 10:27:16PM -0700, Christoph Lameter wrote:
> On Tue, 22 May 2007, KAMEZAWA Hiroyuki wrote:
> 
> > > +config BOUNCE
> > > +	def_bool y
> > > +	depends on BLOCK && MMU && (ZONE_DMA || HIGHMEM)
> > > +
> > 
> > AFAIK, ppc has only ZONE_DMA and it never needs bounce.
> > Is this ok ?
> 
> That is wrong. ppc should have ZONE_NORMAL and no ZONE_DMA.
> Otherwise you cannot switch off ZONE_DMA and you cannot switch off 
> bounce. ZONE_DMA is a zone for exceptional allocs. If you do not have 
> those then you only have normal allocs -> ZONE_NORMAL.

That sounds very wrong to me.  Since about 1995 ARM has always placed
all DMA-able memory in the DMA zone, and none in the normal zone.

The reason for doing this is that normal allocations fall back to DMA
allocations when the normal zone becomes full/empty.  However, DMA
allocations can never be satisfied by allocations from the normal zone.

Moreover, special casing the "doesn't use __GFP_DMA allocations on this
machine so places all memory in ZONE_NORMAL" is just too complicated -
I've no idea which of the 100+ ARM machine support currently merged
into the Linux kernel uses __GFP_DMA allocations and which don't.

The DMA zone is for memory allocations _for_ _DMA_.  If all your memory
is DMA-able then it belongs in the DMA zone.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
