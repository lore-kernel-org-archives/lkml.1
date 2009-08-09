Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbZHIV7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbZHIV7t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 17:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbZHIV7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 17:59:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43959 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996AbZHIV7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 17:59:41 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/5] inotify: use ZERO_PAGE instead of private static
	declaration
To: linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Date: Sun, 09 Aug 2009 17:59:42 -0400
Message-ID: <20090809215941.26204.52486.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090809215935.26204.46787.stgit@paris.rdu.redhat.com>
References: <20090809215935.26204.46787.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inotify needs to pad filenames to an inotify event length.  Currently this
is done by copying 0s from an event declared globally.  This patch doesn't
waste global address space just to have some 0s and instead uses
clear_user()

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/inotify/inotify_user.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index c17d5a3..c3086b0 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -47,9 +47,6 @@
 
 static struct vfsmount *inotify_mnt __read_mostly;
 
-/* this just sits here and wastes global memory.  used to just pad userspace messages with zeros */
-static struct inotify_event nul_inotify_event;
-
 /* these are configurable via /proc/sys/fs/inotify/ */
 static int inotify_max_user_instances __read_mostly;
 static int inotify_max_queued_events __read_mostly;
@@ -215,7 +212,7 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 	/*
 	 * fsnotify only stores the pathname, so here we have to send the pathname
 	 * and then pad that pathname out to a multiple of sizeof(inotify_event)
-	 * with zeros.  I get my zeros from the nul_inotify_event.
+	 * with zeros.
 	 */
 	if (name_len) {
 		unsigned int len_to_zero = name_len - event->name_len;
@@ -224,8 +221,8 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 			return -EFAULT;
 		buf += event->name_len;
 
-		/* fill userspace with 0's from nul_inotify_event */
-		if (copy_to_user(buf, &nul_inotify_event, len_to_zero))
+		/* fill userspace with 0's */
+		if (clear_user(buf, len_to_zero))
 			return -EFAULT;
 		buf += len_to_zero;
 		event_size += name_len;

