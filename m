Return-Path: <linux-kernel-owner+w=401wt.eu-S1760339AbZLPDIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760339AbZLPDIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 22:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755682AbZLPDIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 22:08:22 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52261 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbZLPDIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 22:08:21 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 16 Dec 2009 12:04:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>, andi@firstfloor.org,
       minchan.kim@gmail.com
Subject: [mm][RFC][PATCH 4/11] mm accessor for kvm
Message-Id: <20091216120423.13636fe3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mm_accessor in /kvm layer.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 security/tomoyo/common.c |    4 ++--
 virt/kvm/kvm_main.c      |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

Index: mmotm-mm-accessor/virt/kvm/kvm_main.c
===================================================================
--- mmotm-mm-accessor.orig/virt/kvm/kvm_main.c
+++ mmotm-mm-accessor/virt/kvm/kvm_main.c
@@ -843,18 +843,18 @@ pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t 
 	if (unlikely(npages != 1)) {
 		struct vm_area_struct *vma;
 
-		down_read(&current->mm->mmap_sem);
+		mm_read_lock(current->mm);
 		vma = find_vma(current->mm, addr);
 
 		if (vma == NULL || addr < vma->vm_start ||
 		    !(vma->vm_flags & VM_PFNMAP)) {
-			up_read(&current->mm->mmap_sem);
+			mm_read_unlock(current->mm);
 			get_page(bad_page);
 			return page_to_pfn(bad_page);
 		}
 
 		pfn = ((addr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
-		up_read(&current->mm->mmap_sem);
+		mm_read_unlock(current->mm);
 		BUG_ON(!kvm_is_mmio_pfn(pfn));
 	} else
 		pfn = page_to_pfn(page[0]);

