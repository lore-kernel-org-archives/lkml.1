Return-Path: <linux-kernel-owner+w=401wt.eu-S942062AbYCSW72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942062AbYCSW72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936951AbYCSVYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:24:17 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:33591 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934033AbYCSVYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:24:15 -0400
Date: Tue, 18 Mar 2008 19:33:20 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ptrace: ptrace_attach: use send_sig_info() instead force_sig_specific()
Message-ID: <20080318163320.GA5106@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(depends on signals-send_sig_info-dont-take-tasklist_lock.patch)

Nobody can block/ignore SIGSTOP, no need to use force_sig_specific() in
ptrace_attach. Use the "regular" send_sig_info().

With this patch stracing of /sbin/init doesn't clear its SIGNAL_UNKILLABLE,
but not that this makes ptracing of init safe.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/ptrace.c~5_PTRACE_STOP_NO_FORCE	2008-03-16 18:33:02.000000000 +0300
+++ 25/kernel/ptrace.c	2008-03-18 19:15:54.000000000 +0300
@@ -217,8 +217,7 @@ repeat:
 
 	__ptrace_link(task, current);
 
-	force_sig_specific(SIGSTOP, task);
-
+	send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
 bad:
 	write_unlock_irqrestore(&tasklist_lock, flags);
 	task_unlock(task);

