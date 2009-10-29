Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbZJ3ABv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbZJ3ABv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 20:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465AbZJ3ABt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 20:01:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068AbZJ3ABr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 20:01:47 -0400
Date: Fri, 30 Oct 2009 00:57:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] signals: check ->group_stop_count after
	tracehook_get_signal()
Message-ID: <20091029235702.GA26446@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the call to do_signal_stop() down, after tracehook call.
This makes ->group_stop_count condition visible to tracers before
do_signal_stop() will participate in this group-stop.

Currently the patch has no effect, tracehook_get_signal() always
returns 0.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
---

 kernel/signal.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- V1/kernel/signal.c~2_DO_SIGNAL_STOP_AFTER_TRACEHOOK	2009-10-30 00:44:20.000000000 +0100
+++ V1/kernel/signal.c	2009-10-30 00:53:02.000000000 +0100
@@ -1807,11 +1807,6 @@ relock:
 
 	for (;;) {
 		struct k_sigaction *ka;
-
-		if (unlikely(signal->group_stop_count > 0) &&
-		    do_signal_stop(0))
-			goto relock;
-
 		/*
 		 * Tracing can induce an artifical signal and choose sigaction.
 		 * The return value in @signr determines the default action,
@@ -1823,6 +1818,10 @@ relock:
 		if (unlikely(signr != 0))
 			ka = return_ka;
 		else {
+			if (unlikely(signal->group_stop_count > 0) &&
+			    do_signal_stop(0))
+				goto relock;
+
 			signr = dequeue_signal(current, &current->blocked,
 					       info);
 

