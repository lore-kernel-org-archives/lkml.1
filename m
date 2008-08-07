Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbYHGMXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbYHGMXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbYHGMW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:22:28 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:33780
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753793AbYHGMWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:22:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAOB8mkh8qVRH/2dsb2JhbACseA
X-IronPort-AV: E=Sophos;i="4.31,319,1215360000"; 
   d="scan'208";a="256523321"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 2/4] autofs4 - track uid and gid of last mount requester
To: Andrew Morton <akpm@linux-foundation.org>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Thu, 07 Aug 2008 19:40:14 +0800
Message-ID: <20080807114012.4142.83607.stgit@web.messagingengine.com>
In-Reply-To: <20080807114002.4142.30417.stgit@web.messagingengine.com>
References: <20080807114002.4142.30417.stgit@web.messagingengine.com>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch to track the uid and gid of the last process to request a mount
for on an autofs dentry.

Signed-off-by: Ian Kent <raven@themaw.net>

---

 fs/autofs4/autofs_i.h |    3 +++
 fs/autofs4/inode.c    |    2 ++
 fs/autofs4/waitq.c    |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 0 deletions(-)


diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index ea024d8..fa76d18 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -63,6 +63,9 @@ struct autofs_info {
 	unsigned long last_used;
 	atomic_t count;
 
+	uid_t uid;
+	gid_t gid;
+
 	mode_t	mode;
 	size_t	size;
 
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 9ca2d07..9408507 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -53,6 +53,8 @@ struct autofs_info *autofs4_init_ino(struct autofs_info *ino,
 		atomic_set(&ino->count, 0);
 	}
 
+	ino->uid = 0;
+	ino->gid = 0;
 	ino->mode = mode;
 	ino->last_used = jiffies;
 
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 6d87bb1..7c60c0b 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -457,6 +457,40 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 
 	status = wq->status;
 
+	/*
+	 * For direct and offset mounts we need to track the requestrer
+	 * uid and gid in the dentry info struct. This is so it can be
+	 * supplied, on request, by the misc device ioctl interface.
+	 * This is needed during daemon resatart when reconnecting
+	 * to existing, active, autofs mounts. The uid and gid (and
+	 * related string values) may be used for macro substitution
+	 * in autofs mount maps.
+	 */
+	if (!status) {
+		struct autofs_info *ino;
+		struct dentry *de = NULL;
+
+		/* direct mount or browsable map */
+		ino = autofs4_dentry_ino(dentry);
+		if (!ino) {
+			/* If not lookup actual dentry used */
+			de = d_lookup(dentry->d_parent, &dentry->d_name);
+			if (de)
+				ino = autofs4_dentry_ino(de);
+		}
+
+		/* Set mount requester */
+		if (ino) {
+			spin_lock(&sbi->fs_lock);
+			ino->uid = wq->uid;
+			ino->gid = wq->gid;
+			spin_unlock(&sbi->fs_lock);
+		}
+
+		if (de)
+			dput(de);
+	}
+
 	/* Are we the last process to need status? */
 	mutex_lock(&sbi->wq_mutex);
 	if (!--wq->wait_ctr)
