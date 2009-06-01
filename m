Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbZFAUDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbZFAUDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756665AbZFAUD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:03:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49318 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757619AbZFAUD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:03:26 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/4] dnotify: do not bother to lock entry->lock when reading
	mask
To: linux-kernel@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk, hch@lst.de, eparis@redhat.com
Date: Mon, 01 Jun 2009 16:03:25 -0400
Message-ID: <20090601200325.16582.39071.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090601200314.16582.70992.stgit@paris.rdu.redhat.com>
References: <20090601200314.16582.70992.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

entry->lock is needed to make sure entry->mask does not change while
manipulating it.  In dnotify_should_send_event() we don't care if we get an
old or a new mask value out of this entry so there is no point it taking
the lock.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/dnotify/dnotify.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index 5134e89..ec459b6 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -153,9 +153,8 @@ static bool dnotify_should_send_event(struct fsnotify_group *group,
 	if (!entry)
 		return false;
 
-	spin_lock(&entry->lock);
 	send = (mask & entry->mask);
-	spin_unlock(&entry->lock);
+
 	fsnotify_put_mark(entry); /* matches fsnotify_find_mark_entry */
 
 	return send;

