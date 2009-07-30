Return-Path: <linux-kernel-owner+w=401wt.eu-S1751498AbZG3Qgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498AbZG3Qgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 12:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZG3Qgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 12:36:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49621 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbZG3Qgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 12:36:49 -0400
Date: Thu, 30 Jul 2009 18:32:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH 1/1] cpu_hotplug: don't play with current->cpus_allowed
Message-ID: <20090730163258.GB3617@redhat.com>
References: <20090729023302.GA8899@redhat.com> <20090729212125.GA16970@redhat.com> <20090729214310.GB24631@redhat.com> <4A70FEE3.2070302@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A70FEE3.2070302@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30, Lai Jiangshan wrote:
>
> Oleg Nesterov wrote:
> > _cpu_down() changes the current task's affinity and then recovers it at
> > the end. The problems are well known: we can't restore old_allowed if it
> > was bound to the now-dead-cpu, and we can race with the userspace which
> > can change cpu-affinity during unplug.
> >
> > _cpu_down() should not play with current->cpus_allowed at all. Instead,
> > take_cpu_down() can migrate the caller of _cpu_down() after __cpu_disable()
> > removes the dying cpu from cpu_online_mask.
> >
> >  static int __ref take_cpu_down(void *_param)
> >  {
> >  	struct take_cpu_down_param *param = _param;
> > +	unsigned int cpu = (unsigned long)param->hcpu;
> >  	int err;
> >
> >  	/* Ensure this CPU doesn't handle any more interrupts. */
> > @@ -181,6 +183,8 @@ static int __ref take_cpu_down(void *_pa
> >  	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
> >  				param->hcpu);
> >
> > +	if (task_cpu(param->caller) == cpu)
> > +		move_task_off_dead_cpu(cpu, param->caller);
>
> move_task_off_dead_cpu() calls cpuset_cpus_allowed_locked() which
> needs callback_mutex held. But actually we don't hold it, it'll
> will corrupt the work of other task which holds callback_mutex.
> Is it right?

Of course it is not. That is why I tried to kill cpuset_lock() first.

And I still think it must die. But I don't know how to remove it.

Oleg.

