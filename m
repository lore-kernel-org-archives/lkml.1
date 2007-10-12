Return-Path: <linux-kernel-owner+w=401wt.eu-S1761507AbXJLWx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761507AbXJLWx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932782AbXJLWWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:22:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:49986 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932588AbXJLWWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:22:18 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 60/75] sysfs: make bin attr open get active reference of parent too
Date: Fri, 12 Oct 2007 15:17:04 -0700
Message-Id: <11922277222714-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922277181565-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
 <11922275552558-git-send-email-gregkh@suse.de>
 <119222756066-git-send-email-gregkh@suse.de>
 <11922275642378-git-send-email-gregkh@suse.de>
 <11922275693989-git-send-email-gregkh@suse.de>
 <1192227574129-git-send-email-gregkh@suse.de>
 <11922275781508-git-send-email-gregkh@suse.de>
 <11922275843236-git-send-email-gregkh@suse.de>
 <1192227589276-git-send-email-gregkh@suse.de>
 <1192227593813-git-send-email-gregkh@suse.de>
 <1192227598106-git-send-email-gregkh@suse.de>
 <1192227603335-git-send-email-gregkh@suse.de>
 <1192227611369-git-send-email-gregkh@suse.de>
 <11922276163147-git-send-email-gregkh@suse.de>
 <11922276201219-git-send-email-gregkh@suse.de>
 <11922276254051-git-send-email-gregkh@suse.de>
 <11922276302338-git-send-email-gregkh@suse.de>
 <1192227634772-git-send-email-gregkh@suse.de>
 <11922276392200-git-send-email-gregkh@suse.de>
 <11922276433594-git-send-email-gregkh@suse.de>
 <11922276471365-git-send-email-gregkh@suse.de>
 <1192227653165-git-send-email-gregkh@suse.de>
 <11922276572176-git-send-email-gregkh@suse.de>
 <11922276622731-git-send-email-gregkh@suse.de>
 <11922276672660-git-send-email-gregkh@suse.de>
 <1192227671143-git-send-email-gregkh@suse.de>
 <11922276763650-git-send-email-gregkh@suse.de>
 <1192227681926-git-send-email-gregkh@suse.de>
 <11922276862914-git-send-email-gregkh@suse.de>
 <11922276913288-git-send-email-gregkh@suse.de>
 <1192227695547-git-send-email-gregkh@suse.de>
 <11922276993289-git-send-email-gregkh@suse.de>
 <11922277041450-git-send-email-gregkh@suse.de>
 <11922277091389-git-send-email-gregkh@suse.de>
 <11922277133374-git-send-email-gregkh@suse.de>
 <11922277181565-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

All bin attr operations require active references of itself and its
parent.  There's no reason to allow open when its parent has been
deactivated and allowing it is inconsistent with regular sysfs file.
Use sysfs_get_active_two() in bin attribute open function.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/bin.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index e93fe5e..9c8f882 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -171,8 +171,8 @@ static int open(struct inode * inode, struct file * file)
 	struct bin_buffer *bb = NULL;
 	int error;
 
-	/* need attr_sd for attr */
-	if (!sysfs_get_active(attr_sd))
+	/* binary file operations requires both @sd and its parent */
+	if (!sysfs_get_active_two(attr_sd))
 		return -ENODEV;
 
 	error = -EACCES;
@@ -193,12 +193,12 @@ static int open(struct inode * inode, struct file * file)
 	mutex_init(&bb->mutex);
 	file->private_data = bb;
 
-	/* open succeeded, put active reference */
-	sysfs_put_active(attr_sd);
+	/* open succeeded, put active references */
+	sysfs_put_active_two(attr_sd);
 	return 0;
 
  err_out:
-	sysfs_put_active(attr_sd);
+	sysfs_put_active_two(attr_sd);
 	kfree(bb);
 	return error;
 }
-- 
1.5.3.4

