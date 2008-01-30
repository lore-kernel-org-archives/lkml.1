Return-Path: <linux-kernel-owner+w=401wt.eu-S1760395AbYA3QzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760395AbYA3QzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 11:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbYA3QzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 11:55:08 -0500
Received: from styx.suse.cz ([82.119.242.94]:44537 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751492AbYA3QzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 11:55:06 -0500
Subject: Re: [PATCH] sys_remap_file_pages: fix ->vm_file accounting
From: Miklos Szeredi <mszeredi@suse.cz>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       William Lee Irwin III <wli@holomorphy.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <20080130142014.GA2164@tv-sign.ru>
References: <20080130142014.GA2164@tv-sign.ru>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 17:55:01 +0100
Message-Id: <1201712101.31222.22.camel@tucsk.pomaz.szeredi.hu>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-30 at 17:20 +0300, Oleg Nesterov wrote:
> Fix ->vm_file accounting, mmap_region() may do do_munmap().

Ouch!  I didn't think of that case at all...

There's a small problem with the patch: the vma itself is freed at
unmap, so the fput(vma->vm_file) may crash.  Here's an updated patch.

Thanks for spotting this!

Miklos
----


From: Oleg Nesterov <oleg@tv-sign.ru>

Fix ->vm_file accounting, mmap_region() may do do_munmap().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/mm/fremap.c
===================================================================
--- linux.orig/mm/fremap.c	2008-01-17 19:00:17.000000000 +0100
+++ linux/mm/fremap.c	2008-01-30 17:47:27.000000000 +0100
@@ -190,10 +190,13 @@ asmlinkage long sys_remap_file_pages(uns
 		 */
 		if (mapping_cap_account_dirty(mapping)) {
 			unsigned long addr;
+			struct file *file = vma->vm_file;
 
 			flags &= MAP_NONBLOCK;
-			addr = mmap_region(vma->vm_file, start, size,
+			get_file(file);
+			addr = mmap_region(file, start, size,
 					flags, vma->vm_flags, pgoff, 1);
+			fput(file);
 			if (IS_ERR_VALUE(addr)) {
 				err = addr;
 			} else {


