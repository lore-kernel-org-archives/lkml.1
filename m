Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab0CIVrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 16:47:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab0CIVq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 16:46:58 -0500
Date: Tue, 9 Mar 2010 22:44:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, David Howells <dhowells@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 1/3] call_usermodehelper: no need to unblock the signals
Message-ID: <20100309214456.GA32617@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

____call_usermodehelper() correctly calls flush_signal_handlers()
to set SIG_DFL, but sigemptyset(->blocked) and recalc_sigpending()
are not needed.

This kthread was forked by workqueue thread, all signals must be
unblocked and ignored, no pending signal is possible.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/kmod.c |    3 ---
 1 file changed, 3 deletions(-)

--- mm/kernel/kmod.c~1_SIGNALS	2010-02-26 22:07:38.000000000 +0100
+++ mm/kernel/kmod.c	2010-03-09 21:31:09.000000000 +0100
@@ -153,11 +153,8 @@ static int ____call_usermodehelper(void 
 	struct subprocess_info *sub_info = data;
 	int retval;
 
-	/* Unblock all signals */
 	spin_lock_irq(&current->sighand->siglock);
 	flush_signal_handlers(current, 1);
-	sigemptyset(&current->blocked);
-	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
 	/* We can run anywhere, unlike our parent keventd(). */

