Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbZLDUt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbZLDUt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 15:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757345AbZLDUt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 15:49:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757471AbZLDUtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 15:49:18 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [RFC PATCH 14/15] security: move ima_file_check() to lsm hook
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Cc: viro@zeniv.linux.org.uk, jmorris@namei.org, npiggin@suse.de,
       eparis@redhat.com, zohar@us.ibm.com, jack@suse.cz,
       jmalicki@metacarta.com, dsmith@redhat.com, serue@us.ibm.com, hch@lst.de,
       john@johnmccutchan.com, rlove@rlove.org, ebiederm@xmission.com,
       heiko.carstens@de.ibm.com, penguin-kernel@I-love.SAKURA.ne.jp,
       mszeredi@suse.cz, jens.axboe@oracle.com, akpm@linux-foundation.org,
       matthew@wil.cx, hugh.dickins@tiscali.co.uk,
       kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
       davem@davemloft.net, arnd@arndb.de, eric.dumazet@gmail.com
Date: Fri, 04 Dec 2009 15:48:32 -0500
Message-ID: <20091204204832.18286.19016.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091204204646.18286.24853.stgit@paris.rdu.redhat.com>
References: <20091204204646.18286.24853.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mimi Zohar <zohar@linux.vnet.ibm.com>

Move the ima_file_check() hook from the vfs into the LSM hook.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/open.c           |    7 -------
 security/security.c |    8 +++++++-
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 10bd04e..25c1436 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -30,7 +30,6 @@
 #include <linux/audit.h>
 #include <linux/falloc.h>
 #include <linux/fs_struct.h>
-#include <linux/ima.h>
 
 #include "internal.h"
 
@@ -875,12 +874,6 @@ static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 		}
 	}
 
-	error = ima_file_check(f);
-	if (error) {
-		fput(f);
-		f = ERR_PTR(error);
-	}
-
 	return f;
 
 cleanup_all:
diff --git a/security/security.c b/security/security.c
index fd2d450..a42586b 100644
--- a/security/security.c
+++ b/security/security.c
@@ -722,7 +722,13 @@ int security_file_receive(struct file *file)
 
 int security_dentry_open(struct file *file, const struct cred *cred)
 {
-	return security_ops->dentry_open(file, cred);
+	int ret;
+
+	ret = security_ops->dentry_open(file, cred);
+	if (ret)
+		return ret;
+
+	return ima_file_check(file);
 }
 
 int security_task_create(unsigned long clone_flags)

