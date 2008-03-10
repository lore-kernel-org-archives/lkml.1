Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbYCJVTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbYCJVTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756625AbYCJVSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:18:41 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:58879 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756611AbYCJVSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:18:40 -0400
Date: Tue, 11 Mar 2008 00:17:44 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] signals: cleanup the usage of print_fatal_signal()
Message-ID: <20080310211744.GA1580@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the callsite of print_fatal_signal() down, under
"if (sig_kernel_coredump(signr))", so we don't need to check signr != SIGKILL.

We are only interested in the sig_kernel_coredump() signals anyway, and due to
the previous changes we almost never can see other fatal signals here except
SIGKILL.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~PFS_CLEANUP	2008-03-10 00:47:21.000000000 +0300
+++ 25/kernel/signal.c	2008-03-10 23:55:07.000000000 +0300
@@ -1766,9 +1766,10 @@ relock:
 		 * Anything else is fatal, maybe with a core dump.
 		 */
 		current->flags |= PF_SIGNALED;
-		if ((signr != SIGKILL) && print_fatal_signals)
-			print_fatal_signal(regs, signr);
+
 		if (sig_kernel_coredump(signr)) {
+			if (print_fatal_signals)
+				print_fatal_signal(regs, signr);
 			/*
 			 * If it was able to dump core, this kills all
 			 * other threads in the group and synchronizes with

