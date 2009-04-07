Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbZDGFq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbZDGFq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 01:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbZDGFqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 01:46:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52871 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbZDGFqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 01:46:48 -0400
Message-ID: <49DAE8E4.2030106@cn.fujitsu.com>
Date: Tue, 07 Apr 2009 13:47:16 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] devcgroup: skip superfluous checks when found the DEV_ALL
 elem
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While walking through the whitelist, if the DEV_ALL item is found,
no more check is needed.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 security/device_cgroup.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 5fda7df..b8186ba 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -490,7 +490,7 @@ int devcgroup_inode_permission(struct inode *inode, int mask)
 
 	list_for_each_entry_rcu(wh, &dev_cgroup->whitelist, list) {
 		if (wh->type & DEV_ALL)
-			goto acc_check;
+			goto found;
 		if ((wh->type & DEV_BLOCK) && !S_ISBLK(inode->i_mode))
 			continue;
 		if ((wh->type & DEV_CHAR) && !S_ISCHR(inode->i_mode))
@@ -499,11 +499,12 @@ int devcgroup_inode_permission(struct inode *inode, int mask)
 			continue;
 		if (wh->minor != ~0 && wh->minor != iminor(inode))
 			continue;
-acc_check:
+
 		if ((mask & MAY_WRITE) && !(wh->access & ACC_WRITE))
 			continue;
 		if ((mask & MAY_READ) && !(wh->access & ACC_READ))
 			continue;
+found:
 		rcu_read_unlock();
 		return 0;
 	}
@@ -527,7 +528,7 @@ int devcgroup_inode_mknod(int mode, dev_t dev)
 
 	list_for_each_entry_rcu(wh, &dev_cgroup->whitelist, list) {
 		if (wh->type & DEV_ALL)
-			goto acc_check;
+			goto found;
 		if ((wh->type & DEV_BLOCK) && !S_ISBLK(mode))
 			continue;
 		if ((wh->type & DEV_CHAR) && !S_ISCHR(mode))
@@ -536,9 +537,10 @@ int devcgroup_inode_mknod(int mode, dev_t dev)
 			continue;
 		if (wh->minor != ~0 && wh->minor != MINOR(dev))
 			continue;
-acc_check:
+
 		if (!(wh->access & ACC_MKNOD))
 			continue;
+found:
 		rcu_read_unlock();
 		return 0;
 	}
-- 
1.5.4.rc3

