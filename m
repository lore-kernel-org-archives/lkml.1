Return-Path: <linux-kernel-owner+w=401wt.eu-S1763359AbXGKMHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763359AbXGKMHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbXGKMGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:06:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56717 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641AbXGKMGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:06:52 -0400
Subject: Re: containers (was Re: -mm merge plans for 2.6.23)
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Jackson <pj@sgi.com>
Cc: vatsa@linux.vnet.ibm.com, mingo@elte.hu, containers@lists.osdl.org,
       menage@google.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070711044244.c0916fe5.pj@sgi.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <20070710105240.GA20914@linux.vnet.ibm.com>
	 <6599ad830707101134k29951c45h4af0807603f52b76@mail.gmail.com>
	 <20070710115319.0bdaff34.akpm@linux-foundation.org>
	 <20070711045516.GH2927@linux.vnet.ibm.com>
	 <20070710222942.382fc9ba.akpm@linux-foundation.org>
	 <20070711090423.GA6758@elte.hu> <20070711022352.71604404.pj@sgi.com>
	 <20070711100323.GA23473@linux.vnet.ibm.com>
	 <20070711101958.GA10095@elte.hu>
	 <20070711113953.GB23473@linux.vnet.ibm.com>
	 <20070711044244.c0916fe5.pj@sgi.com>
Content-Type: text/plain
Date: Wed, 11 Jul 2007 14:06:33 +0200
Message-Id: <1184155593.20032.29.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 04:42 -0700, Paul Jackson wrote:
> Srivatsa wrote:
> > The fact that we will have two interface for group scheduler in 2.6.24
> > is what worries me a bit (one user-id based and other container based).
> 
> Yeah.
> 
> One -could- take linear combinations, as Peter drew in his ascii art,
> but would one -want- to do that?

I'd very much like to have it, but that is just me. We could take a
weight of 0 to mean disabling of that grouping and default to that. That
way it would not complicate regular behaviour.

It could be implemented with a simple hashing scheme where
sched_group_hash(tsk) and sched_group_cmp(tsk, group->some_task) could
be used to identify a schedule group.

pseudo code:

u64 sched_group_hash(struct task_struct *tsk)
{
	u64 hash = 0;

	if (tsk->pid->weight)
		hash_add(&hash, tsk->pid);

	if (tsk->pgrp->weight)
		hash_add(&hash, tsk->pgrp);

	if (tsk->uid->weight)
		hash_add(&hash, tsk->uid);

	if (tsk->container->weight)
		hash_add(&hash, tsk->container);

	...

	return hash;
}

s64 sched_group_cmp(struct task_struct *t1, struct task_struct *t2)
{
	s64 cmp;

	if (t1->pid->weight || t2->pid->weight) {
		cmp = t1->pid->weight - t2->pid->weight;
		if (cmp)
			return cmp;
	}

	...

	return 0;
}

u64 sched_group_weight(struct task_struct *tsk)
{
	u64 weight = 1024; /* 1 fixed point 10 bits */

	if (tsk->pid->weight) {
		weight *= tsk->pid->weight;
		weight /= 1024;
	}

	....

	return weight;
}




