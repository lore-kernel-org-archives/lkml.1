Return-Path: <linux-kernel-owner+w=401wt.eu-S1761192AbXIJUSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761192AbXIJUSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 16:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758973AbXIJUSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 16:18:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49070 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757785AbXIJUR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 16:17:59 -0400
Date: Mon, 10 Sep 2007 13:17:58 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Nick Piggin <npiggin@suse.de>, Daniel Phillips <phillips@phunq.net>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dkegel@google.com,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC 0/3] Recursive reclaim (on __PF_MEMALLOC)
In-Reply-To: <1189454122.21778.47.camel@twins>
Message-ID: <Pine.LNX.4.64.0709101315020.25407@schroedinger.engr.sgi.com>
References: <20070814142103.204771292@sgi.com>  <200709050220.53801.phillips@phunq.net>
  <Pine.LNX.4.64.0709050334020.8127@schroedinger.engr.sgi.com> 
 <20070905114242.GA19938@wotan.suse.de>  <Pine.LNX.4.64.0709050507050.9141@schroedinger.engr.sgi.com>
  <20070905121937.GA9246@wotan.suse.de>  <Pine.LNX.4.64.0709101225350.24735@schroedinger.engr.sgi.com>
  <1189453031.21778.28.camel@twins>  <Pine.LNX.4.64.0709101238510.24941@schroedinger.engr.sgi.com>
 <1189454122.21778.47.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007, Peter Zijlstra wrote:

> > Allright maybe you can get the kernel to be stable in the face of having 
> > no memory and debug all the fallback paths in the kernel when an OOM 
> > condition occurs.
> > 
> > But system calls will fail? Like fork/exec? etc? There may be daemons 
> > running that are essential for the system to survive and that cannot 
> > easily take an OOM condition? Various reclaim paths also need memory and 
> > if the allocation fails then reclaim cannot continue.
> 
> I'm not making any of these paths significantly more likely to occur
> than they already are. Lots and lots of users run swap heavy loads day
> in day out - they don't get funny systems (well sometimes they do, and
> theoretically we can easily run out of the PF_MEMALLOC reserves -
> HOWEVER in practise it seems to work quite reliably).
> 

The patchset increases these failures significantly since there will be a 
longer time period where these allocations can fail.

The swap loads are fine as long as we do not exhaust the reserve pools.

IMHO the right solution is to throttle the networking layer to not do 
unbounded allocations. You can likely do this by checking certain VM 
counters like SLAB_UNRECLAIMABLE. If need be we can add a new category of 
SLAB_TEMPORARY for temporary allocs and track these. If they get too large 
then throttle.
