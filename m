Return-Path: <linux-kernel-owner+w=401wt.eu-S933410AbXHNWOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410AbXHNWOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbXHNV5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:57:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55985 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935725AbXHNV5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:57:04 -0400
Date: Tue, 14 Aug 2007 23:56:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/9] Atomic reclaim: Save irq flags in vmscan.c
Message-ID: <20070814215659.GF23308@one.firstfloor.org>
References: <20070814203329.GA22202@one.firstfloor.org> <Pine.LNX.4.64.0708141341120.31513@schroedinger.engr.sgi.com> <20070814204454.GC22202@one.firstfloor.org> <Pine.LNX.4.64.0708141414260.31693@schroedinger.engr.sgi.com> <20070814212355.GA23308@one.firstfloor.org> <Pine.LNX.4.64.0708141425000.31693@schroedinger.engr.sgi.com> <20070814212955.GC23308@one.firstfloor.org> <Pine.LNX.4.64.0708141436380.31693@schroedinger.engr.sgi.com> <20070814214430.GD23308@one.firstfloor.org> <Pine.LNX.4.64.0708141444590.32110@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708141444590.32110@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 02:48:31PM -0700, Christoph Lameter wrote:
> On Tue, 14 Aug 2007, Andi Kleen wrote:
> 
> > > But that still creates lots of overhead each time we take the lru lock!
> > 
> > A lot of overhead in what way? Setting a flag in a cache hot
> > per CPU data variable shouldn't be more than a few cycles.
> 
> Could you be a bit more specific? Where do you want to place the data?

DEFINE_PER_CPU(int, zone_flag);

	get_cpu();	// likely already true and then not needed
	__get_cpu(zone_flag) = 1;
	/* wmb is implied in spin_lock I think */
	spin_lock(&zone->lru_lock);
	...
	spin_unlock(&zone->lru_lock);
	__get_cpu(zone_flag) = 0;
	put_cpu();

Interrupt handler

	if (!__get_cpu(zone_flag)) {
		do things with zone locks 
	}

The interrupt handler shouldn't touch zone_flag. If it wants
to it would need to be converted to a local_t and incremented/decremented
(should be about the same cost at least on architectures with sane
local_t implementation) 
		
-Andi

