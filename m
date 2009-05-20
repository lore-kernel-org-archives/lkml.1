Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbZETHeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbZETHeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbZETHeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:34:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48766 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835AbZETHeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:34:15 -0400
Date: Wed, 20 May 2009 09:33:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com
Subject: Re: [PATCH 0/3] tracepoints: delay argument evaluation
Message-ID: <20090520073348.GA12316@elte.hu>
References: <cover.1242763826.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1242763826.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Baron <jbaron@redhat.com> wrote:

> hi,
> 
> After disassembling some of the tracepoints, I've noticed that 
> arguments that are passed as macros or that perform dereferences, 
> evaluate prior to the tracepoint on/off check. This means that we 
> are needlessly impacting the off case.
> 
> I am proposing to fix this by adding a macro that first checks for 
> on/off and then calls 'trace_##name', preserving type checking. 
> Thus, callsites have to move from:
> 
> trace_block_bio_complete(md->queue, bio);
> 
> to:
> 
> tracepoint_call(block_bio_complete,  md->queue, bio);
>
> I've tried '__always_inline', but that did not fix this issue. 
> Obviously this change will require changes to all the callsites. 
> But, that shouldn't be very hard, I've already included the 
> scheduler and block changes with this patch. I think its important 
> to minimize code execution in the off case, and thus going through 
> all the callsites is well worth it. If we agree on this change, I 
> can change the rest in very short order.
> 
> Below I'm also showing the assembly in the 'dec_pending()' 
> function before and after this change to show the difference it 
> makes. The arguments to the tracepoint are as above, 'md->queue' 
> and 'bio'. Notice the 2 extra instructions, before the initial 
> 'je', that could be moved after the 'je'.

> 
> before:
> 
> ffffffff8137b2a3:       83 3d de 90 4b 00 00    cmpl   $0x0,0x4b90de(%rip)        # ffffffff81834388 <__tracepoint_block_bio_complete+0x8>
> ffffffff8137b2aa:       49 8b 45 50             mov    0x50(%r13),%rax
> ffffffff8137b2ae:       48 89 45 d0             mov    %rax,-0x30(%rbp)
> ffffffff8137b2b2:       74 1f                   je     ffffffff8137b2d3 <dec_pending+0x101>

> after:
> 
> ffffffff8137b2a3:       83 3d de 90 4b 00 00    cmpl   $0x0,0x4b90de(%rip)        # ffffffff81834388 <__tracepoint_block_bio_complete+0x8>
> ffffffff8137b2aa:       74 27                   je     ffffffff8137b2d3 <dec_pending+0x101>

hm, this is really a compiler bug in essence - the compiler should 
delay the construction of arguments into unlikely branches - if the 
arguments are only used there.

We'd basically open-code a clear-cut:

   trace_block_bio_complete(md->queue, bio);
 
into this form:

   trace(block_bio_complete, md->queue, bio);

.. and this latter form could become moot (and a nuisance) if the 
compiler is fixed.

Have you tried very latest GCC, does it still have this optimization 
problem?

Note that the compiler getting this right would help a _lot_ of 
other inline functions in the kernel as well. Arguments only used 
within unlikely() branches are quite common.

	Ingo
