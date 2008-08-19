Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbYHSGDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbYHSGDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 02:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbYHSGDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 02:03:03 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:14074 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752443AbYHSGDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 02:03:02 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ian Campbell <ijc@hellion.org.uk>,
       Jaya Kumar <jayakumar.lkml@gmail.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hugh Dickins <hugh@veritas.com>, Johannes Weiner <hannes@saeurebad.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Kel Modderman <kel@otaku42.de>,
       Markus Armbruster <armbru@redhat.com>
Date: Tue, 19 Aug 2008 07:02:45 +0100
Message-Id: <1219125765-31833-1-git-send-email-ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.6.3
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCH] fbdefio: add set_page_dirty handler to deferred IO FB
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes kernel BUG at lib/radix-tree.c:473.

Previously the handler was incidentally provided by tmpfs but this was
removed with:

  commit 14fcc23fdc78e9d32372553ccf21758a9bd56fa1
  Author: Hugh Dickins <hugh@veritas.com>
  Date:   Mon Jul 28 15:46:19 2008 -0700

    tmpfs: fix kernel BUG in shmem_delete_inode

relying on this behaviour was incorrect in any case and the BUG
also appeared when the device node was on an ext3 filesystem.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
Acked-by: Jaya Kumar <jayakumar.lkml@gmail.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Johannes Weiner <hannes@saeurebad.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Kel Modderman <kel@otaku42.de>
Cc: Markus Armbruster <armbru@redhat.com>
Cc: stable@vger.kernel.org [14fcc23fd is in 2.6.25.14 and 2.6.26.1]
---
 drivers/video/fb_defio.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/video/fb_defio.c b/drivers/video/fb_defio.c
index 59df132..214bb7c 100644
--- a/drivers/video/fb_defio.c
+++ b/drivers/video/fb_defio.c
@@ -114,11 +114,23 @@ static struct vm_operations_struct fb_deferred_io_vm_ops = {
 	.page_mkwrite	= fb_deferred_io_mkwrite,
 };
 
+static int fb_deferred_io_set_page_dirty(struct page *page)
+{
+	if (!PageDirty(page))
+		SetPageDirty(page);
+	return 0;
+}
+
+static const struct address_space_operations fb_deferred_io_aops = {
+	.set_page_dirty = fb_deferred_io_set_page_dirty,
+};
+
 static int fb_deferred_io_mmap(struct fb_info *info, struct vm_area_struct *vma)
 {
 	vma->vm_ops = &fb_deferred_io_vm_ops;
 	vma->vm_flags |= ( VM_IO | VM_RESERVED | VM_DONTEXPAND );
 	vma->vm_private_data = info;
+	vma->vm_file->f_mapping->a_ops = &fb_deferred_io_aops;
 	return 0;
 }
 
-- 
1.5.6.3

