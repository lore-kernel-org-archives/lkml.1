Return-Path: <linux-kernel-owner+w=401wt.eu-S2992776AbXDDJPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992776AbXDDJPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 05:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992782AbXDDJPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 05:15:50 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:60149 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992776AbXDDJPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 05:15:49 -0400
X-AuditID: d80ac287-976cabb000000c42-09-46136cc4444e 
Date: Wed, 4 Apr 2007 10:15:41 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: missing madvise functionality
In-Reply-To: <20070403160231.33aa862d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704040949050.17341@blonde.wat.veritas.com>
References: <46128051.9000609@redhat.com> <p73648dz5oa.fsf@bingen.suse.de>
 <46128CC2.9090809@redhat.com> <20070403172841.GB23689@one.firstfloor.org>
 <20070403125903.3e8577f4.akpm@linux-foundation.org> <4612B645.7030902@redhat.com>
 <20070403202937.GE355@devserv.devel.redhat.com> <20070403144948.fe8eede6.akpm@linux-foundation.org>
 <20070403160231.33aa862d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 04 Apr 2007 09:15:47.0855 (UTC) FILETIME=[D4F999F0:01C77699]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, Andrew Morton wrote:
> 
> All of which indicates that if we can remove the down_write(mmap_sem) from
> this glibc operation, things should get a lot better - there will be no
> additional context switches at all.
> 
> And we can surely do that if all we're doing is looking up pageframes,
> putting pages into fake-swapcache and moving them around on the page LRUs.
> 
> Hugh?  Sanity check?

Setting aside the fake-swapcache part, yes, Rik should be able to do what
Ulrich wants (operating on ptes and pages) without down_write(mmap_sem):
just needing down_read(mmap_sem) to keep the whole vma/pagetable structure
stable, and page table lock (literal or per-page-table) for each contents.

(I didn't understand how Rik would achieve his point 5, _no_ lock
contention while repeatedly re-marking these pages, but never mind.)

(Some mails in this thread overlook that we also use down_write(mmap_sem)
to guard simple things like vma->vm_flags: of course that in itself could
be manipulated with atomics, or spinlock; but like many of the vma fields,
changing it goes hand in hand with the chance that we have to split vma,
which does require the heavy-handed down_write(mmap_sem).  I expect that
splitting those uses apart would be harder than first appears, and better
to go for a more radical redesign - I don't know what.)

But you lose me with the fake-swapcache part of it: that came, I think,
from your initial idea that it would be okay to refault on these ptes.
Don't we all agree now that we'd prefer not to refault on those ptes,
unless some memory pressure has actually decided to pull them out?
(Hmm, yet more list balancing...)

Hugh
