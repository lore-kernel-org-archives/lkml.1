Return-Path: <linux-kernel-owner+w=401wt.eu-S1752166AbYFCNRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbYFCNRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 09:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbYFCNRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 09:17:08 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:44626 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096AbYFCNRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 09:17:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=TB/4bB0IxUK3aVeMAxaLffBi0QhjNhcdTkenLXV68xTc9vKsnyVYzpF5SEHMEIN9su7eI+OJoyF7J4wjL+dLqf5pB2g1mjE7tyrnMWMviI31jNXue0hxz9PafN0/yyzTzOzMeLcA5lvWwc5/5IJl9X8gwPKUCIMLLeKyMXtxf9w=
Date: Tue, 3 Jun 2008 15:16:59 +0200
To: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] proc: calculate the correct /proc/<pid> link count
Message-ID: <20080603131659.GA2970@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Mon, 2 Jun 2008 08:57:45 +0200
Subject: [PATCH] proc: calculate the correct /proc/<pid> link count

commit e9720acd728a46cb40daa52c99a979f7c4ff195c introduced a
/proc/self/net directory without bumping the corresponding link count
for /proc/self.

This patch replaces the static link count initializations with a call
that counts the number of directory entries in the given pid_entry
table whenever it is instantiated, and thus relieves the burden of
manually keeping the two in sync.

Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 fs/proc/base.c |   31 +++++++++++++++++++++++--------
 1 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index c447e07..334ce46 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -127,6 +127,23 @@ struct pid_entry {
 		NULL, &proc_single_file_operations,	\
 		{ .proc_show = &proc_##OTYPE } )
 
+/* Count the number of hardlinks for the pid_entry table, excluding the .
+ * and .. links. */
+static unsigned int pid_entry_count_dirs(const struct pid_entry *entries,
+	unsigned int n)
+{
+	unsigned int i;
+	unsigned int count;
+
+	count = 0;
+	for (i = 0; i < n; ++i) {
+		if (S_ISDIR(entries[i].mode))
+			++count;
+	}
+
+	return count;
+}
+
 int maps_protect;
 EXPORT_SYMBOL(maps_protect);
 
@@ -2585,10 +2602,9 @@ static struct dentry *proc_pid_instantiate(struct inode *dir,
 	inode->i_op = &proc_tgid_base_inode_operations;
 	inode->i_fop = &proc_tgid_base_operations;
 	inode->i_flags|=S_IMMUTABLE;
-	inode->i_nlink = 5;
-#ifdef CONFIG_SECURITY
-	inode->i_nlink += 1;
-#endif
+
+	inode->i_nlink = 2 + pid_entry_count_dirs(tgid_base_stuff,
+		ARRAY_SIZE(tgid_base_stuff));
 
 	dentry->d_op = &pid_dentry_operations;
 
@@ -2816,10 +2832,9 @@ static struct dentry *proc_task_instantiate(struct inode *dir,
 	inode->i_op = &proc_tid_base_inode_operations;
 	inode->i_fop = &proc_tid_base_operations;
 	inode->i_flags|=S_IMMUTABLE;
-	inode->i_nlink = 4;
-#ifdef CONFIG_SECURITY
-	inode->i_nlink += 1;
-#endif
+
+	inode->i_nlink = 2 + pid_entry_count_dirs(tid_base_stuff,
+		ARRAY_SIZE(tid_base_stuff));
 
 	dentry->d_op = &pid_dentry_operations;
 
-- 
1.5.4.1

