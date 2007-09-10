Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbXIJTIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbXIJTIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756407AbXIJTHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:07:51 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47357 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756327AbXIJTHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:07:50 -0400
Date: Mon, 10 Sep 2007 12:07:46 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Mel Gorman <mel@skynet.ie>
Subject: Re: tbench regression - Why process scheduler has impact on tbench
 and why small per-cpu slab (SLUB) cache creates the scenario?
In-Reply-To: <200709100810.46341.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0709101201140.24491@schroedinger.engr.sgi.com>
References: <1188953218.26438.34.camel@ymzhang> <200709081808.42421.nickpiggin@yahoo.com.au>
 <1189385792.14611.1.camel@ymzhang> <200709100810.46341.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007, Nick Piggin wrote:

> OK, so after isolating the scheduler, then SLUB should be as fast as SLAB
> at the same allocation size. That's basically what we need to do before we
> can replace SLAB with it, I think?

The regression is due to the limited number of objects in the per cpu 
"queue" in SLUB for 4k objects. With the .23 code this is one or two 
(order 1 slab). So we have to call into the page allocator frequently and 
do it for order 1 pages which requires the zone locks. Urgh.

I think the regression is best addressed by the page allocator pass 
through patch in mm which makes the page allocator handle these objects. 
They are single pages so the pcp lists are in use which provide much 
larger queues than SLUB/SLAB.

IMHO >=4k objects should be handled by the page allocator. From the 
numbers I have seen there is then still a 1% regression left. If 
that is still the case after we have fixed the scheduler then maybe 
we need to slim down the page allocator fast path.
