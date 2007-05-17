Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbXEQTT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbXEQTT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 15:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755874AbXEQTTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 15:19:19 -0400
Received: from viefep13-int.chello.at ([213.46.255.15]:52263 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755492AbXEQTTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 15:19:19 -0400
Subject: Re: [PATCH 0/5] make slab gfp fair
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Graf <tgraf@suug.ch>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <Pine.LNX.4.64.0705171101360.18085@schroedinger.engr.sgi.com>
References: <20070514131904.440041502@chello.nl>
	 <Pine.LNX.4.64.0705161957440.13458@schroedinger.engr.sgi.com>
	 <1179385718.27354.17.camel@twins>
	 <Pine.LNX.4.64.0705171027390.17245@schroedinger.engr.sgi.com>
	 <20070517175327.GX11115@waste.org>
	 <Pine.LNX.4.64.0705171101360.18085@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Thu, 17 May 2007 21:18:19 +0200
Message-Id: <1179429499.2925.26.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 11:02 -0700, Christoph Lameter wrote:
> On Thu, 17 May 2007, Matt Mackall wrote:
> 
> > Simply stated, the problem is sometimes it's impossible to free memory
> > without allocating more memory. Thus we must keep enough protected
> > reserve that we can guarantee progress. This is what mempools are for
> > in the regular I/O stack. Unfortunately, mempools are a bad match for
> > network I/O.
> > 
> > It's absolutely correct that performance doesn't matter in the case
> > this patch is addressing. All that matters is digging ourselves out of
> > OOM. The box either survives the crisis or it doesn't.
> 
> Well we fail allocations in order to do so and these allocations may be 
> even nonatomic allocs. Pretty dangerous approach.

These allocations didn't have right to the memory they would otherwise
get. Also they will end up in the page allocator just like they normally
would. So from that point, its no different than what happens now; only
they will not eat away the very last bit of memory that could be used to
avoid deadlocking.

> > It's also correct that we should hardly ever get into a situation
> > where we trigger this problem. But such cases are still fairly easy to
> > trigger in some workloads. Swap over network is an excellent example,
> > because we typically don't start swapping heavily until we're quite
> > low on freeable memory.
> 
> Is it not possible to avoid failing allocs? Instead put processes to 
> sleep? Run synchrononous reclaim?

That would radically change the way we do reclaim and would be much
harder to get right. Such things could be done independant from this.

The proposed patch doesn't change how the kernel functions at this
point; it just enforces an existing rule better.



