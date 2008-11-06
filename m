Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbYKFHoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbYKFHoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYKFHoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:44:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45928 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023AbYKFHo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:44:29 -0500
Date: Thu, 6 Nov 2008 08:44:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ken Chen <kenchen@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch] sched: fix single-depth wchan output
Message-ID: <20081106074417.GB8459@elte.hu>
References: <b040c32a0811052158r4f6662dega3503a0c7ec72620@mail.gmail.com> <20081106061125.GA6384@elte.hu> <b040c32a0811052216i4594a094gdcee3ae280cddec7@mail.gmail.com> <20081106063012.GA15731@elte.hu> <b040c32a0811052242q767302cbx2667a68a8e058b6e@mail.gmail.com> <20081106065925.GE15731@elte.hu> <b040c32a0811052328k12c70644n15af3cedab32b6c3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0811052328k12c70644n15af3cedab32b6c3@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ken Chen <kenchen@google.com> wrote:

> On Wed, Nov 5, 2008 at 10:59 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > If it does stack walking manually then please update it to use
> > save_stack_trace() instead - that is the standard API that will
> > utilize the best possible stack walking machinery on the architecture
> > level.
> 
> OK, I pulled the patch out of our code that export stack trace via 
> /proc/pid/trace.  I didn't write this patch, but I think a better 
> choice would be to override struct stacktrace_ops print_trace_ops 
> with a memory buffer pointer to dump the stack into.  If you have 
> any comments, please let me know.  I will polish this patch up and 
> rebase to git-head.

hm, instead of modifying the lowlevel arch dump code, why not just use 
the existing save_stack_trace(), and render the output yourself via a 
trivial sprintf, just like kernel/lockdep.c does?

See kernel/stacktrace.c's print_stack_trace() - that could be extended 
with a sprintf_stack_trace() method. Allocate a large enough buffer 
dynamically, with a max of 128 stacktrace entries or so. (the output 
buffer is limited to 4K-ish anyway, right?)

As a bonus this will work on every architecture, not just x86.

a few other details:

> -	char namebuf[KSYM_NAME_LEN];
> +	char namebuf[128];

... time machine back to old crappy code ;-)

>  	symname = kallsyms_lookup(address, &symsize, &offset,
> -					&modname, namebuf);
> +				  &modname, namebuf);

ditto. But none of this has to be modified so you can just drop these 
bits.

> +	read_lock(&tasklist_lock);
> +	buf_show_task(posp, end, task);
> +	read_unlock(&tasklist_lock);

to get a stable trace we'll need more locking than that (tasklist_lock 
does not exclude scheduling, etc.) - but it takes care of the most 
important detail: tasks exiting from under us. So this should be OK.

>  #endif
> +	INF("trace",  S_IFREG|S_IRUGO, pid_trace),

that needs to be r-------- instead of r--r--r--, for security reasons.

	Ingo
