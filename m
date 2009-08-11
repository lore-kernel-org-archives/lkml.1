Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbZHKU4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbZHKU4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 16:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbZHKU4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 16:56:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:60386 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbZHKU4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 16:56:22 -0400
Subject: Re: perf_counters issue with PERF_SAMPLE_GROUP
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@gmail.com
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
In-Reply-To: <7c86c4470908111240s58385748wdb3c3e4a0d66a1ea@mail.gmail.com>
References: <7c86c4470908110841wca07382gf7487c0ed55909f2@mail.gmail.com>
	 <1250006744.10001.29.camel@twins>
	 <7c86c4470908111240s58385748wdb3c3e4a0d66a1ea@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 11 Aug 2009 22:55:43 +0200
Message-Id: <1250024143.7091.7.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-11 at 21:40 +0200, stephane eranian wrote:

> > You seem to have forgotten to append your test.c though :-)
> >
> Can't send you the program because it uses extra bits and pieces
> which are hard to remove. Otherwise I would have send it already.

Those other bits aren't open source? tskk :-)

> But I think it boils down to the following piece of code in
> perf_counter_output():
>                 leader = counter->group_leader;
>                 list_for_each_entry(sub, &leader->sibling_list, list_entry) {
>                         if (sub != counter)
>                                 sub->pmu->read(sub);
> 
>                         group_entry.id = primary_counter_id(sub);
>                         group_entry.counter = atomic64_read(&sub->count);
> 
>                         perf_output_put(&handle, group_entry);
>                 }

Well, likely, but nothing obviously wrong stands out there, so now I get
to write a reproduces to see what's going wrong.

> >> Related to PERF_SAMPLE_GROUP, I believe there is some information missing.
> >> You need to provide the TIMING information because in the case of SAMPLE_GROUP
> >> you'd like to be able to scale the values of the counters you are
> >> collecting. And you
> >> need the timing at the moment, the sample was recorded not later.
> >
> > Right, so something like the below, possibly complemented with having
> > PERF_COUNTER_IOC_RESET also reset the run-times?
> >
> Yes, but don't you have a namespace issue between PERF_FORMAT_* and
> PERF_SAMPLE_* in the patch below? I would think you want to keep them separate.

Maybe, otoh we've consistently used it whenever exposing the timing
data.

> I am also wondering about why one would want one timing value and not the other.
> In other words, why not group them under a single name. But maybe it is harder
> to return more than one u64 per PERF_FORMAT?

Not really, Paul did it like that initially and we've been consistently
doing it like that -- changing it now is a bit late.


