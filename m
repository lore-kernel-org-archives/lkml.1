Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab0BLVKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 16:10:45 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:34882 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757563Ab0BLVKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 16:10:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=MXF0zsFjRm7usbtHUYdDUMTJjbBXU20MVGU7ZaFKZkiwGNT/NOK7KMJMKxyGyLGG7F
         U+k6ZO4wXE1wMzp7vGKlILflIFZsXLOggfTkG/+NNHqS8qm4qviX6NMi57+SMxlHm6Po
         kiJyu8s18XUKmbokZ502QK3xKakZTjQYYYNyQ=
Date: Fri, 12 Feb 2010 22:10:39 +0100
From: Joris Dolderer <vorstadtkind@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: eparis@redhat.com
Subject: [PATCH 2/3] dnotify: patches for tree-watching fsnotify interface
Message-ID: <20100212221039.13b81c8f@icecube>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify dnotify for the new tree-watching fsnotify interface: check
whether an event came from a child or a far descent.
Modify fsnotify_recalc_inode_mask call.

Signed-off-by: Joris Dolderer <vorstadtkind@googlemail.com>
---
diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index 7e54e52..6ef23cf 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -71,7 +71,7 @@ static void dnotify_recalc_inode_mask(struct
fsnotify_mark_entry *entry) return;
 
 	if (entry->inode)
-		fsnotify_recalc_inode_mask(entry->inode);
+		fsnotify_recalc_inode_mask(entry->inode, false);
 }
 
 /*
@@ -91,7 +91,12 @@ static int dnotify_handle_event(struct
fsnotify_group *group, struct dnotify_struct *dn;
 	struct dnotify_struct **prev;
 	struct fown_struct *fown;
-	__u32 test_mask = event->mask & ~FS_EVENT_ON_CHILD;
+	__u32 test_mask;
+
+	if (event->mask & FS_EVENT_ON_DESCENT)
+		return 0;
+
+	test_mask = event->mask & ~FS_EVENT_ON_CHILD;
 
 	to_tell = event->to_tell;
 
