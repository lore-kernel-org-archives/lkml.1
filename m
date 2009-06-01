Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbZFAUD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbZFAUD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757661AbZFAUDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:03:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49326 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756980AbZFAUDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:03:31 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 4/4] inotify/dnotify: should_send_event shouldn't match on
	FS_EVENT_ON_CHILD
To: linux-kernel@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk, hch@lst.de, eparis@redhat.com
Date: Mon, 01 Jun 2009 16:03:31 -0400
Message-ID: <20090601200330.16582.26737.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090601200314.16582.70992.stgit@paris.rdu.redhat.com>
References: <20090601200314.16582.70992.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inotify and dnotify will both indicate that they want any event which came
from a child inode.  The fix is to mask off FS_EVENT_ON_CHILD when deciding
if inotify or dnotify is interested in a given event.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/dnotify/dnotify.c          |    1 +
 fs/notify/inotify/inotify_fsnotify.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index ec459b6..98a7516 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -153,6 +153,7 @@ static bool dnotify_should_send_event(struct fsnotify_group *group,
 	if (!entry)
 		return false;
 
+	mask = (mask & ~FS_EVENT_ON_CHILD);
 	send = (mask & entry->mask);
 
 	fsnotify_put_mark(entry); /* matches fsnotify_find_mark_entry */
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 160da54..7ef75b8 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -95,6 +95,7 @@ static bool inotify_should_send_event(struct fsnotify_group *group, struct inode
 	if (!entry)
 		return false;
 
+	mask = (mask & ~FS_EVENT_ON_CHILD);
 	send = (entry->mask & mask);
 
 	/* find took a reference */

