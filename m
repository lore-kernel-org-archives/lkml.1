Return-Path: <linux-kernel-owner+w=401wt.eu-S1760294AbXEXHqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760294AbXEXHqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 03:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756274AbXEXHqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 03:46:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56886 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964AbXEXHqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 03:46:17 -0400
Date: Thu, 24 May 2007 09:45:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Anant Nitya <kernel@prachanda.info>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] local_softirq_pending storm
Message-ID: <20070524074534.GA21138@elte.hu>
References: <200705091942.22920.kernel@prachanda.hub> <200705191525.28400.kernel@prachanda.hub> <1179601868.12981.127.camel@chaos> <200705200253.44992.kernel@prachanda.hub> <1179697388.6570.26.camel@chaos> <6bffcb0e0705221203s1ba21ed3j641e91036859db7d@mail.gmail.com> <20070522201046.GA6113@elte.hu> <46547345.8000808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46547345.8000808@redhat.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Chuck Ebbert <cebbert@redhat.com> wrote:

> >  	if (need_resched() && system_state == SYSTEM_RUNNING) {
> > -		raw_local_irq_disable();
> > -		_local_bh_enable();
> > -		raw_local_irq_enable();
> > +		local_bh_enable();
> >  		__cond_resched();
> >  		local_bh_disable();
> >  		return 1;
> 
> We may have a problem with that:
> 
>  BUG: warning at kernel/softirq.c:138/local_bh_enable() (Not tainted)
>   [<c042b2ef>] local_bh_enable+0x45/0x92
>   [<c06036b7>] cond_resched_softirq+0x2c/0x42
>   [<c059d5d0>] release_sock+0x54/0xa3
>   [<c05c9428>] tcp_sendmsg+0x91b/0xa0c
>   [<c05e1bb9>] inet_sendmsg+0x3b/0x45
>   [<c059af34>] sock_aio_write+0xf9/0x105
>   [<c0476035>] do_sync_write+0xc7/0x10a
>   [<c0437265>] autoremove_wake_function+0x0/0x35
>   [<c047688e>] vfs_write+0xbc/0x154
>   [<c0476e8c>] sys_write+0x41/0x67
>   [<c0404f70>] syscall_call+0x7/0xb

hm, this place really shouldnt call cond_resched_softirq() with hardirqs 
disabled.

perhaps a buggy ->sk_backlog_rcv() handler disabled interrupts without 
restoring them?

could you enable CONFIG_PROVE_LOCKING and apply the patch below - which 
location is printed as having last disabled hardirqs?

	Ingo

--------------------->
Subject: [patch] softirqs: print out irq-trace events
From: Ingo Molnar <mingo@elte.hu>

some code is fiddling with softirqs but hardirqs are disabled, so try to 
figure out who disabled hardirqs.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/softirq.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: linux/kernel/softirq.c
===================================================================
--- linux.orig/kernel/softirq.c
+++ linux/kernel/softirq.c
@@ -135,7 +135,15 @@ void local_bh_enable(void)
 
 	WARN_ON_ONCE(in_irq());
 #endif
-	WARN_ON_ONCE(irqs_disabled());
+	if (irqs_disabled()) {
+		static int once = 1;
+
+		if (once) {
+			once = 0;
+			print_irqtrace_events(current);
+			WARN_ON(1);
+		}
+	}
 
 #ifdef CONFIG_TRACE_IRQFLAGS
 	local_irq_save(flags);
