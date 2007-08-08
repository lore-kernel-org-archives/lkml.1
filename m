Return-Path: <linux-kernel-owner+w=401wt.eu-S935764AbXHHBpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935764AbXHHBpD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 21:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758194AbXHHBow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 21:44:52 -0400
Received: from waste.org ([66.93.16.53]:57636 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542AbXHHBov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 21:44:51 -0400
Date: Tue, 7 Aug 2007 20:44:36 -0500
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 04/10] mm: slub: add knowledge of reserve pages
Message-ID: <20070808014435.GG30556@waste.org>
References: <20070806102922.907530000@chello.nl> <20070806103658.603735000@chello.nl> <Pine.LNX.4.64.0708071702560.4941@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708071702560.4941@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 05:13:52PM -0700, Christoph Lameter wrote:
> On Mon, 6 Aug 2007, Peter Zijlstra wrote:
> 
> > Restrict objects from reserve slabs (ALLOC_NO_WATERMARKS) to allocation
> > contexts that are entitled to it.
> 
> Is this patch actually necessary?
>
 > If you are in an atomic context and bound to a cpu then a per cpu slab is 
> assigned to you and no one else can take object aways from that process 
> since nothing else can run on the cpu.

Servicing I/O over the network requires an allocation to send a buffer
and an allocation to later receive the acknowledgement. We can't free
our send buffer (or the memory it's supposed to clean) until the
relevant ack is received. We have to hold our reserves privately
throughout, even if an interrupt that wants to do GFP_ATOMIC
allocation shows up in-between.

> If you are not in an atomic context and are preemptable or can switch 
> allocation context then you can create another context in which reclaim 
> could be run to remove some clean pages and get you more memory. Again no 
> need for the patch.

By the point that this patch is relevant, there are already no clean
pages. The only way to free up more memory is via I/O.

-- 
Mathematics is the supreme nostalgia of our time.
