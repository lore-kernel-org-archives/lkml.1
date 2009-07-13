Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbZGMNoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbZGMNoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 09:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755938AbZGMNoC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 09:44:02 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50046 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755845AbZGMNoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 09:44:01 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/3] inotify: check filename before dropping repeat events
To: linux-kernel@vger.kernel.org
Cc: scott@ubuntu.com, viro@ZenIV.linux.org.uk
Date: Mon, 13 Jul 2009 09:43:59 -0400
Message-ID: <20090713134358.14487.91648.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090713134353.14487.93035.stgit@paris.rdu.redhat.com>
References: <20090713134353.14487.93035.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inotify drops events if the last event on the queue is the same as the
current event.  But it does 2 things wrong.  First it is comparing old->inode
with new->inode.  But after an event if put on the queue the ->inode is no
longer allowed to be used.  It's possible between the last event and this new
event the inode could be reused and we would falsely match the inode's memory
address between two differing events.

The second problem is that when a file is removed fsnotify is passed the
negative dentry for the removed object rather than the postive dentry from
immediately before the removal.  This mean the (broken) inotify tail drop code
was matching the NULL ->inode of differing events.

The fix is to check the file name which is stored with events when doing the
tail drop instead of wrongly checking the address of the stored ->inode.

Reported-by: Scott James Remnant <scott@ubuntu.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/notification.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 959b73e..d1fbbea 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -136,10 +136,14 @@ static bool event_compare(struct fsnotify_event *old, struct fsnotify_event *new
 {
 	if ((old->mask == new->mask) &&
 	    (old->to_tell == new->to_tell) &&
-	    (old->data_type == new->data_type)) {
+	    (old->data_type == new->data_type) &&
+	    (old->name_len == new->name_len)) {
 		switch (old->data_type) {
 		case (FSNOTIFY_EVENT_INODE):
-			if (old->inode == new->inode)
+			/* remember, after old was put on the wait_q we aren't
+			 * allowed to look at the inode any more, only thing
+			 * left to check was if the file_name is the same */
+			if (old->name_len && !strcmp(old->file_name, new->file_name))
 				return true;
 			break;
 		case (FSNOTIFY_EVENT_PATH):

