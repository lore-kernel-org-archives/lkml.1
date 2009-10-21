Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbZJUTVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbZJUTVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbZJUTVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:21:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754917AbZJUTVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:21:11 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>
Subject: [PATCH 25/41] union-mount: stop lookup when directory has S_OPAQUE flag set
Date: Wed, 21 Oct 2009 12:19:23 -0700
Message-Id: <1256152779-10054-26-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-25-git-send-email-vaurora@redhat.com>
References: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
 <1256152779-10054-2-git-send-email-vaurora@redhat.com>
 <1256152779-10054-3-git-send-email-vaurora@redhat.com>
 <1256152779-10054-4-git-send-email-vaurora@redhat.com>
 <1256152779-10054-5-git-send-email-vaurora@redhat.com>
 <1256152779-10054-6-git-send-email-vaurora@redhat.com>
 <1256152779-10054-7-git-send-email-vaurora@redhat.com>
 <1256152779-10054-8-git-send-email-vaurora@redhat.com>
 <1256152779-10054-9-git-send-email-vaurora@redhat.com>
 <1256152779-10054-10-git-send-email-vaurora@redhat.com>
 <1256152779-10054-11-git-send-email-vaurora@redhat.com>
 <1256152779-10054-12-git-send-email-vaurora@redhat.com>
 <1256152779-10054-13-git-send-email-vaurora@redhat.com>
 <1256152779-10054-14-git-send-email-vaurora@redhat.com>
 <1256152779-10054-15-git-send-email-vaurora@redhat.com>
 <1256152779-10054-16-git-send-email-vaurora@redhat.com>
 <1256152779-10054-17-git-send-email-vaurora@redhat.com>
 <1256152779-10054-18-git-send-email-vaurora@redhat.com>
 <1256152779-10054-19-git-send-email-vaurora@redhat.com>
 <1256152779-10054-20-git-send-email-vaurora@redhat.com>
 <1256152779-10054-21-git-send-email-vaurora@redhat.com>
 <1256152779-10054-22-git-send-email-vaurora@redhat.com>
 <1256152779-10054-23-git-send-email-vaurora@redhat.com>
 <1256152779-10054-24-git-send-email-vaurora@redhat.com>
 <1256152779-10054-25-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

Honor the S_OPAQUE flag in the union path lookup.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index b279686..8ebbf4f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -523,6 +523,9 @@ static int __cache_lookup_build_union(struct nameidata *nd, struct qstr *name,
 			path_put(&last);
 		last.dentry = dentry;
 		last.mnt = mntget(nd->path.mnt);
+
+		if (IS_OPAQUE(last.dentry->d_inode))
+			break;
 	}
 
 	if (last.dentry != path->dentry)
@@ -562,7 +565,8 @@ static int cache_lookup_union(struct nameidata *nd, struct qstr *name,
 
 		/* only directories can be part of a union stack */
 		if (!path->dentry->d_inode ||
-		    !S_ISDIR(path->dentry->d_inode->i_mode))
+		    !S_ISDIR(path->dentry->d_inode->i_mode) ||
+		    IS_OPAQUE(path->dentry->d_inode))
 			goto out;
 
 		/* Build the union stack for this part */
@@ -804,6 +808,9 @@ static int __real_lookup_build_union(struct nameidata *nd, struct qstr *name,
 			path_put(&last);
 		last.dentry = next.dentry;
 		last.mnt = mntget(next.mnt);
+
+		if (IS_OPAQUE(last.dentry->d_inode))
+			break;
 	}
 
 	if (last.dentry != path->dentry)
@@ -825,7 +832,8 @@ static int real_lookup_union(struct nameidata *nd, struct qstr *name,
 
 	/* only directories can be part of a union stack */
 	if (!path->dentry->d_inode ||
-	    !S_ISDIR(path->dentry->d_inode->i_mode))
+	    !S_ISDIR(path->dentry->d_inode->i_mode) ||
+	    IS_OPAQUE(path->dentry->d_inode))
 		goto out;
 
 	/* Build the union stack for this part */
@@ -1111,7 +1119,7 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 {
 	int err;
 
-	if (IS_MNT_UNION(nd->path.mnt))
+	if (IS_MNT_UNION(nd->path.mnt) && !IS_OPAQUE(nd->path.dentry->d_inode))
 		goto need_union_lookup;
 
 	path->dentry = __d_lookup(nd->path.dentry, name);
@@ -1676,6 +1684,9 @@ static int __hash_lookup_build_union(struct nameidata *nd, struct qstr *name,
 			path_put(&last);
 		last.dentry = next.dentry;
 		last.mnt = mntget(next.mnt);
+
+		if (IS_OPAQUE(last.dentry->d_inode))
+			break;
 	}
 
 	if (last.dentry != path->dentry)
-- 
1.6.3.3

