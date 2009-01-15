Return-Path: <linux-kernel-owner+w=401wt.eu-S1764227AbZAOLb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764227AbZAOLb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbZAOLbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:31:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41259 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215AbZAOLbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:31:17 -0500
Date: Thu, 15 Jan 2009 12:30:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
       ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       travis@sgi.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
Subject: Re: [patch] add optimized generic percpu accessors
Message-ID: <20090115113045.GG22850@elte.hu>
References: <1231843097-18003-1-git-send-email-tj@kernel.org> <496C717F.70204@kernel.org> <73c1f2160901130527s2d61f4ewf0725c3bf1b36a1a@mail.gmail.com> <496C9FB7.9050907@kernel.org> <496D8CEB.5060402@zytor.com> <20090114093834.GA19799@elte.hu> <496F0F50.6070200@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496F0F50.6070200@kernel.org>
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

> Hello, Ingo.
> 
> Ingo Molnar wrote:
> > Tejun, could you please also add the patch below to your lineup too?
> 
> Sure thing.
> 
> > It is an optimization and a cleanup, and adds the following new generic 
> > percpu methods:
> > 
> >   percpu_read()
> >   percpu_write()
> >   percpu_add()
> >   percpu_sub()
> >   percpu_or() 
> >   percpu_xor()
> > 
> > and implements support for them on x86. (other architectures will fall 
> > back to a default implementation)
> > 
> > The advantage is that for example to read a local percpu variable, instead 
> > of this sequence:
> > 
> >  return __get_cpu_var(var);
> > 
> >  ffffffff8102ca2b:	48 8b 14 fd 80 09 74 	mov    -0x7e8bf680(,%rdi,8),%rdx
> >  ffffffff8102ca32:	81 
> >  ffffffff8102ca33:	48 c7 c0 d8 59 00 00 	mov    $0x59d8,%rax
> >  ffffffff8102ca3a:	48 8b 04 10          	mov    (%rax,%rdx,1),%rax
> > 
> > We can get a single instruction by using the optimized variants:
> > 
> >  return percpu_read(var);
> > 
> >  ffffffff8102ca3f:	65 48 8b 05 91 8f fd 	mov    %gs:0x7efd8f91(%rip),%rax
> > 
> > I also cleaned up the x86-specific APIs and made the x86 code use these 
> > new generic percpu primitives.
> > 
> > It looks quite hard to convince the compiler to generate the optimized 
> > single-instruction sequence for us out of __get_cpu_var(var) - or can you 
> > perhaps see a way to do it?
> 
> Yeah, I thought about that too but couldn't think of a way to persuade 
> the compiler because the compiler doesn't know how to access the 
> address.  I'll play with it a bit more but the clumsy percpu_*() 
> accessors probably might be the only way.  :-(

the new ops are a pretty nice and clean solution i think.

Firstly, accessing the current CPU is the only safe shortcut anyway (there 
is where we can do %fs/%gs / rip-relative addressing modes), and the 
generic per_cpu() APIs dont really provide that guarantee for us. We might 
be able to hook into __get_cpu_var() but those both require to be an 
lvalue and are also relatively rarely used.

So introducing the new, rather straightforward APIs and using them 
wherever they matter for performance is good. Your patchset already shaved 
off an instruction from ordinary per_cpu() accesses, so it's all moving 
rather close to the most-optimal situation already.

	Ingo
