Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbZCBXKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbZCBXKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756791AbZCBXKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:10:17 -0500
Received: from host64.cybernetics.com ([98.174.209.230]:3743 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697AbZCBXKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:10:16 -0500
Message-ID: <49AC6755.6050809@cybernetics.com>
Date: Mon, 02 Mar 2009 18:10:13 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] epoll: remember the event if epoll_wait returns -EFAULT
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
Acked-by: Davide Libenzi <davidel@xmailserver.org>
---
--- a/fs/eventpoll.c	2009-02-23 14:01:41.000000000 -0500
+++ b/fs/eventpoll.c	2009-02-23 14:01:47.000000000 -0500
@@ -1082,8 +1082,10 @@ static int ep_send_events_proc(struct ev
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


