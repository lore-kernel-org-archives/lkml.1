Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582Ab0AKSik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab0AKSik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 13:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436Ab0AKSij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 13:38:39 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:41859 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab0AKSii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 13:38:38 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] procfs: Fix refcnt leak on proc_self_follow_link() error path
Date: Tue, 12 Jan 2010 03:38:36 +0900
Message-ID: <87aawkjxlf.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If ->follow_link handler return the error, it should decrement
nd->path refcnt.

This patch fix it.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/proc/base.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/proc/base.c~namei-procfs-follow_link-fix fs/proc/base.c
--- linux-2.6/fs/proc/base.c~namei-procfs-follow_link-fix	2010-01-12 00:15:15.000000000 +0900
+++ linux-2.6-hirofumi/fs/proc/base.c	2010-01-12 00:15:15.000000000 +0900
@@ -2371,8 +2371,10 @@ static void *proc_self_follow_link(struc
 	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
 	pid_t tgid = task_tgid_nr_ns(current, ns);
 	char tmp[PROC_NUMBUF];
-	if (!tgid)
+	if (!tgid) {
+		path_put(&nd->path);
 		return ERR_PTR(-ENOENT);
+	}
 	sprintf(tmp, "%d", task_tgid_nr_ns(current, ns));
 	return ERR_PTR(vfs_follow_link(nd,tmp));
 }
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
