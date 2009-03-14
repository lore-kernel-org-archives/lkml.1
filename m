Return-Path: <linux-kernel-owner+w=401wt.eu-S1765436AbZCNB4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765436AbZCNB4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755778AbZCNBVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:51 -0400
Received: from kroah.org ([198.145.64.141]:35779 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755179AbZCNBVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:19 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:45 2009
Message-Id: <20090314011045.608542421@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:11:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dan Carpenter <error27@gmail.com>
Subject: [patch 096/114] ext4: Fix NULL dereference in ext4_ext_migrate()s error handling
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=ext4-fix-null-dereference-in-ext4_ext_migrate-s-error-handling.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

(cherry picked from commit 090542641de833c6f756895fc2f139f046e298f9)

This was found through a code checker (http://repo.or.cz/w/smatch.git/).
It looks like you might be able to trigger the error by trying to migrate
a readonly file system.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/migrate.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -480,7 +480,7 @@ int ext4_ext_migrate(struct inode *inode
 					+ 1);
 	if (IS_ERR(handle)) {
 		retval = PTR_ERR(handle);
-		goto err_out;
+		return retval;
 	}
 	tmp_inode = ext4_new_inode(handle,
 				inode->i_sb->s_root->d_inode,
@@ -488,8 +488,7 @@ int ext4_ext_migrate(struct inode *inode
 	if (IS_ERR(tmp_inode)) {
 		retval = -ENOMEM;
 		ext4_journal_stop(handle);
-		tmp_inode = NULL;
-		goto err_out;
+		return retval;
 	}
 	i_size_write(tmp_inode, i_size_read(inode));
 	/*
@@ -617,8 +616,7 @@ err_out:
 
 	ext4_journal_stop(handle);
 
-	if (tmp_inode)
-		iput(tmp_inode);
+	iput(tmp_inode);
 
 	return retval;
 }


