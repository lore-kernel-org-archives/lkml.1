Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbXIQLcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbXIQLcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 07:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbXIQLaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 07:30:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755117AbXIQL35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 07:29:57 -0400
Date: Mon, 17 Sep 2007 07:29:41 -0400
Message-Id: <200709171129.l8HBTfBL024397@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 7/7] CIFS: ignore mode change if it's just for clearing setuid/setgid bits
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: linux-cifs-client@lists.samba.org, nfs@lists.sourceforge.net,
       ecryptfs-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org,
       unionfs@filesystems.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If the ATTR_KILL_S*ID bits are set then any mode change is only for
clearing the setuid/setgid bits. For CIFS, skip the mode change and
let the server handle it.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/inode.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 66436f5..8fa3d63 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1547,6 +1547,11 @@ int cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 	}
 
 	time_buf.Attributes = 0;
+
+	/* skip mode change if it's just for clearing setuid/setgid */
+	if (attrs->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
+		attrs->ia_valid &= ~ATTR_MODE;
+
 	if (attrs->ia_valid & ATTR_MODE) {
 		cFYI(1, ("Mode changed to 0x%x", attrs->ia_mode));
 		mode = attrs->ia_mode;
-- 
1.5.2.1

