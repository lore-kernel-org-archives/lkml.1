Return-Path: <linux-kernel-owner+w=401wt.eu-S1761274AbYA2Ufa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761274AbYA2Ufa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 15:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbYA2UfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 15:35:22 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:34958 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbYA2UfV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 15:35:21 -0500
Message-Id: <479F4631.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 29 Jan 2008 13:28:49 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Paul Jackson" <pj@sgi.com>
Cc: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <dmitry.adamushko@gmail.com>,
       <rostedt@goodmis.org>, <menage@google.com>, <rientjes@google.com>,
       <tong.n.li@intel.com>, <tglx@linutronix.de>,
       <akpm@linux-foundation.org>, <dhaval@linux.vnet.ibm.com>,
       <vatsa@linux.vnet.ibm.com>, <sgrubb@redhat.com>,
       <linux-kernel@vger.kernel.org>, <ebiederm@xmission.com>,
       <nickpiggin@yahoo.com.au>
Subject: Re: scheduler scalability - cgroups, cpusets and
	load-balancing
References: <1201600428.28547.87.camel@lappy>
 <1201604243.28547.101.camel@lappy> <20080129053005.bc7a11d7.pj@sgi.com>
 <479F01AF.BA47.005A.0@novell.com> <20080129102836.be614579.pj@sgi.com>
 <479F1118.BA47.005A.0@novell.com> <20080129133700.7f1ab444.pj@sgi.com>
In-Reply-To: <20080129133700.7f1ab444.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Tue, Jan 29, 2008 at  2:37 PM, in message
<20080129133700.7f1ab444.pj@sgi.com>, Paul Jackson <pj@sgi.com> wrote: 
> Gregory wrote:
>> > 1) What are 'per-domain' variables?
>> 
>> s/per-domain/per-root-domain
> 
> Oh dear - now I've got more questions, not fewer.
> 
>  1) "variables"  ... what variables?

Well, anything that is declared in "struct root_domain" in kernel/sched.c.

For instance, today in mainline we have:

struct root_domain {
	atomic_t refcount;
	cpumask_t span;
	cpumask_t online;

	/*
	 * The "RT overload" flag: it gets set if a CPU has more than
	 * one runnable RT task.
	 */
	cpumask_t rto_mask;
	atomic_t rto_count;
};

The first three are just related to general root-domain infrastructure code.  The last two in this case are related specifically to the rt-overload feature.  In earlier versions of rt-balance, the rt-overload bitmap was a global variable.  By moving it into the root_domain structure, there is now an instance per (um, for lack of a better, more up to date word) "exclusive" cpuset.   That way, disparate cpusets will not bother each other with overload notifications, etc.

Note that in -rt, we have more variables in this structure (RQ priority info) but that patch hasnt been pulled into sched-devel/linux-2.6 yet.

> 
>  2) Is a 'root-domain' just the RT specific portion
>     of a sched_domain, or is it something else?

Its meant to be general, but the only current client is the RT sched_class.  Reading back through the links you guys have been sending, its very similar in concept to the "rt-domain" stuff that you, Peter, and Steven were discussing a while back.

When I was originally putting this stuff together, I wanted to piggy back this data in the sched-domain code.  But I soon realized that the sched-domain trees are per-cpu structures.  What I needed was an "umbrella" structure that would allow cpus in a common cpuset to share arbitrary state data, but yet were associated with the sched-domains that the cpuset code setup.  The first pass had the structures associated with the sched-domain hierarchy, but I soon realized that it was really a per-rq association so I could simplify the design.  I.e.. Rather than have the code walk the sched-domain to find the common "root", I just hung the root directly on the rq itself.

But anyway, to answer the question: The concept is meant to be generic.  For instance, if it made sense for Peters cgroup work to sit here as well, we could just add new fields to the struct root_domain and Peter could access them via rq->rd.

I realize that it could possibly have been designed to abstract away the type of objects that the root-domain manages, but I want to keep the initial code as simple as possible.  We can always complicate^h^h^h^h^hcleanup the code later ;)

Regards,
-Greg


