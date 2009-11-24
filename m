Return-Path: <linux-kernel-owner+w=401wt.eu-S932883AbZKXUHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883AbZKXUHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932829AbZKXUHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:07:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757320AbZKXUG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:06:59 -0500
Date: Tue, 24 Nov 2009 21:01:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: [RFC,PATCH 02/14] signals: check ->group_stop_count after
	tracehook_get_signal()
Message-ID: <20091124200135.GA5761@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(already in mm: signals-check-group_stop_count-after-tracehook_get_signal.patch)

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

--- V1/kernel/signal.c~2_DO_SIGNAL_STOP_AFTER_TRACEHOOK	2009-11-24 19:46:51.000000000 +0100
+++ V1/kernel/signal.c	2009-11-24 19:51:13.000000000 +0100
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
 

