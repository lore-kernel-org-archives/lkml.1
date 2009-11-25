Return-Path: <linux-kernel-owner+w=401wt.eu-S964867AbZKYNbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964867AbZKYNbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934692AbZKYNa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:30:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964836AbZKYN2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:28:20 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>, Alexander Viro <aviro@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 04/30] VFS: Add forget_all_cached_acls()
Date: Wed, 25 Nov 2009 14:22:29 +0000
Message-Id: <1259158975-28499-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1259158975-28499-4-git-send-email-swhiteho@redhat.com>
References: <1259158975-28499-1-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-2-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-3-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-4-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required for cluster filesystems which want to use
cached ACLs so that they can invalidate the cache when
required.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Alexander Viro <aviro@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
 include/linux/posix_acl.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 065a365..6760816 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -147,6 +147,20 @@ static inline void forget_cached_acl(struct inode *inode, int type)
 	if (old != ACL_NOT_CACHED)
 		posix_acl_release(old);
 }
+
+static inline void forget_all_cached_acls(struct inode *inode)
+{
+	struct posix_acl *old_access, *old_default;
+	spin_lock(&inode->i_lock);
+	old_access = inode->i_acl;
+	old_default = inode->i_default_acl;
+	inode->i_acl = inode->i_default_acl = ACL_NOT_CACHED;
+	spin_unlock(&inode->i_lock);
+	if (old_access != ACL_NOT_CACHED)
+		posix_acl_release(old_access);
+	if (old_default != ACL_NOT_CACHED)
+		posix_acl_release(old_default);
+}
 #endif
 
 static inline void cache_no_acl(struct inode *inode)
-- 
1.6.2.5

