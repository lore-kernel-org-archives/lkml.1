Return-Path: <linux-kernel-owner+w=401wt.eu-S1753618AbYEaQOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbYEaQOl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 12:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbYEaQOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 12:14:00 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:38337 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbYEaQN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 12:13:58 -0400
Date: Sat, 31 May 2008 20:15:33 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] signals: do_signal_stop: kill the SIGNAL_UNKILLABLE check
Message-ID: <20080531161533.GA5566@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fae5fa44f1fd079ffbed8e0add929dd7bbd1347f changed do_signal_stop() to check
SIGNAL_UNKILLABLE, this wasn't needed. If signal_group_exit() == F, the
signal sent to SIGNAL_UNKILLABLE task must be already filtered out by the
caller, get_signal_to_deliver(). And if signal_group_exit() == T we are not
going to stop.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/signal.c~2_DSS_KILL_UNKILLABLE_CHECK	2008-05-31 14:54:32.000000000 +0400
+++ 26-rc2/kernel/signal.c	2008-05-31 16:03:39.000000000 +0400
@@ -1649,8 +1649,7 @@ static int do_signal_stop(int signr)
 	} else {
 		struct task_struct *t;
 
-		if (unlikely((sig->flags & (SIGNAL_STOP_DEQUEUED | SIGNAL_UNKILLABLE))
-					 != SIGNAL_STOP_DEQUEUED) ||
+		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
 		    unlikely(signal_group_exit(sig)))
 			return 0;
 		/*

