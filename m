Return-Path: <linux-kernel-owner+w=401wt.eu-S1762593AbXE1QKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762593AbXE1QKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 12:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757113AbXE1QKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 12:10:34 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:40771 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877AbXE1QKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 12:10:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=YKlEQ+B1HRICyCPlZNzyNy8iZyg7iHvVPOJjOqLUC1ucRZl4K/+ekA3YM+a/Ev0gJ2gNuQxIpTsKOCQMy69Itlu8/zEf5rrLnny5ZI9PqnHEmHm8NEPopAKOpC2fooYOO79PumEFUv0AjvE8I4Yj156fH97FjWt/Ku/Q9ZzQ07M=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 2/5] sysfs: fix parent refcounting during rename and move
In-Reply-To: <1180368625600-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Tue, 29 May 2007 01:10:25 +0900
Message-Id: <11803686253382-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Parent reference wasn't properly transferred during rename and move.
Fix it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index a63d12e..a26e3db 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -497,6 +497,9 @@ int sysfs_rename_dir(struct kobject * ko
 	d_move(kobj->dentry, new_dentry);
 
 	list_del_init(&sd->s_sibling);
+	sysfs_get(parent_sd);
+	sysfs_put(sd->s_parent);
+	sd->s_parent = parent_sd;
 	list_add(&sd->s_sibling, &parent_sd->s_children);
 
 	error = 0;
@@ -550,6 +553,9 @@ again:
 
 	/* Remove from old parent's list and insert into new parent's list. */
 	list_del_init(&sd->s_sibling);
+	sysfs_get(new_parent_sd);
+	sysfs_put(sd->s_parent);
+	sd->s_parent = new_parent_sd;
 	list_add(&sd->s_sibling, &new_parent_sd->s_children);
 
 out:
-- 
1.4.3.4


