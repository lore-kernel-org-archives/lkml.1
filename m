Return-Path: <linux-kernel-owner+w=401wt.eu-S1758108AbXI1IDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbXI1IDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757431AbXI1IBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:01:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352AbXI1IBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:01:41 -0400
Message-Id: <20070928080042.396947000@chello.nl>
References: <20070928074200.436463000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 28 Sep 2007 09:42:09 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Cc: Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 09/12] lockdep: add a page lock class per filesystem type
Content-Disposition: inline; filename=lockdep-fs-page.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a different page lock class per filesystem, so we can properly
express the neseting relations between filesystems.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/filesystems.c   |    1 +
 include/linux/fs.h |    5 +++++
 2 files changed, 6 insertions(+)

Index: linux-2.6/fs/filesystems.c
===================================================================
--- linux-2.6.orig/fs/filesystems.c
+++ linux-2.6/fs/filesystems.c
@@ -73,6 +73,7 @@ int register_filesystem(struct file_syst
 	if (fs->next)
 		return -EBUSY;
 	INIT_LIST_HEAD(&fs->fs_supers);
+	lockdep_init_map(&fs->s_mapping_map, fs->name, &fs->s_mapping_key, 0);
 	write_lock(&file_systems_lock);
 	p = find_filesystem(fs->name, strlen(fs->name));
 	if (*p)
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -1302,8 +1302,13 @@ struct file_system_type {
 	struct module *owner;
 	struct file_system_type * next;
 	struct list_head fs_supers;
+
 	struct lock_class_key s_lock_key;
 	struct lock_class_key s_umount_key;
+	struct lock_class_key s_mapping_key;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map s_mapping_map;
+#endif
 };
 
 extern int get_sb_bdev(struct file_system_type *fs_type,

--

