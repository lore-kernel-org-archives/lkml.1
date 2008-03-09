Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbYCIRTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbYCIRTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbYCIRTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:19:36 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:34759 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbYCIRTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:19:35 -0400
Date: Sun, 9 Mar 2008 20:23:29 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 7/6] signals: handle_stop_signal: don't worry about SIGKILL
Message-ID: <20080309172329.GA1344@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

handle_stop_signal() clears SIGNAL_STOP_DEQUEUED when sig == SIGKILL. Remove
this nasty special case. It was needed to prevent the race with group stop and
exit caused by thread-specific SIGKILL. Now that we use complete_signal() for
private signals too this is not needed, complete_signal() will notice SIGKILL
and abort the soon-to-begin group stop.

Except: the target thread is dead (has PF_EXITING). But in that case we should
not just clear SIGNAL_STOP_DEQUEUED and nothing more. We should either kill
the whole thread group, or silently ignore the signal.

I suspect we are not right wrt zombie leaders, but this is another issue which
and should be fixed separately. Note that this check can't abort the group stop
if it was already started/finished, this check only adds a subtle side effect
if we race with the thread which has already dequeued sig_kernel_stop() signal
and temporary released ->siglock.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~7_HSS_NO_KILL	2008-03-09 17:48:28.000000000 +0300
+++ 25/kernel/signal.c	2008-03-09 20:21:02.000000000 +0300
@@ -643,12 +643,6 @@ static void handle_stop_signal(int sig, 
 			 */
 			signal->flags &= ~SIGNAL_STOP_DEQUEUED;
 		}
-	} else if (sig == SIGKILL) {
-		/*
-		 * Make sure that any pending stop signal already dequeued
-		 * is undone by the wakeup for SIGKILL.
-		 */
-		signal->flags &= ~SIGNAL_STOP_DEQUEUED;
 	}
 }
 

