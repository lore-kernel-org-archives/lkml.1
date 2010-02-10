Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab0BJKxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 05:53:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53371 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab0BJKxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 05:53:19 -0500
Subject: Re: [RFC perf,x86] P4 PMU early draft
From: Peter Zijlstra <peterz@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <aa79d98a1002100238v256ca6daw5e00c8b6d8dc4bb6@mail.gmail.com>
References: <20100208184504.GB5130@lenovo> <20100209041739.GA11280@elte.hu>
	 <20100209223909.GE5068@lenovo> <1265796732.11509.260.camel@laptop>
	 <aa79d98a1002100238v256ca6daw5e00c8b6d8dc4bb6@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Feb 2010 11:52:55 +0100
Message-ID: <1265799175.11509.271.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-10 at 13:38 +0300, Cyrill Gorcunov wrote:
> > I'd try BUG_ON(cpu != smp_processor_id()) and scrap passing that cpu
> > thing around.
> >
> 
> no, i need cpu to find out if event has migrated from other thread and
> then i switch
> some thread dependant flags in hw::config (ie escr and cccr), or i
> miss something and events in one cpu just can't migrate to another
> cpu? 

Well, if we validate that cpu == smp_processor_id() (looking at
kernel/perf_event.c that does indeed seem true for
hw_perf_group_sched_in() -- which suggests we should simply remove that
cpu argument), and that cpu will stay constant throughout the whole
callchain (it does, its a local variable), we can remove it and
substitute smp_processor_id(), right?

As to migration of the event, its tied to a task, we're now installing
the event for a task it wouldn't make sense to allow that to be
preemptible.

