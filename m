Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbYFQMeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbYFQMeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 08:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756099AbYFQMdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 08:33:54 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:18551
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756021AbYFQMdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 08:33:53 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jun 2008 08:33:53 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAP5JV0h8qbBs/2dsb2JhbACuIw
X-IronPort-AV: E=Sophos;i="4.27,657,1204470000"; 
   d="scan'208";a="343868518"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 4/7] autofs4 - don't release directory mutex if called in
	oz_mode
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Tue, 17 Jun 2008 20:23:55 +0800
Message-ID: <20080617122355.14725.46170.stgit@raven.themaw.net>
In-Reply-To: <20080617122336.14725.64829.stgit@raven.themaw.net>
References: <20080617122336.14725.64829.stgit@raven.themaw.net>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we now delay hashing of dentrys until the ->mkdir() call,
droping and re-taking the directory mutex within the ->lookup()
function when we are being called by user space is not needed.
This can lead to a race when other processes are attempting to
access the same directory during mount point directory creation.

In this case we need to hang onto the mutex to ensure we don't
get user processes trying to create a mount request for a newly
created dentry after the mount point entry has already been
created. This ensures that when we need to check a dentry passed
to autofs4_wait(), if it is hashed, it is always the mount point
dentry and not a new dentry created by another lookup during
directory creation.

Signed-off-by: Ian Kent <raven@themaw.net>

---

 fs/autofs4/root.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)


diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 7fa303d..236eb9b 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -683,12 +683,11 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 		spin_lock(&dentry->d_lock);
 		dentry->d_flags |= DCACHE_AUTOFS_PENDING;
 		spin_unlock(&dentry->d_lock);
-	}
-
-	if (dentry->d_op && dentry->d_op->d_revalidate) {
-		mutex_unlock(&dir->i_mutex);
-		(dentry->d_op->d_revalidate)(dentry, nd);
-		mutex_lock(&dir->i_mutex);
+		if (dentry->d_op && dentry->d_op->d_revalidate) {
+			mutex_unlock(&dir->i_mutex);
+			(dentry->d_op->d_revalidate)(dentry, nd);
+			mutex_lock(&dir->i_mutex);
+		}
 	}
 
 	/*
