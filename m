Return-Path: <linux-kernel-owner+w=401wt.eu-S1760194AbZDSOCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194AbZDSOCY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 10:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757034AbZDSOCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 10:02:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51010 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731AbZDSOCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 10:02:14 -0400
Date: Sun, 19 Apr 2009 16:01:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] tracing/core: Add current context on tracing recursion
	warning
Message-ID: <20090419140154.GB28919@elte.hu>
References: <1240117295-6873-1-git-send-email-fweisbec@gmail.com> <49EAC15E.7080702@cn.fujitsu.com> <20090419123430.GA5967@nowhere> <20090419134927.GA6262@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090419134927.GA6262@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Sun, Apr 19, 2009 at 02:34:32PM +0200, Frederic Weisbecker wrote:
> > On Sun, Apr 19, 2009 at 02:14:54PM +0800, Li Zefan wrote:
> > > Frederic Weisbecker wrote:
> > > > Hi,
> > > > 
> > > > Here is the v3 of the __string() field patchset.
> > > > It applies suggestions from Steven and Peter with some arrangements.
> > > > 
> > > > This time, filtering is not supported (though it is ready in a pending patch).
> > > > I wanted to provide it but it looks like filtering has been broken recently.
> > > > Once I set a usual string filter, no more traces appear, and clearing it
> > > > doesn't change anything.
> > > > 
> > > 
> > > I tried it, and triggered a WARNING, and ring buffers was
> > > disabled permanently:
> > 
> > 
> > I've also seen this warning but on another event.
> > I don't think this is related to this patchset but
> > more about the tracing recursion detection.
> > 
> > For exemple, here we are in an Irq event, which doesn't
> > use the __string() thing. For such off-case, the only change
> > is a variable declaration and a + 0 operation.
> > 
> > Another thing: I've only seen it in a selftest.
> 
> 
> Worst: I can't reproduce it anymore.
> What were you doing when you got such warning? Were you
> in a selftest, or trying a usual event?
> 
> Also, could you test the following patch. It will give us
> more informations about the tracing recursion.
> 
> You can find it on:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing tracing/recursion
> 
> It's against tip/tracing/core
> 
> Thanks!
> 
> ---
> >From d13bf59ca011b976c561f623e3189a4a5b94370e Mon Sep 17 00:00:00 2001
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Sun, 19 Apr 2009 15:30:19 +0200
> Subject: [PATCH] tracing/core: Add current context on tracing recursion warning

> 
> In case of tracing recursion detection, we only get the stacktrace.
> But the current context may be very useful to debug the issue.
> 
> This patch adds the softirq/hardirq/nmi context with the warning
> using lockdep context display to have a familiar output.
> 
> [ Impact: more information in tracing recursion ]
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/ring_buffer.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index b421b0e..27a6e7d 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -1493,8 +1493,21 @@ static int trace_recursive_lock(void)
>  	level = trace_irq_level();
>  
>  	if (unlikely(current->trace_recursion & (1 << level))) {
> +		static atomic_t warned;
> +
>  		/* Disable all tracing before we do anything else */
>  		tracing_off_permanent();
> +
> +		if (atomic_inc_return(&warned) == 1) {
> +			printk(KERN_WARNING "Tracing recursion: "
> +				"[HC%u[%lu]:SC%u[%lu]:NMI[%lu]:HE%u:SE%u]\n",
> +				current->hardirq_context,
> +				hardirq_count() >> HARDIRQ_SHIFT,
> +				current->softirq_context,
> +				softirq_count() >> SOFTIRQ_SHIFT,
> +				in_nmi(), current->hardirqs_enabled,
> +				current->softirqs_enabled);
> +		}

It would be nice to have this ... but there's no need to do that 
atomic thing - just use printk_once() please. (if we race with 
another instance and get two messages that's not a problem)

	Ingo
