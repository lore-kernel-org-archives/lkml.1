Return-Path: <linux-kernel-owner+w=401wt.eu-S1757033AbXHTMgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033AbXHTMgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 08:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbXHTMgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 08:36:44 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:43119 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbXHTMgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 08:36:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=n66SB5WIll428aGXog32IpCAjAQFhZfhcfRTGdZ5N5nqN1Di2v3biaXpKsRXWSHmMXd06yizFqgvZymtIpvC4z6O4HvCFn5C6Suq2CeWnb10B/5tqbSAA7D2Ew5eCtAnZxTkENs5ZhhUasxj4ksiypzWwaQWqrLZDhvCVBpJ84w=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 01/14] sysfs: fix i_mutex locking in sysfs_get_dentry()
In-Reply-To: <11876133893720-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Mon, 20 Aug 2007 21:36:29 +0900
Message-Id: <11876133893733-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       linux-kernel@vger.kernel.org, satyam@infradead.org,
       stern@rowland.harvard.edu, containers@lists.osdl.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

lookup_one_len_kern() should be called with the parent's i_mutex
locked.  Fix it.

Spotted by Eric W. Biederman.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/dir.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index e4fd8a2..b33af5e 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -130,8 +130,10 @@ struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd)
 
 		/* look it up */
 		parent_dentry = dentry;
+		mutex_lock(&parent_dentry->d_inode->i_mutex);
 		dentry = lookup_one_len_kern(cur->s_name, parent_dentry,
 					     strlen(cur->s_name));
+		mutex_unlock(&parent_dentry->d_inode->i_mutex);
 		dput(parent_dentry);
 
 		if (IS_ERR(dentry)) {
-- 
1.5.0.3


