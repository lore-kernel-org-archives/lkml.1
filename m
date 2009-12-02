Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbZLBPFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbZLBPFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbZLBPFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:05:38 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:41616 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbZLBPFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:05:37 -0500
Message-Id: <20091202150516.256915252@szeredi.hu>
References: <20091202150454.616582634@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Wed, 02 Dec 2009 16:04:58 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Trond.Myklebust@netapp.com
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 4/4] nfs: clean up sillyrenaming in nfs_rename()
Content-Disposition: inline; filename=nfs_rename_dont_instantiate.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

The d_instantiate(new_dentry, NULL) is superfluous, the dentry is
already negative.  Rehashing this dummy dentry isn't needed either,
d_move() works fine on an unhashed target.

The re-checking for busy after a failed nfs_sillyrename() is bogus
too: new_dentry->d_count < 2 would be a bug here.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/nfs/dir.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

Index: linux-2.6/fs/nfs/dir.c
===================================================================
--- linux-2.6.orig/fs/nfs/dir.c	2009-12-02 15:11:19.000000000 +0100
+++ linux-2.6/fs/nfs/dir.c	2009-12-02 15:11:30.000000000 +0100
@@ -1611,14 +1611,11 @@ static int nfs_rename(struct inode *old_
 
 			/* silly-rename the existing target ... */
 			err = nfs_sillyrename(new_dir, new_dentry);
-			if (!err) {
-				new_dentry = rehash = dentry;
-				new_inode = NULL;
-				/* instantiate the replacement target */
-				d_instantiate(new_dentry, NULL);
-			} else if (atomic_read(&new_dentry->d_count) > 1)
-				/* dentry still busy? */
+			if (err)
 				goto out;
+
+			new_dentry = dentry;
+			new_inode = NULL;
 		}
 	}
 

-- 
