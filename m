Return-Path: <linux-kernel-owner+w=401wt.eu-S1760809AbXGNRuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760809AbXGNRuz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 13:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758432AbXGNRur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 13:50:47 -0400
Received: from canuck.infradead.org ([209.217.80.40]:48626 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758766AbXGNRur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 13:50:47 -0400
Subject: Re: [PATCH -rt 5/5] slub: -rt port
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20070714173950.GA806@tv-sign.ru>
References: <20070714175733.194012000@chello.nl>
	 <20070714175840.424675000@chello.nl>  <20070714173950.GA806@tv-sign.ru>
Content-Type: text/plain
Date: Sat, 14 Jul 2007 19:50:17 +0200
Message-Id: <1184435417.5284.58.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-14 at 21:39 +0400, Oleg Nesterov wrote:
> On 07/14, Peter Zijlstra wrote:
> >
> > +static void flush_all(struct kmem_cache *s)
> > +{
> > +	int cpu;
> > +	struct workqueue_struct *wq = flush_slab_workqueue;
> > +
> > +	mutex_lock(&flush_slab_mutex);
> > +	for_each_online_cpu(cpu) {
> > +		struct slab_work_struct *sw = &per_cpu(slab_works, cpu);
> > +
> > +		INIT_WORK(&sw->work, flush_cpu_slab_wq);
> > +		sw->s = s;
> > +		queue_work_cpu(wq, &sw->work, cpu);
> > +	}
> > +	flush_workqueue(wq);
> > +	mutex_unlock(&flush_slab_mutex);
> > +}
> 
> I suspect this is not cpu-hotplug safe. flush_slab_mutex doesn't protect
> from cpu_down(). This means that slab_work_struct could be scheduled on
> the already dead CPU. flush_workqueue(wq) will hang in that case.

Yeah, the function I copied this from: schedule_on_each_cpu() has a
comment to that effect.

Any ideas on how to solve this?

