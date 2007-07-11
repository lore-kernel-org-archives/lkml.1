Return-Path: <linux-kernel-owner+w=401wt.eu-S1761655AbXGKSZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761655AbXGKSZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbXGKSY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:24:58 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:54774 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014AbXGKSY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:24:58 -0400
Date: Wed, 11 Jul 2007 19:24:13 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Jes Sorensen <jes@sgi.com>
cc: Dmitry Monakhov <dmonakhov@sw.ru>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       holt@sgi.com
Subject: Re: [patch] mm: recheck lock rlim after f_op->mmap() method
In-Reply-To: <46949751.1060701@sgi.com>
Message-ID: <Pine.LNX.4.64.0707111906180.22786@blonde.wat.veritas.com>
References: <20070709184917.GA8720@dnb.sw.ru> <Pine.LNX.4.64.0707101813390.4717@blonde.wat.veritas.com>
 <46949751.1060701@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABmluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAZG1vbmFraG92QHN3LnJ1AGplc0BzZ2kuY29tAGhvbHRAc2dpLmNvbQBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnAGhjaEBpbmZyYWRlYWQub3JnAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, Jes Sorensen wrote:
> Hugh Dickins wrote:
> > 
> > Or would this simpler patch be the right one?  I suspect the
> > mspec driver only says VM_LOCKED because of a deep-seated but
> > irrational fear that its pages might fall into reclaim.
> 
> My mind is rusty on this one, so I checked with Robin Holt and his
> is too .... most likely mspec has it for legacy problems, if your
> change shows up to cause new problems, we'll fix them when they appear.
> So from our side, it's fine to go ahead with this patch.

Thanks a lot, Jes: you're right, it probably did something useful
(though incorrectly) in 2.4, but we'd better get rid of it now.
I've Cc'ed Andrew, hoping he'll magically pick up the patch...


[PATCH] mspec_mmap don't set VM_LOCKED

mspec_mmap was setting VM_LOCKED (without adjusting locked_vm):
don't do that, it serves no purpose in 2.6, other than to mess
up the locked_vm accounting - mspec's pages won't get reclaimed
anyway.  Thanks to Dmitry Monakhov for raising the issue.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Jes Sorensen <jes@sgi.com>

--- 2.6.22/drivers/char/mspec.c	2007-04-26 04:08:32.000000000 +0100
+++ linux/drivers/char/mspec.c	2007-07-10 18:12:11.000000000 +0100
@@ -265,7 +265,7 @@ mspec_mmap(struct file *file, struct vm_
 	vdata->refcnt = ATOMIC_INIT(1);
 	vma->vm_private_data = vdata;
 
-	vma->vm_flags |= (VM_IO | VM_LOCKED | VM_RESERVED | VM_PFNMAP);
+	vma->vm_flags |= (VM_IO | VM_RESERVED | VM_PFNMAP);
 	if (vdata->type == MSPEC_FETCHOP || vdata->type == MSPEC_UNCACHED)
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	vma->vm_ops = &mspec_vm_ops;
