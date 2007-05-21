Return-Path: <linux-kernel-owner+w=401wt.eu-S1759887AbXEUIHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887AbXEUIHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbXEUIH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:07:26 -0400
Received: from holomorphy.com ([66.93.40.71]:58713 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375AbXEUIHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:07:24 -0400
Date: Mon, 21 May 2007 01:08:13 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
Message-ID: <20070521080813.GQ31925@holomorphy.com>
References: <20070518040854.GA15654@wotan.suse.de> <Pine.LNX.4.64.0705181112250.11881@schroedinger.engr.sgi.com> <20070519012530.GB15569@wotan.suse.de> <20070519181501.GC19966@holomorphy.com> <20070520052229.GA9372@wotan.suse.de> <20070520084647.GF19966@holomorphy.com> <20070520092552.GA7318@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070520092552.GA7318@wotan.suse.de>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 01:46:47AM -0700, William Lee Irwin III wrote:
>> The lack of consideration of the average case. I'll see what I can smoke
>> out there.

On Sun, May 20, 2007 at 11:25:52AM +0200, Nick Piggin wrote:
> I _am_ considering the average case, and I consider the aligned structure
> is likely to win on average :) I just don't have numbers for it yet.

Choosing k distinct integers (mem_map array indices) from the interval
[0,n-1] results in k(n-k+1)/n non-adjacent intervals of contiguous
array indices on average. The average interval length is
(n+1)/(n-k+1) - 1/C(n,k). Alignment considerations make going much
further somewhat hairy, but it should be clear that contiguity arising
from random choice is non-negligible.

In any event, I don't have all that much of an objection to what's
actually proposed, just this particular cache footprint argument.
One can motivate increases in sizeof(struct page), but not this way.

Now that I've been informed of the ->_count and ->_mapcount issues,
I'd say that they're grave and should be corrected even at the cost
of sizeof(struct page).


-- wli

Many thanks to int-e on EfNet #math for help with the calculations
(perhaps better described as doing them outright).
Heavily-edited IRC log (using Knuth's conventions for M, N, and k as
	the number of runs):

<int-e:#math> wli: oh maybe this can be solved exactly after all. The number
+of configurations of N numbers out of M with exactly k runs is C(N-1, k-1) *
+C(M-N+1, k). When there are k runs, the average run length is N/k, obviously.
<int-e:#math> wli: assume there are k runs. add an empty dummy element at the
+end and at the front - then you have (k+1) empty runs between the k runs.
+Every run has positive length. the empty runs correspond to a partition of
+M-N+2 into k+1 positive numbers, and the occupied runs correspond to one of N
+into k positive numbers, which gives that formula.
<int-e:#math> wli: So the average is 1/C(M,N) * sum[k=1 to N] N/k C(N-1,k-1)
+C(M-N+1,k) = 1/C(M,N) * sum[k=1 to N] C(N,k) C(M-N+1,k) = 1/C(M,N) * (C(M+1,
+N) - 1) = (M+1)/(M-N+1) - 1/C(M,N).
