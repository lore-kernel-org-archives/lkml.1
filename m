Return-Path: <linux-kernel-owner+w=401wt.eu-S1765191AbXKOQQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765191AbXKOQQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 11:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757858AbXKOQQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 11:16:13 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:7780 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385AbXKOQQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 11:16:12 -0500
Date: Thu, 15 Nov 2007 19:15:36 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH] proc: remove useless checks in proc_register()
Message-ID: <20071115161536.GI6216@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Before proc_register() all PDEs are created by proc_create() which
doesn't set ->proc_iops and ->proc_fops -- they're NULL. So those
branches in proc_register() always taken.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 fs/proc/generic.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -525,19 +525,14 @@ static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp
 	dp->low_ino = i;
 
 	if (S_ISDIR(dp->mode)) {
-		if (dp->proc_iops == NULL) {
-			dp->proc_fops = &proc_dir_operations;
-			dp->proc_iops = &proc_dir_inode_operations;
-		}
+		dp->proc_fops = &proc_dir_operations;
+		dp->proc_iops = &proc_dir_inode_operations;
 		dir->nlink++;
 	} else if (S_ISLNK(dp->mode)) {
-		if (dp->proc_iops == NULL)
-			dp->proc_iops = &proc_link_inode_operations;
+		dp->proc_iops = &proc_link_inode_operations;
 	} else if (S_ISREG(dp->mode)) {
-		if (dp->proc_fops == NULL)
-			dp->proc_fops = &proc_file_operations;
-		if (dp->proc_iops == NULL)
-			dp->proc_iops = &proc_file_inode_operations;
+		dp->proc_fops = &proc_file_operations;
+		dp->proc_iops = &proc_file_inode_operations;
 	}
 
 	spin_lock(&proc_subdir_lock);

