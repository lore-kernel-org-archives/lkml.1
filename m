Return-Path: <linux-kernel-owner+w=401wt.eu-S1762645AbXFEC7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762645AbXFEC7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 22:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758199AbXFEC7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 22:59:45 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:39601 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbXFEC7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 22:59:44 -0400
X-IronPort-AV: i="4.16,383,1175486400"; 
   d="scan'208"; a="41089844:sNHT25560633"
Subject: [PATCH] RAMFS NOMMU: missed POSIX UID/GID inode attribute checking
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: David Howells <dhowells@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Tue, 05 Jun 2007 11:02:01 +0800
Message-Id: <1181012521.1577.5.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bryan Wu <bryan.wu@analog.com>

This bug was caught by LTP testcase fchmod06 on Blackfin platform.

In the manpage of fchmod, "EPERM: The effective UID does not match the
owner of the file, and the process is not privileged (Linux: it does not
have the CAP_FOWNER capability)."

But the ramfs nommu code missed the inode_change_ok POSIX UID/GID
verification. This patch fixed this.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Cc: David Howells <dhowells@redhat.com>
---
 fs/ramfs/file-nommu.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index 9345a46..5d258c4 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -195,6 +195,11 @@ static int ramfs_nommu_setattr(struct dentry *dentry, struct iattr *ia)
 	unsigned int old_ia_valid = ia->ia_valid;
 	int ret = 0;
 
+	/* POSIX UID/GID verification for setting inode attributes */
+	ret = inode_change_ok(inode, ia);
+	if (ret)
+		return ret;
+
 	/* by providing our own setattr() method, we skip this quotaism */
 	if ((old_ia_valid & ATTR_UID && ia->ia_uid != inode->i_uid) ||
 	    (old_ia_valid & ATTR_GID && ia->ia_gid != inode->i_gid))
-- 
1.5.2

