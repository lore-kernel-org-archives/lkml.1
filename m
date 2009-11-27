Return-Path: <linux-kernel-owner+w=401wt.eu-S1751853AbZK0RXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbZK0RXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 12:23:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbZK0RXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 12:23:04 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:51641 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbZK0RXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 12:23:03 -0500
Date: Fri, 27 Nov 2009 11:22:36 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Peter Zijlstra <peterz@infradead.org>,
       David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>,
       paulmck@linux.vnet.ibm.com, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: lockdep complaints in slab allocator
In-Reply-To: <4B0CDBDE.8090307@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.0911271116100.20368@router.home>
References: <84144f020911192249l6c7fa495t1a05294c8f5b6ac8@mail.gmail.com>  <1258709153.11284.429.camel@laptop>  <84144f020911200238w3d3ecb38k92ca595beee31de5@mail.gmail.com>  <1258714328.11284.522.camel@laptop> <4B067816.6070304@cs.helsinki.fi> 
 <1258729748.4104.223.camel@laptop> <1259002800.5630.1.camel@penberg-laptop>  <1259003425.17871.328.camel@calx> <4B0ADEF5.9040001@cs.helsinki.fi>  <1259080406.4531.1645.camel@laptop>  <20091124170032.GC6831@linux.vnet.ibm.com>  <1259082756.17871.607.camel@calx>
 <1259086459.4531.1752.camel@laptop>  <1259090615.17871.696.camel@calx>  <1259095580.4531.1788.camel@laptop>  <1259096004.17871.716.camel@calx> <1259096519.4531.1809.camel@laptop>  <alpine.DEB.2.00.0911241302370.6593@chino.kir.corp.google.com> 
 <1259097150.4531.1822.camel@laptop>  <alpine.DEB.2.00.0911241313220.12339@chino.kir.corp.google.com> <1259098552.4531.1857.camel@laptop> <4B0CDBDE.8090307@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009, Pekka Enberg wrote:

> SLUB is good for NUMA, SLAB is pretty much a disaster with it's alien
> tentacles^Hcaches. AFAIK, SLQB hasn't received much NUMA attention so it's not
> obvious whether or not it will be able to perform as well as SLUB or not.
>
> The biggest problem with SLUB is that most of the people (excluding Christoph
> and myself) seem to think the design is unfixable for their favorite workload
> so they prefer to either stay with SLAB or work on SLQB.

The current design of each has its own strength and its weaknesses. A
queued design is not good for HPC and financial apps since it requires
periodic queue cleaning (therefore disturbing a latency critical
application path). Queue processing can go out of hand if there are
many different types of memory (SLAB in NUMA configurations). So a
queueless allocator design is good for some configurations. It is also
beneficial if the allocator must be frugal with memory allocations.

There is not much difference for most workloads in terms of memory
consumption between SLOB and SLUB.

> I really couldn't care less which allocator we end up with as long as it's not
> SLAB. I do think putting more performance tuning effort into SLUB would give
> best results because the allocator is pretty rock solid at this point. People
> seem underestimate the total effort needed to make a slab allocator good
> enough for the general public (which is why I think SLQB still has a long way
> to go).

There are still patches queued here for SLUB that depend on other per cpu
work to be merged in .33. These do not address the caching issues that
people focus on for networking and enterprise apps but they decrease the
minimum latency important for HPC and financial apps. The SLUB fastpath is
the lowest latency allocation path that exists.
