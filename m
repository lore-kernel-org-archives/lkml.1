Return-Path: <linux-kernel-owner+w=401wt.eu-S1758021AbXLKXxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021AbXLKXxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 18:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423AbXLKXw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 18:52:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327AbXLKXwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 18:52:55 -0500
Message-ID: <475F22C8.5040306@redhat.com>
Date: Tue, 11 Dec 2007 17:52:40 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@osdl.org>, Michael Halcrow <mhalcrow@us.ibm.com>
Subject: [PATCH] ecryptfs: initialize new auth_tokens before teardown
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ecryptfs_destroy_mount_crypt_stat() checks whether each 
auth_tok->global_auth_tok_key is nonzero and if so puts that
key.  However, in some early mount error paths nothing has initialized
the pointer, and we try to key_put() garbage.  Running the bad cipher 
tests in the testsuite exposes this, and it's happy with the following 
change.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---

Index: linux/fs/ecryptfs/keystore.c
===================================================================
--- linux.orig/fs/ecryptfs/keystore.c
+++ linux/fs/ecryptfs/keystore.c
@@ -1851,7 +1851,7 @@ ecryptfs_add_global_auth_tok(struct ecry
 	struct ecryptfs_global_auth_tok *new_auth_tok;
 	int rc = 0;
 
-	new_auth_tok = kmem_cache_alloc(ecryptfs_global_auth_tok_cache,
+	new_auth_tok = kmem_cache_zalloc(ecryptfs_global_auth_tok_cache,
 					GFP_KERNEL);
 	if (!new_auth_tok) {
 		rc = -ENOMEM;

