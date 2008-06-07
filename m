Return-Path: <linux-kernel-owner+w=401wt.eu-S1764329AbYFGBYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764329AbYFGBYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760475AbYFGBJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:47 -0400
Received: from sous-sol.org ([216.99.217.87]:42544 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758916AbYFGBJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:27 -0400
Message-Id: <20080607010631.521435380@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:57 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Eric W Biederman <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       "David S. Miller" <davem@davemloft.net>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: [patch 42/50] proc: calculate the correct /proc/<pid> link count
Content-Disposition: inline; filename=proc-calculate-the-correct-proc-pid-link-count.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Vegard Nossum <vegard.nossum@gmail.com>

upstream commit: aed5417593ad125283f35513573282139a8664b5

This patch:

  commit e9720acd728a46cb40daa52c99a979f7c4ff195c
  Author: Pavel Emelyanov <xemul@openvz.org>
  Date:   Fri Mar 7 11:08:40 2008 -0800

    [NET]: Make /proc/net a symlink on /proc/self/net (v3)

introduced a /proc/self/net directory without bumping the corresponding
link count for /proc/self.

This patch replaces the static link count initializations with a call that
counts the number of directory entries in the given pid_entry table
whenever it is instantiated, and thus relieves the burden of manually
keeping the two in sync.

[akpm@linux-foundation.org: cleanup]
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/proc/base.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -126,6 +126,25 @@ struct pid_entry {
 		NULL, &proc_single_file_operations,	\
 		{ .proc_show = &proc_##OTYPE } )
 
+/*
+ * Count the number of hardlinks for the pid_entry table, excluding the .
+ * and .. links.
+ */
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
 
@@ -2483,10 +2502,9 @@ static struct dentry *proc_pid_instantia
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
 
@@ -2713,10 +2731,9 @@ static struct dentry *proc_task_instanti
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
