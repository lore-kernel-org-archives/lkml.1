Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbZG2ABE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbZG2ABE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 20:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbZG2ABB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 20:01:01 -0400
Received: from kroah.org ([198.145.64.141]:35706 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbZG1Xtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:49 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:54 2009
Message-Id: <20090728234154.144353948@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [patch 19/71] cifs: fix regression with O_EXCL creates and optimize away lookup
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=cifs-fix-regression-with-o_excl-creates-and-optimize-away-lookup.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 5ddf1e0ff00fd808c048d0b920784828276cc516 upstream.

cifs: fix regression with O_EXCL creates and optimize away lookup

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Tested-by: Shirish Pargaonkar <shirishp@gmail.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/dir.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -641,6 +641,15 @@ cifs_lookup(struct inode *parent_dir_ino
 			}
 	}
 
+	/*
+	 * O_EXCL: optimize away the lookup, but don't hash the dentry. Let
+	 * the VFS handle the create.
+	 */
+	if (nd->flags & LOOKUP_EXCL) {
+		d_instantiate(direntry, NULL);
+		return 0;
+	}
+
 	/* can not grab the rename sem here since it would
 	deadlock in the cases (beginning of sys_rename itself)
 	in which we already have the sb rename sem */


