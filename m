Return-Path: <linux-kernel-owner+w=401wt.eu-S1759586AbXHTMip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586AbXHTMip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 08:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758369AbXHTMhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 08:37:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:43119 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868AbXHTMgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 08:36:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=Yu1tm14l422v9+GERanjxzp7YOlRsG0SCX1+Akjxp449Mz/3/8tST1nJTlMWTw5ljgZ0nIilQxYQBYzaExcDNZFmIPCUK4KYVxS2HL8Y/+JOuSmuEhDlT3xRr1SrHk9fRGtUA0HShKopt22Yz1+utRfjlF8BHas51vanP1gWF8Y=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 12/14] sysfs: kill SYSFS_FLAG_REMOVED
In-Reply-To: <11876133893720-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Mon, 20 Aug 2007 21:36:30 +0900
Message-Id: <11876133902374-git-send-email-htejun@gmail.com>
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

With sysfs_get_dentry() simplified, there's no user of
SYSFS_FLAG_REMOVED left.  Kill it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c        |    5 +----
 include/linux/sysfs.h |    1 -
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index c55c811..1752342 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -222,7 +222,7 @@ static void sysfs_deactivate(struct sysfs_dirent *sd)
 	DECLARE_COMPLETION_ONSTACK(wait);
 	int v;
 
-	BUG_ON(sd->s_sibling || !(sd->s_flags & SYSFS_FLAG_REMOVED));
+	BUG_ON(sd->s_sibling);
 	sd->s_sibling = (void *)&wait;
 
 	/* atomic_add_return() is a mb(), put_active() will always see
@@ -462,11 +462,8 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
  */
 void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 {
-	BUG_ON(sd->s_flags & SYSFS_FLAG_REMOVED);
-
 	sysfs_unlink_sibling(sd);
 
-	sd->s_flags |= SYSFS_FLAG_REMOVED;
 	sd->s_sibling = acxt->removed;
 	acxt->removed = sd;
 
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index c16e4c5..82c31b2 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -83,7 +83,6 @@ struct sysfs_ops {
 #define SYSFS_COPY_NAME		(SYSFS_DIR | SYSFS_KOBJ_LINK)
 
 #define SYSFS_FLAG_MASK		~SYSFS_TYPE_MASK
-#define SYSFS_FLAG_REMOVED	0x0100
 
 #ifdef CONFIG_SYSFS
 
-- 
1.5.0.3


