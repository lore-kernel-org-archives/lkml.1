Return-Path: <linux-kernel-owner+w=401wt.eu-S1765782AbYD1GRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765782AbYD1GRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbYD1GQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:16:46 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:48111 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751078AbYD1GQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:16:44 -0400
X-Sasl-enc: 1sPFgftUD3bb/j6jVWuKLtvK5WSVc1btJLIsLd2n8aja 1209363341
Date: Mon, 28 Apr 2008 14:14:54 +0800 (WST)
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH] autofs4 - use lookup access intent to support recursive bind
 mounts
Message-ID: <Pine.LNX.4.64.0804281410160.10684@raven.themaw.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew,

For autofs maps that recursively reference other map entries in their
mount point path we need to ensure that these mounts are performed
prior to the current mount request being done. We've used the access
system call, made just prior to performing the mount, to make this
happen. In the case of bind mounts, however, the lookup flags in 
the path walk don't trigger a mount. To do this we need to also
trigger a mount when we see the LOOKUP_ACCESS flag.

Signed-off-by: Ian Kent <raven@themaw.net>

Ian

---
diff -up linux-2.6.25-mm1/fs/autofs4/root.c.lookup-access-intent-trigger linux-2.6.25-mm1/fs/autofs4/root.c
--- linux-2.6.25-mm1/fs/autofs4/root.c.lookup-access-intent-trigger	2008-04-28 11:33:20.000000000 +0800
+++ linux-2.6.25-mm1/fs/autofs4/root.c	2008-04-28 11:36:06.000000000 +0800
@@ -19,6 +19,8 @@
 #include <linux/time.h>
 #include "autofs_i.h"
 
+#define LOOKUP_TRIGGER_FLAGS (LOOKUP_CONTINUE|LOOKUP_DIRECTORY|LOOKUP_ACCESS)
+
 static int autofs4_dir_symlink(struct inode *,struct dentry *,const char *);
 static int autofs4_dir_unlink(struct inode *,struct dentry *);
 static int autofs4_dir_rmdir(struct inode *,struct dentry *);
@@ -291,7 +293,7 @@ static int try_to_fill_dentry(struct den
 			return status;
 		}
 	/* Trigger mount for path component or follow link */
-	} else if (flags & (LOOKUP_CONTINUE | LOOKUP_DIRECTORY) ||
+	} else if (flags & LOOKUP_TRIGGER_FLAGS ||
 			current->link_count) {
 		DPRINTK("waiting for mount name=%.*s",
 			dentry->d_name.len, dentry->d_name.name);
@@ -335,7 +337,7 @@ static void *autofs4_follow_link(struct 
 		nd->flags);
 
 	/* If it's our master or we shouldn't trigger a mount we're done */
-	lookup_type = nd->flags & (LOOKUP_CONTINUE | LOOKUP_DIRECTORY);
+	lookup_type = nd->flags & LOOKUP_TRIGGER_FLAGS;
 	if (oz_mode || !lookup_type)
 		goto done;
 
