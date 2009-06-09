Return-Path: <linux-kernel-owner+w=401wt.eu-S1760933AbZFIKYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760933AbZFIKYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760645AbZFIKTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:19:10 -0400
Received: from kroah.org ([198.145.64.141]:54734 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760641AbZFIKTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:19:08 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:59 2009
Message-Id: <20090609094059.462757128@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:20 -0700
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
       alan@lxorguk.ukuu.org.uk, Mel Gorman <mel@csn.ul.ie>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Ingo Molnar <mingo@elte.hu>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       <starlight@binnacle.cx>, Eric B Munson <ebmunson@us.ibm.com>,
       Adam Litke <agl@us.ibm.com>, Andy Whitcroft <apw@canonical.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 32/87] mm: account for MAP_SHARED mappings using VM_MAYSHARE and not VM_SHARED in hugetlbfs
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=mm-account-for-map_shared-mappings-using-vm_mayshare-and-not-vm_shared-in-hugetlbfs.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mel Gorman <mel@csn.ul.ie>

commit f83a275dbc5ca1721143698e844243fcadfabf6a upstream.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13302

hugetlbfs reserves huge pages but does not fault them at mmap() time to
ensure that future faults succeed.  The reservation behaviour differs
depending on whether the mapping was mapped MAP_SHARED or MAP_PRIVATE.
For MAP_SHARED mappings, hugepages are reserved when mmap() is first
called and are tracked based on information associated with the inode.
Other processes mapping MAP_SHARED use the same reservation.  MAP_PRIVATE
track the reservations based on the VMA created as part of the mmap()
operation.  Each process mapping MAP_PRIVATE must make its own
reservation.

hugetlbfs currently checks if a VMA is MAP_SHARED with the VM_SHARED flag
and not VM_MAYSHARE.  For file-backed mappings, such as hugetlbfs,
VM_SHARED is set only if the mapping is MAP_SHARED and the file was opened
read-write.  If a shared memory mapping was mapped shared-read-write for
populating of data and mapped shared-read-only by other processes, then
hugetlbfs would account for the mapping as if it was MAP_PRIVATE.  This
causes processes to fail to map the file MAP_SHARED even though it should
succeed as the reservation is there.

This patch alters mm/hugetlb.c and replaces VM_SHARED with VM_MAYSHARE
when the intent of the code was to check whether the VMA was mapped
MAP_SHARED or MAP_PRIVATE.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: <starlight@binnacle.cx>
Cc: Eric B Munson <ebmunson@us.ibm.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/hugetlb.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -316,7 +316,7 @@ static void resv_map_release(struct kref
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma)
 {
 	VM_BUG_ON(!is_vm_hugetlb_page(vma));
-	if (!(vma->vm_flags & VM_SHARED))
+	if (!(vma->vm_flags & VM_MAYSHARE))
 		return (struct resv_map *)(get_vma_private_data(vma) &
 							~HPAGE_RESV_MASK);
 	return NULL;
@@ -325,7 +325,7 @@ static struct resv_map *vma_resv_map(str
 static void set_vma_resv_map(struct vm_area_struct *vma, struct resv_map *map)
 {
 	VM_BUG_ON(!is_vm_hugetlb_page(vma));
-	VM_BUG_ON(vma->vm_flags & VM_SHARED);
+	VM_BUG_ON(vma->vm_flags & VM_MAYSHARE);
 
 	set_vma_private_data(vma, (get_vma_private_data(vma) &
 				HPAGE_RESV_MASK) | (unsigned long)map);
@@ -334,7 +334,7 @@ static void set_vma_resv_map(struct vm_a
 static void set_vma_resv_flags(struct vm_area_struct *vma, unsigned long flags)
 {
 	VM_BUG_ON(!is_vm_hugetlb_page(vma));
-	VM_BUG_ON(vma->vm_flags & VM_SHARED);
+	VM_BUG_ON(vma->vm_flags & VM_MAYSHARE);
 
 	set_vma_private_data(vma, get_vma_private_data(vma) | flags);
 }
@@ -353,7 +353,7 @@ static void decrement_hugepage_resv_vma(
 	if (vma->vm_flags & VM_NORESERVE)
 		return;
 
-	if (vma->vm_flags & VM_SHARED) {
+	if (vma->vm_flags & VM_MAYSHARE) {
 		/* Shared mappings always use reserves */
 		h->resv_huge_pages--;
 	} else if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
@@ -369,14 +369,14 @@ static void decrement_hugepage_resv_vma(
 void reset_vma_resv_huge_pages(struct vm_area_struct *vma)
 {
 	VM_BUG_ON(!is_vm_hugetlb_page(vma));
-	if (!(vma->vm_flags & VM_SHARED))
+	if (!(vma->vm_flags & VM_MAYSHARE))
 		vma->vm_private_data = (void *)0;
 }
 
 /* Returns true if the VMA has associated reserve pages */
 static int vma_has_reserves(struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & VM_SHARED)
+	if (vma->vm_flags & VM_MAYSHARE)
 		return 1;
 	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER))
 		return 1;
@@ -924,7 +924,7 @@ static int vma_needs_reservation(struct 
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	struct inode *inode = mapping->host;
 
-	if (vma->vm_flags & VM_SHARED) {
+	if (vma->vm_flags & VM_MAYSHARE) {
 		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
 		return region_chg(&inode->i_mapping->private_list,
 							idx, idx + 1);
@@ -949,7 +949,7 @@ static void vma_commit_reservation(struc
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	struct inode *inode = mapping->host;
 
-	if (vma->vm_flags & VM_SHARED) {
+	if (vma->vm_flags & VM_MAYSHARE) {
 		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
 		region_add(&inode->i_mapping->private_list, idx, idx + 1);
 
@@ -1893,7 +1893,7 @@ retry_avoidcopy:
 	 * at the time of fork() could consume its reserves on COW instead
 	 * of the full address range.
 	 */
-	if (!(vma->vm_flags & VM_SHARED) &&
+	if (!(vma->vm_flags & VM_MAYSHARE) &&
 			is_vma_resv_set(vma, HPAGE_RESV_OWNER) &&
 			old_page != pagecache_page)
 		outside_reserve = 1;
@@ -2000,7 +2000,7 @@ retry:
 		clear_huge_page(page, address, huge_page_size(h));
 		__SetPageUptodate(page);
 
-		if (vma->vm_flags & VM_SHARED) {
+		if (vma->vm_flags & VM_MAYSHARE) {
 			int err;
 			struct inode *inode = mapping->host;
 
@@ -2104,7 +2104,7 @@ int hugetlb_fault(struct mm_struct *mm, 
 			goto out_mutex;
 		}
 
-		if (!(vma->vm_flags & VM_SHARED))
+		if (!(vma->vm_flags & VM_MAYSHARE))
 			pagecache_page = hugetlbfs_pagecache_page(h,
 								vma, address);
 	}
@@ -2289,7 +2289,7 @@ int hugetlb_reserve_pages(struct inode *
 	 * to reserve the full area even if read-only as mprotect() may be
 	 * called to make the mapping read-write. Assume !vma is a shm mapping
 	 */
-	if (!vma || vma->vm_flags & VM_SHARED)
+	if (!vma || vma->vm_flags & VM_MAYSHARE)
 		chg = region_chg(&inode->i_mapping->private_list, from, to);
 	else {
 		struct resv_map *resv_map = resv_map_alloc();
@@ -2330,7 +2330,7 @@ int hugetlb_reserve_pages(struct inode *
 	 * consumed reservations are stored in the map. Hence, nothing
 	 * else has to be done for private mappings here
 	 */
-	if (!vma || vma->vm_flags & VM_SHARED)
+	if (!vma || vma->vm_flags & VM_MAYSHARE)
 		region_add(&inode->i_mapping->private_list, from, to);
 	return 0;
 }


