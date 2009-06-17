Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbZFQUqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbZFQUqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761644AbZFQUpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:45:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:41487 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761061AbZFQUpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:45:10 -0400
From: Jan Blunck <jblunck@suse.de>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       vaurora@redhat.com, hch@lst.de, miklos@szeredi.hu
Subject: [PATCH] VFS: Remove unnecessary micro-optimization in cached_lookup()
Date: Wed, 17 Jun 2009 22:45:08 +0200
Message-Id: <1245271510-31542-5-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245271510-31542-1-git-send-email-jblunck@suse.de>
References: <1245271510-31542-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d_lookup() takes rename_lock which is a seq_lock.  This is so cheap
it's not worth calling lockless __d_lookup() first from
cache_lookup().  Rename cached_lookup() to cache_lookup() while we're
there.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>
---
 fs/namei.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c0cd4cb..9b12363 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -404,15 +404,10 @@ do_revalidate(struct dentry *dentry, struct nameidata *nd)
  * Internal lookup() using the new generic dcache.
  * SMP-safe
  */
-static struct dentry * cached_lookup(struct dentry * parent, struct qstr * name, struct nameidata *nd)
+static struct dentry *cache_lookup(struct dentry *parent, struct qstr *name,
+				   struct nameidata *nd)
 {
-	struct dentry * dentry = __d_lookup(parent, name);
-
-	/* lockess __d_lookup may fail due to concurrent d_move() 
-	 * in some unrelated directory, so try with d_lookup
-	 */
-	if (!dentry)
-		dentry = d_lookup(parent, name);
+	struct dentry *dentry = d_lookup(parent, name);
 
 	if (dentry && dentry->d_op && dentry->d_op->d_revalidate)
 		dentry = do_revalidate(dentry, nd);
@@ -1172,7 +1167,7 @@ static struct dentry *__lookup_hash(struct qstr *name,
 			goto out;
 	}
 
-	dentry = cached_lookup(base, name, nd);
+	dentry = cache_lookup(base, name, nd);
 	if (!dentry) {
 		struct dentry *new;
 
-- 
1.6.0.2

