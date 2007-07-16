Return-Path: <linux-kernel-owner+w=401wt.eu-S933256AbXGPQuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256AbXGPQuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 12:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932923AbXGPQt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 12:49:58 -0400
Received: from waste.org ([66.93.16.53]:56220 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933100AbXGPQt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 12:49:57 -0400
Date: Mon, 16 Jul 2007 11:49:36 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] slob: reduce list scanning
Message-ID: <20070716164936.GW11115@waste.org>
References: <20070714055434.GQ11115@waste.org> <469B09AB.5010309@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469B09AB.5010309@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 04:01:15PM +1000, Nick Piggin wrote:
> Matt Mackall wrote:
> >The version of SLOB in -mm always scans its free list from the
> >beginning, which results in small allocations and free segments
> >clustering at the beginning of the list over time. This causes the
> >average search to scan over a large stretch at the beginning on each
> >allocation.
> >
> >By starting each page search where the last one left off, we evenly
> >distribute the allocations and greatly shorten the average search.
> >
> >Without this patch, kernel compiles on a 1.5G machine take a large
> >amount of system time for list scanning. With this patch, compiles are
> >within a few seconds of performance of a SLAB kernel with no notable
> >change in system time.
> 
> This looks pretty nice, and performance results sound good too.
> IMO this should probably be merged along with the previous
> SLOB patches, because they removed the cyclic scanning to begin
> with (so it may be possible that introduces a performnace
> regression in some situations).
> 
> I wonder what it would take to close the performance gap further.
> I still want to look at per-cpu freelists after Andrew merges
> this set of patches. That may improve both cache hotness and
> CPU scalability.

The idea I'm currently kicking around is having an array of spinlocks
and list heads per CPU and add an array index to the SLOB page struct.

To allocate, we loop over the array starting at the current CPU
looking for space. On failure, we add a page to the current CPU's
list. We can imagine several variants here: attempting to trylock
while scanning the list or doing no fallback at all. The first is
liable to be unhelpful if there's actually contention, the second will
consume more total memory but reduce the average scan time.

To free, we locate the list from the page struct so we can grab the
relevant lock.

This probably also ends up being very friendly to NUMA. But it's not
clear that it's worth doing for the common case of 2 cores, where
contention may be too low to be worth the extra trouble.

> Actually SLOB potentially has some fundamental CPU cache hotness
> advantages over the other allocators, for the same reasons as
> its space advantages. It may be possible to make some workloads
> faster with SLOB than with SLUB! Maybe we could remove SLAB and
> SLUB then :)

It's all handwaving until there are actually benchmarks.

-- 
Mathematics is the supreme nostalgia of our time.
