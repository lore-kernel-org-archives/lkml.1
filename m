Return-Path: <linux-kernel-owner+w=401wt.eu-S1758551AbZERQQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbZERQQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbZERQNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:13:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:41517 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330AbZERQJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:09:31 -0400
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: [PATCH 05/32] VFS: Remove unnecessary micro-optimization in cached_lookup()
Date: Mon, 18 May 2009 18:09:01 +0200
Message-Id: <1242662968-11684-6-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
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
index 081aef1..a9dd19b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -402,15 +402,10 @@ do_revalidate(struct dentry *dentry, struct nameidata *nd)
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
@@ -1168,7 +1163,7 @@ static struct dentry *__lookup_hash(struct qstr *name,
 			goto out;
 	}
 
-	dentry = cached_lookup(base, name, nd);
+	dentry = cache_lookup(base, name, nd);
 	if (!dentry) {
 		struct dentry *new;
 
-- 
1.6.1.3

