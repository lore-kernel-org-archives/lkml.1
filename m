Return-Path: <linux-kernel-owner+w=401wt.eu-S1751205AbYDQBc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205AbYDQBc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757208AbYDQBKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:10:35 -0400
Received: from sous-sol.org ([216.99.217.87]:59054 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363AbYDQBKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:10:33 -0400
Message-Id: <20080417010321.398997883@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:32 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Christian Lamparter <chunkeey@web.de>, nickpiggin@yahoo.com.au,
       Nick Piggin <npiggin@suse.de>, Robert Love <rlove@google.com>,
       John McCutchan <ttb@tentacle.dhs.org>, Jan Kara <jack@ucw.cz>,
       Yan Zheng <yanzheng@21cn.com>
Subject: inotify: remove debug code
Content-Disposition: inline; filename=inotify-remove-debug-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Nick Piggin <npiggin@suse.de>

upstream commit: 0d71bd5993b630a989d15adc2562a9ffe41cd26d

The inotify debugging code is supposed to verify that the
DCACHE_INOTIFY_PARENT_WATCHED scalability optimisation does not result in
notifications getting lost nor extra needless locking generated.

Unfortunately there are also some races in the debugging code.  And it isn't
very good at finding problems anyway.  So remove it for now.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Robert Love <rlove@google.com>
Cc: John McCutchan <ttb@tentacle.dhs.org>
Cc: Jan Kara <jack@ucw.cz>
Cc: Yan Zheng <yanzheng@21cn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Lamparter <chunkeey@web.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/dcache.c  |    3 ---
 fs/inotify.c |   17 +++++------------
 2 files changed, 5 insertions(+), 15 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1408,9 +1408,6 @@ void d_delete(struct dentry * dentry)
 	if (atomic_read(&dentry->d_count) == 1) {
 		dentry_iput(dentry);
 		fsnotify_nameremove(dentry, isdir);
-
-		/* remove this and other inotify debug checks after 2.6.18 */
-		dentry->d_flags &= ~DCACHE_INOTIFY_PARENT_WATCHED;
 		return;
 	}
 
--- a/fs/inotify.c
+++ b/fs/inotify.c
@@ -168,20 +168,14 @@ static void set_dentry_child_flags(struc
 		struct dentry *child;
 
 		list_for_each_entry(child, &alias->d_subdirs, d_u.d_child) {
-			if (!child->d_inode) {
-				WARN_ON(child->d_flags & DCACHE_INOTIFY_PARENT_WATCHED);
+			if (!child->d_inode)
 				continue;
-			}
+
 			spin_lock(&child->d_lock);
-			if (watched) {
-				WARN_ON(child->d_flags &
-						DCACHE_INOTIFY_PARENT_WATCHED);
+			if (watched)
 				child->d_flags |= DCACHE_INOTIFY_PARENT_WATCHED;
-			} else {
-				WARN_ON(!(child->d_flags &
-					DCACHE_INOTIFY_PARENT_WATCHED));
-				child->d_flags&=~DCACHE_INOTIFY_PARENT_WATCHED;
-			}
+			else
+				child->d_flags &=~DCACHE_INOTIFY_PARENT_WATCHED;
 			spin_unlock(&child->d_lock);
 		}
 	}
@@ -253,7 +247,6 @@ void inotify_d_instantiate(struct dentry
 	if (!inode)
 		return;
 
-	WARN_ON(entry->d_flags & DCACHE_INOTIFY_PARENT_WATCHED);
 	spin_lock(&entry->d_lock);
 	parent = entry->d_parent;
 	if (parent->d_inode && inotify_inode_watched(parent->d_inode))

-- 
