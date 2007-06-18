Return-Path: <linux-kernel-owner+w=401wt.eu-S1764205AbXFRPiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764205AbXFRPiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 11:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762610AbXFRPin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 11:38:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756289AbXFRPim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 11:38:42 -0400
Date: Mon, 18 Jun 2007 11:35:15 -0400 (EDT)
From: Jason Baron <jbaron@redhat.com>
X-X-Sender: jbaron@dhcp83-20.boston.redhat.com
To: Christoph Hellwig <hch@infradead.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, nickpiggin@yahoo.com.au,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] madvise_need_mmap_write() usage
In-Reply-To: <20070616194130.GA6681@infradead.org>
Message-ID: <Pine.LNX.4.64.0706181132020.23021@dhcp83-20.boston.redhat.com>
References: <Pine.LNX.4.64.0706151118150.11498@dhcp83-20.boston.redhat.com>
 <20070616194130.GA6681@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 16 Jun 2007, Christoph Hellwig wrote:

> On Fri, Jun 15, 2007 at 11:20:31AM -0400, Jason Baron wrote:
> > hi,
> > 
> > i was just looking at the new madvise_need_mmap_write() call...can we
> > avoid an extra case statement and function call as follows?
> 
> Sounds like a good idea, but please move the assignment out of the
> conditional.
> 

ok, here's an updated version:


Signed-off-by: Jason Baron <jbaron@redhat.com>


diff --git a/mm/madvise.c b/mm/madvise.c
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -287,9 +287,11 @@ asmlinkage long sys_madvise(unsigned long start, size_t len_in, int behavior)
 	struct vm_area_struct * vma, *prev;
 	int unmapped_error = 0;
 	int error = -EINVAL;
+	int write;
 	size_t len;
 
-	if (madvise_need_mmap_write(behavior))
+	write = madvise_need_mmap_write(behavior);
+	if (write)
 		down_write(&current->mm->mmap_sem);
 	else
 		down_read(&current->mm->mmap_sem);
@@ -354,7 +356,7 @@ asmlinkage long sys_madvise(unsigned long start, size_t len_in, int behavior)
 			vma = find_vma(current->mm, start);
 	}
 out:
-	if (madvise_need_mmap_write(behavior))
+	if (write)
 		up_write(&current->mm->mmap_sem);
 	else
 		up_read(&current->mm->mmap_sem);
