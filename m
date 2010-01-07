Return-Path: <linux-kernel-owner+w=401wt.eu-S1752620Ab0AGMtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab0AGMtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 07:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235Ab0AGMtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 07:49:42 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34236 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab0AGMtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 07:49:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GRbgo6OPRP1bvQGm+ZadXHiIj22lKSQs9vlQUxEmaymAlOAGpnDDBj6HsAEU++dvSu
         zRk4UG5aB1lRr9dmIhFTic4yS8yq3zeoBaKkAF++H7sc6ZTIsYzQePuJ3UH1YNUuZsHz
         wczC9AXs0h6QvAbQlAWn8xLd4Hgk4SKpmBxo8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] reiserfs: Don't call reiserfs_get_acl() with the reiserfs lock
Date: Thu,  7 Jan 2010 13:49:37 +0100
Message-Id: <1262868577-6389-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reiserfs_get_acl is usually not called under the reiserfs lock,
as it doesn't need it. But it happens when it is called by
reiserfs_acl_chmod(), which creates a dependency inversion against
the private xattr inodes mutexes for the given inode.

We need to call it without the reiserfs lock, especially since
it's unnecessary.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 fs/reiserfs/xattr_acl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/reiserfs/xattr_acl.c b/fs/reiserfs/xattr_acl.c
index 35d6e67..f559c9e 100644
--- a/fs/reiserfs/xattr_acl.c
+++ b/fs/reiserfs/xattr_acl.c
@@ -452,7 +452,9 @@ int reiserfs_acl_chmod(struct inode *inode)
 		return 0;
 	}
 
+	reiserfs_write_unlock(inode->i_sb);
 	acl = reiserfs_get_acl(inode, ACL_TYPE_ACCESS);
+	reiserfs_write_lock(inode->i_sb);
 	if (!acl)
 		return 0;
 	if (IS_ERR(acl))
-- 
1.6.2.3

