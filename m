Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbXDXUaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbXDXUaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbXDXUaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:30:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60762 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754418AbXDXUae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:30:34 -0400
Date: Tue, 24 Apr 2007 13:30:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
In-Reply-To: <Pine.LNX.4.64.0704242109290.11314@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0704241326410.13005@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
 <20070423142919.5809e03f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704231503540.975@schroedinger.engr.sgi.com>
 <20070423154224.15ebf8f7.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241339460.26223@blonde.wat.veritas.com>
 <20070424101116.1cb7512e.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241954050.28487@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0704241254420.12907@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0704242109290.11314@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Hugh Dickins wrote:

> On Tue, 24 Apr 2007, Christoph Lameter wrote:
> > On Tue, 24 Apr 2007, Hugh Dickins wrote:
> > 
> > > Or Christoph may prevail in persuading there's no such problem.
> > 
> > This is pointless. NUMA allocations can only be controlled for the highest 
> > zone. If we switch to a lower zone then we allocate on a different zone 
> > than the user requested.
> 
> Sorry, I'm not following you there.   Perhaps your comment is saying
> that second patch is pointless, because it forces allocations elsewhere
> than the policy requires?  Rather than commenting on the line you quote?

NUMA allocation can only be controlled for the highest zone. If you switch 
to another zone then no control of the node is possible anymore.

> (When I said I didn't know if the patch would have unwanted side-effects
> I was rather wondering what happens when you ask the allocator to do
> some impossible combination.)

It falls back from HIGHMEM to NORMAL (on 32 bit numa that means node 0. 
The result of your patch is that someone requiring an alloc on node 4 will
get memory on node 0).

> > If the system has both high memory and normal memory then only allocations 
> > to highmemory are subject to memory policies etc etc. The block device 
> > allocations would be in zone normal/dma and thus be exempt from NUMA 
> > placement.
> 
> Please just point us to the line where sys_move_pages enforces this.

It does not. It will happily move the pages into highmem. The filesystem 
cannot expect the page to remain in the same zone without holding a 
reference count. Swap may also move pages between zones. There is nothing 
special in what page migration does here.

I would say that the filesystem is broke if it has such expectations 
regardless of page migration.



