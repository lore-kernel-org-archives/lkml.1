Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbZJUTbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbZJUTbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbZJUTbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:31:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860AbZJUTUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:20:15 -0400
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
Subject: [PATCH 04/41] VFS: Remove unnecessary micro-optimization in cached_lookup()
Date: Wed, 21 Oct 2009 12:19:02 -0700
Message-Id: <1256152779-10054-5-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-4-git-send-email-vaurora@redhat.com>
References: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
 <1256152779-10054-2-git-send-email-vaurora@redhat.com>
 <1256152779-10054-3-git-send-email-vaurora@redhat.com>
 <1256152779-10054-4-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

d_lookup() takes rename_lock which is a seq_lock.  This is so cheap
it's not worth calling lockless __d_lookup() first from
cache_lookup().  Rename cached_lookup() to cache_lookup() while we're
there.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index e334f25..9c9ecfa 100644
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
@@ -1191,7 +1186,7 @@ static struct dentry *__lookup_hash(struct qstr *name,
 			goto out;
 	}
 
-	dentry = cached_lookup(base, name, nd);
+	dentry = cache_lookup(base, name, nd);
 	if (!dentry) {
 		struct dentry *new;
 
-- 
1.6.3.3

