Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbYH1SVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbYH1SVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbYH1SUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:20:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:41698 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756783AbYH1SUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:20:43 -0400
From: Tejun Heo <tj@kernel.org>
To: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/5] FUSE: add fuse_conn->release()
Date: Fri, 29 Aug 2008 03:19:03 +0900
Message-Id: <1219947544-666-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219947544-666-1-git-send-email-tj@kernel.org>
References: <1219947544-666-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 18:20:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add fuse_conn->release() so that fuse_conn can be embedded in other
structures.  If unspecified, the original action - kfree() - is done.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fuse/fuse_i.h |    3 +++
 fs/fuse/inode.c  |    6 +++++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 4795264..67f33e8 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -465,6 +465,9 @@ struct fuse_conn {
 
 	/** Version counter for attribute changes */
 	u64 attr_version;
+
+	/** Called on final put.  If implemented, should free the connection */
+	void (*release)(struct fuse_conn *);
 };
 
 static inline struct fuse_conn *get_fuse_conn_super(struct super_block *sb)
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 8d092ea..b99bb95 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -543,7 +543,11 @@ void fuse_conn_put(struct fuse_conn *fc)
 			fuse_request_free(fc->destroy_req);
 		mutex_destroy(&fc->inst_mutex);
 		bdi_destroy(&fc->bdi);
-		kfree(fc);
+
+		if (fc->release)
+			fc->release(fc);
+		else
+			kfree(fc);
 	}
 }
 EXPORT_SYMBOL_GPL(fuse_conn_put);
-- 
1.5.4.5

