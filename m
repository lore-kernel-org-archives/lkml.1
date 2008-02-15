Return-Path: <linux-kernel-owner+w=401wt.eu-S1759926AbYBOR64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759926AbYBOR64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 12:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757172AbYBOR6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 12:58:33 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:59342 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756010AbYBOR6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:58:31 -0500
Date: Fri, 15 Feb 2008 21:02:04 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] do_signal_stop: use signal_group_exit()
Message-ID: <20080215180204.GA4359@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_signal_stop() needs signal_group_exit() but checks sig->group_exit_task.
This (optimization) is correct, SIGNAL_STOP_DEQUEUED and SIGNAL_GROUP_EXIT
are mutually exclusive, but looks confusing. Use signal_group_exit(), this
is not fastpath, the code clarity is more important.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~6_DO_SIGNAL_STOP	2008-02-15 16:59:17.000000000 +0300
+++ 25/kernel/signal.c	2008-02-15 20:34:32.000000000 +0300
@@ -1718,7 +1718,7 @@ static int do_signal_stop(int signr)
 		struct task_struct *t;
 
 		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
-		    unlikely(sig->group_exit_task))
+		    unlikely(signal_group_exit(sig)))
 			return 0;
 		/*
 		 * There is no group stop already in progress.

