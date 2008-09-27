Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbYI0Wtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbYI0Wtn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 18:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbYI0Wtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 18:49:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:51004 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbYI0Wte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 18:49:34 -0400
Message-ID: <48DEB828.3020408@kernel.org>
Date: Sun, 28 Sep 2008 07:48:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, viro@hera.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] sysfs: use ilookup5() instead of ilookup5_nowait()
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 27 Sep 2008 22:49:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As inode creation is protected by sysfs_mutex, ilookup5_nowait()
always either fails to find at all or finds one which is fully
initialized, so using ilookup5_nowait() or ilookup5() doesn't make any
difference.  Switch to ilookup5() as it's planned to be removed.  This
change also makes lookup return value handling a bit simpler.

This change was suggested by Al Viro.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Al Viro <viro@hera.kernel.org>
---
Greg, can you please put this for 2.6.28?  This should be safe but
this isn't a bug fix and it's way too late for 2.6.27.  Thanks.

 fs/sysfs/dir.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index aedaeba..c04935c 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -370,17 +370,17 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
 	memset(acxt, 0, sizeof(*acxt));
 	acxt->parent_sd = parent_sd;
 
-	/* Lookup parent inode.  inode initialization and I_NEW
-	 * clearing are protected by sysfs_mutex.  By grabbing it and
-	 * looking up with _nowait variant, inode state can be
-	 * determined reliably.
+	/* Lookup parent inode.  inode initialization is protected by
+	 * sysfs_mutex, so inode existence can be determined by
+	 * looking up inode while holding sysfs_mutex.
 	 */
 	mutex_lock(&sysfs_mutex);
 
-	inode = ilookup5_nowait(sysfs_sb, parent_sd->s_ino, sysfs_ilookup_test,
-				parent_sd);
+	inode = ilookup5(sysfs_sb, parent_sd->s_ino, sysfs_ilookup_test,
+			 parent_sd);
+	if (inode) {
+		WARN_ON(inode->i_state & I_NEW);
 
-	if (inode && !(inode->i_state & I_NEW)) {
 		/* parent inode available */
 		acxt->parent_inode = inode;
 
@@ -393,8 +393,7 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
 			mutex_lock(&inode->i_mutex);
 			mutex_lock(&sysfs_mutex);
 		}
-	} else
-		iput(inode);
+	}
 }
 
 /**
