Return-Path: <linux-kernel-owner+w=401wt.eu-S1756466AbYK3UVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466AbYK3UVq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 15:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbYK3UVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 15:21:38 -0500
Received: from bu3sch.de ([62.75.166.246]:34421 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755536AbYK3UVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 15:21:38 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Phil Blundell <philb@gnu.org>,
       Carsten Gross <carsten@sol.wohnheim.uni-ulm.de>,
       Jose Renau <renau@acm.org>, Tim Waugh <tim@cyberelk.demon.co.uk>
Subject: [PATCH] IEEE1284: Use del_timer_sync in parport_wait_event
Date: Sun, 30 Nov 2008 21:20:49 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811302120.49766.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use del_timer_sync() instead of del_timer() to make sure
the timer won't be running when we return from parport_wait_event(),
because this would crash due to destruction of timer_list.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

This is completely untested and just based on a code review.
Just think about the following sequence of events:
add_timer.
down_interruptible is interrupted by a signal.
We enter the timer callback handler on another CPU.
del_timer, but the timer callback is still running.
Return from parport_wait_even, which destroys the automatic variable "timer"
while the callback is running on another CPU.

Index: linux-2.6/drivers/parport/ieee1284.c
===================================================================
--- linux-2.6.orig/drivers/parport/ieee1284.c	2008-10-24 21:08:12.000000000 +0200
+++ linux-2.6/drivers/parport/ieee1284.c	2008-11-30 21:09:25.000000000 +0100
@@ -84,7 +84,7 @@ int parport_wait_event (struct parport *
 
 	add_timer (&timer);
 	ret = down_interruptible (&port->physport->ieee1284.irq);
-	if (!del_timer (&timer) && !ret)
+	if (!del_timer_sync (&timer) && !ret)
 		/* Timed out. */
 		ret = 1;
 

-- 
Greetings Michael.
