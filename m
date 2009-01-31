Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbZAaD1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbZAaD1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbZAaDZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 22:25:25 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:34928 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbZAaDZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 22:25:24 -0500
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Date: Fri, 30 Jan 2009 19:25:14 -0800
Subject: [patch 5/7] epoll keyed wakeups - teach epoll about hints coming with the wakeup key
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.16376.1233372319.5>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The follwing patch uses the events hint now sent by some devices, to
avoid unnecessary wakeups for events that are of no interest for the
caller. This code handles both devices that are sending keyed events,
and the ones that are not (and event the ones that sometimes send events,
and sometimes don't).



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/eventpoll.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: linux-2.6.mod/fs/eventpoll.c
===================================================================
--- linux-2.6.mod.orig/fs/eventpoll.c	2009-01-30 12:11:39.000000000 -0800
+++ linux-2.6.mod/fs/eventpoll.c	2009-01-30 12:11:47.000000000 -0800
@@ -785,6 +785,15 @@ static int ep_poll_callback(wait_queue_t
 	if (!(epi->event.events & ~EP_PRIVATE_BITS))
 		goto out_unlock;
 
+        /*
+	 * Check the events coming with the callback. At this stage, not
+	 * every device reports the events in the "key" parameter of the
+	 * callback. We need to be able to handle both cases here, hence the
+	 * test for "key" != NULL before the event match test.
+	 */
+	if (key && !((unsigned long) key & epi->event.events))
+		goto out_unlock;
+
 	/*
 	 * If we are trasfering events to userspace, we can hold no locks
 	 * (because we're accessing user memory, and because of linux f_op->poll()
@@ -1260,7 +1269,6 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 	case EPOLL_CTL_ADD:
 		if (!epi) {
 			epds.events |= POLLERR | POLLHUP;
-
 			error = ep_insert(ep, &epds, tfile, fd);
 		} else
 			error = -EEXIST;

