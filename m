Return-Path: <linux-kernel-owner+w=401wt.eu-S936351AbXHHATI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936351AbXHHATI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 20:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763161AbXHHASz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 20:18:55 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37202 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761801AbXHHASy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 20:18:54 -0400
Date: Tue, 7 Aug 2007 17:13:52 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 04/10] mm: slub: add knowledge of reserve pages
In-Reply-To: <20070806103658.603735000@chello.nl>
Message-ID: <Pine.LNX.4.64.0708071702560.4941@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl> <20070806103658.603735000@chello.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2007, Peter Zijlstra wrote:

> Restrict objects from reserve slabs (ALLOC_NO_WATERMARKS) to allocation
> contexts that are entitled to it.

Is this patch actually necessary?

If you are in an atomic context and bound to a cpu then a per cpu slab is 
assigned to you and no one else can take object aways from that process 
since nothing else can run on the cpu. The point of the patch is to avoid 
other processes draining objects right? So you do not need the 
modifications in that case.

If you are not in an atomic context and are preemptable or can switch 
allocation context then you can create another context in which reclaim 
could be run to remove some clean pages and get you more memory. Again no 
need for the patch.

I guess you may be limited in not being able to call into reclaim again 
because it is already running. Maybe that can be fixed? F.e. zone reclaim 
does that for the NUMA case. It simply scans for easily reclaimable pages.

We could guarantee easily reclaimable pages to exist in much larger 
numbers than the reserves of min_free_kbytes. So in a tight spot one could 
reclaim from those.

