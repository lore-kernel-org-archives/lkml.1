Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbYKCOEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbYKCOEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 09:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbYKCOEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 09:04:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52501 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923AbYKCOEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 09:04:40 -0500
Date: Mon, 3 Nov 2008 15:04:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, srostedt@redhat.com,
       a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Identify which executable object the userspace address
	belongs to. Store thread group leader id, and use it to lookup the
	address in the process's map. We could have looked up the address
	on thread's map, but the thread might not exist by the time we are
	called. The process might not exist either, but if you are reading
	trace_pipe, that is unlikely.
Message-ID: <20081103140406.GA14472@elte.hu>
References: <1225660694-19765-1-git-send-email-edwintorok@gmail.com> <1225660694-19765-2-git-send-email-edwintorok@gmail.com> <1225660694-19765-3-git-send-email-edwintorok@gmail.com> <20081103074754.GB13727@elte.hu> <490EB361.9090007@gmail.com> <20081103082932.GF28771@elte.hu> <490F035A.5070209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <490F035A.5070209@gmail.com>
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


* Török Edwin <edwintorok@gmail.com> wrote:

> > note that NMI interaction of user-space stackframe walkers can be 
> > a bit tricky: the basic problem is that if you fetch a user-space 
> > stackframe that can create a fault
> 
> The code in trace_sysprof.c (which I used as a base for the 
> save_stack_trace_user) disables pagefaults before reading the 
> stackframe from userspace. Does it avoid this problem then?

no, it does not solve it - because pagefault_disable is a "soft" 
mechanism which does not disable the faults themselves. (it only 
disables some of their effects)

> > , and the IRET at the end of the fault handler will re-enable NMIs 
> > (violating the NMI code's assumptions).
> 
> Is this already a problem with oprofile's user-stack walker?

yes, oprofile's code is buggy here too. And not enabled by default, 
and probably not used by many people. The bug would show up as 
mistakenly enabled NMIs from within NMIs - the kernel will _probably_ 
live but could lock up or overflow its stack, etc.

> > The best approach would be if the kernel could output the best 
> > info by default
> 
> The kernel could do some grouping and counting (as latencytop does), 
> but I don't see where it would fit in frace's infrastructure.
>
> I think ftrace's one entry per event is useful in many situations 
> (debugging, latency measurements), but if the events occur too 
> frequently it could produce too much data, and it would be more 
> efficient to do some counting/grouping of similar info in-kernel 
> before outputting to userspace. Perhaps as a layer on top of ftrace? 
> What do you think?

yes, histogram generation would be a natural 'view' of a tracer: have 
a look at Steve's likely()/unlikely() tracer that introduces that 
notion into ftrace.

	Ingo
