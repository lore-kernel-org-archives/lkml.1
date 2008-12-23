Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbYLWDXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbYLWDXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 22:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbYLWDXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 22:23:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53239 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbYLWDXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 22:23:11 -0500
Message-ID: <4950595C.9070907@cn.fujitsu.com>
Date: Tue, 23 Dec 2008 11:22:04 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroups: avoid accessing uninitialized data in failure path
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If cgroup_get_rootdir() failed, free_cg_links() will be called
in the failure path, but tmp_cg_links hasn't been initialized
at that time.

I should be blamed to introduce this bug in 2.6.26 merge window.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 8185a0f..330b7ae 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1024,7 +1024,7 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 		if (ret == -EBUSY) {
 			mutex_unlock(&cgroup_mutex);
 			mutex_unlock(&inode->i_mutex);
-			goto drop_new_super;
+			goto free_cg_links;
 		}
 
 		/* EBUSY should be the only error here */
@@ -1073,10 +1073,11 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 
 	return simple_set_mnt(mnt, sb);
 
+ free_cg_links:
+	free_cg_links(&tmp_cg_links);
  drop_new_super:
 	up_write(&sb->s_umount);
 	deactivate_super(sb);
-	free_cg_links(&tmp_cg_links);
 	return ret;
 }
 
-- 
1.5.4.rc3

