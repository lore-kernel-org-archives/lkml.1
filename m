Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299AbZH1RUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbZH1RUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 13:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbZH1RUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 13:20:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbZH1RUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 13:20:10 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/3] inotify: fix length reporting and size checking
To: linux-kernel@vger.kernel.org
Date: Fri, 28 Aug 2009 13:20:11 -0400
Message-ID: <20090828172011.24585.34026.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090828172004.24585.14234.stgit@paris.rdu.redhat.com>
References: <20090828172004.24585.14234.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0db501bd0610ee0c0 introduced a regresion in that it now sends a nul
terminator but the length accounting when checking for space or
reporting to userspace did not take this into account.  This corrects
all of the rounding logic.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/inotify/inotify_user.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index b547ae1..6111670 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -154,7 +154,8 @@ static struct fsnotify_event *get_one_event(struct fsnotify_group *group,
 
 	event = fsnotify_peek_notify_event(group);
 
-	event_size += roundup(event->name_len, event_size);
+	if (event->name_len)
+		event_size += roundup(event->name_len + 1, event_size);
 
 	if (event_size > count)
 		return ERR_PTR(-EINVAL);
@@ -327,8 +328,9 @@ static long inotify_ioctl(struct file *file, unsigned int cmd,
 		list_for_each_entry(holder, &group->notification_list, event_list) {
 			event = holder->event;
 			send_len += sizeof(struct inotify_event);
-			send_len += roundup(event->name_len,
-					     sizeof(struct inotify_event));
+			if (event->name_len)
+				send_len += roundup(event->name_len + 1,
+						sizeof(struct inotify_event));
 		}
 		mutex_unlock(&group->notification_mutex);
 		ret = put_user(send_len, (int __user *) p);

