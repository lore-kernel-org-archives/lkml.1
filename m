Return-Path: <linux-kernel-owner+w=401wt.eu-S1762902AbZAOM1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762902AbZAOM1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 07:27:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbZAOM0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 07:26:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48356 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324AbZAOM0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 07:26:48 -0500
Date: Thu, 15 Jan 2009 13:26:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
       ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       travis@sgi.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
Subject: Re: [patch] add optimized generic percpu accessors
Message-ID: <20090115122611.GJ22850@elte.hu>
References: <1231843097-18003-1-git-send-email-tj@kernel.org> <496C717F.70204@kernel.org> <73c1f2160901130527s2d61f4ewf0725c3bf1b36a1a@mail.gmail.com> <496C9FB7.9050907@kernel.org> <496D8CEB.5060402@zytor.com> <20090114093834.GA19799@elte.hu> <496F0F50.6070200@kernel.org> <20090115113045.GG22850@elte.hu> <496F2032.5080502@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496F2032.5080502@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> Ingo Molnar wrote:
> > The new ops are a pretty nice and clean solution i think.
> > 
> > Firstly, accessing the current CPU is the only safe shortcut anyway (there 
> > is where we can do %fs/%gs / rip-relative addressing modes), and the 
> > generic per_cpu() APIs dont really provide that guarantee for us. We might 
> > be able to hook into __get_cpu_var() but those both require to be an 
> > lvalue and are also relatively rarely used.
> > 
> > So introducing the new, rather straightforward APIs and using them 
> > wherever they matter for performance is good. Your patchset already shaved 
> > off an instruction from ordinary per_cpu() accesses, so it's all moving 
> > rather close to the most-optimal situation already.
> 
> Yeah, I don't think we can do much better than those ops.  I have two
> issues tho.
> 
> 1. percpu_and() is missing.  I added it for completeness's sake.

Sure - it would be commonly used as well. Perhaps we dont need 
percpu_xor() at all? (or and and ops already give a complete algebra)

> 2. The generic percpu_op() should be local to the cpu, so it should
>    expand to...
> 
>    do { get_cpu_var(var) OP (val); put_cpu_var(var) } while (0)
> 
>    as the original x86_OP_percpu() did.  Right?
> 
> Thanks.

hm, that removes much of its appeal - a preempt off+on sequence is quite 
bloaty. Most percpu usage sites are already within critical sections.

I think they are more analogous to per_cpu(var, cpu), which does not 
disable preemption either. There's no 'get/put' in them, which signals 
that they dont auto-disable preemption.

	Ingo
