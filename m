Return-Path: <linux-kernel-owner+w=401wt.eu-S935691AbXGZTHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935691AbXGZTHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 15:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761783AbXGZTHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 15:07:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761445AbXGZTHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 15:07:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] NOMMU: Fix SYSV IPC SHM
To: torvalds@osdl.org, akpm@osdl.org, npiggin@suse.de
Cc: linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org, dhowells@redhat.com
Date: Thu, 26 Jul 2007 20:06:15 +0100
Message-ID: <20070726190615.32553.7958.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Fix the SYSV IPC SHM to work with the changes applied by the new fault handler
patches when CONFIG_MMU=n.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ramfs/file-nommu.c |    7 ++++++-
 ipc/shm.c             |    2 ++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index cad2b7a..237fe8b 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -295,5 +295,10 @@ unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
  */
 int ramfs_nommu_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	return vma->vm_flags & VM_SHARED ? 0 : -ENOSYS;
+	if (!(vma->vm_flags & VM_SHARED))
+		return -ENOSYS;
+
+	file_accessed(file);
+	vma->vm_ops = &generic_file_vm_ops;
+	return 0;
 }
diff --git a/ipc/shm.c b/ipc/shm.c
index d0259e3..d88ac5a 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -268,7 +268,9 @@ static int shm_mmap(struct file * file, struct vm_area_struct * vma)
 	if (ret != 0)
 		return ret;
 	sfd->vm_ops = vma->vm_ops;
+#ifdef CONFIG_MMU
 	BUG_ON(!sfd->vm_ops->fault);
+#endif
 	vma->vm_ops = &shm_vm_ops;
 	shm_open(vma);
 

