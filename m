Return-Path: <linux-kernel-owner+w=401wt.eu-S1752275AbZIGVDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbZIGVDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 17:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbZIGVDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 17:03:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751959AbZIGVDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 17:03:49 -0400
Date: Mon, 7 Sep 2009 14:02:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>
cc: Eric Paris <eparis@redhat.com>, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: [PATCH 2/8] Simplify exec_permission_lite() logic
In-Reply-To: <alpine.LFD.2.01.0909071401210.3419@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0909071402220.3419@localhost.localdomain>
References: <alpine.LFD.2.01.0909071337510.3419@localhost.localdomain> <alpine.LFD.2.01.0909071401210.3419@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 28 Aug 2009 10:50:37 -0700

Instead of returning EAGAIN and having the caller do something
special for that case,  just do the special case directly.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 fs/namei.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 164aa15..bf8aa95 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -435,7 +435,7 @@ static int exec_permission_lite(struct inode *inode)
 	umode_t	mode = inode->i_mode;
 
 	if (inode->i_op->permission)
-		return -EAGAIN;
+		return inode_permission(inode, MAY_EXEC);
 
 	if (current_fsuid() == inode->i_uid)
 		mode >>= 6;
@@ -853,9 +853,6 @@ static int __link_path_walk(const char *name, struct nameidata *nd)
 
 		nd->flags |= LOOKUP_CONTINUE;
 		err = exec_permission_lite(inode);
-		if (err == -EAGAIN)
-			err = inode_permission(nd->path.dentry->d_inode,
-					       MAY_EXEC);
  		if (err)
 			break;
 
-- 
1.6.4.1.209.g74b8

