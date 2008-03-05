Return-Path: <linux-kernel-owner+w=401wt.eu-S1764880AbYCEWo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764880AbYCEWo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758765AbYCEWnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:43:50 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:54933 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758419AbYCEWnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:43:49 -0500
Date: Thu, 6 Mar 2008 01:43:21 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [RFC,PATCH 2/2] __group_complete_signal: fix? signal load-balancing
Message-ID: <20080305224321.GA6345@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch needs an ack, probably I just misunderstood the comments.

Suppose that the main thread blocks the signal. In that case
__group_complete_signal() tries to find another thread starting from
signal->curr_target.

The comment says about load-balancing, but this is not what happens?
Suppose that wants_signal(signal->curr_target) == T. In that case we
always choose the same ->curr_target thread. Isn't it better to try
to "spread" the signals over the thread group?

With this patch we are trying to find another suitable thread starting
from next_thread(signal->curr_target), thus distributing the load over
the whole thread group.

Bad idea? If not, probably we can also remove the "if (wants_signal())"
at the top of __group_complete_signal() ?

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~4_GCS_BALANCE	2008-03-06 01:07:55.000000000 +0300
+++ 25/kernel/signal.c	2008-03-06 01:34:57.000000000 +0300
@@ -863,13 +863,14 @@ __group_complete_signal(int sig, struct 
 		/*
 		 * Otherwise try to find a suitable thread.
 		 */
-		t = signal->curr_target;
-		if (t == NULL)
-			/* restart balancing at this thread */
-			t = signal->curr_target = p;
+		if (!signal->curr_target)
+			signal->curr_target = p;
 
-		while (!wants_signal(sig, t)) {
+		for (t = signal->curr_target ;; ) {
 			t = next_thread(t);
+			if (wants_signal(sig, t))
+				break;
+
 			if (t == signal->curr_target)
 				/*
 				 * No thread needs to be woken.

