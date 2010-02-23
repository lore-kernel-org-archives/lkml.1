Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab0BXHIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:08:11 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:34197 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab0BXHII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:08:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=UbkM3nezJgANYAaAushZm86M5QiDHmdmx9sQFdZ4s66MapX8XA4jiwMgISciLCVDZG
         LSpfZ1fedMuLjxyrlGvD5nhJ3lZEOAXPhjQgRMGQQf3sEWAam44F1Lj6tbrXDFnJ6wIa
         8+5FGGye+ZuKa7L7KsHbW6J0uNR/y6nXYNqIk=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Serge E . Hallyn" <serue@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH 3/6] mqueue: simplify do_open() error handling
Date: Tue, 23 Feb 2010 04:04:25 -0300
Message-Id: <16a124bca4a5ba7f104634d783a67c77359de182.1266907496.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
In-Reply-To: <cover.1266907495.git.andre.goddard@gmail.com>
References: <cover.1266907495.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It reduces code size:
text    data     bss     dec     hex filename
9925      72      16   10013    271d ipc/mqueue-BEFORE.o
9885      72      16    9973    26f5 ipc/mqueue-AFTER.o

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 ipc/mqueue.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 04403fd..2cddf93 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -657,24 +657,28 @@ out:
 static struct file *do_open(struct ipc_namespace *ipc_ns,
 				struct dentry *dentry, int oflag)
 {
+	int ret;
 	const struct cred *cred = current_cred();
 
 	static const int oflag2acc[O_ACCMODE] = { MAY_READ, MAY_WRITE,
 						  MAY_READ | MAY_WRITE };
 
 	if ((oflag & O_ACCMODE) == (O_RDWR | O_WRONLY)) {
-		dput(dentry);
-		mntput(ipc_ns->mq_mnt);
-		return ERR_PTR(-EINVAL);
+		ret = -EINVAL;
+		goto err;
 	}
 
 	if (inode_permission(dentry->d_inode, oflag2acc[oflag & O_ACCMODE])) {
-		dput(dentry);
-		mntput(ipc_ns->mq_mnt);
-		return ERR_PTR(-EACCES);
+		ret = -EACCES;
+		goto err;
 	}
 
 	return dentry_open(dentry, ipc_ns->mq_mnt, oflag, cred);
+
+err:
+	dput(dentry);
+	mntput(ipc_ns->mq_mnt);
+	return ERR_PTR(ret);
 }
 
 SYSCALL_DEFINE4(mq_open, const char __user *, u_name, int, oflag, mode_t, mode,
-- 
1.7.0.87.g0901d

