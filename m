Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbYJWCpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbYJWCpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191AbYJWCpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:45:35 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:26418
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756151AbYJWCpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:45:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAPp//0h8qQJT/2dsb2JhbADAQINO
X-IronPort-AV: E=Sophos;i="4.33,468,1220198400"; 
   d="scan'208";a="267105480"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 1/6] autofs4 - correct offset mount expire check
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>
Date: Thu, 23 Oct 2008 10:35:13 +0800
Message-ID: <20081023023513.4508.54940.stgit@raven.themaw.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When checking a directory tree in autofs_tree_busy() we can incorrectly
decide that the tree isn't busy. This happens for the case of an active
offset mount as autofs4_follow_mount() follows past the active offset
mount, which has an open file handle used for expires, causing the file
handle not to count toward the busyness check.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

---

 fs/autofs4/expire.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)


diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index cde2f8e..4b6fb3f 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -56,12 +56,23 @@ static int autofs4_mount_busy(struct vfsmount *mnt, struct dentry *dentry)
 	mntget(mnt);
 	dget(dentry);
 
-	if (!autofs4_follow_mount(&mnt, &dentry))
+	if (!follow_down(&mnt, &dentry))
 		goto done;
 
-	/* This is an autofs submount, we can't expire it */
-	if (is_autofs4_dentry(dentry))
-		goto done;
+	if (is_autofs4_dentry(dentry)) {
+		struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+
+		/* This is an autofs submount, we can't expire it */
+		if (sbi->type == AUTOFS_TYPE_INDIRECT)
+			goto done;
+
+		/*
+		 * Otherwise it's an offset mount and we need to check
+		 * if we can umount its mount, if there is one.
+		 */
+		if (!d_mountpoint(dentry))
+			goto done;
+	}
 
 	/* Update the expiry counter if fs is busy */
 	if (!may_umount_tree(mnt)) {

