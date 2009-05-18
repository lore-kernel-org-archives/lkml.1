Return-Path: <linux-kernel-owner+w=401wt.eu-S1758749AbZERQQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbZERQQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758034AbZERQNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:13:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56880 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450AbZERQJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:09:30 -0400
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: [PATCH 23/32] union-mount: stop lookup when finding a whiteout
Date: Mon, 18 May 2009 18:09:19 +0200
Message-Id: <1242662968-11684-24-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the lookup if we find a whiteout during union path lookup.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>
---
 fs/namei.c |   30 ++++++++++++++++++++++--------
 1 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 83cc5ea..9c38df3 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -440,10 +440,10 @@ static int __cache_lookup_topmost(struct nameidata *nd, struct qstr *name,
 	path->dentry = dentry;
 	path->mnt = dentry ? nd->path.mnt : NULL;
 
-	if (!dentry || dentry->d_inode)
+	if (!dentry || (dentry->d_inode || d_is_whiteout(dentry)))
 		return !dentry;
 
-	/* look for the first non-negative dentry */
+	/* look for the first non-negative or whiteout dentry */
 
 	while (follow_union_down(&nd->path.mnt, &nd->path.dentry)) {
 		dentry = d_hash_and_lookup(nd->path.dentry, name);
@@ -465,7 +465,7 @@ static int __cache_lookup_topmost(struct nameidata *nd, struct qstr *name,
 				goto out_dput;
 		}
 
-		if (dentry->d_inode)
+		if (dentry->d_inode || d_is_whiteout(dentry))
 			goto out_dput;
 
 		dput(dentry);
@@ -503,6 +503,11 @@ static int __cache_lookup_build_union(struct nameidata *nd, struct qstr *name,
 				return 1;
 		}
 
+		if (d_is_whiteout(dentry)) {
+			dput(dentry);
+			break;
+		}
+
 		if (!dentry->d_inode) {
 			dput(dentry);
 			continue;
@@ -714,7 +719,6 @@ out_unlock:
  * type mismatch and whiteouts.
  *
  * FIXME:
- * - handle DT_WHT
  * - handle union stacks in use
  * - handle union stacks mounted upon union stacks
  * - avoid unnecessary allocations of union locks
@@ -729,7 +733,7 @@ static int __real_lookup_topmost(struct nameidata *nd, struct qstr *name,
 	if (err)
 		return err;
 
-	if (path->dentry->d_inode)
+	if (path->dentry->d_inode || d_is_whiteout(path->dentry))
 		return 0;
 
 	while (follow_union_down(&nd->path.mnt, &nd->path.dentry)) {
@@ -745,7 +749,7 @@ static int __real_lookup_topmost(struct nameidata *nd, struct qstr *name,
 		if (err)
 			goto out;
 
-		if (next.dentry->d_inode) {
+		if (next.dentry->d_inode || d_is_whiteout(next.dentry)) {
 			dput(path->dentry);
 			mntget(next.mnt);
 			*path = next;
@@ -788,6 +792,11 @@ static int __real_lookup_build_union(struct nameidata *nd, struct qstr *name,
 		if (err)
 			goto out;
 
+		if (d_is_whiteout(next.dentry)) {
+			dput(next.dentry);
+			break;
+		}
+
 		if (!next.dentry->d_inode) {
 			dput(next.dentry);
 			continue;
@@ -1577,7 +1586,7 @@ static int __hash_lookup_topmost(struct nameidata *nd, struct qstr *name,
 	if (err)
 		return err;
 
-	if (path->dentry->d_inode)
+	if (path->dentry->d_inode || d_is_whiteout(path->dentry))
 		return 0;
 
 	while (follow_union_down(&nd->path.mnt, &nd->path.dentry)) {
@@ -1595,7 +1604,7 @@ static int __hash_lookup_topmost(struct nameidata *nd, struct qstr *name,
 		if (err)
 			goto out;
 
-		if (next.dentry->d_inode) {
+		if (next.dentry->d_inode || d_is_whiteout(next.dentry)) {
 			dput(path->dentry);
 			mntget(next.mnt);
 			*path = next;
@@ -1633,6 +1642,11 @@ static int __hash_lookup_build_union(struct nameidata *nd, struct qstr *name,
 		if (err)
 			goto out;
 
+		if (d_is_whiteout(next.dentry)) {
+			dput(next.dentry);
+			break;
+		}
+
 		if (!next.dentry->d_inode) {
 			dput(next.dentry);
 			continue;
-- 
1.6.1.3

