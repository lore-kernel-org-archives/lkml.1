Return-Path: <linux-kernel-owner+w=401wt.eu-S934057AbYBGUL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934057AbYBGUL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759812AbYBGUEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:04:16 -0500
Received: from ns2.suse.de ([195.135.220.15]:59568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761735AbYBGUEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:04:14 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Roland Dreier <rdreier@cisco.com>,
       Tejun Heo <htejun@gmail.com>
Subject: [PATCH 3/3] sysfs: remove BUG_ON() from sysfs_remove_group()
Date: Thu,  7 Feb 2008 12:02:19 -0800
Message-Id: <1202414539-4672-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <20080207200140.GA4572@suse.de>
References: <20080207200140.GA4572@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's possible that the caller of sysfs_remove_group messed up and passed in an attribute group that was not really registered to this kobject.  But don't panic for such a foolish error, spit out a warning about what happened, and continue on our way safely.

Cc: Roland Dreier <rdreier@cisco.com>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/group.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 0871c3d..4779049 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -77,7 +77,12 @@ void sysfs_remove_group(struct kobject * kobj,
 
 	if (grp->name) {
 		sd = sysfs_get_dirent(dir_sd, grp->name);
-		BUG_ON(!sd);
+		if (!sd) {
+			printk(KERN_WARNING "sysfs group %p not found for "
+				"kobject '%s'\n", grp, kobject_name(kobj));
+			WARN_ON(!sd);
+			return;
+		}
 	} else
 		sd = sysfs_get(dir_sd);
 
-- 
1.5.4

