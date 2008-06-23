Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbYFWXIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbYFWXIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 19:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbYFWXHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 19:07:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:39089 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbYFWXHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 19:07:13 -0400
Date: Mon, 23 Jun 2008 16:04:52 -0700
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
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [patch 10/10] Fix ZERO_PAGE breakage with vmware
Message-ID: <20080623230452.GD29853@suse.de>
References: <20080623225737.837265824@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-zero_page-breakage-with-vmware.patch"
In-Reply-To: <20080623230417.GA29853@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.25.9-stable review patch.  If anyone has any objections, please let
us know.

Note, I had to merge this patch by hand, can someone verify that I 
didn't mess it up?

------------------ 

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 672ca28e300c17bf8d792a2a7a8631193e580c74 upstream

Commit 89f5b7da2a6bad2e84670422ab8192382a5aeb9f ("Reinstate ZERO_PAGE
optimization in 'get_user_pages()' and fix XIP") broke vmware, as
reported by Jeff Chua:

  "This broke vmware 6.0.4.
   Jun 22 14:53:03.845: vmx| NOT_IMPLEMENTED
   /build/mts/release/bora-93057/bora/vmx/main/vmmonPosix.c:774"

and the reason seems to be that there's an old bug in how we handle do
FOLL_ANON on VM_SHARED areas in get_user_pages(), but since it only
triggered if the whole page table was missing, nobody had apparently hit
it before.

The recent changes to 'follow_page()' made the FOLL_ANON logic trigger
not just for whole missing page tables, but for individual pages as
well, and exposed this problem.

This fixes it by making the test for when FOLL_ANON is used more
careful, and also makes the code easier to read and understand by moving
the logic to a separate inline function.

Reported-and-tested-by: Jeff Chua <jeff.chua.linux@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memory.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -989,6 +989,26 @@ no_page_table:
 	return page;
 }
 
+/* Can we do the FOLL_ANON optimization? */
+static inline int use_zero_page(struct vm_area_struct *vma)
+{
+	/*
+	 * We don't want to optimize FOLL_ANON for make_pages_present()
+	 * when it tries to page in a VM_LOCKED region. As to VM_SHARED,
+	 * we want to get the page from the page tables to make sure
+	 * that we serialize and update with any other user of that
+	 * mapping.
+	 */
+	if (vma->vm_flags & (VM_LOCKED | VM_SHARED))
+		return 0;
+	/*
+	 * And if we have a fault or a nopfn routine, it's not an
+	 * anonymous region.
+	 */
+	return !vma->vm_ops ||
+		(!vma->vm_ops->fault && !vma->vm_ops->nopfn);
+}
+
 int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		unsigned long start, int len, int write, int force,
 		struct page **pages, struct vm_area_struct **vmas)
@@ -1063,9 +1083,7 @@ int get_user_pages(struct task_struct *t
 		foll_flags = FOLL_TOUCH;
 		if (pages)
 			foll_flags |= FOLL_GET;
-		if (!write && !(vma->vm_flags & VM_LOCKED) &&
-		    (!vma->vm_ops || (!vma->vm_ops->nopage &&
-					!vma->vm_ops->fault)))
+		if (!write && use_zero_page(vma))
 			foll_flags |= FOLL_ANON;
 
 		do {

-- 
