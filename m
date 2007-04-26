Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbXDZRM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbXDZRM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbXDZQ7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:59:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39455 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbXDZQ7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:59:13 -0400
Date: Thu, 26 Apr 2007 09:55:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Miklos Szeredi <mszeredi@suse.cz>,
       Hugh Dickins <hugh@veritas.com>
Subject: [patch 09/33] holepunch: fix mmap_sem i_mutex deadlock
Message-ID: <20070426165539.GJ1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="holepunch-fix-mmap_sem-i_mutex-deadlock.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Hugh Dickins <hugh@veritas.com>

sys_madvise has down_write of mmap_sem, then madvise_remove calls
vmtruncate_range which takes i_mutex and i_alloc_sem: no, we can
easily devise deadlocks from that ordering.

madvise_remove drop mmap_sem while calling vmtruncate_range: luckily,
since madvise_remove doesn't split or merge vmas, it's easy to handle
this case with a NULL prev, without restructuring sys_madvise.  (Though
sad to retake mmap_sem when it's unlikely to be needed, and certainly
down_read is sufficient for MADV_REMOVE, unlike the other madvices.)

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/madvise.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -159,9 +159,10 @@ static long madvise_remove(struct vm_are
 				unsigned long start, unsigned long end)
 {
 	struct address_space *mapping;
-        loff_t offset, endoff;
+	loff_t offset, endoff;
+	int error;
 
-	*prev = vma;
+	*prev = NULL;	/* tell sys_madvise we drop mmap_sem */
 
 	if (vma->vm_flags & (VM_LOCKED|VM_NONLINEAR|VM_HUGETLB))
 		return -EINVAL;
@@ -180,7 +181,12 @@ static long madvise_remove(struct vm_are
 			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
 	endoff = (loff_t)(end - vma->vm_start - 1)
 			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
-	return  vmtruncate_range(mapping->host, offset, endoff);
+
+	/* vmtruncate_range needs to take i_mutex and i_alloc_sem */
+	up_write(&current->mm->mmap_sem);
+	error = vmtruncate_range(mapping->host, offset, endoff);
+	down_write(&current->mm->mmap_sem);
+	return error;
 }
 
 static long
@@ -315,12 +321,15 @@ asmlinkage long sys_madvise(unsigned lon
 		if (error)
 			goto out;
 		start = tmp;
-		if (start < prev->vm_end)
+		if (prev && start < prev->vm_end)
 			start = prev->vm_end;
 		error = unmapped_error;
 		if (start >= end)
 			goto out;
-		vma = prev->vm_next;
+		if (prev)
+			vma = prev->vm_next;
+		else	/* madvise_remove dropped mmap_sem */
+			vma = find_vma(current->mm, start);
 	}
 out:
 	up_write(&current->mm->mmap_sem);

-- 
