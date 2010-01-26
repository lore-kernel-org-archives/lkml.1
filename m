Return-Path: <linux-kernel-owner+w=401wt.eu-S1751314Ab0AZFT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314Ab0AZFT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 00:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850Ab0AZFT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 00:19:27 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53813 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab0AZFT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 00:19:27 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Roman Jarosz" <kedgedev@gmail.com>
Subject: Re: OOM-Killer kills too much with 2.6.32.2
Cc: kosaki.motohiro@jp.fujitsu.com, lkml <linux-kernel@vger.kernel.org>,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>, michael@reinelt.co.at,
       jcnengel@googlemail.com, rientjes@google.com, earny@net4u.de,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
In-Reply-To: <op.u63v1pxzasvm2a@kedge>
References: <20100125104728.4935.A69D9226@jp.fujitsu.com> <op.u63v1pxzasvm2a@kedge>
Message-Id: <20100126141055.5AAD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 26 Jan 2010 14:19:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc to lots related person)

> On Mon, 25 Jan 2010 02:48:08 +0100, KOSAKI Motohiro  
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> >> Hi,
> >>
> >> since kernel 2.6.32.2 (also tried 2.6.32.3) I get a lot of oom-killer
> >> kills when I do hard disk intensive tasks (mainly in VirtualBox which is
> >> running Windows XP) and IMHO it kills processes even if I have a lot of
> >> free memory.
> >>
> >> Is this a known bug? I have self compiled kernel so I can try patches.
> >
> > Can you please post your .config?

Hi all,

Strangely, all reproduce machine are x86_64 with Intel i915. but I don't
have any solid evidence.
Can anyone please apply following debug patch and reproduce this issue?

this patch write some debug message into /var/log/messages.

Thanks.



---
 mm/memory.c |   45 +++++++++++++++++++++++++++++++++++++--------
 1 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 09e4b1b..5c9ebd8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2128,17 +2128,23 @@ reuse:
 gotten:
 	pte_unmap_unlock(page_table, ptl);
 
-	if (unlikely(anon_vma_prepare(vma)))
+	if (unlikely(anon_vma_prepare(vma))) {
+		printk(KERN_ERR "OOM at %s:%d\n", __FILE__, __LINE__);
 		goto oom;
+	}
 
 	if (is_zero_pfn(pte_pfn(orig_pte))) {
 		new_page = alloc_zeroed_user_highpage_movable(vma, address);
-		if (!new_page)
+		if (!new_page) {
+			printk(KERN_ERR "OOM at %s:%d\n", __FILE__, __LINE__);
 			goto oom;
+		}
 	} else {
 		new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
-		if (!new_page)
+		if (!new_page) {
+			printk(KERN_ERR "OOM at %s:%d\n", __FILE__, __LINE__);
 			goto oom;
+		}
 		cow_user_page(new_page, old_page, address, vma);
 	}
 	__SetPageUptodate(new_page);
@@ -2153,8 +2159,10 @@ gotten:
 		unlock_page(old_page);
 	}
 
-	if (mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))
+	if (mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL)) {
+		printk(KERN_ERR "OOM at %s:%d\n", __FILE__, __LINE__);
 		goto oom_free_new;
+	}
 
 	/*
 	 * Re-check the pte - we dropped the lock
@@ -2272,6 +2280,10 @@ oom:
 
 unwritable_page:
 	page_cache_release(old_page);
+
+	if (ret & VM_FAULT_OOM)
+		printk(KERN_ERR "do_wp ->page_mkwrite OOM %pf %x\n", vma->vm_ops->page_mkwrite, ret);
+
 	return ret;
 }
 
@@ -2670,15 +2682,21 @@ static int do_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	/* Allocate our own private page. */
 	pte_unmap(page_table);
 
-	if (unlikely(anon_vma_prepare(vma)))
+	if (unlikely(anon_vma_prepare(vma))) {
+		printk(KERN_ERR "OOM at %s:%d\n", __FILE__, __LINE__);
 		goto oom;
+	}
 	page = alloc_zeroed_user_highpage_movable(vma, address);
-	if (!page)
+	if (!page) {
+		printk(KERN_ERR "OOM at %s:%d\n", __FILE__, __LINE__);
 		goto oom;
+	}
 	__SetPageUptodate(page);
 
-	if (mem_cgroup_newpage_charge(page, mm, GFP_KERNEL))
+	if (mem_cgroup_newpage_charge(page, mm, GFP_KERNEL)) {
+		printk(KERN_ERR "OOM at %s:%d\n", __FILE__, __LINE__);
 		goto oom_free_page;
+	}
 
 	entry = mk_pte(page, vma->vm_page_prot);
 	if (vma->vm_flags & VM_WRITE)
@@ -2742,8 +2760,12 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	vmf.page = NULL;
 
 	ret = vma->vm_ops->fault(vma, &vmf);
-	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
+	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE))) {
+		if (ret & VM_FAULT_OOM)
+			printk(KERN_ERR "->fault OOM %pf %x %x\n", vma->vm_ops->fault, ret, flags);
+
 		return ret;
+	}
 
 	if (unlikely(PageHWPoison(vmf.page))) {
 		if (ret & VM_FAULT_LOCKED)
@@ -2768,16 +2790,19 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		if (!(vma->vm_flags & VM_SHARED)) {
 			anon = 1;
 			if (unlikely(anon_vma_prepare(vma))) {
+				printk(KERN_ERR "OOM at %s:%d\n", __FILE__, __LINE__);
 				ret = VM_FAULT_OOM;
 				goto out;
 			}
 			page = alloc_page_vma(GFP_HIGHUSER_MOVABLE,
 						vma, address);
 			if (!page) {
+				printk(KERN_ERR "OOM at %s:%d\n", __FILE__, __LINE__);
 				ret = VM_FAULT_OOM;
 				goto out;
 			}
 			if (mem_cgroup_newpage_charge(page, mm, GFP_KERNEL)) {
+				printk(KERN_ERR "OOM at %s:%d\n", __FILE__, __LINE__);
 				ret = VM_FAULT_OOM;
 				page_cache_release(page);
 				goto out;
@@ -2896,6 +2921,10 @@ out:
 
 unwritable_page:
 	page_cache_release(page);
+
+	if (ret & VM_FAULT_OOM)
+		printk(KERN_ERR "->page_mkwrite OOM %pf %x %x\n", vma->vm_ops->page_mkwrite, ret, flags);
+
 	return ret;
 }
 
-- 
1.6.5.2



