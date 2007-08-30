Return-Path: <linux-kernel-owner+w=401wt.eu-S1762685AbXH3PHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762685AbXH3PHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 11:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761410AbXH3PHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 11:07:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760690AbXH3PHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 11:07:05 -0400
Date: Thu, 30 Aug 2007 11:06:59 -0400
Message-Id: <200708301506.l7UF6xHg002143@dantu.rdu.redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: linux-cifs-client@lists.samba.org, nfs@lists.sourceforge.net
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 3/3] CIFS: ignore mode change if it's just for clearing setuid/setgid bits
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
index dd41677..279f3c5 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1538,6 +1538,11 @@ int cifs_setattr(struct dentry *direntry, struct iattr *attrs)
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

