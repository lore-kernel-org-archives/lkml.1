Return-Path: <linux-kernel-owner+w=401wt.eu-S1759295AbYDCTPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295AbYDCTPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbYDCTPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:15:35 -0400
Received: from relay1.sgi.com ([192.48.171.29]:35467 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753667AbYDCTPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:15:35 -0400
Date: Thu, 3 Apr 2008 12:12:57 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] SLQB: YASA
In-Reply-To: <20080403072550.GC25932@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0804031200530.7265@schroedinger.engr.sgi.com>
References: <20080403072550.GC25932@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008, Nick Piggin wrote:

> I've been playing around with slab allocators because I'm concerned about
> the directions that SLUB is going in. I've come up so far with a working
> alternative implementation, which I have called SLQB (the remaining vowels
> are crap).

Hmm... Interesting stuff. I have toyed around with a lot of similar ideas 
to add at least limited queuing to SLUB but the increased overhead / 
complexity in the hot paths always killed these attempts. Well worth 
pursuing and I could even imagine the queuing you are adding to be merged 
to SLUB (or rename it to whatever else) if it does not impact performance 
otherwise.

> What I have tried to concentrate on is:
> - Per CPU scalability, which is important for MC and MT CPUs.
> This is achieved by having per CPU queues of node local free and partial
> lists. Per node lists are used for off-node allocations.

Yeah that is similar to SLAB. The off node lists will require locks and 
thus you run into similar issues with queue management as in SLAB. How do 
you expire the objects and configure the queues?
 
> - Good performance with order-0 pages.
> I feel that order-0 allocations are the way to go and higher orders are not.
> This is achieved by using queues of pages. We still could* use higher order
> allocations, but it is not as important as SLUB.

If you want to go with order-0 pages then it would be good to first work 
on the page allocator performance so that there is no need of buffering 
order-0 allocations in the slab allocators. The buffering stuff for 4k 
allocs that I had to add to SLUB in 2.6.25 and that likely concerns you 
could go mostly away if the page allocator had competitive performance.

Higher orders are still likely a must in the future because it allows a 
reduction of the metadata management overhead (pretty important for 
filesystems f.e.). And the argument about faster processors compensating 
for the increased effort to manage the metadata (page structs and such) 
really does not cut it because memory speeds do not keep up nor does the 
evolution of the locking algorithms / reclaim logic in the kernel.
