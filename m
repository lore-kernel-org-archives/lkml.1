Return-Path: <linux-kernel-owner+w=401wt.eu-S1760283AbZAHM5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760283AbZAHM5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759925AbZAHM4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:56:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40757 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759889AbZAHM4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:56:01 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/10] NOMMU: Improve procfs output using per-MM VMAs [ver #3]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: bernds_cb1@t-online.de, dhowells@redhat.com, rgetz@blackfin.uclinux.org,
       vapier.adi@gmail.com, lethal@linux-sh.org, linux-kernel@vger.kernel.org
Date: Thu, 08 Jan 2009 12:54:17 +0000
Message-ID: <20090108125417.28454.38792.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090108125346.28454.90871.stgit@warthog.procyon.org.uk>
References: <20090108125346.28454.90871.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve procfs output using per-MM VMAs for process memory accounting.

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Mike Frysinger <vapier.adi@gmail.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
---

 fs/proc/task_nommu.c |   32 ++++++++++++++++++++++----------
 1 files changed, 22 insertions(+), 10 deletions(-)


diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index ca4a48d..343ea12 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -16,24 +16,31 @@
 void task_mem(struct seq_file *m, struct mm_struct *mm)
 {
 	struct vm_area_struct *vma;
+	struct vm_region *region;
 	struct rb_node *p;
-	unsigned long bytes = 0, sbytes = 0, slack = 0;
+	unsigned long bytes = 0, sbytes = 0, slack = 0, size;
         
 	down_read(&mm->mmap_sem);
 	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p)) {
 		vma = rb_entry(p, struct vm_area_struct, vm_rb);
 
 		bytes += kobjsize(vma);
+
+		region = vma->vm_region;
+		if (region) {
+			size = kobjsize(region);
+			size += region->vm_end - region->vm_start;
+		} else {
+			size = vma->vm_end - vma->vm_start;
+		}
+
 		if (atomic_read(&mm->mm_count) > 1 ||
-		    vma->vm_region ||
 		    vma->vm_flags & VM_MAYSHARE) {
-			sbytes += kobjsize((void *) vma->vm_start);
-			if (vma->vm_region)
-				sbytes += kobjsize(vma->vm_region);
+			sbytes += size;
 		} else {
-			bytes += kobjsize((void *) vma->vm_start);
-			slack += kobjsize((void *) vma->vm_start) -
-				(vma->vm_end - vma->vm_start);
+			bytes += size;
+			if (region)
+				slack = region->vm_end - vma->vm_end;
 		}
 	}
 
@@ -77,7 +84,7 @@ unsigned long task_vsize(struct mm_struct *mm)
 	down_read(&mm->mmap_sem);
 	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p)) {
 		vma = rb_entry(p, struct vm_area_struct, vm_rb);
-		vsize += vma->vm_region->vm_end - vma->vm_region->vm_start;
+		vsize += vma->vm_end - vma->vm_start;
 	}
 	up_read(&mm->mmap_sem);
 	return vsize;
@@ -87,6 +94,7 @@ int task_statm(struct mm_struct *mm, int *shared, int *text,
 	       int *data, int *resident)
 {
 	struct vm_area_struct *vma;
+	struct vm_region *region;
 	struct rb_node *p;
 	int size = kobjsize(mm);
 
@@ -94,7 +102,11 @@ int task_statm(struct mm_struct *mm, int *shared, int *text,
 	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p)) {
 		vma = rb_entry(p, struct vm_area_struct, vm_rb);
 		size += kobjsize(vma);
-		size += kobjsize((void *) vma->vm_start);
+		region = vma->vm_region;
+		if (region) {
+			size += kobjsize(region);
+			size += region->vm_end - region->vm_start;
+		}
 	}
 
 	size += (*text = mm->end_code - mm->start_code);

