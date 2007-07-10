Return-Path: <linux-kernel-owner+w=401wt.eu-S1763499AbXGJR2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763499AbXGJR2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 13:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762185AbXGJR1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 13:27:49 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:50225 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760779AbXGJR1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 13:27:48 -0400
Date: Tue, 10 Jul 2007 18:27:05 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Dmitry Monakhov <dmonakhov@sw.ru>
cc: Jes Sorensen <jes@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: recheck lock rlim after f_op->mmap() method
In-Reply-To: <20070709184917.GA8720@dnb.sw.ru>
Message-ID: <Pine.LNX.4.64.0707101813390.4717@blonde.wat.veritas.com>
References: <20070709184917.GA8720@dnb.sw.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAA2luYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAZG1vbmFraG92QHN3LnJ1AGplc0BzZ2kuY29tAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007, Dmitry Monakhov wrote:
> Some device drivers can change vm_flags in their f_op->mmap
> method. In order to be on the safe side we have to recheck
> lock rlimit. Now we have to check lock rlimit from two places,
> let's move this common code to helper functon.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  mm/mmap.c |   33 ++++++++++++++++++++++++++-------
>  1 files changed, 26 insertions(+), 7 deletions(-)

Or would this simpler patch be the right one?  I suspect the
mspec driver only says VM_LOCKED because of a deep-seated but
irrational fear that its pages might fall into reclaim.

(I'd like to take out VM_RESERVED too, but that can always happen
another, indefinitely postponed time; there are others of those.)

Hugh

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
