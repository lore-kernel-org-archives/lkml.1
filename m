Return-Path: <linux-kernel-owner+w=401wt.eu-S965330AbXBUFN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965330AbXBUFN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 00:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965351AbXBUFN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 00:13:56 -0500
Received: from wx-out-0506.google.com ([66.249.82.235]:9533 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965330AbXBUFNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 00:13:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=WSrEuXc5vVS68/2yqqRVQbaovt9xFnhY7Mf3WuL//QGpdzQ8hHvbnH2i1ddbanr/mcGHP36lm8An8qZ15VuU5LHcrvphsio3oY9kNu/cEyCu+ABCg1CrptmcxGUYVKhooA7d60ppfItc4zEWp/Ah+c3IT6uzR5nZNilQ4nvB3OU=
Message-ID: <45DBD56B.30104@gmail.com>
Date: Wed, 21 Feb 2007 00:15:23 -0500
From: Florin Malita <fmalita@gmail.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061027)
MIME-Version: 1.0
To: akpm@osdl.org, hpa@zytor.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] devpts: add fsnotify create event
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, devpts doesn't generate an fsnotify event upon pts creation 
because the regular vfs paths aren't involved. Deallocation, on the 
other hand, correctly generates a nameremove event thanks to the 
d_delete() invocation in devpts_pty_kill().

This patch adds the missing fsnotify_create() trigger in devpts_pty_new().

Signed-off-by: Florin Malita <fmalita@gmail.com>
---

 fs/devpts/inode.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 643e57b..06ef9a2 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -19,6 +19,7 @@ #include <linux/mount.h>
 #include <linux/tty.h>
 #include <linux/devpts_fs.h>
 #include <linux/parser.h>
+#include <linux/fsnotify.h>
 
 #define DEVPTS_SUPER_MAGIC 0x1cd1
 
@@ -178,8 +179,10 @@ int devpts_pty_new(struct tty_struct *tt
 	inode->i_private = tty;
 
 	dentry = get_node(number);
-	if (!IS_ERR(dentry) && !dentry->d_inode)
+	if (!IS_ERR(dentry) && !dentry->d_inode) {
 		d_instantiate(dentry, inode);
+		fsnotify_create(devpts_root->d_inode, dentry);
+	}
 
 	mutex_unlock(&devpts_root->d_inode->i_mutex);
 


