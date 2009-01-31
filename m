Return-Path: <linux-kernel-owner+w=401wt.eu-S1760699AbZAaDHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760699AbZAaDHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbZAaCrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:39 -0500
Received: from kroah.org ([198.145.64.141]:55433 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756905AbZAaCrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:31 -0500
Date: Fri, 30 Jan 2009 18:43:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>
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
       alan@lxorguk.ukuu.org.uk, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh@veritas.com>
Subject: [patch 24/43] Fix OOPS in mmap_region() when merging adjacent
	VM_LOCKED file segments
Message-ID: <20090131024303.GY12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-oops-in-mmap_region-when-merging-adjacent-vm_locked-file-segments.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

This patch differs from the upstream commit
de33c8db5910cda599899dd431cc30d7c1018cbf written by Linus, as it aims to
only prevent the oops from happening, not attempt to change anything
else.


The problem was introduced by commit
ba470de43188cdbff795b5da43a1474523c6c2fb

which added new references to *vma after we've potentially freed it.

From: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Maksim Yevmenkin <maksim.yevmenkin@gmail.com>
Tested-by: Maksim Yevmenkin <maksim.yevmenkin@gmail.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 mm/mmap.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1095,6 +1095,7 @@ unsigned long mmap_region(struct file *f
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev;
+	struct vm_area_struct *merged_vma;
 	int correct_wcount = 0;
 	int error;
 	struct rb_node **rb_link, *rb_parent;
@@ -1207,13 +1208,17 @@ munmap_back:
 	if (vma_wants_writenotify(vma))
 		vma->vm_page_prot = vm_get_page_prot(vm_flags & ~VM_SHARED);
 
-	if (file && vma_merge(mm, prev, addr, vma->vm_end,
-			vma->vm_flags, NULL, file, pgoff, vma_policy(vma))) {
+	merged_vma = NULL;
+	if (file)
+		merged_vma = vma_merge(mm, prev, addr, vma->vm_end,
+			vma->vm_flags, NULL, file, pgoff, vma_policy(vma));
+	if (merged_vma) {
 		mpol_put(vma_policy(vma));
 		kmem_cache_free(vm_area_cachep, vma);
 		fput(file);
 		if (vm_flags & VM_EXECUTABLE)
 			removed_exe_file_vma(mm);
+		vma = merged_vma;
 	} else {
 		vma_link(mm, vma, prev, rb_link, rb_parent);
 		file = vma->vm_file;

