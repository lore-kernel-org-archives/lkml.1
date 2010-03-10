Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab0CJSBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 13:01:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50839 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932578Ab0CJSBX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 13:01:23 -0500
Subject: Re: Q: select_fallback_rq() && cpuset_lock()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20100310173018.GA1294@redhat.com>
References: <20100309180615.GA11681@redhat.com>
	 <1268239242.5279.46.camel@twins>  <20100310173018.GA1294@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Mar 2010 19:01:15 +0100
Message-ID: <1268244075.5279.53.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-10 at 18:30 +0100, Oleg Nesterov wrote:
> On 03/10, Peter Zijlstra wrote:
> >
> > On Tue, 2010-03-09 at 19:06 +0100, Oleg Nesterov wrote:
> > > In particular, see http://marc.info/?l=linux-kernel&m=125261083613103
> >
> > /me puts it on the to-review stack.
> 
> Great, thanks. In fact, you already acked it before ;)
> 
> > > But now I have another question. Since 5da9a0fb673a0ea0a093862f95f6b89b3390c31e
> > > cpuset_cpus_allowed_locked() is called without callback_mutex held by
> > > try_to_wake_up().
> > >
> > > And, without callback_mutex held, isn't it possible to race with, say,
> > > update_cpumask() which changes cpuset->cpus_allowed? Yes, update_tasks_cpumask()
> > > should fixup task->cpus_allowed later. But isn't it possible (at least
> > > in theory) that try_to_wake_up() gets, say, all-zeroes in task->cpus_allowed
> > > after select_fallback_rq()->cpuset_cpus_allowed_locked() if we race with
> > > update_cpumask()->cpumask_copy() ?
> >
> > Hurmm,.. good point,.. yes I think that might be possible.
> > p->cpus_allowed is synchronized properly, but cs->cpus_allowed is not,
> > bugger.
> >
> > I guess the quick fix is to really bail and always use cpu_online_mask
> > in select_fallback_rq().
> 
> Yes, but this breaks cpusets.

Arguably, so, but you can also argue that binding a task to a cpu and
then unplugging that cpu without first fixing up the affinity is a 'you
get to keep both pieces' situation.

> Peter, please see the attached mbox with the last discussion and patches.
> Of course, the changes in sched.c need the trivial fixups. I'll resend
> if you think these changes make sense.

Ah, right.. Damn I must be getting old, there wasn't even a spark of
recollection.

Right, so if you refresh these patches, I'll feed them to mingo and they
should eventually end up in -linus, how's that? :-)
