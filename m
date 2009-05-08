Return-Path: <linux-kernel-owner+w=401wt.eu-S1764148AbZEHTF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764148AbZEHTF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbZEHTFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:05:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36722 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285AbZEHTFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:05:10 -0400
Date: Fri, 8 May 2009 21:04:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com
Subject: Re: [PATCH 1/2] kernel/{sched,smp}.c: fix static decl prior to
	struct declaration
Message-ID: <20090508190409.GA12130@elte.hu>
References: <20090508184838.GA11157@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508184838.GA11157@havoc.gtf.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

> According to C99 6.9.2p3, any declaration "static struct foo my_foo;"
> must follow the definition of struct foo.
> 
> Apparently, gcc's lack of warning is a bug.
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

good spotting, i'll apply this fix, but:

>   */
>  struct task_group root_task_group;
>  
> -#ifdef CONFIG_FAIR_GROUP_SCHED
> -/* Default task group's sched entity on each cpu */
> -static DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
> -/* Default task group's cfs_rq on each cpu */
> -static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
> -#endif /* CONFIG_FAIR_GROUP_SCHED */
> -
> -#ifdef CONFIG_RT_GROUP_SCHED
> -static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
> -static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
> -#endif /* CONFIG_RT_GROUP_SCHED */
> -#else /* !CONFIG_USER_SCHED */
> -#define root_task_group init_task_group
> -#endif /* CONFIG_USER_SCHED */
> -
>  /* task_group_lock serializes add/remove of task groups and also changes to

This block has a visible imbalance of preprocessor directives - 
there's a #else you moved, without moving the outermost #ifdef. My 
guess is that this will go down in a fireball with 
CONFIG_GROUP_SCHED disabled?

	Ingo
