Return-Path: <linux-kernel-owner+w=401wt.eu-S1161311AbXCNOoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161311AbXCNOoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 10:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161325AbXCNOoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 10:44:39 -0400
Received: from holomorphy.com ([66.93.40.71]:47193 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161311AbXCNOoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 10:44:38 -0400
Date: Wed, 14 Mar 2007 07:43:58 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Pavel Emelianov <xemul@sw.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] kernel/pid.c pid allocation wierdness
Message-ID: <20070314144358.GS2986@holomorphy.com>
References: <45F7A4B3.5040005@sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F7A4B3.5040005@sw.ru>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 10:30:59AM +0300, Pavel Emelianov wrote:
> I'm looking at how alloc_pid() works and can't understand
> one (simple/stupid) thing.
> It first kmem_cache_alloc()-s a strct pid, then calls
> alloc_pidmap() and at the end it taks a global pidmap_lock()
> to add new pid to hash.
> The question is - why does alloc_pidmap() use at least
> two atomic ops and potentially loop to find a zero bit
> in pidmap? Why not call alloc_pidmap() under pidmap_lock
> and find zero pid in pidmap w/o any loops and atomics?
> The same is for free_pid(). Do I miss something?

pidmap_lock protects the ->page elements of the pidmap array. The
bitmap is not protected by it. It was intended to be as lockless as
possible, so the lock there essentially stands in for a cmpxchg().

A loop of some kind is strictly necessary regardless; in this lockless
case concurrent bitmap updates can trigger looping. It's very important
that only O(1) operations happen under the lock. These operations are
installing freshly-allocated pidmap pages, inserting a struct pid into
a hashtable collision chain, and removing a struct pid from a hashtable
collision chain. Traversals of hashtable collision chains are lockless
as per RCU. In any event, the atomic bit operations allow purely
lockless bitmap updates as well as purely lockless bitmap reads.

Essentially the idioms you're noticing are all for SMP scalability; in
particular, pid allocation used to cause enormous stress on tasklist_lock
that would trigger NMI-based deadlock detectors. Backing out such
optimizations is tantamount to making the systems affected by that (i.e.
any with enough cpus) crash that way again.


-- wli
