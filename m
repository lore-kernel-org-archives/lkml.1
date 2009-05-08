Return-Path: <linux-kernel-owner+w=401wt.eu-S1764034AbZEHTL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764034AbZEHTL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbZEHTLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:11:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46453 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbZEHTLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:11:17 -0400
Date: Fri, 8 May 2009 21:09:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Travis <travis@sgi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com
Subject: Re: [RFC PATCH 2/2] kernel/sched.c: VLA in middle of struct
Message-ID: <20090508190944.GB12130@elte.hu>
References: <20090508184838.GA11157@havoc.gtf.org> <20090508185015.GA11320@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508185015.GA11320@havoc.gtf.org>
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


* Jeff Garzik <jeff@garzik.org> wrote:

> The semantics for variable-length arrays __in the middle of structs__
> are quite muddy, and a case in sched.c presents an interesting case,
> as the preceding code comment indicates:
> 
> 	/*
> 	 * The cpus mask in sched_group and sched_domain hangs off
> 	 the end.  * FIXME: use cpumask_var_t or dynamic percpu alloc
> 	 to avoid * wasting space for nr_cpu_ids < CONFIG_NR_CPUS.  */
> 	struct static_sched_group {
> 		struct sched_group sg; DECLARE_BITMAP(cpus,
> 		CONFIG_NR_CPUS);
> 	};
> 
> 	struct static_sched_domain {
> 		struct sched_domain sd; DECLARE_BITMAP(span,
> 		CONFIG_NR_CPUS);
> 	};
> 
> Both sched_group and sched_domain have the following trailing struct
> member:
> 
> 	unsigned long cpumask[];
> 
> So this change is intended largely to spawn a discussion, because
> I'm not sure this VLA-in-middle-of-struct behavior is guaranteed to
> always behave as expected?
> 
> Maybe a C expert can say whether cpumask[0] is better than cpumask[],
> or have other comments?

This bit of the code is a bit temporary, with a half-done cpumask 
conversion ...

I'm not convinced at all that this code wants to be converted to 
cpuvar_t. These are all either statically percpu or dynamically 
allocated structures, so we wont allocate NR_CPUS of them. So i'd 
lean towards embedding a full struct cpumask and that's it.

That cpumask[] should probably be cpumask[0], to document the 
aliasing to ->span and ->cpus properly.

Rusty, what do you think?

	Ingo
