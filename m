Return-Path: <linux-kernel-owner+w=401wt.eu-S933534AbXKPPI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534AbXKPPI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 10:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbXKPPIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 10:08:49 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:19016 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695AbXKPPIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 10:08:48 -0500
Date: Fri, 16 Nov 2007 18:08:40 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH 2/4] proc: detect duplicate names on registration
Message-ID: <20071116150839.GD19517@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, please drop procfs-detect-duplicate-names.patch and apply this
instead.
------------
[PATCH] proc: detect duplicate names on registration

From: Zhang Rui <rui.zhang@intel.com>

Print a warning if PDE is registered with a name which already exists in
target directory.

Bug report and a simple fix can be found here:
http://bugzilla.kernel.org/show_bug.cgi?id=8798

[\n fixlet and no undescriptive variable usage --adobriyan]
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 fs/proc/generic.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -518,6 +518,7 @@ static const struct inode_operations proc_dir_inode_operations = {
 static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp)
 {
 	unsigned int i;
+	struct proc_dir_entry *tmp;
 	
 	i = get_inode_number();
 	if (i == 0)
@@ -536,6 +537,15 @@ static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp
 	}
 
 	spin_lock(&proc_subdir_lock);
+
+	for (tmp = dir->subdir; tmp; tmp = tmp->next)
+		if (strcmp(tmp->name, dp->name) == 0) {
+			printk(KERN_WARNING "PDE '%s' already registered\n",
+				dp->name);
+			dump_stack();
+			break;
+		}
+
 	dp->next = dir->subdir;
 	dp->parent = dir;
 	dir->subdir = dp;

