Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbYKSSwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbYKSSwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 13:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbYKSSwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 13:52:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbYKSSwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 13:52:07 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] protect /sbin/init from unwanted signals more
In-Reply-To: Oleg Nesterov's message of  Tuesday, 18 November 2008 18:59:01 +0100 <20081118175901.GA17134@redhat.com>
References: <20081118175901.GA17134@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20081119185148.DC1D31544EB@magilla.localdomain>
Date: Wed, 19 Nov 2008 10:51:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The effect is fine, but that seems like a kludgey way to do it.
I really don't think the sigaction case matters--certainly it will never
come up with SIGKILL.  What about just this instead?

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -66,6 +66,15 @@ static int sig_ignored(struct task_struct *t, int sig)
 		return 0;
 
 	handler = sig_handler(t, sig);
+
+	/*
+	 * For init, short-circuit any signal without a handler.
+	 * We won't allow them to be delivered, so don't even queue them.
+	 */
+	if (unlikely(signal->flags & SIGNAL_UNKILLABLE) &&
+	    (handler == SIG_IGN || handler == SIG_DFL))
+		return 1;
+
 	if (!sig_handler_ignored(handler, sig))
 		return 0;
 
With that, I wonder if the SIGNAL_UNKILLABLE checks in get_signal_to_deliver
and complete_signal are needed at all.  Hmm, I guess we do because this
doesn't affect blocked signals, so they might be unblocked and delivered.
(Note that since it doesn't affect blocked signals, this doesn't break init
using sigwait if it wanted to.)


Thanks,
Roland
