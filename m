Return-Path: <linux-kernel-owner+w=401wt.eu-S1761631AbXFEBoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761631AbXFEBoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 21:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988AbXFEBoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 21:44:15 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752583AbXFEBoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 21:44:14 -0400
Date: Mon, 4 Jun 2007 18:44:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH/RFC] signal races/bugs, losing TIF_SIGPENDING and other
 woes
In-Reply-To: <1181006711.31677.97.camel@localhost.localdomain>
Message-ID: <alpine.LFD.0.98.0706041831400.23741@woody.linux-foundation.org>
References: <1181006711.31677.97.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 5 Jun 2007, Benjamin Herrenschmidt wrote:
> 
>  - something calls recalc_sigpending_tsk() on thread A (for example,
>    something try to sends it S2 which is blocked). There is no longer
>    an active signal and thus TIF_SIGPENDING is cleared on thread A

I agree. That's unquestionably a bug. We should *never* clear sigpending 
for somebody else.

I have to say, your patch looks pretty ugly though. It also looks like 
it's rife to be subtly buggy (ie somebody calls "recalc_sigpending_tsk()" 
with "current" and doesn't realize the subtle rule.

So I'd rather just make it more explicit, and simple, and just have 
something really simple like the appended instead..

If we want to be fancier (and avoid the unnecessary compare for the cases 
where we statically know that we're calling it with "t" being "current"), 
we could make it an inline function and factor things out a bit, but I'm 
not sure how worthwhile that really is.

I also wonder if we should just remove the "clear_tsk_thread_flag()" thing 
*entirely*, and do it only in the do_sigal() path. THAT, however, is a 
much bigger change. This one-liner seems the trivial and most obvious 
patch.

Comments?

		Linus

---
 kernel/signal.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index acdfc05..61abd8d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -105,7 +105,8 @@ static int recalc_sigpending_tsk(struct task_struct *t)
 		set_tsk_thread_flag(t, TIF_SIGPENDING);
 		return 1;
 	}
-	clear_tsk_thread_flag(t, TIF_SIGPENDING);
+	if (t == current)
+		clear_tsk_thread_flag(t, TIF_SIGPENDING);
 	return 0;
 }
 
