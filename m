Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbZBIRaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbZBIRaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZBIR3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:29:54 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:10057 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbZBIR3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:29:53 -0500
Subject: [PATCH] mm: rearrange exit_mmap() to unlock before arch_exit_mmap
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Christophe Saout <christophe@saout.de>,
       Alex Williamson <alex.williamson@hp.com>, Nick Piggin <npiggin@suse.de>
Content-Type: text/plain
Organization: HP/OSLO
Date: Mon, 09 Feb 2009 12:29:48 -0500
Message-Id: <1234200588.22359.30.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy@goop.org>

Subject: mm: rearrange exit_mmap() to unlock before arch_exit_mmap

Applicable to 29-rc4 and 28-stable

Christophe Saout reported [in precursor to:
http://marc.info/?l=linux-kernel&m=123209902707347&w=4]:

> Note that I also some a different issue with CONFIG_UNEVICTABLE_LRU.
> Seems like Xen tears down current->mm early on process termination, so
> that __get_user_pages in exit_mmap causes nasty messages when the
> process had any mlocked pages.  (in fact, it somehow manages to get into
> the swapping code and produces a null pointer dereference trying to get
> a swap token)

Jeremy explained:

Yes.  In the normal case under Xen, an in-use pagetable is "pinned", 
meaning that it is RO to the kernel, and all updates must go via 
hypercall (or writes are trapped and emulated, which is much the same 
thing).  An unpinned pagetable is not currently in use by any process, 
and can be directly accessed as normal RW pages.

As an optimisation at process exit time, we unpin the pagetable as early 
as possible (switching the process to init_mm), so that all the normal 
pagetable teardown can happen with direct memory accesses.

This happens in exit_mmap() -> arch_exit_mmap().  The munlocking happens 
a few lines below.  The obvious thing to do would be to move 
arch_exit_mmap() to below the munlock code, but I think we'd want to 
call it even if mm->mmap is NULL, just to be on the safe side.

Thus, this patch:

exit_mmap() needs to unlock any locked vmas before calling
arch_exit_mmap, as the latter may switch the current mm to init_mm,
which would cause the former to fail.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Acked-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>

---
 mm/mmap.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

===================================================================
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2078,12 +2078,8 @@
 	unsigned long end;
 
 	/* mm's last user has gone, and its about to be pulled down */
-	arch_exit_mmap(mm);
 	mmu_notifier_release(mm);
 
-	if (!mm->mmap)	/* Can happen if dup_mmap() received an OOM */
-		return;
-
 	if (mm->locked_vm) {
 		vma = mm->mmap;
 		while (vma) {
@@ -2092,7 +2088,13 @@
 			vma = vma->vm_next;
 		}
 	}
+
+	arch_exit_mmap(mm);
+
 	vma = mm->mmap;
+	if (!vma)	/* Can happen if dup_mmap() received an OOM */
+		return;
+
 	lru_add_drain();
 	flush_cache_mm(mm);
 	tlb = tlb_gather_mmu(mm, 1);





