Return-Path: <linux-kernel-owner+w=401wt.eu-S1765511AbZBNBc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765511AbZBNBc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762587AbZBNBQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:18 -0500
Received: from kroah.org ([198.145.64.141]:50283 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763011AbZBNBQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:11 -0500
Date: Fri, 13 Feb 2009 17:12:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Christophe Saout <christophe@saout.de>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Alex Williamson <alex.williamson@hp.com>
Subject: [patch 13/48] mm: rearrange exit_mmap() to unlock before
	arch_exit_mmap
Message-ID: <20090214011244.GN17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mm-rearrange-exit_mmap-to-unlock-before-arch_exit_mmap.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeremy Fitzhardinge <jeremy@goop.org>

commit 9480c53e9b2aa13a06283ffb96bb8f1873ac4e9a upstream.

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
meaning that it is RO to the kernel, and all updates must go via hypercall
(or writes are trapped and emulated, which is much the same thing).  An
unpinned pagetable is not currently in use by any process, and can be
directly accessed as normal RW pages.

As an optimisation at process exit time, we unpin the pagetable as early
as possible (switching the process to init_mm), so that all the normal
pagetable teardown can happen with direct memory accesses.

This happens in exit_mmap() -> arch_exit_mmap().  The munlocking happens
a few lines below.  The obvious thing to do would be to move
arch_exit_mmap() to below the munlock code, but I think we'd want to
call it even if mm->mmap is NULL, just to be on the safe side.

Thus, this patch:

exit_mmap() needs to unlock any locked vmas before calling arch_exit_mmap,
as the latter may switch the current mm to init_mm, which would cause the
former to fail.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christophe Saout <christophe@saout.de>
Cc: Keir Fraser <keir.fraser@eu.citrix.com>
Cc: Christophe Saout <christophe@saout.de>
Cc: Alex Williamson <alex.williamson@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/mmap.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2093,7 +2093,6 @@ void exit_mmap(struct mm_struct *mm)
 	unsigned long end;
 
 	/* mm's last user has gone, and its about to be pulled down */
-	arch_exit_mmap(mm);
 	mmu_notifier_release(mm);
 
 	if (mm->locked_vm) {
@@ -2104,7 +2103,13 @@ void exit_mmap(struct mm_struct *mm)
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

