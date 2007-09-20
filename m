Return-Path: <linux-kernel-owner+w=401wt.eu-S1762255AbXITIei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762255AbXITIei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758976AbXITIb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:31:56 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:12702 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363AbXITIbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:31:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=NUIAhxX4l17LGbO0FArlLKptmu/UDDnwNgADTMpc6t1UNUBPJ5dkpXih9dNN3XD2tgg4/TbpfP49QvpyAtA/bRpND01EyORxyrXBos5FSoqhZ+nmogiD5HHM5xvTUcvptMQkP/gv1nBu0T3VJRyDKuDY9EHO9v2P4lS9IsRQqAQ=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 5/8] sysfs: implement symlink auto-rename
In-Reply-To: <11902770971822-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:31:38 +0900
Message-Id: <1190277098339-git-send-email-htejun@gmail.com>
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

When a sysfs_node or one of its ancestors is renamed, automatically
rename symlinks pointing to it according to the name format together.

Note that as links created with kobject based sysfs_create_link()
aren't chained on its target, they aren't renamed automatically.  This
is for backward compatibility.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 4a04cb4..eac8fef 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -1196,6 +1196,7 @@ static int sysfs_prep_rename(struct sysfs_rename_context *rcxt,
 {
 	struct sysfs_rcxt_rename_ent *rent;
 	struct sysfs_rcxt_mutex_ent *ment;
+	struct sysfs_dirent *cur;
 	int rc;
 
 	INIT_LIST_HEAD(&rcxt->mutexes);
@@ -1220,6 +1221,50 @@ static int sysfs_prep_rename(struct sysfs_rename_context *rcxt,
 		goto err;
 
 	/*
+	 * prep links pointing to @sd and its children
+	 */
+	cur = NULL;
+	while ((cur = sysfs_tree_walk_next(sd, cur))) {
+		struct sysfs_dirent *link;
+
+		if (sysfs_type(cur) != SYSFS_DIR)
+			continue;
+
+		for (link = cur->s_dir.links; link; link = link->s_link.next) {
+			const char *link_new_name;
+			int copied;
+
+			rc = sysfs_link_name(link->s_link.name_fmt,
+					     link->s_link.target,
+					     &link_new_name,
+					     sd, new_parent, new_name);
+			if (rc < 0)
+				goto err;
+			copied = rc;
+
+			if (!strcmp(link->s_name, link_new_name)) {
+				if (copied)
+					kfree(link_new_name);
+				continue;
+			}
+
+			rc = -ENOMEM;
+			rent = sysfs_rcxt_add(rcxt, link, link->s_parent);
+			if (!rent) {
+				mutex_unlock(&sysfs_mutex);
+				goto err;
+			}
+
+			rent->new_name = link_new_name;
+			rent->new_name_copied = copied;
+
+			rc = sysfs_rcxt_get_dentries(rcxt, rent);
+			if (rc)
+				goto err;
+		}
+	}
+
+	/*
 	 * lock all i_mutexes
 	 */
  try_lock:
-- 
1.5.0.3


