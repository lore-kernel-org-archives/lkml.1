Return-Path: <linux-kernel-owner+w=401wt.eu-S1763106AbZAOSDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763106AbZAOSDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 13:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbZAOSDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 13:03:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50160 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799AbZAOSDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 13:03:24 -0500
Date: Thu, 15 Jan 2009 19:02:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>, ebiederm@xmission.com,
       cl@linux-foundation.org, rusty@rustcorp.com.au, travis@sgi.com,
       linux-kernel@vger.kernel.org, steiner@sgi.com, hugh@veritas.com
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
Message-ID: <20090115180259.GJ22472@elte.hu>
References: <496D8CEB.5060402@zytor.com> <20090114093834.GA19799@elte.hu> <496F0F50.6070200@kernel.org> <20090115113045.GG22850@elte.hu> <496F2032.5080502@kernel.org> <20090115122611.GJ22850@elte.hu> <496F346B.6020804@kernel.org> <20090115130740.GE21839@elte.hu> <496F38C7.5000403@kernel.org> <20090115093007.4215b4b4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115093007.4215b4b4.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 15 Jan 2009 22:23:19 +0900 Tejun Heo <tj@kernel.org> wrote:
> 
> > --- a/include/asm-generic/percpu.h
> > +++ b/include/asm-generic/percpu.h
> > @@ -80,4 +80,56 @@ extern void setup_per_cpu_areas(void);
> >  #define DECLARE_PER_CPU(type, name) extern PER_CPU_ATTRIBUTES \
> >  					__typeof__(type) per_cpu_var(name)
> >  
> > +/*
> > + * Optional methods for optimized non-lvalue per-cpu variable access.
> > + *
> > + * @var can be a percpu variable or a field of it and its size should
> > + * equal char, int or long.  percpu_read() evaluates to a lvalue and
> > + * all others to void.
> > + *
> > + * These operations are guaranteed to be atomic w.r.t. preemption.
> > + * The generic versions use plain get/put_cpu_var().  Archs are
> > + * encouraged to implement single-instruction alternatives which don't
> > + * require preemption protection.
> > + */
> > +#ifndef percpu_read
> > +# define percpu_read(var)						\
> > +  ({									\
> > +	typeof(per_cpu_var(var)) __tmp_var__;				\
> > +	__tmp_var__ = get_cpu_var(var);					\
> > +	put_cpu_var(var);						\
> > +	__tmp_var__;							\
> > +  })
> > +#endif
> 
> I wonder if the preempt_disable()/preempt_enable() in here actually
> does anything useful on any architecture.

Provides "this is IRQ safe" and "this is preempt safe" semantics.

	Ingo
