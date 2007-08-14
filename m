Return-Path: <linux-kernel-owner+w=401wt.eu-S934310AbXHNWUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934310AbXHNWUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbXHNWHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:07:17 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37443 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755738AbXHNWHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:07:12 -0400
Date: Tue, 14 Aug 2007 15:07:10 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/9] Atomic reclaim: Save irq flags in vmscan.c
In-Reply-To: <20070814215659.GF23308@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0708141504350.32420@schroedinger.engr.sgi.com>
References: <20070814203329.GA22202@one.firstfloor.org>
 <Pine.LNX.4.64.0708141341120.31513@schroedinger.engr.sgi.com>
 <20070814204454.GC22202@one.firstfloor.org>
 <Pine.LNX.4.64.0708141414260.31693@schroedinger.engr.sgi.com>
 <20070814212355.GA23308@one.firstfloor.org>
 <Pine.LNX.4.64.0708141425000.31693@schroedinger.engr.sgi.com>
 <20070814212955.GC23308@one.firstfloor.org>
 <Pine.LNX.4.64.0708141436380.31693@schroedinger.engr.sgi.com>
 <20070814214430.GD23308@one.firstfloor.org>
 <Pine.LNX.4.64.0708141444590.32110@schroedinger.engr.sgi.com>
 <20070814215659.GF23308@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Andi Kleen wrote:

> > Could you be a bit more specific? Where do you want to place the data?
> 
> DEFINE_PER_CPU(int, zone_flag);
> 
> 	get_cpu();	// likely already true and then not needed
> 	__get_cpu(zone_flag) = 1;
> 	/* wmb is implied in spin_lock I think */

No its not. Only on x64 which has implicit write ordering.

> 	spin_lock(&zone->lru_lock);
> 	...
> 	spin_unlock(&zone->lru_lock);
> 	__get_cpu(zone_flag) = 0;
> 	put_cpu();
> 
> Interrupt handler
> 
> 	if (!__get_cpu(zone_flag)) {

There are more spinlocks needed. So we would just check the whole bunch 
and fail if any of them are used?

> 		do things with zone locks 
> 	}
> 
> The interrupt handler shouldn't touch zone_flag. If it wants
> to it would need to be converted to a local_t and incremented/decremented
> (should be about the same cost at least on architectures with sane
> local_t implementation) 

That would mean we need to fork the code for reclaim?
