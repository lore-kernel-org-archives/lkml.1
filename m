Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbZJYU1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbZJYU1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 16:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbZJYU1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 16:27:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192AbZJYU1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 16:27:11 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 4/5] fsnotify: initialize the group->num_marks in a better
	place
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de
Date: Sun, 25 Oct 2009 16:27:14 -0400
Message-ID: <20091025202713.11501.31399.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091025202655.11501.70437.stgit@paris.rdu.redhat.com>
References: <20091025202655.11501.70437.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the comments say that group->num_marks is held because the group
is on the fsnotify_group list.  This isn't strictly the case, we really
just hold the num_marks for the life of the group (any time group->refcnt
is != 0)  This patch moves the initialization stuff and makes it clear when
it is really being held.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/group.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/notify/group.c b/fs/notify/group.c
index 73d2c30..f8c2f0f 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -82,9 +82,6 @@ static void fsnotify_add_group(struct fsnotify_group *group)
 	BUG_ON(!mutex_is_locked(&fsnotify_grp_mutex));
 
 	group->on_inode_group_list = 1;
-	/* being on the fsnotify_groups list holds one num_marks */
-	atomic_inc(&group->num_marks);
-
 	list_add_tail_rcu(&group->inode_group_list, &fsnotify_inode_groups);
 }
 
@@ -184,7 +181,14 @@ struct fsnotify_group *fsnotify_alloc_group(__u32 mask,
 	if (!group)
 		return ERR_PTR(-ENOMEM);
 
+	/* set to 0 when there a no external references to this group */
 	atomic_set(&group->refcnt, 1);
+	/*
+	 * hits 0 when there are no external references AND no marks for
+	 * this group
+	 */
+	atomic_set(&group->num_marks, 1);
+
 
 	group->mask = mask;
 

