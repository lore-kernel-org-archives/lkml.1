Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab0BXKjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 05:39:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756526Ab0BXKjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 05:39:19 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
       Mimi Zohar <zohar@us.ibm.com>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       "Amit K. Arora" <amitarora@in.ibm.com>
Subject: [PATCH] security: fix error return path in ima_inode_alloc
Date: Wed, 24 Feb 2010 18:39:02 +0800
Message-Id: <1267007942-315-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If radix_tree_preload is failed in ima_inode_alloc, we don't need
radix_tree_preload_end because kernel is alread preempt enabled

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: James Morris <jmorris@namei.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amit K. Arora <amitarora@in.ibm.com>
---
 security/integrity/ima/ima_iint.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
index 0d83edc..2d4d05d 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -63,12 +63,11 @@ int ima_inode_alloc(struct inode *inode)
 	spin_lock(&ima_iint_lock);
 	rc = radix_tree_insert(&ima_iint_store, (unsigned long)inode, iint);
 	spin_unlock(&ima_iint_lock);
+	radix_tree_preload_end();
 out:
 	if (rc < 0)
 		kmem_cache_free(iint_cache, iint);
 
-	radix_tree_preload_end();
-
 	return rc;
 }
 
-- 
1.6.6

