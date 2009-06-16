Return-Path: <linux-kernel-owner+w=401wt.eu-S1764255AbZFPUnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764255AbZFPUnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762950AbZFPUkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:40:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59614 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762752AbZFPUkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:40:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/17] AFS: Add key request for pioctl
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, Wang Lei <wang840925@gmail.com>,
       David Howells <dhowells@redhat.com>
Date: Tue, 16 Jun 2009 21:39:06 +0100
Message-ID: <20090616203906.4526.40945.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
References: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Lei <wang840925@gmail.com>

afs_pioctl() should get the security key applicable to the nominated file and
pass it on to the command handlers.

Signed-off-by: Wang Lei <wang840925@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/pioctl.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)


diff --git a/fs/afs/pioctl.c b/fs/afs/pioctl.c
index 5a76017..63a6211 100644
--- a/fs/afs/pioctl.c
+++ b/fs/afs/pioctl.c
@@ -17,9 +17,28 @@
  */
 long afs_pioctl(struct dentry *dentry, int cmd, struct vice_ioctl *arg)
 {
+	struct afs_vnode *vnode = AFS_FS_I(dentry->d_inode);
+	struct key *key;
+	long ret;
+
+	_enter(",%x(%d),{%d,%d}",
+	       cmd, _IOC_NR(cmd), arg->in_size, arg->out_size);
+
+	key = afs_request_key(vnode->volume->cell);
+	if (IS_ERR(key)) {
+		ret = PTR_ERR(key);
+		_leave(" = %ld [no key]", ret);
+		return ret;
+	}
+
 	switch (cmd) {
 	default:
 		printk(KERN_DEBUG "AFS: Unsupported pioctl command %x\n", cmd);
-		return -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
+		break;
 	}
+
+	key_put(key);
+	_leave(" = %ld", ret);
+	return ret;
 }

