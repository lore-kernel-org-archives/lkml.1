Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbYJQXRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbYJQXRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 19:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755820AbYJQXRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 19:17:47 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:58483 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545AbYJQXRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 19:17:47 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 17 Oct 2008 16:17:40 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch] epoll avoid double-inserts in case of EFAULT
Message-ID: <Pine.LNX.4.64.0810171602310.21410@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


First Episode:

Thomas found that there is an unnecessary (always true) test in 
ep_send_events(). The callback never inserts into ->rdllink while the 
send loop is performed, and also does the ~EP_PRIVATE_BITS test. Given 
we're holding the mutex during this time, the conditions tested inside the 
loop are always true.
This patch drops the test done inside the re-insertion loop.

Second Episode:

The test "!ep_is_linked(&epi->rdllink)" wasn't there because we inserts 
into ->rdllink, but because the send-events loop might terminate before 
the whole list is scanned (-EFAULT). In such cases, when the loop 
terminates early, and when a (leftover) file received an event while we're 
performing the lockless loop, we need such test to avoid to double insert 
the epoll items. The list_splice() done a few steps below, will correctly 
re-insert the ones that were left on "txlist".
This should be the reason for the thread "2.6.27-05178-g2e532d6: list_add 
corruption" from Alexander Beregalov.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>



- Davide


---
 fs/eventpoll.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: linux-2.6.mod/fs/eventpoll.c
===================================================================
--- linux-2.6.mod.orig/fs/eventpoll.c	2008-10-17 15:51:09.000000000 -0700
+++ linux-2.6.mod/fs/eventpoll.c	2008-10-17 15:54:14.000000000 -0700
@@ -930,8 +930,15 @@
 	 * inside the main ready-list here.
 	 */
 	for (nepi = ep->ovflist; (epi = nepi) != NULL;
-	     nepi = epi->next, epi->next = EP_UNACTIVE_PTR)
-		list_add_tail(&epi->rdllink, &ep->rdllist);
+	     nepi = epi->next, epi->next = EP_UNACTIVE_PTR) {
+		/*
+		 * If the above loop quit with errors, the epoll item might still
+		 * be linked to "txlist", and the list_splice() done below will
+		 * take care of those cases.
+		 */
+		if (!ep_is_linked(&epi->rdllink))
+			list_add_tail(&epi->rdllink, &ep->rdllist);
+	}
 	/*
 	 * We need to set back ep->ovflist to EP_UNACTIVE_PTR, so that after
 	 * releasing the lock, events will be queued in the normal way inside

