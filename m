Return-Path: <linux-kernel-owner+w=401wt.eu-S1758791AbYFQMep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbYFQMep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 08:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758369AbYFQMeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 08:34:17 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:29064
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758324AbYFQMeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 08:34:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAFZJV0h8qbBs/2dsb2JhbACuIQ
X-IronPort-AV: E=Sophos;i="4.27,657,1204470000"; 
   d="scan'208";a="330449801"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 5/7] autofs4 - use lookup intent flags to trigger mounts
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Tue, 17 Jun 2008 20:24:00 +0800
Message-ID: <20080617122400.14725.61435.stgit@raven.themaw.net>
In-Reply-To: <20080617122336.14725.64829.stgit@raven.themaw.net>
References: <20080617122336.14725.64829.stgit@raven.themaw.net>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an open(2) call is made on an autofs mount point directory that
already exists and the O_DIRECTORY flag is not used the needed mount
callback to the daemon is not done. This leads to the path walk
continuing resulting in a callback to the daemon with an incorrect
key. open(2) is called without O_DIRECTORY by the "find" utility but
this should be handled properly anyway.

This happens because autofs needs to use the lookup flags to decide
when to callback to the daemon to perform a mount to prevent mount
storms. For example, an autofs indirect mount map that has the "browse"
option will have the mount point directories are pre-created and the
stat(2) call made by a color ls against each directory will cause all
these directories to be mounted. It is unfortunate we need to resort
to this but mount maps can be quite large. Additionally, if a user
manually umounts an autofs indirect mount the directory isn't removed
which also leads to this situation.

To resolve this autofs needs to use the lookup intent flags to enable
it to make this decision. This patch adds this check and triggers a
call back if any of the lookup intent flags are set as all these calls
warrant a mount attempt be requested.

I know that external VFS code which uses the lookup flags is something
that the VFS would like to eliminate but I have no choice as I can't
see any other way to do this. A VFS dentry or inode operation callback
which returns the lookup "type" (requires a definition) would be
sufficient. But this change is needed now and I'm not aware of the form
that coming VFS changes will take so I'm not willing to propose anything
along these lines.

If anyone can provide an alternate method I would be happy to use it.

Signed-off-by: Ian Kent <raven@themaw.net>

---

 fs/autofs4/root.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)


diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 236eb9b..7f3ebf1 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -31,6 +31,9 @@ static int autofs4_root_readdir(struct file * filp, void * dirent, filldir_t fil
 static struct dentry *autofs4_lookup(struct inode *,struct dentry *, struct nameidata *);
 static void *autofs4_follow_link(struct dentry *, struct nameidata *);
 
+#define TRIGGER_FLAGS   (LOOKUP_CONTINUE | LOOKUP_DIRECTORY)
+#define TRIGGER_INTENTS (LOOKUP_OPEN | LOOKUP_ACCESS | LOOKUP_CREATE)
+
 const struct file_operations autofs4_root_operations = {
 	.open		= dcache_dir_open,
 	.release	= dcache_dir_close,
@@ -291,7 +294,7 @@ static int try_to_fill_dentry(struct dentry *dentry, int flags)
 			return status;
 		}
 	/* Trigger mount for path component or follow link */
-	} else if (flags & (LOOKUP_CONTINUE | LOOKUP_DIRECTORY) ||
+	} else if (flags & (TRIGGER_FLAGS | TRIGGER_INTENTS) ||
 			current->link_count) {
 		DPRINTK("waiting for mount name=%.*s",
 			dentry->d_name.len, dentry->d_name.name);
@@ -336,7 +339,7 @@ static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
 		nd->flags);
 
 	/* If it's our master or we shouldn't trigger a mount we're done */
-	lookup_type = nd->flags & (LOOKUP_CONTINUE | LOOKUP_DIRECTORY);
+	lookup_type = nd->flags & (TRIGGER_FLAGS | TRIGGER_INTENTS);
 	if (oz_mode || !lookup_type)
 		goto done;
 
