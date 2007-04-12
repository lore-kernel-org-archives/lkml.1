Return-Path: <linux-kernel-owner+w=401wt.eu-S1161552AbXDLCym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161552AbXDLCym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161535AbXDLCyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:54:13 -0400
Received: from qb-out-0506.google.com ([72.14.204.226]:4941 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161547AbXDLCyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:54:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=WaXNzlMmpq5pmPfn6a/lmYBCJLLzuqr1z8Wjb5e9wbjFFUUbfMvwbnxQKHF9wq0fOj1bpMRYrzmrrh8Pgz6F3s7/INLszY3FogHuKJG7oGsNOMSF0QOmO+HBcydJrhBOF83ega5CtF7wAC5Se5gO5r5B5SlKZ6OUHwhw7VJ+t64=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       David Woodhouse <dwmw2@infradead.org>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       Anton Altaparmakov <aia21@cantab.net>,
       Evgeniy Dushistov <dushistov@mail.ru>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       reiserfs-dev@namesys.com
Date: Wed, 11 Apr 2007 19:49:38 -0700
Message-Id: <20070412024938.27380.22802.patchbomb.py@localhost>
In-Reply-To: <20070412024938.27380.54538.patchbomb.py@localhost>
Subject: [PATCH 15/17] sysv: convert dir_get_page to read_kmap_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace sysv dir_get_page() with the new read_kmap_page().

Signed-off-by: Nate Diller <nate.diller@gmail.com>

---

diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/sysv/dir.c linux-2.6.21-rc5-mm4-test/fs/sysv/dir.c
--- linux-2.6.21-rc5-mm4/fs/sysv/dir.c	2007-04-05 17:14:25.000000000 -0700
+++ linux-2.6.21-rc5-mm4-test/fs/sysv/dir.c	2007-04-06 01:59:19.000000000 -0700
@@ -50,15 +50,6 @@ static int dir_commit_chunk(struct page 
 	return err;
 }
 
-static struct page * dir_get_page(struct inode *dir, unsigned long n)
-{
-	struct address_space *mapping = dir->i_mapping;
-	struct page *page = read_mapping_page(mapping, n, NULL);
-	if (!IS_ERR(page))
-		kmap(page);
-	return page;
-}
-
 static int sysv_readdir(struct file * filp, void * dirent, filldir_t filldir)
 {
 	unsigned long pos = filp->f_pos;
@@ -77,7 +68,7 @@ static int sysv_readdir(struct file * fi
 	for ( ; n < npages; n++, offset = 0) {
 		char *kaddr, *limit;
 		struct sysv_dir_entry *de;
-		struct page *page = dir_get_page(inode, n);
+		struct page *page = read_kmap_page(inode->i_mapping, n);
 
 		if (IS_ERR(page))
 			continue;
@@ -149,7 +140,7 @@ struct sysv_dir_entry *sysv_find_entry(s
 
 	do {
 		char *kaddr;
-		page = dir_get_page(dir, n);
+		page = read_kmap_page(dir->i_mapping, n);
 		if (!IS_ERR(page)) {
 			kaddr = (char*)page_address(page);
 			de = (struct sysv_dir_entry *) kaddr;
@@ -191,7 +182,7 @@ int sysv_add_link(struct dentry *dentry,
 
 	/* We take care of directory expansion in the same loop */
 	for (n = 0; n <= npages; n++) {
-		page = dir_get_page(dir, n);
+		page = read_kmap_page(dir->i_mapping, n);
 		err = PTR_ERR(page);
 		if (IS_ERR(page))
 			goto out;
@@ -299,7 +290,7 @@ int sysv_empty_dir(struct inode * inode)
 	for (i = 0; i < npages; i++) {
 		char *kaddr;
 		struct sysv_dir_entry * de;
-		page = dir_get_page(inode, i);
+		page = read_kmap_page(inode->i_mapping, i);
 
 		if (IS_ERR(page))
 			continue;
@@ -353,7 +344,7 @@ void sysv_set_link(struct sysv_dir_entry
 
 struct sysv_dir_entry * sysv_dotdot (struct inode *dir, struct page **p)
 {
-	struct page *page = dir_get_page(dir, 0);
+	struct page *page = read_kmap_page(dir->i_mapping, 0);
 	struct sysv_dir_entry *de = NULL;
 
 	if (!IS_ERR(page)) {
