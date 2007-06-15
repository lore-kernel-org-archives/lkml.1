Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbXFOPX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbXFOPX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbXFOPXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:23:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32778 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbXFOPXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:23:18 -0400
Date: Fri, 15 Jun 2007 11:20:31 -0400 (EDT)
From: Jason Baron <jbaron@redhat.com>
X-X-Sender: jbaron@dhcp83-20.boston.redhat.com
To: linux-kernel@vger.kernel.org
cc: linux-mm@kvack.org, nickpiggin@yahoo.com.au,
       Rik van Riel <riel@redhat.com>
Subject: [PATCH] madvise_need_mmap_write() usage
Message-ID: <Pine.LNX.4.64.0706151118150.11498@dhcp83-20.boston.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


hi,

i was just looking at the new madvise_need_mmap_write() call...can we
avoid an extra case statement and function call as follows?

thanks,

-Jason


Signed-off-by: Jason Baron <jbaron@redhat.com>

diff --git a/mm/madvise.c b/mm/madvise.c
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -287,9 +287,10 @@ asmlinkage long sys_madvise(unsigned long start, size_t len_in, int behavior)
 	struct vm_area_struct * vma, *prev;
 	int unmapped_error = 0;
 	int error = -EINVAL;
+	int write;
 	size_t len;
 
-	if (madvise_need_mmap_write(behavior))
+	if (write = madvise_need_mmap_write(behavior))
 		down_write(&current->mm->mmap_sem);
 	else
 		down_read(&current->mm->mmap_sem);
@@ -354,7 +355,7 @@ asmlinkage long sys_madvise(unsigned long start, size_t len_in, int behavior)
 			vma = find_vma(current->mm, start);
 	}
 out:
-	if (madvise_need_mmap_write(behavior))
+	if (write)
 		up_write(&current->mm->mmap_sem);
 	else
 		up_read(&current->mm->mmap_sem);
