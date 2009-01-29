Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbZA2Ghp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbZA2Ghp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 01:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbZA2Ghg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 01:37:36 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37896 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbZA2Ghg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 01:37:36 -0500
Date: Wed, 28 Jan 2009 22:33:30 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, hpa@zytor.com, hch@lst.de
Cc: serue@us.ibm.com, "David C. Hansen" <haveblue@us.ibm.com>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org,
       sukadev@us.ibm.com
Subject: [RFC][PATCH] devpts: Must release s_umount on error
Message-ID: <20090129063330.GB22898@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Wed, 28 Jan 2009 16:57:12 -0800
Subject: [RFC][PATCH] devpts: Must release s_umount on error

We should drop the ->s_umount mutex if an error occurs after the
sget()/grab_super() call. This was introduced when adding support
for multiple instances of devpts and noticed during a code review/reorg.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 fs/devpts/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index d008105..ad186b4 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -390,6 +390,7 @@ static int new_pts_mount(struct file_system_type *fs_type, int flags,
 
 fail:
 	dput(mnt->mnt_sb->s_root);
+	up_write(&mnt->mnt_sb->s_umount);
 	deactivate_super(mnt->mnt_sb);
 	return err;
 }
@@ -479,6 +480,7 @@ static int init_pts_mount(struct file_system_type *fs_type, int flags,
 	err = mknod_ptmx(mnt->mnt_sb);
 	if (err) {
 		dput(mnt->mnt_sb->s_root);
+		up_write(&mnt->mnt_sb->s_umount);
 		deactivate_super(mnt->mnt_sb);
 	}
 
-- 
1.5.2.5

