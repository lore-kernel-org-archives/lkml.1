Return-Path: <linux-kernel-owner+w=401wt.eu-S937383AbXG3QPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937383AbXG3QPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932836AbXG3QOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:14:08 -0400
Received: from mail.suse.de ([195.135.220.2]:40547 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764568AbXG3QOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:05 -0400
Message-Id: <20070730161323.606124587@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:28 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 05/26] VFS: cache_lookup() cleanup
Content-Disposition: inline; filename=um/vfs-cache_lookup-cleanup.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cache_lookup() can directly use d_lookup() instead of calling __d_lookup()
first since rename_lock is a seq_lock.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/namei.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -403,15 +403,10 @@ do_revalidate(struct dentry *dentry, str
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
@@ -1276,7 +1271,7 @@ static inline struct dentry *__lookup_ha
 			goto out;
 	}
 
-	dentry = cached_lookup(base, name, nd);
+	dentry = cache_lookup(base, name, nd);
 	if (!dentry) {
 		struct dentry *new = d_alloc(base, name);
 		dentry = ERR_PTR(-ENOMEM);

-- 

