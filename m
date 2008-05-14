Return-Path: <linux-kernel-owner+w=401wt.eu-S1761307AbYENR37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761307AbYENR37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbYENR3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:29:48 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53360 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753255AbYENR3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:29:47 -0400
Date: Wed, 14 May 2008 10:29:41 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       mpm@selenic.com, Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
In-Reply-To: <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com>
References: <20080510030831.796641881@sgi.com>  <20080510030919.604216074@sgi.com>
 <4825709A.2020407@firstfloor.org>  <20080510221515.3540a6cc@bree.surriel.com>
  <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com>
 <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2008, Pekka Enberg wrote:

> Christoph fixed a tbench regression that was in the same ballpark as
> the TPC regression reported by Matthew which is why we've asked the
> Intel folks to re-test. But yeah, we're working on it.

I suspect that the TPC regression was due to the page allocator order 0 
inefficiencies like the tbench regression but we have no data yet to 
establish that.

Fundamentally there is no way to avoid complex queueing on free() unless 
one directly frees the object. This is serialized in SLUB by taking a page 
lock. If we can establish that the object is from the current cpu slab 
then no lock is taken because the slab is reserved for the current 
processor. So the bad case is a free of a object with a long life span or 
an object freed on a remote processor.

Howver, the "slow" case in SLUB is still much less complex 
than comparable processing in SLAB. It is quite fast.

SLAB freeing can avoid taking a lock if

1. We can establish that the object is node local (trivial if !NUMA 
otherwise we need to get the node information from the page struct and 
compare to the current node).

2. There is space in the per cpu queue

If the object is *not* node local then we have to take an alien lock for 
the remote node in order to put the object in an alien queue. That is much 
less efficient than the SLUB case. SLAB then needs to run the cache reaper 
to expire these object into the remote nodes queues (later the cache 
reaper may then actually free these objects). This management overhead 
does not exist in SLUB. The cache reaper causes processors to not be 
available for short time frames (the reaper scans through all slab 
caches!) which in turn cause regression in applications that need to 
respond in a short time frame (HPC appls, network applications that are 
timing critical).

Note that the lock granularity in SLUB is finer than the locks in SLAB. 
SLUB can concurrently free multiple objects to the same remote node etc 
etc. If the objects belong to different slabs then there is no dirtying of 
any shared cachelines.

The main issue for SLAB vs. SLUB on free is likely the !NUMA case in which 
SLAB can avoid the overhead of the node check (which does not exist in 
SLUB) and in which case we can always immediately batch the object (if 
there is space). The additional overhead in SLUB is mainly one 
atomic instruction over the SLAB fastpath.

So I think that the free need to  stay as is. The disadvantages in terms 
of the complexity of handling the objects and expiring them and the issue 
of having to take per node locks in SLAB makes it hard to justify adding a 
queue for free in SLUB. Maybe someone has an inspiration on how to do this 
effective that is better than my attempts which always ultimately ended 
implementing code that thad the same issues that we have in SLAB.
