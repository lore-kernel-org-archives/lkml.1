Return-Path: <linux-kernel-owner+w=401wt.eu-S1423020AbXDXSyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423020AbXDXSyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 14:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423021AbXDXSyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 14:54:09 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:50324 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423020AbXDXSyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 14:54:08 -0400
X-AuditID: d80ac287-a989fbb00000590d-23-462e524fcc74 
Date: Tue, 24 Apr 2007 19:53:54 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
In-Reply-To: <Pine.LNX.4.64.0704241042550.8418@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0704241941421.28487@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
 <20070423142919.5809e03f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704231503540.975@schroedinger.engr.sgi.com>
 <20070423154224.15ebf8f7.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241339460.26223@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0704241042550.8418@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 24 Apr 2007 18:54:07.0168 (UTC) FILETIME=[EFA39400:01C786A1]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Christoph Lameter wrote:
> On Tue, 24 Apr 2007, Hugh Dickins wrote:
> 
> > I've not yet looked at the patch under discussion, but this remark
> > prompts me...  a couple of days ago I got very worried by the various
> > hard-wired GFP_HIGHUSER allocations in mm/migrate.c and mm/mempolicy.c,
> > and wondered how those would work out if someone has a blockdev mmap'ed.
> 
> I hope you are not confused by the fact that memory policies are only
> ever applied to one zone on a node. This is either HIGHMEM or NORMAL. 
> There is no memory policy support for other than the highest zone.

I was certainly ignorant of that; but I'm not convinced it eliminates
the potential issue.  For a start, sys_move_pages seems not to involve
mempolicies at all - I don't see what prevents it migrating blockdev
pages away from the only node which has NORMAL memory.

> Metadata is not movable nor subject to memory policies.
> It will never be mapped into a process space.

Not as metadata, no.  But someone (let's hope only root, though I may
be wrong on that) can map any part of the block device into userspace.

> > yup.  wherever we dereference buffer_head.b_data we're touching
> > page_address(buffer_head.b_page) without kmapping.
> 
> Yes but before we get there we will bounce pagecache pages into an area 
> where we do not need kmap.

Again, I'm not convinced: bouncing gets done for the I/O,
but where is it done to meet the filesystem's expectations?

On the other hand, as I said, I've seen no problem myself in practice.
However, if there is no problem, why do block devices demand GFP_USER?

Hugh
