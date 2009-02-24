Return-Path: <linux-kernel-owner+w=401wt.eu-S1759521AbZBXRaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbZBXRaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759801AbZBXR2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:28:34 -0500
Received: from host64.cybernetics.com ([98.174.209.230]:2716 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759796AbZBXR2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:28:33 -0500
Message-ID: <49A42E3F.1010005@cybernetics.com>
Date: Tue, 24 Feb 2009 12:28:31 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] [-mm] epoll: remember the event if epoll_wait returns
 -EFAULT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If epoll_wait returns -EFAULT, the event that was being returned when
the fault was encountered will be forgotten.  This is not a big deal
since EFAULT will happen only if a buggy userspace program passes in a
bad address, in which case what happens later usually doesn't matter.
However, it is easy to remember the event for later, and this patch
makes a simple change to do that.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

This patch is against the current -mm tree, and might not apply
to 2.6.29.  Since this patch probably won't go into 2.6.29, you may
apply this version of the patch after the other patches in -mm.

--- a/fs/eventpoll.c	2009-02-23 14:01:41.000000000 -0500
+++ b/fs/eventpoll.c	2009-02-23 14:01:47.000000000 -0500
@@ -1119,8 +1119,10 @@ static int ep_send_events_proc(struct ev
 		 */
 		if (revents) {
 			if (__put_user(revents, &uevent->events) ||
-			    __put_user(epi->event.data, &uevent->data))
+			    __put_user(epi->event.data, &uevent->data)) {
+				list_add(&epi->rdllink, head);
 				return eventcnt ? eventcnt : -EFAULT;
+			}
 			eventcnt++;
 			uevent++;
 			if (epi->event.events & EPOLLONESHOT)

