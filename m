Return-Path: <linux-kernel-owner+w=401wt.eu-S1752358AbZH0MWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbZH0MWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbZH0MWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:22:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbZH0MWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:22:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] AFS: Stop readlink() on AFS crashing because file not passed
	to afs_readpage()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Anton Blanchard <anton@samba.org>
Date: Thu, 27 Aug 2009 13:22:31 +0100
Message-ID: <20090827122231.14557.79687.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kAFS crashes when asked to read a symbolic link because page_getlink() passes a
NULL file pointer to read_mapping_page(), but afs_readpage() expects a file
pointer from which to extract a key.

Modify afs_readpage() to request the appropriate key from the calling process's
keyrings if a file struct is not supplied with one attached.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Anton Blanchard <anton@samba.org>
---

 fs/afs/file.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)


diff --git a/fs/afs/file.c b/fs/afs/file.c
index 0149dab..681c2a7 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -134,9 +134,16 @@ static int afs_readpage(struct file *file, struct page *page)
 
 	inode = page->mapping->host;
 
-	ASSERT(file != NULL);
-	key = file->private_data;
-	ASSERT(key != NULL);
+	if (file) {
+		key = file->private_data;
+		ASSERT(key != NULL);
+	} else {
+		key = afs_request_key(AFS_FS_S(inode->i_sb)->volume->cell);
+		if (IS_ERR(key)) {
+			ret = PTR_ERR(key);
+			goto error_nokey;
+		}
+	}
 
 	_enter("{%x},{%lu},{%lu}", key_serial(key), inode->i_ino, page->index);
 
@@ -207,12 +214,17 @@ static int afs_readpage(struct file *file, struct page *page)
 		unlock_page(page);
 	}
 
+	if (!file)
+		key_put(key);
 	_leave(" = 0");
 	return 0;
 
 error:
 	SetPageError(page);
 	unlock_page(page);
+	if (!file)
+		key_put(key);
+error_nokey:
 	_leave(" = %d", ret);
 	return ret;
 }

