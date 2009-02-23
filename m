Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbZBWPn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbZBWPn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755440AbZBWPnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:43:49 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:43636 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755725AbZBWPns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:43:48 -0500
Date: Mon, 23 Feb 2009 10:34:58 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Andi Kleen <andi@firstfloor.org>
cc: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [RFC PATCH 00/20] Cleanup and optimise the page allocato
In-Reply-To: <87prhauiry.fsf@basil.nowhere.org>
Message-ID: <alpine.DEB.1.10.0902231032150.7298@qirst.com>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> <87prhauiry.fsf@basil.nowhere.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009, Andi Kleen wrote:

> > Counters are surprising expensive, we spent a good chuck of our time in
> > functions like __dec_zone_page_state and __dec_zone_state. In a profiled
> > run of kernbench, the time spent in __dec_zone_state was roughly equal to
> > the combined cost of the rest of the page free path. A quick check showed
> > that almost half of the time in that function is spent on line 233 alone
> > which for me is;
> >
> > 	(*p)--;
> >
> > That's worth a separate investigation but it might be a case that
> > manipulating int8_t on the machine I was using for profiling is unusually
> > expensive.
>
> What machine was that?
>
> In general I wouldn't expect even on a system with slow char
> operations to be that expensive. It sounds more like a cache miss or a
> cache line bounce. You could possibly confirm by using appropiate
> performance counters.

I have seen similar things occur with some processors. 16 bit or 8 bit
arithmetic can be a problem.

> > Converting this to an int might be faster but the increased
> > memory consumption and cache footprint might be a problem. Opinions?
>
> One possibility would be to move the zone statistics to allocated
> per cpu data. Or perhaps just stop counting per zone at all and
> only count per cpu.

Statistics are in a structure allocated and dedicated for a certain cpu.
It cannot be per cpu data as long as the per cpu allocator has not been
merged. Cache line footprint is reduced with the per cpu allocator.

> > So, by and large it's an improvement of some sort.
>
> That seems like an understatement.

Ack. There is certainly more work to be done on the page allocator. Looks
like a good start to me though.
