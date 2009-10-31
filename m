Return-Path: <linux-kernel-owner+w=401wt.eu-S933193AbZJaSrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193AbZJaSrz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 14:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933071AbZJaSrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 14:47:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932929AbZJaSrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 14:47:51 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 05/10] fanotify: do not clone on merge unless needed
To: linux-kernel@vger.kernel.org, linus-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
       eparis@redhat.com
Date: Sat, 31 Oct 2009 14:47:47 -0400
Message-ID: <20091031184747.17244.40431.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091031184721.17244.16465.stgit@paris.rdu.redhat.com>
References: <20091031184721.17244.16465.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently if 2 events are going to be merged on the notication queue with
different masks the second event will be cloned and will replace the first
event.  However if this notification queue is the only place referencing
the event in question there is no reason not to just update the event in
place.  We can tell this if the event->refcnt == 1.  Since we hold a
reference for each queue this event is on we know that when refcnt == 1
this is the only queue.  The other concern is that it might be about to be
added to a new queue, but this can't be the case since fsnotify holds a
reference on the event until it is finished adding it to queues.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify/fanotify.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 8e574d6..5b0b6b4 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -46,6 +46,16 @@ static int fanotify_merge(struct list_head *list, struct fsnotify_event *event)
 			if (test_event->mask == event->mask)
 				goto out;
 
+			/*
+			 * if the refcnt == 1 this is the only queue
+			 * for this event and so we can update the mask
+			 * in place.
+			 */
+			if (atomic_read(&test_event->refcnt) == 1) {
+				test_event->mask |= event->mask;
+				goto out;
+			}
+
 			/* can't allocate memory, merge was no possible */
 			new_event = fsnotify_clone_event(test_event);
 			if (unlikely(!new_event)) {

