Return-Path: <linux-kernel-owner+w=401wt.eu-S932226AbXCXWJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbXCXWJh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 18:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbXCXWJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 18:09:37 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:35781 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbXCXWJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 18:09:36 -0400
To: akpm@linux-foundation.org
CC: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <E1HVEOB-0006fX-00@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Sat, 24 Mar 2007 23:07:07 +0100)
Subject: [patch 2/3] only allow nonlinear vmas for ram backed filesystems
References: <E1HVEOB-0006fX-00@dorka.pomaz.szeredi.hu>
Message-Id: <E1HVEQJ-0006gF-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 24 Mar 2007 23:09:19 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Dirty page accounting/limiting doesn't work for nonlinear mappings, so
for non-ram backed filesystems emulate with linear mappings.  This
retains ABI compatibility with previous kernels at minimal code cost.

All known users of nonlinear mappings actually use tmpfs, so this
shouldn't have any negative effect.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux-2.6.21-rc4-mm1/mm/fremap.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/mm/fremap.c	2007-03-24 22:30:05.000000000 +0100
+++ linux-2.6.21-rc4-mm1/mm/fremap.c	2007-03-24 22:37:59.000000000 +0100
@@ -181,6 +181,24 @@ asmlinkage long sys_remap_file_pages(uns
 			goto retry;
 		}
 		mapping = vma->vm_file->f_mapping;
+		/*
+		 * page_mkclean doesn't work on nonlinear vmas, so if dirty
+		 * pages need to be accounted, emulate with linear vmas.
+		 */
+		if (mapping_cap_account_dirty(mapping)) {
+			unsigned long addr;
+
+			flags &= MAP_NONBLOCK;
+			addr = mmap_region(vma->vm_file, start, size, flags,
+					   vma->vm_flags, pgoff, 1);
+			if (IS_ERR_VALUE(addr))
+				err = addr;
+			else {
+				BUG_ON(addr != start);
+				err = 0;
+			}
+			goto out;
+		}
 		spin_lock(&mapping->i_mmap_lock);
 		flush_dcache_mmap_lock(mapping);
 		vma->vm_flags |= VM_NONLINEAR;
