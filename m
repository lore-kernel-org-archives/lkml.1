Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbYKTOY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbYKTOY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754879AbYKTOXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:23:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:46411 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760AbYKTOXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:23:33 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, akpm@linux-foundation.org, greg@kroah.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/5] FUSE: add fuse_conn->release()
Date: Thu, 20 Nov 2008 23:23:02 +0900
Message-Id: <1227190983-5820-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1227190983-5820-1-git-send-email-tj@kernel.org>
References: <1227190983-5820-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 20 Nov 2008 14:23:13 +0000 (UTC)
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
index c4164b2..23df478 100644
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
index 068e0f2..eae4ff9 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -544,7 +544,11 @@ void fuse_conn_put(struct fuse_conn *fc)
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
1.5.6

