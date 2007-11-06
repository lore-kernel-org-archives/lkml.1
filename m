Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbXKFPFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbXKFPFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 10:05:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbXKFPFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 10:05:31 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34358 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbXKFPFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 10:05:30 -0500
Subject: Re: problem in follow_hugetlb_page on ppc64 architecture with
	get_user_pages
From: aglitke <agl@us.ibm.com>
To: Christoph Raisch <RAISCH@de.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, general@lists.openfabrics.org,
       Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>
In-Reply-To: <OF6FC435A0.F59C9AD9-ONC125738B.002A5195-C125738B.002A424A@de.ibm.com>
References: <OF6FC435A0.F59C9AD9-ONC125738B.002A5195-C125738B.002A424A@de.ibm.com>
Content-Type: text/plain
Organization: IBM
Date: Tue, 06 Nov 2007 09:05:32 -0600
Message-Id: <1194361532.20383.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please try this patch and see if it helps.

commit 6decbd17d6fb70d50f6db2c348bb41d7246a67d1
Author: Adam Litke <agl@us.ibm.com>
Date:   Tue Nov 6 06:59:12 2007 -0800

    hugetlb: follow_hugetlb_page for write access
    
    When calling get_user_pages(), a write flag is passed in by the caller to
    indicate if write access is required on the faulted-in pages.  Currently,
    follow_hugetlb_page() ignores this flag and always faults pages for
    read-only access.
    
    This patch passes the write flag down to follow_hugetlb_page() and makes
    sure hugetlb_fault() is called with the right write_access parameter.
    
    Test patch only.  Not Signed-off.

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 3a19b03..31fa0a0 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -19,7 +19,7 @@ static inline int is_vm_hugetlb_page(struct vm_area_struct *vma)
 int hugetlb_sysctl_handler(struct ctl_table *, int, struct file *, void __user *, size_t *, loff_t *);
 int hugetlb_treat_movable_handler(struct ctl_table *, int, struct file *, void __user *, size_t *, loff_t *);
 int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *, struct vm_area_struct *);
-int follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *, struct page **, struct vm_area_struct **, unsigned long *, int *, int);
+int follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *, struct page **, struct vm_area_struct **, unsigned long *, int *, int, int);
 void unmap_hugepage_range(struct vm_area_struct *, unsigned long, unsigned long);
 void __unmap_hugepage_range(struct vm_area_struct *, unsigned long, unsigned long);
 int hugetlb_prefault(struct address_space *, struct vm_area_struct *);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index eab8c42..b645985 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -621,7 +621,8 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 
 int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			struct page **pages, struct vm_area_struct **vmas,
-			unsigned long *position, int *length, int i)
+			unsigned long *position, int *length, int i,
+			int write)
 {
 	unsigned long pfn_offset;
 	unsigned long vaddr = *position;
@@ -643,7 +644,7 @@ int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			int ret;
 
 			spin_unlock(&mm->page_table_lock);
-			ret = hugetlb_fault(mm, vma, vaddr, 0);
+			ret = hugetlb_fault(mm, vma, vaddr, write);
 			spin_lock(&mm->page_table_lock);
 			if (!(ret & VM_FAULT_ERROR))
 				continue;
diff --git a/mm/memory.c b/mm/memory.c
index f82b359..1bcd444 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1039,7 +1039,7 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 
 		if (is_vm_hugetlb_page(vma)) {
 			i = follow_hugetlb_page(mm, vma, pages, vmas,
-						&start, &len, i);
+						&start, &len, i, write);
 			continue;
 		}
 

On Tue, 2007-11-06 at 08:42 +0100, Christoph Raisch wrote:
> Hello,
> if get_user_pages is used on a hugetlb vma, and there was no previous write
> to the pages,
> follow_hugetlb_page will call
> ret = hugetlb_fault(mm, vma, vaddr, 0),
> although the page should be used for write access in get_user_pages.
> 
> We currently see this when testing Infiniband on ppc64 with ehca +
> hugetlbfs.
> From reading the code this should also be an issue on other architectures.
> Roland, Adam, are you aware of anything in this area with mellanox
> Infiniband cards or other usages with I/O adapters?
> 
> Gruss / Regards
> Christoph R. + Nam Ng.
> 
> 
-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

