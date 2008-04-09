Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbYDISqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbYDISqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 14:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbYDISpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 14:45:55 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:50162 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004AbYDISpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 14:45:54 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 9 Apr 2008 11:45:47 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zach Brown <zach.brown@oracle.com>,
       Jeff Roberson <jroberson@chesapeake.net>
Subject: [patch] eventfd/kaio integration fix
Message-ID: <Pine.LNX.4.64.0804091138050.7000@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Roberson discovered a race when using kaio eventfd based 
notifications. This patch fixes the race by moving the notification inside 
the spinlocked section of kaio. The operation is safe since eventfd 
spinlock and kaio one are unrelated.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/aio.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

Index: linux-2.6.mod/fs/aio.c
===================================================================
--- linux-2.6.mod.orig/fs/aio.c	2008-04-08 16:25:27.000000000 -0700
+++ linux-2.6.mod/fs/aio.c	2008-04-09 11:37:10.000000000 -0700
@@ -936,14 +936,6 @@
 		return 1;
 	}
 
-	/*
-	 * Check if the user asked us to deliver the result through an
-	 * eventfd. The eventfd_signal() function is safe to be called
-	 * from IRQ context.
-	 */
-	if (!IS_ERR(iocb->ki_eventfd))
-		eventfd_signal(iocb->ki_eventfd, 1);
-
 	info = &ctx->ring_info;
 
 	/* add a completion event to the ring buffer.
@@ -992,6 +984,15 @@
 	kunmap_atomic(ring, KM_IRQ1);
 
 	pr_debug("added to ring %p at [%lu]\n", iocb, tail);
+
+	/*
+	 * Check if the user asked us to deliver the result through an
+	 * eventfd. The eventfd_signal() function is safe to be called
+	 * from IRQ context.
+	 */
+	if (!IS_ERR(iocb->ki_eventfd))
+		eventfd_signal(iocb->ki_eventfd, 1);
+
 put_rq:
 	/* everything turned out well, dispose of the aiocb. */
 	ret = __aio_put_req(ctx, iocb);
