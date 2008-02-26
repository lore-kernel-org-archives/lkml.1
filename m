Return-Path: <linux-kernel-owner+w=401wt.eu-S1761438AbYBZD0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761438AbYBZD0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 22:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759720AbYBZDZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 22:25:59 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:50264 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758793AbYBZDZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 22:25:58 -0500
X-Sasl-enc: D/gWU+CK2zN8fB/0VrBVZ+lY2L1xEB2k8TOPQdSyUSbo 1203996356
Date: Tue, 26 Feb 2008 12:23:20 +0900 (WST)
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 3/4] autofs4 - track uid and gid of last mount requestor
In-Reply-To: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>
Message-ID: <Pine.LNX.4.64.0802261208400.8490@raven.themaw.net>
References: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Patch to track the uid and gid of the last process to request
a mount for on an autofs dentry.

Signed-off-by: Ian Kent < raven@themaw.net>

Ian

---
diff -up linux-2.6.25-rc2-mm1/fs/autofs4/inode.c.track-last-mount-ids linux-2.6.25-rc2-mm1/fs/autofs4/inode.c
--- linux-2.6.25-rc2-mm1/fs/autofs4/inode.c.track-last-mount-ids	2008-02-20 13:11:28.000000000 +0900
+++ linux-2.6.25-rc2-mm1/fs/autofs4/inode.c	2008-02-20 13:12:23.000000000 +0900
@@ -43,6 +43,8 @@ struct autofs_info *autofs4_init_ino(str
 
 	ino->flags = 0;
 	ino->mode = mode;
+	ino->uid = 0;
+	ino->gid = 0;
 	ino->inode = NULL;
 	ino->dentry = NULL;
 	ino->size = 0;
diff -up linux-2.6.25-rc2-mm1/fs/autofs4/autofs_i.h.track-last-mount-ids linux-2.6.25-rc2-mm1/fs/autofs4/autofs_i.h
--- linux-2.6.25-rc2-mm1/fs/autofs4/autofs_i.h.track-last-mount-ids	2008-02-20 13:14:03.000000000 +0900
+++ linux-2.6.25-rc2-mm1/fs/autofs4/autofs_i.h	2008-02-20 13:14:34.000000000 +0900
@@ -58,6 +58,9 @@ struct autofs_info {
 	unsigned long last_used;
 	atomic_t count;
 
+	uid_t uid;
+	gid_t gid;
+
 	mode_t	mode;
 	size_t	size;
 
diff -up linux-2.6.25-rc2-mm1/fs/autofs4/waitq.c.track-last-mount-ids linux-2.6.25-rc2-mm1/fs/autofs4/waitq.c
--- linux-2.6.25-rc2-mm1/fs/autofs4/waitq.c.track-last-mount-ids	2008-02-20 13:06:20.000000000 +0900
+++ linux-2.6.25-rc2-mm1/fs/autofs4/waitq.c	2008-02-20 13:10:23.000000000 +0900
@@ -363,6 +363,38 @@ int autofs4_wait(struct autofs_sb_info *
 
 	status = wq->status;
 
+	/*
+	 * For direct and offset mounts we need to track the requestor
+	 * uid and gid in the dentry info struct. This is so it can be
+	 * supplied, on request, by the misc device ioctl interface.
+	 * This is needed during daemon resatart when reconnecting
+	 * to existing, active, autofs mounts. The uid and gid (and
+	 * related string values) may be used for macro substitution
+	 * in autofs mount maps.
+	 */
+	if (!status) {
+		struct dentry *de = NULL;
+
+		/* direct mount or browsable map */
+		ino = autofs4_dentry_ino(dentry);
+		if (!ino) {
+			/* If not lookup actual dentry used */
+			de = d_lookup(dentry->d_parent, &dentry->d_name);
+			ino = autofs4_dentry_ino(de);
+		}
+
+		/* Set mount requestor */
+		if (ino) {
+			if (ino) {
+				ino->uid = wq->uid;
+				ino->gid = wq->gid;
+			}
+		}
+
+		if (de)
+			dput(de);
+	}
+
 	/* Are we the last process to need status? */
 	if (atomic_dec_and_test(&wq->wait_ctr))
 		kfree(wq);
