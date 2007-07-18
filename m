Return-Path: <linux-kernel-owner+w=401wt.eu-S964868AbXGRXcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868AbXGRXcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936408AbXGRX1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:27:17 -0400
Received: from mail.suse.de ([195.135.220.2]:57480 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936265AbXGRX1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:27:15 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Gabriel C <nix.or.die@googlemail.com>,
       Miles Lane <miles.lane@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 13/14] sysfs: kill an extra put in sysfs_create_link() failure path
Date: Wed, 18 Jul 2007 16:25:49 -0700
Message-Id: <11848012023373-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11848011982615-git-send-email-gregkh@suse.de>
References: <20070718232400.GC4620@kroah.com>
 <11848011502972-git-send-email-gregkh@suse.de>
 <11848011551094-git-send-email-gregkh@suse.de>
 <11848011593154-git-send-email-gregkh@suse.de>
 <118480116414-git-send-email-gregkh@suse.de>
 <1184801169806-git-send-email-gregkh@suse.de>
 <11848011731698-git-send-email-gregkh@suse.de>
 <1184801177102-git-send-email-gregkh@suse.de>
 <11848011802979-git-send-email-gregkh@suse.de>
 <11848011842017-git-send-email-gregkh@suse.de>
 <1184801188568-git-send-email-gregkh@suse.de>
 <11848011924027-git-send-email-gregkh@suse.de>
 <11848011982615-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

There is a subtle bug in sysfs_create_link() failure path.  When
symlink creation fails because there's already a node with the same
name, the target sysfs_dirent is put twice - once by failure path of
sysfs_create_link() and once more when the symlink is released.

Fix it by making only the symlink node responsible for putting
target_sd.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Gabriel C <nix.or.die@googlemail.com>
Cc: Miles Lane <miles.lane@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/symlink.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 2f86e04..d056e96 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -86,7 +86,9 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 	sd = sysfs_new_dirent(name, S_IFLNK|S_IRWXUGO, SYSFS_KOBJ_LINK);
 	if (!sd)
 		goto out_put;
+
 	sd->s_elem.symlink.target_sd = target_sd;
+	target_sd = NULL;	/* reference is now owned by the symlink */
 
 	sysfs_addrm_start(&acxt, parent_sd);
 
-- 
1.5.2.2

