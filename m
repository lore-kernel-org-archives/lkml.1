Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbZGXOYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbZGXOYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 10:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbZGXOYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 10:24:32 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:52451 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbZGXOYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 10:24:31 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC][PATCH 5/5] perfcounter: Add support for kernel hardware 
 breakpoints
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <c62985530907240702h2b2de14bw2f0d475f46067e4e@mail.gmail.com>
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com>
	 <1248109687-7808-6-git-send-email-fweisbec@gmail.com>
	 <1248354493.26273.2.camel@twins>
	 <c62985530907240702h2b2de14bw2f0d475f46067e4e@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Jul 2009 16:26:09 +0200
Message-Id: <1248445569.6987.74.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-24 at 16:02 +0200, Frédéric Weisbecker wrote:
> 2009/7/23 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> > On Mon, 2009-07-20 at 13:08 -0400, Frederic Weisbecker wrote:
> >> This adds the support for kernel hardware breakpoints in perfcounter.
> >> It is added as a new type of software counter and can be defined by
> >> using the counter number 5 and by passsing the address of the
> >> breakpoint to set through the config attribute.
> >
> > Is there a limit to these hardware breakpoints? If so, the software
> > counter model is not sufficient, since we assume we can always schedule
> > all software counters. However if you were to add more counters than you
> > have hardware breakpoints you're hosed.
> >
> >
> 
> Hmm, indeed. But this patch handles this case:
> 
> +static const struct pmu *bp_perf_counter_init(struct perf_counter *counter)
> +{
> +       if (hw_breakpoint_perf_init((unsigned long)counter->attr.config))
> +               return NULL;
> +
> 
> IIRC, hw_breakpoint_perf_init() calls register_kernel_breakpoint() which in turn
> returns -ENOSPC if we haven't any breakpoint room left.
> 
> It seems we can only set 4 breakpoints simultaneously in x86, or
> something close to that.

Ah, that's not the correct way of doing that. Suppose that you would
register 4 breakpoint counter to one task, that would leave you unable
to register a breakpoint counter on another task. Even though these
breakpoints would never be scheduled simultaneously.

Also, regular perf counters would multiplex counters when over-committed
on a hardware resource, allowing you to create more such breakpoints
than you have actual hardware slots.

The way to do this is to create a breakpoint pmu which would simply fail
the pmu->enable() method if there are insufficient hardware resources
available.

Also, your init routine, the above hw_breakpoint_perf_init(), will have
to verify that when the counter is part of a group, this and all other
hw breakpoint counters in that group can, now, but also in the future,
be scheduled simultaneously.

This means that there should be some arbitration towards other in-kernel
hw breakpoint users, because if you allow all 4 hw breakpoints in a
group and then let another hw breakpoint users have one, you can never
schedule that group again.

[ which raises a fun point, Paulus do we handle groups having multiple
  'hardware' pmu's in? ]

Now, for the actual counter implementation you can probably re-use the
swcounter code, but you also need a pmu implementation.

