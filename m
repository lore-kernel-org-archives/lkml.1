Return-Path: <linux-kernel-owner+w=401wt.eu-S1753137AbZHXRit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbZHXRit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 13:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbZHXRis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 13:38:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbZHXRiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 13:38:46 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/3] inotify: do not BUG on idr entries at inotify destruction
To: linux-kernel@vger.kernel.org, linux-fs-devel@vger.kernel.org
Cc: zdenek.kabelac@gmail.com, torvalds@linux-foundation.org,
       christoph.thielecke@gmx.de, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, grant.wilson@zen.co.uk, mikko.cal@gmail.com
Date: Mon, 24 Aug 2009 13:38:12 -0400
Message-ID: <20090824173812.14196.381.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090824173524.14196.25992.stgit@paris.rdu.redhat.com>
References: <20090824173524.14196.25992.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an inotify watch is left in the idr when an fsnotify group is destroyed
this will lead to a BUG.  This is not a dangerous situation and really
indicates a programming bug and leak of memory.  This patch changes it to
use a WARN and a printk rather than killing people's boxes.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/inotify/inotify_fsnotify.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 5dcbafe..cf003fc 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -107,6 +107,16 @@ static bool inotify_should_send_event(struct fsnotify_group *group, struct inode
 
 static int idr_callback(int id, void *p, void *data)
 {
+	struct fsnotify_mark_entry *entry;
+	struct inotify_inode_mark_entry *ientry;
+
+	entry = p;
+	ientry = container_of(entry, struct inotify_inode_mark_entry, fsn_entry);
+
+	WARN(1, "inotify closing but id=%d still in idr.  Probably leaking memory\n", id);
+
+	printk(KERN_WARNING "group=%p entry->group=%p inode=%p wd=%d\n",
+	       data, entry->group, entry->inode, ientry->wd);
 	BUG();
 	return 0;
 }

