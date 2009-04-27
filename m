Return-Path: <linux-kernel-owner+w=401wt.eu-S1760794AbZD0V5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760794AbZD0V5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 17:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329AbZD0VzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 17:55:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41458 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758186AbZD0VzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 17:55:05 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 10/12] fsnotify: fsnotify marks on inodes pin them in core
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       akpm@linux-foundation.org
Date: Mon, 27 Apr 2009 17:53:55 -0400
Message-ID: <20090427215355.14161.66130.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090427215305.14161.33354.stgit@paris.rdu.redhat.com>
References: <20090427215305.14161.33354.stgit@paris.rdu.redhat.com>
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

 fs/notify/inode_mark.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index a395348..282150f 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -204,6 +204,8 @@ void fsnotify_destroy_mark_by_entry(struct fsnotify_mark_entry *entry)
 	 */
 
 
+	iput(inode);
+
 	/*
 	 * it's possible that this group tried to destroy itself, but this
 	 * this mark was simultaneously being freed by inode.  If that's the
@@ -306,6 +308,10 @@ int fsnotify_add_mark(struct fsnotify_mark_entry *entry,
 	struct fsnotify_mark_entry *lentry;
 	int ret = 0;
 
+	inode = igrab(inode);
+	if (unlikely(!inode))
+		return -EINVAL;
+
 	/*
 	 * LOCKING ORDER!!!!
 	 * entry->lock
@@ -337,6 +343,7 @@ int fsnotify_add_mark(struct fsnotify_mark_entry *entry,
 
 	if (lentry) {
 		ret = -EEXIST;
+		iput(inode);
 		fsnotify_put_mark(lentry);
 	} else {
 		__fsnotify_update_child_dentry_flags(inode);

