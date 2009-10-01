Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbZJABBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbZJABBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 21:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbZJABBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 21:01:12 -0400
Received: from outbound.icp-qv1-irony-out5.iinet.net.au ([203.59.1.105]:53952
	"EHLO outbound.icp-qv1-irony-out5.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755340AbZJABBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 21:01:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAPCbw0rLO7dJ/2dsb2JhbADXZoQnBIFNVg
X-IronPort-AV: E=Sophos;i="4.44,483,1249228800"; 
   d="scan'208";a="41636836"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 02/10] autofs4 - use macros for expiring list
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Sage Weil <sage@newdream.net>, Al Viro <viro@ZenIV.linux.org.uk>,
       Andreas Dilger <adilger@sun.com>, Christoph Hellwig <hch@infradead.org>,
       Yehuda Saheh <yehuda@newdream.net>
Date: Thu, 01 Oct 2009 09:01:02 +0800
Message-ID: <20091001010102.7675.55471.stgit@zeus.themaw.net>
In-Reply-To: <20091001010054.7675.77673.stgit@zeus.themaw.net>
References: <20091001010054.7675.77673.stgit@zeus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define some simple macro functions for adding and deleting entries
on the expiring dentry list.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/autofs_i.h |   26 ++++++++++++++++++++++++++
 fs/autofs4/root.c     |   15 +++------------
 2 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index f3cf151..fe9fc23 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -266,5 +266,31 @@ out:
 	return ret;
 }
 
+static inline void autofs4_add_expiring(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	if (ino) {
+		spin_lock(&sbi->lookup_lock);
+		if (list_empty(&ino->expiring))
+			list_add(&ino->expiring, &sbi->expiring_list);
+		spin_unlock(&sbi->lookup_lock);
+	}
+	return;
+}
+
+static inline void autofs4_del_expiring(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	if (ino) {
+		spin_lock(&sbi->lookup_lock);
+		if (!list_empty(&ino->expiring))
+			list_del_init(&ino->expiring);
+		spin_unlock(&sbi->lookup_lock);
+	}
+	return;
+}
+
 void autofs4_dentry_release(struct dentry *);
 extern void autofs4_kill_sb(struct super_block *);
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 67d8d96..2954ac5 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -563,10 +563,7 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 			 */
 			ino = autofs4_dentry_ino(expiring);
 			autofs4_expire_wait(expiring);
-			spin_lock(&sbi->lookup_lock);
-			if (!list_empty(&ino->expiring))
-				list_del_init(&ino->expiring);
-			spin_unlock(&sbi->lookup_lock);
+			autofs4_del_expiring(expiring);
 			dput(expiring);
 		}
 
@@ -732,10 +729,7 @@ static int autofs4_dir_unlink(struct inode *dir, struct dentry *dentry)
 	dir->i_mtime = CURRENT_TIME;
 
 	spin_lock(&dcache_lock);
-	spin_lock(&sbi->lookup_lock);
-	if (list_empty(&ino->expiring))
-		list_add(&ino->expiring, &sbi->expiring_list);
-	spin_unlock(&sbi->lookup_lock);
+	autofs4_add_expiring(dentry);
 	spin_lock(&dentry->d_lock);
 	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
@@ -761,10 +755,7 @@ static int autofs4_dir_rmdir(struct inode *dir, struct dentry *dentry)
 		spin_unlock(&dcache_lock);
 		return -ENOTEMPTY;
 	}
-	spin_lock(&sbi->lookup_lock);
-	if (list_empty(&ino->expiring))
-		list_add(&ino->expiring, &sbi->expiring_list);
-	spin_unlock(&sbi->lookup_lock);
+	autofs4_add_expiring(dentry);
 	spin_lock(&dentry->d_lock);
 	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);

