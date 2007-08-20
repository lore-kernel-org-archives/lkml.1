Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbXHTI7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbXHTI7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 04:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbXHTI7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 04:59:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59781 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbXHTI7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 04:59:38 -0400
Subject: Re: [PATCH] Should GFP_ATOMIC fail when we're below low watermark?
From: Peter Zijlstra <peterz@infradead.org>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200708201838.50262.nigel@nigel.suspend2.net>
References: <200708201138.50508.nigel@nigel.suspend2.net>
	 <1187577830.6114.140.camel@twins>
	 <200708201838.50262.nigel@nigel.suspend2.net>
Content-Type: text/plain
Date: Mon, 20 Aug 2007 10:59:36 +0200
Message-Id: <1187600376.6114.186.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-20 at 18:38 +1000, Nigel Cunningham wrote:
> Hi.
> 
> On Monday 20 August 2007 12:43:50 Peter Zijlstra wrote:
> > On Mon, 2007-08-20 at 11:38 +1000, Nigel Cunningham wrote:
> > > Hi all.
> > > 
> > > In current git (and for a while now), an attempt to allocate memory with 
> > > GFP_ATOMIC will fail if we're below the low watermark level. The only way 
> to 
> > > access that memory that I can see (not that I've looked that hard) is to 
> have 
> > > PF_MEMALLOC set (ie from kswapd). I'm wondering if this behaviour is 
> correct. 
> > > Shouldn't GFP_ATOMIC allocations ignore watermarks too? How about 
> GFP_KERNEL?
> > > 
> > > The following patch is a potential fix for GFP_ATOMIC.
> > 
> > Sorry, no.
> > 
> > GFP_ATOMIC must fail when below the watermark. GFP_KERNEL has __GFP_WAIT
> > and hence can sleep and wait for reclaim so that should not be a problem
> > (usually).
> > 
> > GFP_ATOMIC may not access the reserves because the reserves are needed
> > to get out of OOM deadlocks within the VM. Consider the fact that
> > freeing memory needs memory - if there is no memory free, you cannot
> > free memory and you're pretty much stuck.
> 
> I guess, then, the question should be whether the watermark values are 
> appropriate. Do we need high order allocations watermarked if this is the 
> only purpose, particularly considering that whatever memory is allocated for 
> this purpose is essentially useless 99.9% of the time?

Could you perhaps explain what you're trying to do? No matter what we
do, GFP_ATOMIC will fail eventually, there is only so much one can do
without blocking.

As for higher order allocations, until we have a full online defrag
solution those too can fail at any moment (even with __GFP_WAIT).

