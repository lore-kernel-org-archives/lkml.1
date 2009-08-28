Return-Path: <linux-kernel-owner+w=401wt.eu-S1752158AbZH1RUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbZH1RUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 13:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbZH1RUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 13:20:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbZH1RUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 13:20:05 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/3] inotify: do not send a block of zeros when no pathname is
	available
To: linux-kernel@vger.kernel.org
Date: Fri, 28 Aug 2009 13:20:04 -0400
Message-ID: <20090828172004.24585.14234.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Rogers <brian@xyzw.org>

When an event has no pathname, there's no need to pad it with a null byte and
therefore generate an inotify_event sized block of zeros. This fixes a
regression introduced by commit 0db501bd0610ee0c0aca84d927f90bcccd09e2bd where
my system wouldn't finish booting because some process was being confused by
this.

Signed-off-by: Brian Rogers <brian@xyzw.org>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/inotify/inotify_user.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 0e781bc..b547ae1 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -180,7 +180,7 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 	struct fsnotify_event_private_data *fsn_priv;
 	struct inotify_event_private_data *priv;
 	size_t event_size = sizeof(struct inotify_event);
-	size_t name_len;
+	size_t name_len = 0;
 
 	/* we get the inotify watch descriptor from the event private data */
 	spin_lock(&event->lock);
@@ -196,10 +196,12 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 		inotify_free_event_priv(fsn_priv);
 	}
 
-	/* round up event->name_len so it is a multiple of event_size
+	/*
+	 * round up event->name_len so it is a multiple of event_size
 	 * plus an extra byte for the terminating '\0'.
 	 */
-	name_len = roundup(event->name_len + 1, event_size);
+	if (event->name_len)
+		name_len = roundup(event->name_len + 1, event_size);
 	inotify_event.len = name_len;
 
 	inotify_event.mask = inotify_mask_to_arg(event->mask);

