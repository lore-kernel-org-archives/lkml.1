Return-Path: <linux-kernel-owner+w=401wt.eu-S1757508AbZAWUP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbZAWUP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 15:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbZAWUPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 15:15:50 -0500
Received: from waste.org ([66.93.16.53]:49002 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011AbZAWUPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 15:15:49 -0500
Subject: Re: [PATCH] SLUB: revert direct page allocator pass through
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, yanmin_zhang@linux.intel.com,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <alpine.DEB.1.10.0901230955470.13690@qirst.com>
References: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI>
	 <200901231952.53961.nickpiggin@yahoo.com.au>
	 <alpine.DEB.1.10.0901230955470.13690@qirst.com>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 14:12:50 -0600
Message-Id: <1232741570.5202.498.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-23 at 10:03 -0500, Christoph Lameter wrote:
> On Fri, 23 Jan 2009, Nick Piggin wrote:
> 
> > Hmm, it lists quite a number of advantages that I guess are being
> > reverted too? What was the test case(s) that prompted this commit
> > in the first place? Better ensure it doesn't slow down...
> 
> The advantage was mainly memory savings and abilty to redefined kmallocs
> to go directly to the page allocator. Totally avoids slab allocator overhead.
> 
> I thought higher order allocations were not supposed to be used in
> performance critical paths? Didnt you want to do everything with order-0
> allocs?
> 
> It seems that we currently need the slab allocators to compensate for the
> performance problems in the page allocator for these higher order allocs.
> I'd rather have the page allocator fixed but things are as they are.

I still think we should experiment with changing the hierarchy:

Rename all the core get_free_page* functions to buddy_*

Make SL*B call into buddy_* with a default order of N (>=0)

Replace the old get_free_page* functions with simple wrappers that
call into SL*B for order <= N or buddy_* for order >= N

This tackles several problems at once:

- fragmentation of SL*B due to small pages
- poor performance of get_free_pages moderate orders
- poor cache-locality for get_free_pages

-- 
http://selenic.com : development and support for Mercurial and Linux


