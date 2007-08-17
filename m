Return-Path: <linux-kernel-owner+w=401wt.eu-S1759344AbXHQLuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344AbXHQLuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 07:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755802AbXHQLuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 07:50:07 -0400
Received: from mailout06.sul.t-online.de ([194.25.134.19]:34568 "EHLO
	mailout06.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755705AbXHQLuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 07:50:05 -0400
Message-ID: <46C58B4E.4080803@t-online.de>
Date: Fri, 17 Aug 2007 13:49:34 +0200
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070810)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Wu, Bryan" <Bryan.Wu@analog.com>
Subject: Re: [PATCH] NOMMU: Separate out VMAs
References: <23249.1186492623@redhat.com> <46B86FC1.7050601@t-online.de> <46695F6D.5050600@t-online.de> <8772.1186149811@redhat.com> <23350.1186492903@redhat.com>
In-Reply-To: <23350.1186492903@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------060405050503000009040109"
X-ID: JbrK5sZbQebWsNk4++He+HbrsjMYImzg1TE8QKSEgiBSC4h64YE40U
X-TOI-MSGID: d66574df-288c-43b1-ba42-7b4ef8030084
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060405050503000009040109
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

David Howells wrote:
> David Howells <dhowells@redhat.com> wrote:
> 
>> Yes.  I found the major leak this morning.  There may be a minor leak, but I'm
>> not convinced it's in the mmap stuff.  See revised patch.
> 
> Oops.  That was the old patch.  Try this one instead.
> 

Here are some changes to make it more stable on my system.  In 
do_mmap_private, I've commented out the logic to free excess pages, as 
it fragments terribly and causes a simple
  while true; do cat /proc/buddyinfo; done
loop to go oom.  Also, I think you're freeing high-order pages unaligned 
to their order?
In shrink_vma, we must save the mm across calls to remove_vma_from_mm 
(oops when telnetting into the box).
In do_munmap, we can deal with freeing more than one vma.  I've not 
touched the rb-tree logic in the shared file case, as I have no idea 
what it's trying to do given that only exact matches are allowed.

It still does not survive my mmap stress-tester, so I'll keep looking.

Why do we need vm_regions for anonymous memory?  Wouldn't it be enough 
to just have a VMA?


Bernd
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif

--------------060405050503000009040109
Content-Type: text/plain;
 name="fish.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fish.diff"

diff --width=180 -x '*~' -x '.*' -x 'Sys*' -dru linux-2.6.x-daves-baseline/mm/nommu.c linux-2.6.x/mm/nommu.c
--- linux-2.6.x-daves-baseline/mm/nommu.c	2007-08-14 21:20:43.000000000 +0200
+++ linux-2.6.x/mm/nommu.c	2007-08-16 19:11:29.000000000 +0200
@@ -922,19 +931,23 @@
 	total = 1 << order;
 	atomic_add(total, &mmap_pages_allocated);
 
-	point = len >> PAGE_SHIFT;
-	while (point < total) {
-		order = ilog2(total - point);
-		_debug("shave %u/%lu", 1 << order, total - point);
-		atomic_sub(1 << order, &mmap_pages_allocated);
-		__free_pages(pages + point, order);
-		point += 1 << order;
+	len = PAGE_SIZE << order;
+#if 0
+	while (total > (len >> PAGE_SHIFT)) {
+		unsigned long to_free;
+		order = ilog2(total - (len >> PAGE_SHIFT));
+		to_free = 1 << order;
+		_debug("shave %u/%lu", to_free, total - (len >> PAGE_SHIFT));
+		atomic_sub(to_free, &mmap_pages_allocated);
+		__free_pages(pages + total - to_free, order);
+		total -= to_free;
 	}
 
 	total = len >> PAGE_SHIFT;
 	for (point = 1; point < total; point++)
 		set_page_refcounted(&pages[point]);
-
+#endif
+	split_page(pages, order);
 	base = page_address(pages);
 	region->vm_start = vma->vm_start = (unsigned long) base;
 	region->vm_end   = vma->vm_end   = vma->vm_start + len;
@@ -1294,6 +1307,7 @@
 		      unsigned long from, unsigned long to)
 {
 	struct vm_region *region;
+	struct mm_struct *mm = vma->vm_mm;
 
 	_enter("");
 
@@ -1304,7 +1318,7 @@
 		vma->vm_end = from;
 	else
 		vma->vm_start = to;
-	add_vma_to_mm(vma->vm_mm, vma);
+	add_vma_to_mm(mm, vma);
 
 	/* cut the region down to size */
 	region = vma->vm_region;
@@ -1337,44 +1351,59 @@
 
 	_enter(",%lx,%zx", start, len);
 
-	/* find the first potentially overlapping VMA */
-	vma = find_vma(mm, start);
-	if (!vma) {
-		_leave(" = -EINVAL [no]");
-		return -EINVAL;
-	}
-
-	/* we're allowed to split an anonymous VMA but not a file-backed one */
-	if (vma->vm_file) {
-		do {
-			if (start > vma->vm_start) {
-				_leave(" = -EINVAL [miss]");
-				return -EINVAL;
-			}
-			if (end == vma->vm_end)
-				goto erase_whole_vma;
-			rb = rb_next(&vma->vm_rb);
-			vma = rb_entry(rb, struct vm_area_struct, vm_rb);
-		} while (rb);
-		_leave(" = -EINVAL [split file]");
-		return -EINVAL;
-	} else {
-		/* the region must be a subset of the VMA found */
-		if (start == vma->vm_start && end == vma->vm_end)
-			goto erase_whole_vma;
-		if (start < vma->vm_start || end > vma->vm_end) {
+	while (start < end) {
+		unsigned long this_end;
+		/* find the first potentially overlapping VMA */
+		vma = find_vma(mm, start);
+		if (!vma) {
+			_leave(" = -EINVAL [no]");
+			return -EINVAL;
+		}
+		if (start < vma->vm_start) {
 			_leave(" = -EINVAL [superset]");
 			return -EINVAL;
 		}
-		if (start != vma->vm_start && end != vma->vm_end) {
+
+		this_end = vma->vm_end;
+
+		/* See if we can delete the entire VMA.  */
+		if (start == vma->vm_start && end >= this_end) {
+			delete_vma_from_mm(vma);
+			put_vma(vma);
+			start = this_end;
+			continue;
+		}
+
+		/* we're allowed to split an anonymous VMA but not a file-backed one */
+		if (vma->vm_file) {
+			do {
+				if (start > vma->vm_start) {
+					_leave(" = -EINVAL [miss]");
+					return -EINVAL;
+				}
+				if (end == vma->vm_end)
+					goto erase_whole_vma;
+				rb = rb_next(&vma->vm_rb);
+				vma = rb_entry(rb, struct vm_area_struct, vm_rb);
+			} while (rb);
+			_leave(" = -EINVAL [split file]");
+			return -EINVAL;
+		} else {
+			if (start > vma->vm_start && end >= this_end) {
+				shrink_vma(vma, start, this_end);
+				start = this_end;
+			} else if (start == vma->vm_start && end < this_end) {
+				shrink_vma(vma, start, end);
+				break;
+			}
 			ret = split_vma(mm, vma, start, 1);
 			if (ret < 0) {
 				_leave(" = %d [split]", ret);
 				return ret;
-			}
+			}
 		}
-		return shrink_vma(vma, start, end);
 	}
+	return 0;
 
 erase_whole_vma:
 	delete_vma_from_mm(vma);

--------------060405050503000009040109--
