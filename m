Return-Path: <linux-kernel-owner+w=401wt.eu-S1752339AbZIGVEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbZIGVEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 17:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZIGVEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 17:04:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751917AbZIGVEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 17:04:41 -0400
Date: Mon, 7 Sep 2009 14:03:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>
cc: Eric Paris <eparis@redhat.com>, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: [PATCH 4/8] Simplify exec_permission_lite(), part 3
In-Reply-To: <alpine.LFD.2.01.0909071402510.3419@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0909071403110.3419@localhost.localdomain>
References: <alpine.LFD.2.01.0909071337510.3419@localhost.localdomain> <alpine.LFD.2.01.0909071401210.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402220.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402510.3419@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 28 Aug 2009 11:08:31 -0700

Don't call down to the generic inode_permission() function just to
call the inode-specific permission function - just do it directly.

The generic inode_permission() code does things like checking MAY_WRITE
and devcgroup_inode_permission(), neither of which are relevant for the
light pathname walk permission checks (we always do just MAY_EXEC, and
the inode is never a special device).

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 fs/namei.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index e39e5cb..7959e70 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -434,8 +434,12 @@ static int exec_permission_lite(struct inode *inode)
 {
 	umode_t	mode = inode->i_mode;
 
-	if (inode->i_op->permission)
-		return inode_permission(inode, MAY_EXEC);
+	if (inode->i_op->permission) {
+		int ret = inode->i_op->permission(inode, MAY_EXEC);
+		if (!ret)
+			goto ok;
+		return ret;
+	}
 
 	if (current_fsuid() == inode->i_uid)
 		mode >>= 6;
-- 
1.6.4.1.209.g74b8

