Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbZBIVTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbZBIVTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbZBIVRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:17:05 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36438 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbZBIVRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:17:04 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v1 09/11] fsnotify: fsnotify marks on inodes pin them in core
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       malware-list@lists.printk.net, akpm@linux-foundation.org
Date: Mon, 09 Feb 2009 16:16:09 -0500
Message-ID: <20090209211609.8985.24420.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090209211525.8985.13887.stgit@paris.rdu.redhat.com>
References: <20090209211525.8985.13887.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch pins any inodes with an fsnotify mark in core.  The idea is that
as soon as the mark is removed from the inode->fsnotify_mark_entries list
the inode will be iput.  In reality is doesn't quite work exactly this way.
The igrab will happen when the mark is added to an inode, but the iput will
happen when the inode pointer is NULL'd inside the mark.

It's possible that 2 racing things will try to remove the mark from
different directions.  One may try to remove the mark because of an
explicit request and one might try to remove it because the inode was
deleted.  It's possible that the removal because of inode deletion will
remove the mark from the inode's list, but the removal by explicit request
will actually set entry->inode == NULL; and call the iput.  This is safe.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/inode_mark.c |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 840bd91..ff65e62 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -108,13 +108,16 @@ void fsnotify_clear_marks_by_group(struct fsnotify_group *group)
 		spin_lock(&inode->i_lock);
 
 		list_del_init(&entry->i_list);
-		entry->inode = NULL;
 		list_del_init(&entry->g_list);
-		entry->group = NULL;
-		entry->freeme = 1;
 
 		fsnotify_recalc_inode_mask_locked(inode);
 		spin_unlock(&inode->i_lock);
+
+		entry->group = NULL;
+		entry->freeme = 1;
+		entry->inode = NULL;
+		iput(inode);
+
 		spin_unlock(&entry->lock);
 
 		fsnotify_put_mark(entry);
@@ -137,14 +140,17 @@ void fsnotify_destroy_mark_by_entry(struct fsnotify_mark_entry *entry)
 		spin_lock(&inode->i_lock);
 
 	list_del_init(&entry->i_list);
-	entry->inode = NULL;
 	list_del_init(&entry->g_list);
+
+	entry->inode = NULL;
 	entry->group = NULL;
 	entry->freeme = 1;
 
 	if (inode) {
 		fsnotify_recalc_inode_mask_locked(inode);
 		spin_unlock(&inode->i_lock);
+
+		iput(inode);
 	}
 	if (group)
 		spin_unlock(&group->mark_lock);
@@ -173,6 +179,11 @@ void fsnotify_clear_marks_by_inode(struct inode *inode, unsigned int flags)
 	 * try to grab entry->inode->i_lock without a problem.
 	 */
 	list_for_each_entry_safe(entry, lentry, &free_list, free_i_list) {
+		spin_lock(&entry->lock);
+		if (entry->inode)
+			iput(entry->inode);
+		entry->inode = NULL;
+		spin_unlock(&entry->lock);
 		entry->group->ops->mark_clear_inode(entry, inode, flags);
 		fsnotify_put_mark(entry);
 	}
@@ -209,9 +220,13 @@ int fsnotify_add_mark(struct fsnotify_mark_entry *entry)
 {
 	struct fsnotify_mark_entry *lentry;
 	struct fsnotify_group *group = entry->group;
-	struct inode *inode = entry->inode;
+	struct inode *inode;
 	int ret = 0;
 
+	inode = igrab(entry->inode);
+	if (unlikely(!inode))
+		return -EINVAL;
+
 	/*
 	 * LOCKING ORDER!!!!
 	 * entry->lock

