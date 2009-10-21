Return-Path: <linux-kernel-owner+w=401wt.eu-S1755150AbZJUTVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbZJUTVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbZJUTVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:21:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932238AbZJUTVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:21:08 -0400
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
Subject: [PATCH 26/41] union-mount: stop lookup when finding a whiteout
Date: Wed, 21 Oct 2009 12:19:24 -0700
Message-Id: <1256152779-10054-27-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-26-git-send-email-vaurora@redhat.com>
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
 <1256152779-10054-26-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

Stop the lookup if we find a whiteout during union path lookup.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |   30 ++++++++++++++++++++++--------
 1 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 8ebbf4f..fb463ac 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -442,10 +442,10 @@ static int __cache_lookup_topmost(struct nameidata *nd, struct qstr *name,
 	path->dentry = dentry;
 	path->mnt = dentry ? nd->path.mnt : NULL;
 
-	if (!dentry || dentry->d_inode)
+	if (!dentry || (dentry->d_inode || d_is_whiteout(dentry)))
 		return !dentry;
 
-	/* look for the first non-negative dentry */
+	/* look for the first non-negative or whiteout dentry */
 
 	while (follow_union_down(&nd->path.mnt, &nd->path.dentry)) {
 		dentry = d_hash_and_lookup(nd->path.dentry, name);
@@ -467,7 +467,7 @@ static int __cache_lookup_topmost(struct nameidata *nd, struct qstr *name,
 				goto out_dput;
 		}
 
-		if (dentry->d_inode)
+		if (dentry->d_inode || d_is_whiteout(dentry))
 			goto out_dput;
 
 		dput(dentry);
@@ -505,6 +505,11 @@ static int __cache_lookup_build_union(struct nameidata *nd, struct qstr *name,
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
@@ -716,7 +721,6 @@ out_unlock:
  * type mismatch and whiteouts.
  *
  * FIXME:
- * - handle DT_WHT
  * - handle union stacks in use
  * - handle union stacks mounted upon union stacks
  * - avoid unnecessary allocations of union locks
@@ -731,7 +735,7 @@ static int __real_lookup_topmost(struct nameidata *nd, struct qstr *name,
 	if (err)
 		return err;
 
-	if (path->dentry->d_inode)
+	if (path->dentry->d_inode || d_is_whiteout(path->dentry))
 		return 0;
 
 	while (follow_union_down(&nd->path.mnt, &nd->path.dentry)) {
@@ -747,7 +751,7 @@ static int __real_lookup_topmost(struct nameidata *nd, struct qstr *name,
 		if (err)
 			goto out;
 
-		if (next.dentry->d_inode) {
+		if (next.dentry->d_inode || d_is_whiteout(next.dentry)) {
 			dput(path->dentry);
 			mntget(next.mnt);
 			*path = next;
@@ -790,6 +794,11 @@ static int __real_lookup_build_union(struct nameidata *nd, struct qstr *name,
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
@@ -1610,7 +1619,7 @@ static int __hash_lookup_topmost(struct nameidata *nd, struct qstr *name,
 	if (err)
 		return err;
 
-	if (path->dentry->d_inode)
+	if (path->dentry->d_inode || d_is_whiteout(path->dentry))
 		return 0;
 
 	while (follow_union_down(&nd->path.mnt, &nd->path.dentry)) {
@@ -1628,7 +1637,7 @@ static int __hash_lookup_topmost(struct nameidata *nd, struct qstr *name,
 		if (err)
 			goto out;
 
-		if (next.dentry->d_inode) {
+		if (next.dentry->d_inode || d_is_whiteout(next.dentry)) {
 			dput(path->dentry);
 			mntget(next.mnt);
 			*path = next;
@@ -1666,6 +1675,11 @@ static int __hash_lookup_build_union(struct nameidata *nd, struct qstr *name,
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
1.6.3.3

