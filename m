Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbYJOTgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbYJOTgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 15:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYJOTgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 15:36:00 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:43394 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052AbYJOTf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 15:35:59 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] vfs: Fix possible chmod/truncate race condition.
From: Dmitri Monakhov <dmonakhov@openvz.org>
Date: Wed, 15 Oct 2008 23:35:27 +0400
Message-ID: <m33aixy7ls.fsf@dmon-lap.sw.ru>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
---
 fs/open.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 07da935..3423b94 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -214,10 +214,9 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 		newattrs.ia_valid |= ATTR_FILE;
 	}
 
+	mutex_lock(&dentry->d_inode->i_mutex);
 	/* Remove suid/sgid on truncate too */
 	newattrs.ia_valid |= should_remove_suid(dentry);
-
-	mutex_lock(&dentry->d_inode->i_mutex);
 	err = notify_change(dentry, &newattrs);
 	mutex_unlock(&dentry->d_inode->i_mutex);
 	return err;
-- 
1.5.4.3

