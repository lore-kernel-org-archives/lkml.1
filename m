Return-Path: <linux-kernel-owner+w=401wt.eu-S936599AbYEUS2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936599AbYEUS2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932826AbYEUS2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:28:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:53898 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761597AbYEUS2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:28:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=q454lmpZjLRQbLWu2YO+owEio4njTQCIj/VxsnThFjwjgwPOQDak4m8eagkAnRASr3rb386uk6Ex5bjF/Q50YBgCrhrMNdNa4i4OP+3phaSGl7KFlA2MmJApskM/adkdt4tBxH0azZI9BjZIoxWRkoCLBaxDc2Vn9LYe9GdbA7U=
Message-ID: <19f34abd0805211128r29fa437fm9e9e4c3d3c196f62@mail.gmail.com>
Date: Wed, 21 May 2008 20:28:02 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: initialization of static per-cpu variables
Cc: "Rusty Russel" <rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I encountered this comment in kernel/softirq.c:

/* Some compilers disobey section attribute on statics when not
   initialized -- RR */
static DEFINE_PER_CPU(struct tasklet_head, tasklet_vec) = { NULL };
static DEFINE_PER_CPU(struct tasklet_head, tasklet_hi_vec) = { NULL };

So I assume it's the combination of static and whatever section
DFINE_PER_CPU puts the variable in which is the problem.

However, there's a LOT of these "static DEFINE_PER_CPU" without any
initializer in the rest of the code, e.g.:

$ g 'static DEFINE_PER_CPU' kernel/sched.c
static DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
static DEFINE_PER_CPU(unsigned long long, time_offset);
static DEFINE_PER_CPU(unsigned long long, prev_cpu_time);
static DEFINE_PER_CPU(spinlock_t, aggregate_lock);
static DEFINE_PER_CPU(struct sched_domain, cpu_domains);
static DEFINE_PER_CPU(struct sched_group, sched_group_cpus);
static DEFINE_PER_CPU(struct sched_domain, core_domains);
static DEFINE_PER_CPU(struct sched_group, sched_group_core);
static DEFINE_PER_CPU(struct sched_domain, phys_domains);
static DEFINE_PER_CPU(struct sched_group, sched_group_phys);
static DEFINE_PER_CPU(struct sched_domain, node_domains);
static DEFINE_PER_CPU(struct sched_domain, allnodes_domains);
static DEFINE_PER_CPU(struct sched_group, sched_group_allnodes);

The comment seems to be ancient and I don't know who wrote it, so I'm
making a guess that it's Rusty Russel (Cced).

So which do we do, delete the comment (on the grounds that it is
invalid) or fix these other declarations (there's a lot of them)?

Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
