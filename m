Return-Path: <linux-kernel-owner+w=401wt.eu-S1755114AbYKCIaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbYKCIaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 03:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbYKCI3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 03:29:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41351 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604AbYKCI3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 03:29:51 -0500
Date: Mon, 3 Nov 2008 09:29:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>,
       Robert Richter <robert.richter@amd.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Identify which executable object the userspace address
	belongs to. Store thread group leader id, and use it to lookup the
	address in the process's map. We could have looked up the address
	on thread's map, but the thread might not exist by the time we are
	called. The process might not exist either, but if you are reading
	trace_pipe, that is unlikely.
Message-ID: <20081103082932.GF28771@elte.hu>
References: <1225660694-19765-1-git-send-email-edwintorok@gmail.com> <1225660694-19765-2-git-send-email-edwintorok@gmail.com> <1225660694-19765-3-git-send-email-edwintorok@gmail.com> <20081103074754.GB13727@elte.hu> <490EB361.9090007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <490EB361.9090007@gmail.com>
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

> > Your patches are a nice feature we want to have nevertheless - to 
> > be able to see where a user-space app is running has been one of 
> > the historically weak points of kernel instrumentation.
> 
> Thanks.
> It currently works for x86 only, but architecture porters can add
> support for theirs quite easily, it just needs to modeled after how
> oprofile does it for example.
> BTW would it make sense to change oprofile and the sysprof tracer to use
> save_stack_trace_user? It would eliminate some code duplication.

that definitely sounds like the right direction. I've Cc:-ed Robert 
Richter, the Oprofile maintainer - please Cc: him to code that touches 
oprofile.

note that NMI interaction of user-space stackframe walkers can be a 
bit tricky: the basic problem is that if you fetch a user-space 
stackframe that can create a fault, and the IRET at the end of the 
fault handler will re-enable NMIs (violating the NMI code's 
assumptions).

there are patches on lkml written by Mathieu Desnoyers that solve this 
by changing all the fault path to use RET instead of IRET. It might 
make sense to dust them off - we carried them for a long time in -tip 
and they were robust. (they just never had any really strong 
justification and were rather complex - that changes now)

Mathieu, what do you think?

> Would it make sense to add a script that post-processes the output 
> to scripts/tracing?
>
> It would parse a trace log (from trace or latency_trace) and use 
> addr2line to resolve the address to source:line, and if successful 
> replace the relative address with that; and also group identical 
> stack traces together.

sure, please add it to scripts/tracing/.

The best approach would be if the kernel could output the best info by 
default - but that seems rather hard for addr2line functionality which 
involves debuginfo processing, etc.

	Ingo
