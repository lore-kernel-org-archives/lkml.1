Return-Path: <linux-kernel-owner+w=401wt.eu-S1423071AbXDXTe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423071AbXDXTe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 15:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423067AbXDXTe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 15:34:56 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:44400 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423071AbXDXTex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 15:34:53 -0400
Date: Tue, 24 Apr 2007 12:34:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
In-Reply-To: <Pine.LNX.4.64.0704241941421.28487@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0704241234341.12753@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
 <20070423142919.5809e03f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704231503540.975@schroedinger.engr.sgi.com>
 <20070423154224.15ebf8f7.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241339460.26223@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0704241042550.8418@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0704241941421.28487@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Hugh Dickins wrote:

> I was certainly ignorant of that; but I'm not convinced it eliminates
> the potential issue.  For a start, sys_move_pages seems not to involve
> mempolicies at all - I don't see what prevents it migrating blockdev
> pages away from the only node which has NORMAL memory.

There is no need to. If the user does something stupid (and 32bit NUMA 
system are so stupid by default) as you say then this means that the 
pages would have to use bounce buffers to be written back.

> > Metadata is not movable nor subject to memory policies.
> > It will never be mapped into a process space.
> 
> Not as metadata, no.  But someone (let's hope only root, though I may
> be wrong on that) can map any part of the block device into userspace.

Concurrent access to a block device by a filesystem and the user? That 
cannot go over well. If one just reads then I would expect that a copy
of the metadata becomes available to the user. Also you cannot migrate 
pages that have multiple references (which is the case here if the 
filesystem uses the page cache for the metadata) unless the user has 
special priviledges and uses special command options.

A page that has references that cannot be accounted for by page migration 
is never migrated. I would assume that the filesystem at minimum takes a 
refcount on the page used for metadata.

If the filesystem would not take a refcount then it would already be in 
trouble because the page may then be evicted at any time.

> > Yes but before we get there we will bounce pagecache pages into an area 
> > where we do not need kmap.
> 
> Again, I'm not convinced: bouncing gets done for the I/O,
> but where is it done to meet the filesystem's expectations?

Bouncing gets done for the block device and the block device determines 
the zones from which it can do I/O. Thus the block device determines the 
allocation restrictions.

> On the other hand, as I said, I've seen no problem myself in practice.
> However, if there is no problem, why do block devices demand GFP_USER?

GFP_USER requires allocation in non highmem areas. These are typically 
reachable by device DMA. I think there is no problem if one would open a 
block device with GFP_HIGHMEM. The pages may be allocated in highmem 
which would require bounce buffers but otherwise we will be fine. A 
ramdisk device may just work fine with highmem.

If the system has both high memory and normal memory then only allocations 
to highmemory are subject to memory policies etc etc. The block device 
allocations would be in zone normal/dma and thus be exempt from NUMA 
placement.
