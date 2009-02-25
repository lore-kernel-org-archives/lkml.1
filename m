Return-Path: <linux-kernel-owner+w=401wt.eu-S1760846AbZBYHh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760846AbZBYHh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 02:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbZBYHhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 02:37:18 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58171 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355AbZBYHhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 02:37:17 -0500
Date: Wed, 25 Feb 2009 16:35:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
       "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: [PATCH 1/2] cgroup allow subsys to set default mode of its own file
Message-Id: <20090225163555.d2a0b24c.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

cgroup's subsys has "readonly" files, but default permission is always
rw-r--r--. This allows to create r--r--r-- file to subsys.
(The user can do chmod on this read-only file. But this behavior is not
 different from current pseudo file systems as /proc.)

Reason:
 When I wrote tools for maintain cgroup, I can't find which file is
 writable intarfece or not via cgroup file systems. (finally, I did
 dirty approach.)
 IMHO, showing "this file is read-only" in explicit way is useful
 for user-land (tools). In other story, a file whose name sounds read-only
 may have "trigger" operation and support reseting. In this case,
 "writable" is informative.
 

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/cgroup.h |    2 ++
 kernel/cgroup.c        |    5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

Index: mmotm-2.6.29-Feb24/include/linux/cgroup.h
===================================================================
--- mmotm-2.6.29-Feb24.orig/include/linux/cgroup.h
+++ mmotm-2.6.29-Feb24/include/linux/cgroup.h
@@ -258,6 +258,8 @@ struct cftype {
 	 */
 	char name[MAX_CFTYPE_NAME];
 	int private;
+	/* if not 0, mode is set to mode, otherwise 0644 */
+	int mode;
 
 	/*
 	 * If non-zero, defines the maximum length of string that can
Index: mmotm-2.6.29-Feb24/kernel/cgroup.c
===================================================================
--- mmotm-2.6.29-Feb24.orig/kernel/cgroup.c
+++ mmotm-2.6.29-Feb24/kernel/cgroup.c
@@ -1767,7 +1767,10 @@ int cgroup_add_file(struct cgroup *cgrp,
 	BUG_ON(!mutex_is_locked(&dir->d_inode->i_mutex));
 	dentry = lookup_one_len(name, dir, strlen(name));
 	if (!IS_ERR(dentry)) {
-		error = cgroup_create_file(dentry, 0644 | S_IFREG,
+		int mode = 0644;
+		if (cft->mode)
+			mode = cft->mode;
+		error = cgroup_create_file(dentry, mode | S_IFREG,
 						cgrp->root->sb);
 		if (!error)
 			dentry->d_fsdata = (void *)cft;

