Return-Path: <linux-kernel-owner+w=401wt.eu-S932950AbYDYWUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbYDYWUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 18:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762608AbYDYWTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 18:19:55 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40553 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762510AbYDYWTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 18:19:54 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 07/12] Unionfs: set append offset correctly for copied-up files
Date: Fri, 25 Apr 2008 18:19:03 -0400
Message-Id: <12091619511099-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12091619483888-git-send-email-ezk@cs.sunysb.edu>
References: <12091619483888-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 0fc7963..83034c2 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -258,9 +258,13 @@ static int do_delayed_copyup(struct file *file)
 		else
 			err = copyup_deleted_file(file, dentry, bstart,
 						  bindex);
-
-		if (!err)
+		/* if succeeded, set lower open-file flags and break */
+		if (!err) {
+			struct file *lower_file;
+			lower_file = unionfs_lower_file_idx(file, bindex);
+			lower_file->f_flags = file->f_flags;
 			break;
+		}
 	}
 	if (err || (bstart <= fbstart(file)))
 		goto out;
@@ -491,6 +495,10 @@ static int __open_file(struct inode *inode, struct file *file)
 			}
 			return err;
 		} else {
+			/*
+			 * turn off writeable flags, to force delayed copyup
+			 * by caller.
+			 */
 			lower_flags &= ~(OPEN_WRITE_FLAGS);
 		}
 	}
-- 
1.5.2.2

