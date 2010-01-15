Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab0AORQQ (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 12:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757818Ab0AORP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 12:15:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757744Ab0AORP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 12:15:58 -0500
From: eparis@redhat.com
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, faure@kde.org,
        bhutchings@solarflare.com, akpm@linux-foundation.org,
        linux@horizon.com, Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/2] inotify: do not reuse watch descriptors
Date: Fri, 15 Jan 2010 12:12:24 -0500
Message-Id: <1263575545-26703-1-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

Since commit 7e790dd5fc937bc8d2400c30a05e32a9e9eef276 inotify changed the
manor in which it gave watch descriptors back to userspace.  Previous to
this commit inotify acted like the following:

inotify_add_watch(X, Y, Z) = 1
inotify_rm_watch(X, 1);
inotify_add_watch(X, Y, Z) = 2

but after this patch inotify would return watch descriptors like so:

inotify_add_watch(X, Y, Z) = 1
inotify_rm_watch(X, 1);
inotify_add_watch(X, Y, Z) = 1

which I saw as equivalent to opening an fd where

open(file) = 1;
close(1);
open(file) = 1;

seemed perfectly reasonable.  The issue is that quite a bit of userspace
apparently relies on the behavior in which watch descriptors will not be
quickly reused.  KDE relies on it, I know some selinux packages rely on it,
and I have heard complaints from other random sources such as debian bug
558981.

Although the man page implies what we do is ok, we broke userspace so this
patch almost reverts us to the old behavior.  It is still slightly racey
and I have patches that would fix that, but they are rather large and this
will fix it for all real world cases.  The race is as follows:

task1 creates a watch and blocks in idr_new_watch() before it updates the hint.
task2 creates a watch and updates the hint.
task1 updates the hint with it's older wd
task removes the watch created by task2
task adds a new watch and will reuse the wd originally given to task2

it requires moving some locking around the hint (last_wd) but this should
solve it for the real world and be -stable safe.

As a side effect this patch papers over a bug in the lib/idr code which is
causing a large number WARN's to pop on people's system and many reports
in kerneloops.org.  I'm working on the root cause of that idr bug seperately
but this should make inotify immune to that issue.

Signed-off-by: Eric Paris <eparis@redhat.com>
---
 fs/notify/inotify/inotify_user.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 8271cf0..a94e8bd 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -552,7 +552,7 @@ retry:
 
 	spin_lock(&group->inotify_data.idr_lock);
 	ret = idr_get_new_above(&group->inotify_data.idr, &tmp_ientry->fsn_entry,
-				group->inotify_data.last_wd,
+				group->inotify_data.last_wd+1,
 				&tmp_ientry->wd);
 	spin_unlock(&group->inotify_data.idr_lock);
 	if (ret) {
@@ -632,7 +632,7 @@ static struct fsnotify_group *inotify_new_group(struct user_struct *user, unsign
 
 	spin_lock_init(&group->inotify_data.idr_lock);
 	idr_init(&group->inotify_data.idr);
-	group->inotify_data.last_wd = 1;
+	group->inotify_data.last_wd = 0;
 	group->inotify_data.user = user;
 	group->inotify_data.fa = NULL;
 
-- 
1.6.5.3

