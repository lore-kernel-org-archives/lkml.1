Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbXLRWqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbXLRWqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbXLRWqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:46:23 -0500
Received: from rtr.ca ([76.10.145.34]:4530 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbXLRWqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:46:22 -0500
Message-ID: <47684DBD.6030502@rtr.ca>
Date: Tue, 18 Dec 2007 17:46:21 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: RFC: permit link(2)  to work across --bind mounts ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why does link(2) not support hard-linking across bind mount points
of the same underlying filesystem ?

Is it as simple as something like this patch below (minus the printk)?
Not likely, but then I'm not a filesystem guru.

???

--- old/fs/namei.c	2007-12-15 12:33:13.000000000 -0500
+++ linux/fs/namei.c	2007-12-18 17:37:04.000000000 -0500
@@ -2398,8 +2398,11 @@
 	if (error)
 		goto out;
 	error = -EXDEV;
-	if (old_nd.mnt != nd.mnt)
-		goto out_release;
+	if (old_nd.mnt != nd.mnt) {
+		if (old_nd.mnt->mnt_sb != nd.mnt->mnt_sb)
+			goto out_release;
+		printk("sys_linkat: old_nd.mnt != nd.mnt, but sb is the same. Continuing..\n");
+	}
 	new_dentry = lookup_create(&nd, 0);
 	error = PTR_ERR(new_dentry);
 	if (IS_ERR(new_dentry))
