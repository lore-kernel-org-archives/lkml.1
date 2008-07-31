Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbYGaOe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbYGaOe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 10:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbYGaOeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 10:34:46 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:40226 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbYGaOep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 10:34:45 -0400
Date: Thu, 31 Jul 2008 16:35:15 +0200
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: John Kacur <jkacur@gmail.com>, Chirag Jog <chirag@linux.vnet.ibm.com>,
       J?rgen Mell <j.mell@t-online.de>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>,
       Josh Triplett <josht@linux.vnet.ibm.com>,
       "Timothy R. Chavez" <tim.chavez@linux.vnet.ibm.com>
Subject: Re: [PATCH] Fix Bug messages
Message-ID: <20080731163515.4a992060@bull.net>
In-Reply-To: <1217512907.8157.91.camel@twins>
References: <alpine.LFD.1.10.0807252141420.574@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0807291440240.14925@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0807300006180.14925@apollo.tec.linutronix.de>
	<200807301101.32417.j.mell@t-online.de>
	<20080730171842.GB3420@linux.vnet.ibm.com>
	<20080731100023.0221ec2b@bull.net>
	<520f0cf10807310313q45599221q3db1b6fd7e7c722f@mail.gmail.com>
	<20080731132336.362bd487@bull.net>
	<520f0cf10807310649l1083e29bmf0f704e13dee96c@mail.gmail.com>
	<1217512907.8157.91.camel@twins>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Peter,

On Thu, 31 Jul 2008 16:01:47 +0200 Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2008-07-31 at 15:49 +0200, John Kacur wrote:
> > Signed-off-by: John Kacur <jkacur@gmail.com>
> > Index: linux-2.6.26-rt1/net/core/sock.c
> > ===================================================================
> > --- linux-2.6.26-rt1.orig/net/core/sock.c
> > +++ linux-2.6.26-rt1/net/core/sock.c
> > @@ -1986,11 +1986,12 @@ static __init int net_inuse_init(void)
> >  
> >  core_initcall(net_inuse_init);
> >  #else
> > -static DEFINE_PER_CPU(struct prot_inuse, prot_inuse);
> > +static DEFINE_PER_CPU_LOCKED(struct prot_inuse, prot_inuse);
> >  
> >  void sock_prot_inuse_add(struct net *net, struct proto *prot, int val)
> >  {
> > -       __get_cpu_var(prot_inuse).val[prot->inuse_idx] += val;
> > +       int cpu = 0;
> > +       __get_cpu_var_locked(prot_inuse, cpu).val[prot->inuse_idx] += val;
> >  }
> >  EXPORT_SYMBOL_GPL(sock_prot_inuse_add);
> >  
> > @@ -2000,7 +2001,7 @@ int sock_prot_inuse_get(struct net *net,
> >         int res = 0;
> >  
> >         for_each_possible_cpu(cpu)
> > -               res += per_cpu(prot_inuse, cpu).val[idx];
> > +               res += per_cpu_var_locked(prot_inuse, cpu).val[idx];
> >  
> >         return res >= 0 ? res : 0;
> >  }
> 
> This doesn't look good. You declare it as a PER_CPU_LOCKED, but then
> never use the extra lock to synchronize data.
> 
> Given that sock_proc_inuse_get() is a racy read anyway, the 'right' fix
> would be to do something like:
> 
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 91f8bbc..5a8ace4 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1941,8 +1941,9 @@ static DECLARE_BITMAP(proto_inuse_idx, PROTO_INUSE_NR);
>  #ifdef CONFIG_NET_NS
>  void sock_prot_inuse_add(struct net *net, struct proto *prot, int val)
>  {
> -	int cpu = smp_processor_id();
> +	int cpu = get_cpu();
>  	per_cpu_ptr(net->core.inuse, cpu)->val[prot->inuse_idx] += val;
> +	put_cpu();
>  }
>  EXPORT_SYMBOL_GPL(sock_prot_inuse_add);
>  
> @@ -1988,7 +1989,9 @@ static DEFINE_PER_CPU(struct prot_inuse, prot_inuse);
>  
>  void sock_prot_inuse_add(struct net *net, struct proto *prot, int val)
>  {
> -	__get_cpu_var(prot_inuse).val[prot->inuse_idx] += val;
> +	int cpu = get_cpu();
> +	per_cpu(prot_inuse, cpu).val[prot->inuse_idx] += val;
> +	put_cpu();
>  }
>  EXPORT_SYMBOL_GPL(sock_prot_inuse_add);
>  
> This disables preemption, but only for a very short time - so it doesn't
> hurt the preempt-latency.
> 
> The alternative is to take a lock, do the inc, and drop the lock again,
> which is much more expensive.

  This does indeed seem to fix the problem, no more BUGs appearing
on the console with 2.6.26-rt1 now.

  Thanks,

  Sebastien.


