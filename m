Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbYKRSAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbYKRSAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 13:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbYKRSA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 13:00:28 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:31322 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbYKRSA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 13:00:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=g1Ymvsojj0hRdYD7xJ7Zt9hWeIGJY+lONKYOiDEZgtzQskAxz9D6l4/mW7mzfHX0MQ
         NSmkLwTG2TUBNOQo4EG7LRve17wtQVFTNW7YfLiSL7XZ+PVbECxTlIJuCbV6ntDA7cj7
         UyjVB7GcSSgw4WLE4Km73XMIwCU9hQbu9dlgw=
Date: Tue, 18 Nov 2008 18:00:03 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jeff Dike <jdike@addtoit.com>, Andrew Morton <akpm@osdl.org>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [Patch] hostfs: fix a duplicated global function name
Message-ID: <20081118180003.GF3185@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fs/hostfs/hostfs_user.c defines do_readlink() as non-static,
and so does fs/xfs/linux-2.6/xfs_ioctl.c when CONFIG_XFS_DEBUG=y.
So rename do_readlink() in hostfs to hostfs_do_readlink().

I think it's better if XFS guys will also rename their do_readlink(),
it's not necessary to use such a general name.

Compile test only.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Jeff Dike <jdike@addtoit.com>


---
diff --git a/fs/hostfs/hostfs.h b/fs/hostfs/hostfs.h
index 6ae9011..2f34f8f 100644
--- a/fs/hostfs/hostfs.h
+++ b/fs/hostfs/hostfs.h
@@ -81,7 +81,7 @@ extern int do_rmdir(const char *file);
 extern int do_mknod(const char *file, int mode, unsigned int major,
 		    unsigned int minor);
 extern int link_file(const char *from, const char *to);
-extern int do_readlink(char *file, char *buf, int size);
+extern int hostfs_do_readlink(char *file, char *buf, int size);
 extern int rename_file(char *from, char *to);
 extern int do_statfs(char *root, long *bsize_out, long long *blocks_out,
 		     long long *bfree_out, long long *bavail_out,
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 7f34f43..3a31451 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -168,7 +168,7 @@ static char *follow_link(char *link)
 		if (name == NULL)
 			goto out;
 
-		n = do_readlink(link, name, len);
+		n = hostfs_do_readlink(link, name, len);
 		if (n < len)
 			break;
 		len *= 2;
@@ -943,7 +943,7 @@ int hostfs_link_readpage(struct file *file, struct page *page)
 	name = inode_name(page->mapping->host, 0);
 	if (name == NULL)
 		return -ENOMEM;
-	err = do_readlink(name, buffer, PAGE_CACHE_SIZE);
+	err = hostfs_do_readlink(name, buffer, PAGE_CACHE_SIZE);
 	kfree(name);
 	if (err == PAGE_CACHE_SIZE)
 		err = -E2BIG;
diff --git a/fs/hostfs/hostfs_user.c b/fs/hostfs/hostfs_user.c
index 53fd0a6..b79424f 100644
--- a/fs/hostfs/hostfs_user.c
+++ b/fs/hostfs/hostfs_user.c
@@ -377,7 +377,7 @@ int link_file(const char *to, const char *from)
 	return 0;
 }
 
-int do_readlink(char *file, char *buf, int size)
+int hostfs_do_readlink(char *file, char *buf, int size)
 {
 	int n;
 


