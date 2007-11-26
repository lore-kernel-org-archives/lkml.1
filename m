Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbXKZQpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbXKZQpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbXKZQp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:45:28 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52777 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668AbXKZQp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:45:26 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 10/16] Unionfs: create opaque directories' whiteouts unconditionally
Date: Mon, 26 Nov 2007 11:44:07 -0500
Message-Id: <11960954572168-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
References: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Needed to maintain Unix semantics (LTP testing).

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/subr.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/subr.c b/fs/unionfs/subr.c
index 968ee8c..1a26c57 100644
--- a/fs/unionfs/subr.c
+++ b/fs/unionfs/subr.c
@@ -162,6 +162,19 @@ int make_dir_opaque(struct dentry *dentry, int bindex)
 	struct dentry *lower_dentry, *diropq;
 	struct inode *lower_dir;
 	struct nameidata nd;
+	kernel_cap_t orig_cap;
+
+	/*
+	 * Opaque directory whiteout markers are special files (like regular
+	 * whiteouts), and should appear to the users as if they don't
+	 * exist.  They should be created/deleted regardless of directory
+	 * search/create permissions, but only for the duration of this
+	 * creation of the .wh.__dir_opaque: file.  Note, this does not
+	 * circumvent normal ->permission).
+	 */
+	orig_cap = current->cap_effective;
+	cap_raise(current->cap_effective, CAP_DAC_READ_SEARCH);
+	cap_raise(current->cap_effective, CAP_DAC_OVERRIDE);
 
 	lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
 	lower_dir = lower_dentry->d_inode;
@@ -189,6 +202,7 @@ int make_dir_opaque(struct dentry *dentry, int bindex)
 
 out:
 	mutex_unlock(&lower_dir->i_mutex);
+	current->cap_effective = orig_cap;
 	return err;
 }
 
-- 
1.5.2.2

