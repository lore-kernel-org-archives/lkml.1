Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbXGGSsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbXGGSsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 14:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbXGGSsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 14:48:11 -0400
Received: from mail.screens.ru ([213.234.233.54]:33022 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbXGGSsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 14:48:10 -0400
Date: Sat, 7 Jul 2007 22:48:07 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Vadim Lobanov <vlobanov@speakeasy.net>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] do_poll: return -EINTR when signalled
Message-ID: <20070707184807.GA196@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

do_poll() checks signal_pending() but returns 0 when interrupted. This means
the caller has to check signal_pending() again.

Change it to return -EINTR when signal_pending() and count == 0.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/fs/select.c~2_move	2007-07-07 20:08:36.000000000 +0400
+++ t/fs/select.c	2007-07-07 20:42:00.000000000 +0400
@@ -588,7 +588,7 @@ static int do_poll(unsigned int nfds,  s
 	/* Optimise the no-wait case */
 	if (!(*timeout))
 		pt = NULL;
- 
+
 	for (;;) {
 		struct poll_list *walk;
 		long __timeout;
@@ -618,10 +618,12 @@ static int do_poll(unsigned int nfds,  s
 		 * a poll_table to them on the next loop iteration.
 		 */
 		pt = NULL;
-		if (count || !*timeout || signal_pending(current))
-			break;
-		count = wait->error;
-		if (count)
+		if (!count) {
+			count = wait->error;
+			if (signal_pending(current))
+				count = -EINTR;
+		}
+		if (count || !*timeout)
 			break;
 
 		if (*timeout < 0) {
@@ -691,8 +693,6 @@ int do_sys_poll(struct pollfd __user *uf
 
 	poll_initwait(&table);
 	fdcount = do_poll(nfds, head, &table, timeout);
-	if (!fdcount && signal_pending(current))
-		fdcount = -EINTR;
 	poll_freewait(&table);
 
 	for (walk = head; walk; walk = walk->next) {

