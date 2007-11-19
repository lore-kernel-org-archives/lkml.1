Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbXKSWbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbXKSWbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755369AbXKSWbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:31:38 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57826 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbXKSWbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:31:37 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH] proc: Proper pidns handling for /proc/self
References: <20071117183109.GA2605@tv-sign.ru>
Date: Mon, 19 Nov 2007 15:30:06 -0700
In-Reply-To: <20071117183109.GA2605@tv-sign.ru> (Oleg Nesterov's message of
	"Sat, 17 Nov 2007 21:31:09 +0300")
Message-ID: <m1ejeluavl.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Currently if you access a /proc that is not mounted with your
processes current pid namespace /proc/self will point at a completely
different process.  Ouch!.

This patch fixes /proc/self to point to the current process if
it is available in the particular mount of /proc or to return
-ENOENT if the current process is not visible.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/base.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 7e8eca4..34a1821 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2049,15 +2049,23 @@ static const struct file_operations proc_coredump_filter_operations = {
 static int proc_self_readlink(struct dentry *dentry, char __user *buffer,
 			      int buflen)
 {
+	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
+	pid_t tgid = task_tgid_nr_ns(current, ns);
 	char tmp[PROC_NUMBUF];
-	sprintf(tmp, "%d", task_tgid_vnr(current));
+	if (!tgid)
+		return -ENOENT;
+	sprintf(tmp, "%d", tgid);
 	return vfs_readlink(dentry,buffer,buflen,tmp);
 }
 
 static void *proc_self_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
+	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
+	pid_t tgid = task_tgid_nr_ns(current, ns);
 	char tmp[PROC_NUMBUF];
-	sprintf(tmp, "%d", task_tgid_vnr(current));
+	if (!tgid)
+		return ERR_PTR(-ENOENT);
+	sprintf(tmp, "%d", task_tgid_nr_ns(current, ns));
 	return ERR_PTR(vfs_follow_link(nd,tmp));
 }
 
-- 
1.5.3.rc6.17.g1911

