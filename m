Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab0BMJNk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 04:13:40 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:47247 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab0BMJNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 04:13:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=bCUwh8oPXPTNcMz9Rj1+I6uAe8QAL8nxE0FuKc2n9df3TkazTznkQ/9Zhvy4IAFyYZ
         VuwvTCqRLNU74hhB5rc/Pi0xWYN1ndBqiRnf4/ZaBpfVQASBsR7bWJW3gkFObQrmHYxM
         mtxvrZ6+Zf9GexdDHbaB+qSXvxkyKeCsw2tcU=
Date: Sat, 13 Feb 2010 10:07:24 +0100
From: Joris Dolderer <vorstadtkind@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: eparis@redhat.com
Subject: [PATCH 2/3] dnotify: changes for tree-watching fsnotify interface
Message-Id: <20100213100724.edc0aeb9.vorstadtkind@googlemail.com>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify dnotify for the new tree-watching fsnotify interface: check whether an event
came from a child or a far descent.
Modify fsnotify_recalc_inode_mask call.

Signed-off-by: Joris Dolderer <vorstadtkind@googlemail.com>
---
 fs/notify/dnotify/dnotify.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)
diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index 7e54e52..6ef23cf 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -71,7 +71,7 @@ static void dnotify_recalc_inode_mask(struct fsnotify_mark_entry *entry)
 		return;
 
 	if (entry->inode)
-		fsnotify_recalc_inode_mask(entry->inode);
+		fsnotify_recalc_inode_mask(entry->inode, false);
 }
 
 /*
@@ -91,7 +91,12 @@ static int dnotify_handle_event(struct fsnotify_group *group,
 	struct dnotify_struct *dn;
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
 
