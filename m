Return-Path: <linux-kernel-owner+w=401wt.eu-S1759985AbXGJIRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbXGJIRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 04:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbXGJIRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 04:17:40 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50535 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297AbXGJIRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 04:17:38 -0400
Date: Tue, 10 Jul 2007 11:17:36 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <clameter@sgi.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Matt Mackall <mpm@selenic.com>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
In-Reply-To: <Pine.LNX.4.64.0707090907010.13970@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0707101049230.23040@sbz-30.cs.Helsinki.FI>
References: <20070708034952.022985379@sgi.com>  <20070708035018.074510057@sgi.com>
 <20070708075119.GA16631@elte.hu>  <20070708110224.9cd9df5b.akpm@linux-foundation.org>
  <4691A415.6040208@yahoo.com.au> <84144f020707090404l657a62c7x89d7d06b3dd6c34b@mail.gmail.com>
 <Pine.LNX.4.64.0707090907010.13970@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Mon, 9 Jul 2007, Pekka Enberg wrote:
> > I assume with "slab external fragmentation" you mean allocating a
> > whole page for a slab when there are not enough objects to fill the
> > whole thing thus wasting memory? We could try to combat that by
> > packing multiple variable-sized slabs within a single page. Also,
> > adding some non-power-of-two kmalloc caches might help with internal
> > fragmentation.

On Mon, 9 Jul 2007, Christoph Lameter wrote:
> Ther are already non-power-of-two kmalloc caches for 96 and 192 bytes 
> sizes.

I know that, but for my setup at least, there seems to be a need for a 
non-power of two cache between 512 and 1024. What I am seeing is average 
allocation size for kmalloc-512 being around 270-280 which wastes total 
of 10 KB of memory due to internal fragmentation. Might be a buggy caller 
that can be fixed with its own cache too.

On Mon, 9 Jul 2007, Pekka Enberg wrote:
> > In any case, SLUB needs some serious tuning for smaller machines
> > before we can get rid of SLOB.

On Mon, 9 Jul 2007, Christoph Lameter wrote:
> Switch off CONFIG_SLUB_DEBUG to get memory savings.

Curious, /proc/meminfo immediately after boot shows:

SLUB (debugging enabled):

(none):~# cat /proc/meminfo 
MemTotal:        30260 kB
MemFree:         22096 kB

SLUB (debugging disabled):

(none):~# cat /proc/meminfo 
MemTotal:        30276 kB
MemFree:         22244 kB

SLOB:

(none):~# cat /proc/meminfo 
MemTotal:        30280 kB
MemFree:         22004 kB

That's 92 KB advantage for SLUB with debugging enabled and 240 KB when 
debugging is disabled.

Nick, Matt, care to retest SLUB and SLOB for your setups?

				Pekka
