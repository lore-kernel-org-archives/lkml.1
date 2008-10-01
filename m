Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400AbYJAJOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbYJAJOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 05:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbYJAJN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 05:13:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50425 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424AbYJAJN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 05:13:58 -0400
Date: Wed, 1 Oct 2008 11:13:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/31] cpumask: Documentation
Message-ID: <20081001091325.GA12503@elte.hu>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com> <20080929180250.287081000@polaris-admin.engr.sgi.com> <200810010849.46874.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810010849.46874.rusty@rustcorp.com.au>
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

> On Tuesday 30 September 2008 04:02:51 Mike Travis wrote:
> > +The Changes
> > +
> > +Provide new cpumask interface API.  The relevant change is basically
> > +cpumask_t becomes an opaque object.  This should result in the minimum
> > +amount of modifications while still allowing the inline cpumask functions,
> > +and the ability to declare static cpumask objects.
> > +
> > +
> > +    /* raw declaration */
> > +    struct __cpumask_data_s { DECLARE_BITMAP(bits, NR_CPUS); };
> > +
> > +    /* cpumask_map_t used for declaring static cpumask maps */
> > +    typedef struct __cpumask_data_s cpumask_map_t[1];
> > +
> > +    /* cpumask_t used for function args and return pointers */
> > +    typedef struct __cpumask_data_s *cpumask_t;
> > +    typedef const struct __cpumask_data_s *const_cpumask_t;
> > +
> > +    /* cpumask_var_t used for local variable, definition follows */
> > +    typedef struct __cpumask_data_s	cpumask_var_t[1]; /* SMALL NR_CPUS */
> > +    typedef struct __cpumask_data_s	*cpumask_var_t;	  /* LARGE NR_CPUS */
> > +
> > +    /* replaces cpumask_t dst = (cpumask_t)src */
> > +    void cpus_copy(cpumask_t dst, const cpumask_t src);
> 
> Hi Mike,
> 
>     I have several problems with this patch series.  First, it's a flag day 
> change, which means it isn't bisectable and can't go through linux-next.  
> Secondly, we still can't hide the definition of the cpumask struct as long as 
> they're passed as cpumask_t, so it's going to be hard to find assignments 
> (illegal once we allocate nr_cpu_ids bits rather than NR_CPUS), and on-stack 
> users.
> 
>     Finally, we end up with code which is slightly more opaque than the 
> current code, with two new typedefs.  And that's an ongoing problem.
> 
>     I took a slightly divergent line with my patch series, and introduced a 
> parallel cpumask system which always passes and returns masks by pointer:
> 
> 	cpumask_t -> struct cpumask
> 	on-stack cpumask_t -> cpumask_var_t (same as your patch)
> 	cpus_and(dst, src1, src2) etc -> cpumask_and(&dst, &src1, &src2)
> 	cpumask_t cpumask_of_cpu(cpu) -> const struct cpumask *cpumask_of(cpu)
> 	cpumask_t cpu_online_map etc -> const struct cpumask *cpu_online_mask etc.
> 
> The old ops are expressed in terms of the new ops, and can be phased out over 
> time.

that looks very sane to me.

one small request:

> I'll commit these to my quilt series today.

IMHO, an infrastructure change of this magnitude should absolutely be 
done via the Git space. This needs a ton of testing and needs bisection, 
a real Git track record, etc.

	Ingo
