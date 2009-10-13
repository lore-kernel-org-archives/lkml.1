Return-Path: <linux-kernel-owner+w=401wt.eu-S1759240AbZJMIoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240AbZJMIoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 04:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759211AbZJMIoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 04:44:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58203 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759192AbZJMIoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 04:44:09 -0400
Date: Tue, 13 Oct 2009 10:43:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC] x86, mce: use of TRACE_EVENT for mce
Message-ID: <20091013084324.GB9610@elte.hu>
References: <4ACEE5E0.3050701@jp.fujitsu.com> <1255074286.5228.163.camel@yhuang-dev.sh.intel.com> <4ACEF4D9.9090600@jp.fujitsu.com> <1255079484.5228.201.camel@yhuang-dev.sh.intel.com> <4AD3E731.7080900@jp.fujitsu.com> <1255404495.6047.298.camel@yhuang-dev.sh.intel.com> <4AD41793.9020400@jp.fujitsu.com> <1255414771.6047.405.camel@yhuang-dev.sh.intel.com> <20091013062939.GA8484@elte.hu> <4AD42A0D.7050104@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD42A0D.7050104@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> Ingo Molnar wrote:
> > * Huang Ying <ying.huang@intel.com> wrote:
> > 
> >> I have talked with Ingo about this patch. But he has different idea 
> >> about MCE log ring buffer and he didn't want to merge the patch even 
> >> as an urgent bug fixes. It seems that another re-post can not convince 
> >> him.
> > 
> > Correct. The fixes are beyond what we can do in .32 - and for .33 i 
> > outlined (with a patch) that we should be using not just the ftrace 
> > ring-buffer (like your patch did) but perf events to expose MCE events.
> > 
> > That brings MCE events to a whole new level of functionality.
> > 
> > Event injection support would be an interesting new addition to 
> > kernel/perf_event.c: non-MCE user-space wants to inject events as well - 
> > both to simulate rare events, and to define their own user-space events.
> > 
> > Is there any technical reason why we wouldnt want to take this far 
> > superior approach?
> > 
> > 	Ingo
> 
> We could have more aggressive discussion if there is a real patch. 
> This is an example.

That's the right attitude :-)

I've created a new topic tree for this approach: tip:perf/mce, and i've 
committed your patch with a changelog outlining the approach, and pushed 
it out. Please send delta patches against latest tip:master.

I think the next step should be to determine the rough 'event structure' 
we want to map out. The mce_record event you added should be split up 
some more.

For example we definitely want thermal events to be separate. One 
approach would be the RFC patch i sent in "[PATCH] x86: mce: New MCE 
logging design" - feel free to pick that up and iterate it.

A question would be whether each MCA/MCE bank should have a separate 
event enumerated. I.e. right now 'perf list' shows:

  mce:mce_record                             [Tracepoint event]

It might make sense to do something like:

  mce:mce_bank_2                             [Tracepoint event]
  mce:mce_bank_3                             [Tracepoint event]
  mce:mce_bank_5                             [Tracepoint event]
  mce:mce_bank_6                             [Tracepoint event]
  mce:mce_bank_8                             [Tracepoint event]

But this is pretty static and meaningless - so what i'd like to see is 
to enumerate the _logical purpose_ of the MCE events, largely driven by 
the physical source of the event:

  $ perf list 2>&1 | grep mce
  mce:mce_cpu                                [Tracepoint event]
  mce:mce_thermal                            [Tracepoint event]
  mce:mce_cache                              [Tracepoint event]
  mce:mce_memory                             [Tracepoint event]
  mce:mce_bus                                [Tracepoint event]
  mce:mce_device                             [Tracepoint event]
  mce:mce_other                              [Tracepoint event]

etc. - with a few simple rules about what type of event goes into which 
category, such as:

 - CPU internal errors go into mce_cpu
 - memory or L3 cache related errors go into mce_memory
 - L2 and lower level cache errors go into mce_cache
 - general IO / bus / interconnect errors go into mce_bus
 - specific device faults go into mce_device
 - the rest goes into mce_other

Note - this is just a first rough guesstimate list - more can be added 
and the definition can be made stricter. (Please suggest modifications 
to this categorization.) Each event still has finegrained fields that 
allows further disambiguation of precisely which event the CPU 
generated.

Note that these categories will be largely CPU independent. Certain 
models will offer events in all of these categories, some models will 
only provide events in a very limited subset of these events.

The logical structure remains CPU model independent and tools, admins 
and users can standardize on this generic 'logical overview' event 
structure - instead of the current maze of model specific MCE decoding 
with no real structure over it.

Once we have this higher level logging structure (while still preserving 
the fine details as well), we can go a step forward and attach things 
like the ability to panic the box to individual events.

[ Note, we might also still keep a 'generic' event like mce_record as
  well, if that still makes sense once we've split up the events
  properly. ]

Then the next step would be clean and generic event injection support 
that uses perf events.

Hm? Looks like pretty exciting stuff to me - there's a _lot_ of 
expressive potential in the hardware, we have myriads of interesting 
details that can be logged - we just need to free it up and make it 
available properly.

	Ingo
