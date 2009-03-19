Return-Path: <linux-kernel-owner+w=401wt.eu-S1760448AbZCSSKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760448AbZCSSKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758604AbZCSSH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:07:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46027 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758322AbZCSSH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:07:26 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 11/13] fsnotify: fsnotify marks on inodes pin them in core
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       akpm@linux-foundation.org
Date: Thu, 19 Mar 2009 14:05:53 -0400
Message-ID: <20090319180553.17449.71990.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com>
References: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com>
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

 fs/notify/inode_mark.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 144b09a..362b04c 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -159,6 +159,8 @@ void fsnotify_destroy_mark_by_entry(struct fsnotify_mark_entry *entry)
 	group->ops->freeing_mark(entry, group);
 
 	fsnotify_update_dentry_child_flags(inode);
+
+	iput(inode);
 }
 
 void fsnotify_clear_marks_by_group(struct fsnotify_group *group)
@@ -228,11 +230,16 @@ void fsnotify_init_mark(struct fsnotify_mark_entry *entry, void (*free_mark)(str
 	entry->free_mark = free_mark;
 }
 
-int fsnotify_add_mark(struct fsnotify_mark_entry *entry, struct fsnotify_group *group, struct inode *inode)
+int fsnotify_add_mark(struct fsnotify_mark_entry *entry, struct fsnotify_group *group, struct inode *in_inode)
 {
 	struct fsnotify_mark_entry *lentry;
+	struct inode *inode;
 	int ret = 0;
 
+	inode = igrab(in_inode);
+	if (unlikely(!inode))
+		return -EINVAL;
+
 	/*
 	 * LOCKING ORDER!!!!
 	 * entry->lock

