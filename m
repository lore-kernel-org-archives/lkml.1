Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999Ab0ANWdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab0ANWdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873Ab0ANWdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:33:33 -0500
Received: from kroah.org ([198.145.64.141]:60637 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756758Ab0ANW2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:50 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 37/52] quota: Fix dquot_transfer for filesystems different from ext4
Date: Thu, 14 Jan 2010 14:27:16 -0800
Message-Id: <1263508051-7868-37-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-36-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
 <1263508051-7868-13-git-send-email-gregkh@suse.de>
 <1263508051-7868-14-git-send-email-gregkh@suse.de>
 <1263508051-7868-15-git-send-email-gregkh@suse.de>
 <1263508051-7868-16-git-send-email-gregkh@suse.de>
 <1263508051-7868-17-git-send-email-gregkh@suse.de>
 <1263508051-7868-18-git-send-email-gregkh@suse.de>
 <1263508051-7868-19-git-send-email-gregkh@suse.de>
 <1263508051-7868-20-git-send-email-gregkh@suse.de>
 <1263508051-7868-21-git-send-email-gregkh@suse.de>
 <1263508051-7868-22-git-send-email-gregkh@suse.de>
 <1263508051-7868-23-git-send-email-gregkh@suse.de>
 <1263508051-7868-24-git-send-email-gregkh@suse.de>
 <1263508051-7868-25-git-send-email-gregkh@suse.de>
 <1263508051-7868-26-git-send-email-gregkh@suse.de>
 <1263508051-7868-27-git-send-email-gregkh@suse.de>
 <1263508051-7868-28-git-send-email-gregkh@suse.de>
 <1263508051-7868-29-git-send-email-gregkh@suse.de>
 <1263508051-7868-30-git-send-email-gregkh@suse.de>
 <1263508051-7868-31-git-send-email-gregkh@suse.de>
 <1263508051-7868-32-git-send-email-gregkh@suse.de>
 <1263508051-7868-33-git-send-email-gregkh@suse.de>
 <1263508051-7868-34-git-send-email-gregkh@suse.de>
 <1263508051-7868-35-git-send-email-gregkh@suse.de>
 <1263508051-7868-36-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 05b5d898235401c489c68e1f3bc5706a29ad5713 upstream.

Commit fd8fbfc1 modified the way we find amount of reserved space
belonging to an inode. The amount of reserved space is checked
from dquot_transfer and thus inode_reserved_space gets called
even for filesystems that don't provide get_reserved_space callback
which results in a BUG.

Fix the problem by checking get_reserved_space callback and return 0 if
the filesystem does not provide it.

CC: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/quota/dquot.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index c4d07a8..2534987 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1425,6 +1425,9 @@ static void inode_sub_rsv_space(struct inode *inode, qsize_t number)
 static qsize_t inode_get_rsv_space(struct inode *inode)
 {
 	qsize_t ret;
+
+	if (!inode->i_sb->dq_op->get_reserved_space)
+		return 0;
 	spin_lock(&inode->i_lock);
 	ret = *inode_reserved_space(inode);
 	spin_unlock(&inode->i_lock);
-- 
1.6.6

