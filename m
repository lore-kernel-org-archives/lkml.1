Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbYHMIoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbYHMIoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbYHMIjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:36 -0400
Received: from smtp.nokia.com ([192.100.105.134]:31904 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493AbYHMIje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:34 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] UBIFS: correct orphan deletion order
Date: Wed, 13 Aug 2008 13:17:45 +0300
Message-Id: <1218622675-28853-17-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:03.0706 (UTC) FILETIME=[0A80E7A0:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <ext-adrian.hunter@nokia.com>

The debug function that checks orphans, does so using the
TNC mutex. That means it will not see a correct picture
if the inode is removed from the orphan tree before it is
removed from TNC.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 fs/ubifs/journal.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index 25de6fd..acdae00 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -871,10 +871,11 @@ int ubifs_jnl_delete_inode(struct ubifs_info *c, const struct inode *inode)
 		return ubifs_jnl_write_inode(c, inode);
 	}
 
-	ubifs_delete_orphan(c, inode->i_ino);
 	err = ubifs_tnc_remove_ino(c, inode->i_ino);
 	if (err)
 		ubifs_ro_mode(c, err);
+	else
+		ubifs_delete_orphan(c, inode->i_ino);
 	up_read(&c->commit_sem);
 	return err;
 }
-- 
1.5.4.1

