Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbZBVWGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbZBVWGj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 17:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbZBVWGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 17:06:31 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23110 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbZBVWGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 17:06:30 -0500
Date: Sun, 22 Feb 2009 23:05:48 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Paul Jackson <pj@sgi.com>, Simon Derr <simon.derr@bull.net>,
       Paul Menage <menage@google.com>, Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] Remove some pointless conditionals before kfree() in
 kernel/cgroup.c
Message-ID: <alpine.LNX.2.00.0902222254350.1236@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's a small patch for kernel/cgroup.c

Removes a few pointless tests of pointer == 0 before kfree() in 
kernel/cgroup.c.
If the pointer we hand to kfree() is 0, then kfree() is a noop, so there 
is no need to test.

Reduces object file size a bit : 

Before:
$ size kernel/cgroup.o
   text    data     bss     dec     hex filename
  21593    7804    4924   34321    8611 kernel/cgroup.o
After:
$ size kernel/cgroup.o
   text    data     bss     dec     hex filename
  21537    7744    4924   34205    859d kernel/cgroup.o

and source file size shrinks a bit too - always nice.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9edb5c4..1c0a9b5 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -865,8 +865,7 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
 	if (opts.release_agent)
 		strcpy(root->release_agent_path, opts.release_agent);
  out_unlock:
-	if (opts.release_agent)
-		kfree(opts.release_agent);
+	kfree(opts.release_agent);
 	mutex_unlock(&cgroup_mutex);
 	mutex_unlock(&cgrp->dentry->d_inode->i_mutex);
 	return ret;
@@ -969,15 +968,13 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 	/* First find the desired set of subsystems */
 	ret = parse_cgroupfs_options(data, &opts);
 	if (ret) {
-		if (opts.release_agent)
-			kfree(opts.release_agent);
+		kfree(opts.release_agent);
 		return ret;
 	}
 
 	root = kzalloc(sizeof(*root), GFP_KERNEL);
 	if (!root) {
-		if (opts.release_agent)
-			kfree(opts.release_agent);
+		kfree(opts.release_agent);
 		return -ENOMEM;
 	}
 


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

