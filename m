Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbYHBNAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbYHBNAh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 09:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbYHBNA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 09:00:29 -0400
Received: from gustav.zipernowsky.hu ([193.225.20.248]:45974 "EHLO
	gustav.zipernowsky.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbYHBNA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 09:00:28 -0400
MIME-Version: 1.0
Date: Sat, 02 Aug 2008 15:00:22 +0200
From: Oliver Pinter <oliver@zipernowsky.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>, stable@kernel.org
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org
Subject: [RFC, 2.6.26.2-rc1] signals: do_signal_stop: kill the SIGNAL_UNKILLABLE
 check
Reply-To: oliver.pntr@gmail.com
Message-ID: <e65964651c0f02f5554e1e4c5e40a876@zipernowsky.hu>
User-Agent: RoundCube Webmail/0.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2b201a9eddf509e8e935b45e573648e36f4b623f Mon Sep 17 00:00:00 2001
From: Oleg Nesterov <oleg@tv-sign.ru>
Date: Fri, 25 Jul 2008 01:47:31 -0700
Subject: [PATCH] signals: do_signal_stop: kill the SIGNAL_UNKILLABLE check

[ Upstream commit 2b201a9eddf509e8e935b45e573648e36f4b623f ]

fae5fa44f1fd079ffbed8e0add929dd7bbd1347f changed do_signal_stop() to check
SIGNAL_UNKILLABLE, this wasn't needed.  If signal_group_exit() == F, the
signal sent to SIGNAL_UNKILLABLE task must be already filtered out by the
caller, get_signal_to_deliver().  And if signal_group_exit() == T we are
not going to stop.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/kernel/signal.c b/kernel/signal.c
index 15f901a..0514da5 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1649,8 +1649,7 @@ static int do_signal_stop(int signr)
 	} else {
 		struct task_struct *t;
 
-		if (unlikely((sig->flags & (SIGNAL_STOP_DEQUEUED | SIGNAL_UNKILLABLE))
-					 != SIGNAL_STOP_DEQUEUED) ||
+		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
 		    unlikely(signal_group_exit(sig)))
 			return 0;
 		/*


