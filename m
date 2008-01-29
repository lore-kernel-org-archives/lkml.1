Return-Path: <linux-kernel-owner+w=401wt.eu-S1764927AbYA2QDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764927AbYA2QDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 11:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756637AbYA2QDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 11:03:14 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:27977 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759973AbYA2QDN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 11:03:13 -0500
Message-Id: <479F01AF.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 29 Jan 2008 08:36:31 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Paul Jackson" <pj@sgi.com>
Cc: <mingo@elte.hu>, <dmitry.adamushko@gmail.com>, <rostedt@goodmis.org>,
       <menage@google.com>, <rientjes@google.com>, <tong.n.li@intel.com>,
       <tglx@linutronix.de>, <akpm@linux-foundation.org>,
       <dhaval@linux.vnet.ibm.com>, <vatsa@linux.vnet.ibm.com>,
       <sgrubb@redhat.com>, <linux-kernel@vger.kernel.org>,
       <ebiederm@xmission.com>, <nickpiggin@yahoo.com.au>
Subject: Re: scheduler scalability - cgroups, cpusets and
	load-balancing
References: <1201600428.28547.87.camel@lappy>
 <1201604243.28547.101.camel@lappy> <20080129053005.bc7a11d7.pj@sgi.com>
In-Reply-To: <20080129053005.bc7a11d7.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Tue, Jan 29, 2008 at  6:30 AM, in message
<20080129053005.bc7a11d7.pj@sgi.com>, Paul Jackson <pj@sgi.com> wrote: 
> Peter wrote, in reply to Peter ;):
>> > [ It looks to me it balances a group over the largest SD the current cpu
>> >   has access to, even though that might be larger than the SD associated
>> >   with the cpuset of that particular cgroup. ]
>> 
>> Hmm, with a bit more thought I think that does indeed DTRT. Because, if
>> the cpu belongs to a disjoint cpuset, the highest sd (with
>> load-balancing enabled) would be that. Right?
> 
> The code that defines sched domains, kernel/sched.c 
> partition_sched_domains(),
> as called from the cpuset code in kernel/cpuset.c rebuild_sched_domains(),
> does not make use of the full range of sched_domain possibilities.
> 
> In particular, it only sets up some non-overlapping set of sched domains.
> Every CPU ends up in at most a single sched domain.
> 
> The original reason that one can't define overlapping sched domains via
> this cpuset interface (based off the cpuset 'sched_load_balance' flag)
> is that I didn't realize it was even possible to overlap sched domains
> when I wrote the cpuset code defining sched domains.  And then when I
> later realized one could overlap sched domains, I (a) didn't see a need
> to do so, and (b) couldn't see how to do so via the cpuset interface
> without causing my brain to explode.
> 
> Now, back to Peter's question, being a bit pedantic, CPUs don't belong
> to disjoint cpusets, except in the most minimal situation that there is
> only one cpuset covering all CPUs.
> 
> Rather what happens, when you have need for some realtime CPUs, is that:
>  1) you turn off sched_load_balance on the top cpuset,
>  2) you setup your realtime cpuset as a child cpuset of the top cpuset
>     such that its CPUs doesn't overlap any of its siblings, and
>  3) you turn off sched_load_balance in that realtime cpuset.
> 
> At that point, sched domains are rebuilt, including providing a
> sched domain that just contains the CPUs in that realtime cpuset, and
> normal scheduler load balancing ceases on the CPUs in that realtime
> cpuset.

Hi Paul,
  I am a bit confused as to why you disable load-balancing in the RT cpuset?  It shouldn't be strictly necessary in order for the RT scheduler to do its job (unless I am misunderstanding what you are trying to accomplish?).  Do you do this because you *have* to in order to make real-time deadlines, or because its just a further optimization?

-Greg


> 
>> [ Just a bit of a shame we have all cgroups represented on each cpu. ]
> 
> Could you restate this -- I suspect it's obvious, but I'm oblivious ;).



