Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbZFBHfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbZFBHfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbZFBHe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:34:57 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:20077 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbZFBHe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:34:56 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [patch 3/3 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0906020016060.24915@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0906011828040.6936@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0906011830490.6936@chino.kir.corp.google.com>
	 <20090601225602.3482cd0d.akpm@linux-foundation.org>
	 <alpine.DEB.2.00.0906020016060.24915@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Tue, 02 Jun 2009 09:34:55 +0200
Message-Id: <1243928095.23657.5633.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-02 at 00:26 -0700, David Rientjes wrote:
> > I really think/hope/expect that this is unneeded.
> > 
> > Do we know of any callsites which do greater-than-order-0 allocations
> > with GFP_NOFAIL?  If so, we should fix them.
> > 
> > Then just ban order>0 && GFP_NOFAIL allocations.
> > 
> 
> That seems like a different topic: banning higher-order __GFP_NOFAIL 
> allocations or just deprecating __GFP_NOFAIL altogether and slowly 
> switching users over is a worthwhile effort, but is unrelated.
> 
> This patch is necessary because we explicitly deny the oom killer from 
> being used when the order is greater than PAGE_ALLOC_COSTLY_ORDER because 
> of an assumption that it won't help.  That assumption isn't always true, 
> especially for large memory-hogging tasks that have mlocked large chunks 
> of contiguous memory, for example.  The only thing we do know is that 
> direct reclaim has not made any progress so we're unlikely to get a 
> substantial amount of memory freeing in the immediate future.  Such an 
> instance will simply loop forever without killing that rogue task for a 
> __GFP_NOFAIL allocation.
> 
> So while it's better in the long-term to deprecate the flag as much as 
> possible and perhaps someday remove it from the page allocator entirely, 
> we're faced with the current behavior of either looping endlessly or 
> freeing memory so the kernel allocation may succeed when direct reclaim 
> has failed, which also makes this a rare instance where the oom killer 
> will never needlessly kill a task.

I would really prefer if we do as Andrew suggests. Both will fix this
problem, so I don't see it as a different topic at all.

Eradicating __GFP_NOFAIL is a fine goal, but very hard work (people have
been wanting to do that for many years). But simply limiting it to
0-order allocation should be much(?) easier.


