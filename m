Return-Path: <linux-kernel-owner+w=401wt.eu-S1762227AbYBEXLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762227AbYBEXLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756298AbYBEXK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:10:59 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43849 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756182AbYBEXK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:10:58 -0500
Date: Tue, 5 Feb 2008 15:10:52 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [PATCH] mmu notifiers #v5
In-Reply-To: <20080205222657.GG7441@v2.random>
Message-ID: <Pine.LNX.4.64.0802051504450.16261@schroedinger.engr.sgi.com>
References: <20080201120955.GX7185@v2.random>
 <Pine.LNX.4.64.0802011118060.18163@schroedinger.engr.sgi.com>
 <20080203021704.GC7185@v2.random> <Pine.LNX.4.64.0802041106370.9656@schroedinger.engr.sgi.com>
 <20080205052525.GD7441@v2.random> <Pine.LNX.4.64.0802042206200.6739@schroedinger.engr.sgi.com>
 <20080205180802.GE7441@v2.random> <Pine.LNX.4.64.0802051013440.11705@schroedinger.engr.sgi.com>
 <20080205205519.GF7441@v2.random> <Pine.LNX.4.64.0802051400200.14665@schroedinger.engr.sgi.com>
 <20080205222657.GG7441@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Andrea Arcangeli wrote:

> > You can avoid the page-pin and the pt lock completely by zapping the 
> > mappings at _start and then holding off new references until _end.
> 
> "holding off new references until _end" = per-range mutex less scalar
> and more expensive than the PT lock that has to be taken anyway.

You can of course setup a 2M granularity lock to get the same granularity 
as the pte lock. That would even work for the cases where you have to page 
pin now.

> > Maybe that is true for KVM but certainly not true for the GRU. The GRU is 
> > designed to manage several petabytes of memory that may be mapped by a 
> > series of Linux instances. If a process only maps a small chunk of 4 
> > Gigabytes then we already have to deal with 1 mio callbacks.
> 
> KVM is also going to map a lot of stuff, but mapping involves mmap,
> munmap/mremap/mprotect not. The size of mmap is irrelevant in both
> approaches. optimizing do_exit by making the tlb-miss runtime slower
> doesn't sound great to me and that's your patch does if you force GRU
> to use it.

The size of the mmap is relevant if you have to perform callbacks on 
every mapped page that involved take mmu specific locks. That seems to be 
the case with this approach.

Optimizing do_exit by taking a single lock to zap all external references 
instead of 1 mio callbacks somehow leads to slowdown?

