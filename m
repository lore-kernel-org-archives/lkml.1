Return-Path: <linux-kernel-owner+w=401wt.eu-S1762922AbXIKIXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762922AbXIKIXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 04:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760971AbXIKIXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 04:23:21 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:54871 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760534AbXIKIXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 04:23:20 -0400
Date: Tue, 11 Sep 2007 17:23:07 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, David Howells <dhowells@redhat.com>,
       Greg Ungerer <gerg@snapgear.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm] splice: Disable vmsplice on nommu.
Message-ID: <20070911082307.GB19495@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Greg Ungerer <gerg@snapgear.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The vmsplice rework in -mm breaks nommu:

fs/built-in.o: In function `splice_setup_vma':
fs/splice.c:1272: undefined reference to `may_expand_vm'
fs/splice.c:1272: undefined reference to `protection_map'
fs/splice.c:1272: undefined reference to `insert_vm_struct'
fs/splice.c:1272: undefined reference to `vm_stat_account'

This is going to be non-trivial to wire up properly on nommu, and
it's debateable whether there's even any point in trying. For now,
disable vmsplice if CONFIG_MMU=n and wire it up as a cond syscall
for the platforms that support both.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 fs/splice.c     |    2 ++
 kernel/sys_ni.c |    1 +
 2 files changed, 3 insertions(+)

--- linux-2.6.23-rc4-mm1.orig/fs/splice.c	2007-09-11 15:15:54.000000000 +0900
+++ linux-2.6.23-rc4-mm1/fs/splice.c	2007-09-11 17:11:02.000000000 +0900
@@ -1180,6 +1180,7 @@
 	return -EINVAL;
 }
 
+#ifdef CONFIG_MMU
 /*
  * Undo vmsplice_to_user map. Basically just lookup the vmas and
  * detach/unmap/remove them.
@@ -1686,6 +1687,7 @@
 
 	return error;
 }
+#endif /* CONFIG_MMU */
 
 asmlinkage long sys_splice(int fd_in, loff_t __user *off_in,
 			   int fd_out, loff_t __user *off_out,
--- linux-2.6.23-rc4-mm1.orig/kernel/sys_ni.c	2007-09-11 15:15:56.000000000 +0900
+++ linux-2.6.23-rc4-mm1/kernel/sys_ni.c	2007-09-11 17:09:24.000000000 +0900
@@ -139,6 +139,7 @@
 cond_syscall(sys_madvise);
 cond_syscall(sys_mremap);
 cond_syscall(sys_remap_file_pages);
+cond_syscall(sys_vmsplice);
 cond_syscall(compat_sys_move_pages);
 cond_syscall(compat_sys_migrate_pages);
 
