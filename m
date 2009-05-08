Return-Path: <linux-kernel-owner+w=401wt.eu-S1763795AbZEHTP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763795AbZEHTP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbZEHTPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:15:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54763 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910AbZEHTPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:15:17 -0400
Date: Fri, 8 May 2009 21:13:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com
Subject: Re: [PATCH 1/2] kernel/{sched,smp}.c: fix static decl prior to
	struct declaration
Message-ID: <20090508191355.GC12130@elte.hu>
References: <20090508184838.GA11157@havoc.gtf.org> <20090508190409.GA12130@elte.hu> <4A04833B.1010209@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A04833B.1010209@garzik.org>
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

> Ingo Molnar wrote:
>> * Jeff Garzik <jeff@garzik.org> wrote:
>>
>>> According to C99 6.9.2p3, any declaration "static struct foo my_foo;"
>>> must follow the definition of struct foo.
>>>
>>> Apparently, gcc's lack of warning is a bug.
>>>
>>> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
>>
>> good spotting, i'll apply this fix, but:
>>
>>>   */
>>>  struct task_group root_task_group;
>>>  -#ifdef CONFIG_FAIR_GROUP_SCHED
>>> -/* Default task group's sched entity on each cpu */
>>> -static DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
>>> -/* Default task group's cfs_rq on each cpu */
>>> -static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
>>> -#endif /* CONFIG_FAIR_GROUP_SCHED */
>>> -
>>> -#ifdef CONFIG_RT_GROUP_SCHED
>>> -static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
>>> -static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
>>> -#endif /* CONFIG_RT_GROUP_SCHED */
>>> -#else /* !CONFIG_USER_SCHED */
>>> -#define root_task_group init_task_group
>>> -#endif /* CONFIG_USER_SCHED */
>>> -
>>>  /* task_group_lock serializes add/remove of task groups and also changes to
>>
>> This block has a visible imbalance of preprocessor directives -  
>> there's a #else you moved, without moving the outermost #ifdef. My  
>> guess is that this will go down in a fireball with CONFIG_GROUP_SCHED 
>> disabled?
>
> It seems you are correct, I missed it in my 'allmodconfig' and 
> 'jeffs hw config' builds.
>
> Are you fixing this up, or should I regen the patch?

Please resend it. That area of the code is a bit of an #ifdef maze, 
hard to move around. (And i'd rather let you mess it up than mess it 
up myself - then i can blame it on you and bounce it back to you for 
fixing ;-)

Also, a style cleanup there might help a bit: adding a bit more 
geometric structure to the #ifdefs there might make the hierarchy 
stand out a bit more:

# ifdef CONFIG_RT_GROUP_SCHED
static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
# endif /* CONFIG_RT_GROUP_SCHED */
#else /* !CONFIG_USER_SCHED */
# define root_task_group init_task_group
#endif /* CONFIG_USER_SCHED */

in such a lineup it's more apparent at a glance when a piece of code 
gets snatched in an incomplete way.

Thanks,

	Ingo
