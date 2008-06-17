Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbYFQMYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbYFQMYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 08:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbYFQMXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 08:23:49 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:54180
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755787AbYFQMXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 08:23:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAMBJV0h8qbBs/2dsb2JhbACuIg
X-IronPort-AV: E=Sophos;i="4.27,657,1204470000"; 
   d="scan'208";a="236046515"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 2/7] autofs4 - revert - redo lookup in ttfd
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Tue, 17 Jun 2008 20:23:44 +0800
Message-ID: <20080617122344.14725.11503.stgit@raven.themaw.net>
In-Reply-To: <20080617122336.14725.64829.stgit@raven.themaw.net>
References: <20080617122336.14725.64829.stgit@raven.themaw.net>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series enables the use of a single dentry for lookups
prior to the dentry being hashed and so we no longer need to
redo the lookup. This patch reverts the patch of commit
033790449ba9c4dcf8478a87693d33df625c23b5.

Signed-off-by: Ian Kent <raven@themaw.net>

---

 fs/autofs4/root.c |   21 ---------------------
 1 files changed, 0 insertions(+), 21 deletions(-)


diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 2e8959c..8511cb2 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -242,7 +242,6 @@ static int try_to_fill_dentry(struct dentry *dentry, int flags)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
-	struct dentry *new;
 	int status;
 
 	/* Block on any pending expiry here; invalidate the dentry
@@ -320,26 +319,6 @@ static int try_to_fill_dentry(struct dentry *dentry, int flags)
 	dentry->d_flags &= ~DCACHE_AUTOFS_PENDING;
 	spin_unlock(&dentry->d_lock);
 
-	/*
-	 * The dentry that is passed in from lookup may not be the one
-	 * we end up using, as mkdir can create a new one.  If this
-	 * happens, and another process tries the lookup at the same time,
-	 * it will set the PENDING flag on this new dentry, but add itself
-	 * to our waitq.  Then, if after the lookup succeeds, the first
-	 * process that requested the mount performs another lookup of the
-	 * same directory, it will show up as still pending!  So, we need
-	 * to redo the lookup here and clear pending on that dentry.
-	 */
-	if (d_unhashed(dentry)) {
-		new = d_lookup(dentry->d_parent, &dentry->d_name);
-		if (new) {
-			spin_lock(&new->d_lock);
-			new->d_flags &= ~DCACHE_AUTOFS_PENDING;
-			spin_unlock(&new->d_lock);
-			dput(new);
-		}
-	}
-
 	return 0;
 }
 
