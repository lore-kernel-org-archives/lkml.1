Return-Path: <linux-kernel-owner+w=401wt.eu-S933496AbYDYWXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933496AbYDYWXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 18:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933028AbYDYWUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 18:20:32 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40567 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764072AbYDYWUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 18:20:00 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 10/12] Unionfs: maintain one-open-file invariant for non-directories
Date: Fri, 25 Apr 2008 18:19:06 -0400
Message-Id: <12091619533479-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12091619483888-git-send-email-ezk@cs.sunysb.edu>
References: <12091619483888-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 2706194..82b0eea 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -320,7 +320,9 @@ static int __unionfs_file_revalidate(struct file *file, struct dentry *dentry,
 	 * to refresh things.
 	 */
 	if (d_deleted(dentry) ||
-	    (sbgen <= fgen && dbstart(dentry) == fbstart(file)))
+	    (sbgen <= fgen &&
+	     dbstart(dentry) == fbstart(file) &&
+	     unionfs_lower_file(file)))
 		goto out_may_copyup;
 
 	/* save orig branch ID */
@@ -369,6 +371,8 @@ static int __unionfs_file_revalidate(struct file *file, struct dentry *dentry,
 			unionfs_mntput(sb->s_root,
 				       branch_id_to_idx(sb, orig_brid));
 		}
+		/* regular files have only one open lower file */
+		fbend(file) = fbstart(file);
 	}
 	atomic_set(&UNIONFS_F(file)->generation,
 		   atomic_read(&UNIONFS_I(dentry->d_inode)->generation));
@@ -381,6 +385,9 @@ out_may_copyup:
 		pr_debug("unionfs: do delay copyup of \"%s\"\n",
 			 dentry->d_name.name);
 		err = do_delayed_copyup(file);
+		/* regular files have only one open lower file */
+		if (!err && !S_ISDIR(dentry->d_inode->i_mode))
+			fbend(file) = fbstart(file);
 	}
 
 out:
-- 
1.5.2.2

