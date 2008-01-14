Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbYANViI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbYANViI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbYANVhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:37:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814AbYANVhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:37:50 -0500
Message-ID: <478BD58A.705@redhat.com>
Date: Mon, 14 Jan 2008 15:35:06 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
CC: Roman Zippel <zippel@linux-m68k.org>, Adrian Bunk <bunk@stusta.de>
Subject: [PATCH] hfs: fix coverity-found null deref
References: <478BD0D8.8070101@redhat.com>
In-Reply-To: <478BD0D8.8070101@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix potential null deref introduced by commit
cf0594625083111ae522496dc1c256f7476939c2
http://bugzilla.kernel.org/show_bug.cgi?id=9748

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---

Index: linux-2.6.24-rc6-mm1/fs/hfs/btree.c
===================================================================
--- linux-2.6.24-rc6-mm1.orig/fs/hfs/btree.c
+++ linux-2.6.24-rc6-mm1/fs/hfs/btree.c
@@ -61,7 +61,7 @@ struct hfs_btree *hfs_btree_open(struct 
 	mapping = tree->inode->i_mapping;
 	page = read_mapping_page(mapping, 0, NULL);
 	if (IS_ERR(page))
-		goto free_tree;
+		goto free_inode;
 
 	/* Load the header */
 	head = (struct hfs_btree_header_rec *)(kmap(page) + sizeof(struct hfs_bnode_desc));
@@ -107,11 +107,12 @@ struct hfs_btree *hfs_btree_open(struct 
 	page_cache_release(page);
 	return tree;
 
- fail_page:
+fail_page:
 	page_cache_release(page);
- free_tree:
+free_inode:
 	tree->inode->i_mapping->a_ops = &hfs_aops;
 	iput(tree->inode);
+free_tree:
 	kfree(tree);
 	return NULL;
 }

