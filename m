Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbYJASmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbYJASmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 14:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbYJASmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 14:42:09 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:54190 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbYJASmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 14:42:08 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 1 Oct 2008 11:41:58 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch] epoll drop unnecessary test
Message-ID: <Pine.LNX.4.64.0810011129260.20243@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas found that there is an unnecessary (always true) test in 
ep_send_events(). The callback never inserts into ->rdllink while the 
send loop is performed, and also does the ~EP_PRIVATE_BITS test. Given 
we're holding the mutex during this time, the conditions tested inside the 
loop are always true.
This patch drops the test done inside the re-insertion loop.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>



- Davide


---
 fs/eventpoll.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

Index: linux-2.6.mod/fs/eventpoll.c
===================================================================
--- linux-2.6.mod.orig/fs/eventpoll.c	2008-10-01 11:25:17.000000000 -0700
+++ linux-2.6.mod/fs/eventpoll.c	2008-10-01 11:26:58.000000000 -0700
@@ -927,14 +927,11 @@
 	/*
 	 * During the time we spent in the loop above, some other events
 	 * might have been queued by the poll callback. We re-insert them
-	 * here (in case they are not already queued, or they're one-shot).
+	 * inside the main ready-list here.
 	 */
 	for (nepi = ep->ovflist; (epi = nepi) != NULL;
-	     nepi = epi->next, epi->next = EP_UNACTIVE_PTR) {
-		if (!ep_is_linked(&epi->rdllink) &&
-		    (epi->event.events & ~EP_PRIVATE_BITS))
-			list_add_tail(&epi->rdllink, &ep->rdllist);
-	}
+	     nepi = epi->next, epi->next = EP_UNACTIVE_PTR)
+		list_add_tail(&epi->rdllink, &ep->rdllist);
 	/*
 	 * We need to set back ep->ovflist to EP_UNACTIVE_PTR, so that after
 	 * releasing the lock, events will be queued in the normal way inside

