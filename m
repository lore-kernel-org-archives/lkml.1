Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbZIHLlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbZIHLlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 07:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbZIHLlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 07:41:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbZIHLlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 07:41:03 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       hch@infradead.org, Jan Kara <jack@suse.cz>
Subject: [PATCH] fs: Make sure data stored into inode is properly seen before unlocking new inode
Date: Tue,  8 Sep 2009 13:41:03 +0200
Message-Id: <1252410063-26872-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In theory it could happen that on one CPU we initialize a new inode but clearing
of I_NEW | I_LOCK gets reordered before some of the initialization. Thus on
another CPU we return not fully uptodate inode from iget_locked().

This seems to fix a corruption issue on ext3 mounted over NFS.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

  Since Al doesn't seem to be online, does anybody else have opinion on this
patch? I can merge it via my tree but I'd like to get a review from someone
else.

diff --git a/fs/inode.c b/fs/inode.c
index 901bad1..e9a8e77 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -696,6 +696,7 @@ void unlock_new_inode(struct inode *inode)
 	 * just created it (so there can be no old holders
 	 * that haven't tested I_LOCK).
 	 */
+	smp_mb();
 	WARN_ON((inode->i_state & (I_LOCK|I_NEW)) != (I_LOCK|I_NEW));
 	inode->i_state &= ~(I_LOCK|I_NEW);
 	wake_up_inode(inode);
-- 
1.6.0.2

