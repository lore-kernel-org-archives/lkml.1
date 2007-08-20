Return-Path: <linux-kernel-owner+w=401wt.eu-S1760622AbXHTP7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622AbXHTP7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 11:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759929AbXHTP7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 11:59:16 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:33638 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759704AbXHTP7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 11:59:15 -0400
Date: Mon, 20 Aug 2007 20:01:57 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] do_sigaction: don't worry about signal_pending()
Message-ID: <20070820160157.GA1279@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

do_sigaction() returns -ERESTARTNOINTR if signal_pending(). The comment says:

	* If there might be a fatal signal pending on multiple
	* threads, make sure we take it before changing the action.
	
I think this is not needed. We should only worry about SIGNAL_GROUP_EXIT case,
bit it implies a pending SIGKILL which can't be cleared by do_sigaction.

Kill this special case.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/kernel/signal.c~SA_NOPEND	2007-08-20 19:40:31.000000000 +0400
+++ t/kernel/signal.c	2007-08-20 19:43:41.000000000 +0400
@@ -2300,15 +2300,6 @@ int do_sigaction(int sig, struct k_sigac
 	k = &current->sighand->action[sig-1];
 
 	spin_lock_irq(&current->sighand->siglock);
-	if (signal_pending(current)) {
-		/*
-		 * If there might be a fatal signal pending on multiple
-		 * threads, make sure we take it before changing the action.
-		 */
-		spin_unlock_irq(&current->sighand->siglock);
-		return -ERESTARTNOINTR;
-	}
-
 	if (oact)
 		*oact = *k;
 

