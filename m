Return-Path: <linux-kernel-owner+w=401wt.eu-S937424AbZAPVZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937424AbZAPVZP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 16:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762537AbZAPVYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 16:24:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41633 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762700AbZAPVYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 16:24:54 -0500
Date: Fri, 16 Jan 2009 22:24:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>, ebiederm@xmission.com,
       cl@linux-foundation.org, travis@sgi.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, steiner@sgi.com, hugh@veritas.com
Subject: Re: [patch] add optimized generic percpu accessors
Message-ID: <20090116212415.GC10063@elte.hu>
References: <1231843097-18003-1-git-send-email-tj@kernel.org> <20090115113045.GG22850@elte.hu> <496F2032.5080502@kernel.org> <200901170748.53734.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901170748.53734.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Thursday 15 January 2009 22:08:26 Tejun Heo wrote:
> > Hello,
> > 
> > Ingo Molnar wrote:
> > > The new ops are a pretty nice and clean solution i think.
> > > 
> > > Firstly, accessing the current CPU is the only safe shortcut anyway (there 
> > > is where we can do %fs/%gs / rip-relative addressing modes), and the 
> > > generic per_cpu() APIs dont really provide that guarantee for us. We might 
> > > be able to hook into __get_cpu_var() but those both require to be an 
> > > lvalue and are also relatively rarely used.
> > > 
> > > So introducing the new, rather straightforward APIs and using them 
> > > wherever they matter for performance is good. Your patchset already shaved 
> > > off an instruction from ordinary per_cpu() accesses, so it's all moving 
> > > rather close to the most-optimal situation already.
> > 
> > Yeah, I don't think we can do much better than those ops.  I have two
> > issues tho.
> > 
> > 1. percpu_and() is missing.  I added it for completeness's sake.
> > 
> > 2. The generic percpu_op() should be local to the cpu, so it should
> >    expand to...
> > 
> >    do { get_cpu_var(var) OP (val); put_cpu_var(var) } while (0)
> > 
> >    as the original x86_OP_percpu() did.  Right?
> > 
> > Thanks.
> 
> No no no no.  This is a crapload of infrastructure noone will use.
>
> Please just start by adding read_percpu like so (this won't apply since 
> there's lots of other per-cpu things going on, but you get the idea).
> 
> We don't need a whole set of operators for a handful of 
> non-arch-specific cases.  Reading a var is fairly common, the other ops 
> are diminishing returns and we already have local_t for some of these 
> cases (and we're reviewing that, too).

Actually, the percpu_add()/sub() ops are useful for statistics. (can be 
done without preempt disable/enable) percpu_write() is also obviously 
useful. The others are common arithmetic operators, for completeness of 
the API.

	Ingo
