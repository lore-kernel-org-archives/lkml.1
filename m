Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbYLSUs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbYLSUs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 15:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbYLSUre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 15:47:34 -0500
Received: from kumera.dghda.com ([80.68.90.171]:35279 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbYLSUrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 15:47:33 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>
Subject: [PATCH, v5] vfs: ensure page symlinks are NUL-terminated
Date: Fri, 19 Dec 2008 20:47:12 +0000
Message-Id: <1229719638-6982-5-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229719638-6982-4-git-send-email-duaneg@dghda.com>
References: <1229719638-6982-1-git-send-email-duaneg@dghda.com>
 <1229719638-6982-2-git-send-email-duaneg@dghda.com>
 <1229719638-6982-3-git-send-email-duaneg@dghda.com>
 <1229719638-6982-4-git-send-email-duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On-disk data corruption could cause a page link to have its i_size set
to PAGE_SIZE (or a multiple thereof) and its contents all non-NUL.
NUL-terminate the link name to ensure this doesn't cause further
problems for the kernel.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

Unchanged from v4.

 fs/namei.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index af3783f..2416922 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2750,13 +2750,16 @@ int vfs_follow_link(struct nameidata *nd, const char *link)
 /* get the link contents into pagecache */
 static char *page_getlink(struct dentry * dentry, struct page **ppage)
 {
-	struct page * page;
+	char *kaddr;
+	struct page *page;
 	struct address_space *mapping = dentry->d_inode->i_mapping;
 	page = read_mapping_page(mapping, 0, NULL);
 	if (IS_ERR(page))
 		return (char*)page;
 	*ppage = page;
-	return kmap(page);
+	kaddr = kmap(page);
+	nd_terminate_link(kaddr, dentry->d_inode->i_size, PAGE_SIZE - 1);
+	return kaddr;
 }
 
 int page_readlink(struct dentry *dentry, char __user *buffer, int buflen)
-- 
1.6.0.4

