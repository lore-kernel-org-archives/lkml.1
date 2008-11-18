Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbYKRQ65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbYKRQ65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 11:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbYKRQ6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 11:58:47 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46014 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbYKRQ6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 11:58:46 -0500
Date: Tue, 18 Nov 2008 18:59:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] protect /sbin/init from unwanted signals more
Message-ID: <20081118175901.GA17134@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init ignores the SIG_DFL signals but we queue them anyway, including
SIGKILL. This is mostly OK, the signal will be dropped silently when
dequeued, but the pending SIGKILL has 2 bad implications:

	- it implies fatal_signal_pending(), so we confuse things
	  like wait_for_completion_killable/lock_page_killable.

	- for the sub-namespace inits, the pending SIGKILL can
	  mask (legacy_queue) the subsequent SIGKILL from the
	  parent namespace which must kill cinit reliably.
	  (preparation, cinits don't have SIGNAL_UNKILLABLE yet)

The patch can't help when init is ptraced, but ptracing of init is
not "safe" anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- K-IS/kernel/signal.c~1_INIT_IGN_KILL	2008-11-10 19:21:17.000000000 +0100
+++ K-IS/kernel/signal.c	2008-11-17 19:54:09.000000000 +0100
@@ -43,7 +43,13 @@ static struct kmem_cache *sigqueue_cache
 
 static void __user *sig_handler(struct task_struct *t, int sig)
 {
-	return t->sighand->action[sig - 1].sa.sa_handler;
+	void __user *h = t->sighand->action[sig - 1].sa.sa_handler;
+
+	/* drop SIGKILL early to not confuse wait_xxx_killable/etc */
+	if (unlikely(t->signal->flags & SIGNAL_UNKILLABLE) && h == SIG_DFL)
+		h = SIG_IGN;
+
+	return h;
 }
 
 static int sig_handler_ignored(void __user *handler, int sig)

