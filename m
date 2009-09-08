Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbZIHGwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbZIHGwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 02:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbZIHGwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 02:52:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41763 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464AbZIHGwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 02:52:42 -0400
Date: Tue, 8 Sep 2009 08:52:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] perf_counter: Add PERF_COUNTER_IOC_SET_FILTER ioctl
Message-ID: <20090908065227.GA6505@elte.hu>
References: <4AA4C04D.1050201@cn.fujitsu.com> <4AA4C0B3.3070300@cn.fujitsu.com> <1252341871.7959.37.camel@laptop> <20090907164852.GA6485@elte.hu> <1252342545.7959.42.camel@laptop> <4AA5AA0F.4060104@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA5AA0F.4060104@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> Peter Zijlstra wrote:
> > On Mon, 2009-09-07 at 18:48 +0200, Ingo Molnar wrote:
> >> * Peter Zijlstra <peterz@infradead.org> wrote:
> >>
> >>> On Mon, 2009-09-07 at 16:13 +0800, Li Zefan wrote:
> >>>> Allow to set profile filter via ioctl.
> >>> Hrm,.. not at all sure about this.. what are the ABI implications?
> >> I think the ABI should be fine if it's always a sub-set of C syntax. 
> >> That would be C expressions initially. Hm?
> > 
> > Right, so I've no clue what filter expressions look like, and the
> > changelog doesn't help us at all. It doesn't mention its a well
> > considered decision to henceforth freeze the expression syntax.
> > 
> > Of course, since filters so far only work with tracepoint things, and
> > since you can only come by tracepoint things through debugfs, and since
> > anything debugfs is basically a free-for-all ABI-less world, we might be
> > good, but then this is a very ill-defined ioctl() indeed.
> > 
> > So please, consider this well -- there might not be a second chance.
> > 
> 
> Ok, the expressions are:
> 
>   1. S = opr1 op opr2	(op: ==, !=, <, <=, >, >=.
> 			 opr1 should be a field in the format file)
>   2. E = S1 op S2	(op: ||, &&)
>   3. E = E1 op E2	(op: ||, &&)
>   4. () can be used
> 
> I don't the syntax will be changed, but we may extend it, like 
> adding not ! operator. Like, for a func ptr, besides 
> "func==0xccee4400", we may want to allow "func==foo". Those 
> extentions are ok for the ABI, right?

Yeah - extensions (new operators, control structures, etc.) are fine 
- incompatible changes are not. So as long as we stick to the C 
syntax the ABI is: 'be a sub-set of C' - and that's easy to ensure 
in the long run. Needs to be added prominently in form of comments, 
etc.

It would also be useful for security engines: a filter attached to a 
security probe point (or syscalls) would allow the runtime shaping 
of security policy - to unprivileged user-space. If filters get 
inherited by child tasks and if child tasks are not allowed to make 
filters more permissive (i.e. if they can only add filters) that 
would be an excellent tool for safe sandboxing like Google Chrome's 
sandbox.

Btw., could we define the ABI in a way to allow not just expressions 
in the future, but small C-syntax scripts too? I.e. in the long run 
these filters could do dprobes alike safe scripting, injected by 
unprivileged user-space and parsed/validated and executed in the 
kernel.

It could also be useful for network filtering rules, etc. - and 
everyone knows C syntax so it has an easy learning curve.

Do you see where i'm going? Filter expressions are a _very_ powerful 
concept not just to tracing, and we want to spread it to more places 
in the kernel. Perfcounters are a natural first hop - just lets keep 
future options open too.

	Ingo

