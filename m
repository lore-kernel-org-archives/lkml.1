Return-Path: <linux-kernel-owner+w=401wt.eu-S1753067AbYCIQHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbYCIQHr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 12:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750834AbYCIQHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 12:07:38 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51753 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbYCIQHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 12:07:37 -0400
Date: Sun, 9 Mar 2008 19:11:53 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH] signals: print_fatal_signal: fix the signr "calculation"
Message-ID: <20080309161153.GA76@tv-sign.ru>
References: <20080308172453.GA28323@tv-sign.ru> <20080308190311.779B326F990@magilla.localdomain> <20080309110511.GA18128@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080309110511.GA18128@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09, Ingo Molnar wrote:
> 
> * Roland McGrath <roland@redhat.com> wrote:
> 
> > I'm not sure print-fatal-signals was really ever intended for 
> > non-coredump signals.  It doesn't seem like it would be all that 
> > useful.  It's probably even undesireable for every normal C-c killing 
> > something to cause a printk.
> 
> correct. We used to have them for SIGKILL but even that was confusing to 
> users - so the intent very much is to only have them for truly 
> unexpected, non-user generated and 'fatal', coredump-generating signals.

Yes, I see now, thanks.

Let me clarify why I started this thread. I'm thinking how we can "improve"
fatal signals. Let's look at this patch

	http://marc.info/?l=linux-kernel&m=120498888702466

(under discussion, let's suppose it will be accepted). In short: with this
patch the thread-specific SIGKILL shutdowns the whole thread group early on
signal delivery, the same way like the group-wide SIGKILL does.

For various reasons we can't currently do the same for sig_kernel_coredump()
signals. But, when rlim[RLIMIT_CORE] == 0, we don't actually need coredumping?
So, we could do something like


	-	if (!sig_kernel_coredump(sig)) {
	+	if (!sig_kernel_coredump(sig) || !signal->rlim[RLIMIT_CORE]) {

			// shutdown the whole group,
			// send SIGKILL to each thread

to speedup the processing of fatal coredump signals (to clarify: this issue
is minor, just for example. and the change above is not exactly right).

However, this breaks print_fatal_signal(), because with this change nobody
will dequeue the "right" signal to report, it was transformed to the "global"
SIGKILL.

So, if we change the behaviour of thread-specific coredump signals, then
we should "fix" print_fatal_signal(). At least, now I know which signals
should be reported.

Thanks!

Oleg.

