Return-Path: <linux-kernel-owner+w=401wt.eu-S1760119AbYDQBP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760119AbYDQBP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759079AbYDQBHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:07:38 -0400
Received: from sous-sol.org ([216.99.217.87]:58859 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758952AbYDQBHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:07:35 -0400
Message-Id: <20080417010317.497463045@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:31 -0700
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
Subject: inotify: fix race
Content-Disposition: inline; filename=inotify-fix-race.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Nick Piggin <npiggin@suse.de>

upstream commit: d599e36a9ea85432587f4550acc113cd7549d12a

There is a race between setting an inode's children's "parent watched" flag
when placing the first watch on a parent, and instantiating new children of
that parent: a child could miss having its flags set by
set_dentry_child_flags, but then inotify_d_instantiate might still see
!inotify_inode_watched.

The solution is to set_dentry_child_flags after adding the watch.  Locking is
taken care of, because both set_dentry_child_flags and inotify_d_instantiate
hold dcache_lock and child->d_locks.

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
 fs/inotify.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/fs/inotify.c
+++ b/fs/inotify.c
@@ -627,6 +627,7 @@ s32 inotify_add_watch(struct inotify_han
 		      struct inode *inode, u32 mask)
 {
 	int ret = 0;
+	int newly_watched;
 
 	/* don't allow invalid bits: we don't want flags set */
 	mask &= IN_ALL_EVENTS | IN_ONESHOT;
@@ -653,12 +654,18 @@ s32 inotify_add_watch(struct inotify_han
 	 */
 	watch->inode = igrab(inode);
 
-	if (!inotify_inode_watched(inode))
-		set_dentry_child_flags(inode, 1);
-
 	/* Add the watch to the handle's and the inode's list */
+	newly_watched = !inotify_inode_watched(inode);
 	list_add(&watch->h_list, &ih->watches);
 	list_add(&watch->i_list, &inode->inotify_watches);
+	/*
+	 * Set child flags _after_ adding the watch, so there is no race
+	 * windows where newly instantiated children could miss their parent's
+	 * watched flag.
+	 */
+	if (newly_watched)
+		set_dentry_child_flags(inode, 1);
+
 out:
 	mutex_unlock(&ih->mutex);
 	mutex_unlock(&inode->inotify_mutex);

-- 
