Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbXITIb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbXITIb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbXITIbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:31:45 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:12702 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbXITIbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:31:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=c09l1pTJoD3+5YfLuNGry+7fVIUsWaBl8hX7BgF/i04mixqrhxStklpulLD/kxtME1FENP1OZOcVM/0O1t3kmuKcVuRFFfIIZ2A9KuesE2VAQ/5us35pv1mSioy0MmCEYO++qAUkt0E/8+onrIZ96bYRdv0I5pdubN7/9ybtbh8=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 4/8] sysfs: implement symlink auto-removal
In-Reply-To: <11902770971822-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:31:38 +0900
Message-Id: <11902770982552-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When a sysfs_node is removed, automatically remove all symlinks
pointing to it together.

Note that as links created with kobject based sysfs_create_link()
aren't chained on its target, they aren't removed automatically.  This
is for backward compatibility.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index bb9e87e..4a04cb4 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -956,6 +956,12 @@ void __sysfs_remove(struct sysfs_dirent *sd, int recurse)
 		    (sysfs_type(cur) == SYSFS_DIR || cur->s_parent != sd))
 			continue;
 
+		/* kill all symlinks pointing to @cur */
+		if (sysfs_type(cur) == SYSFS_DIR)
+			while (cur->s_dir.links)
+				sysfs_remove_one(&acxt, cur->s_dir.links);
+
+		/* kill @cur */
 		sysfs_remove_one(&acxt, cur);
 	} while ((cur = next));
 
-- 
1.5.0.3


