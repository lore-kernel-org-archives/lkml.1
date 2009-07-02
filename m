Return-Path: <linux-kernel-owner+w=401wt.eu-S1752957AbZGBFEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbZGBFEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 01:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbZGBFD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 01:03:58 -0400
Received: from home.keithp.com ([63.227.221.253]:59945 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbZGBFD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 01:03:57 -0400
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jul 2009 01:03:57 EDT
From: Keith Packard <keithp@keithp.com>
To: linux-kernel@vger.kernel.org
Cc: john@johnmccutchan.com, rlove@rlove.org, eparis@parisplace.org,
       Keith Packard <keithp@keithp.com>
Subject: [PATCH] fs/notify/inotify: decrement user inotify count on close
Date: Wed,  1 Jul 2009 21:56:38 -0700
Message-Id: <1246510598-6136-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The per-user inotify_devs value is incremented each time a new file is
allocated, but never decremented. This led to inotify_init failing after a
limited number of calls.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 fs/notify/inotify/inotify_user.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index ff231ad..ff27a29 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -296,12 +296,15 @@ static int inotify_fasync(int fd, struct file *file, int on)
 static int inotify_release(struct inode *ignored, struct file *file)
 {
 	struct fsnotify_group *group = file->private_data;
+	struct user_struct *user = group->inotify_data.user;
 
 	fsnotify_clear_marks_by_group(group);
 
 	/* free this group, matching get was inotify_init->fsnotify_obtain_group */
 	fsnotify_put_group(group);
 
+	atomic_dec(&user->inotify_devs);
+
 	return 0;
 }
 
-- 
1.6.3.1

