Return-Path: <linux-kernel-owner+w=401wt.eu-S934000AbXCPBdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934000AbXCPBdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 21:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934006AbXCPBdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 21:33:18 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34108 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934000AbXCPBdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 21:33:17 -0400
Date: Fri, 16 Mar 2007 07:10:24 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: xemul@sw.ru, dev@sw.ru, pj@sgi.com, sam@vilain.net, ebiederm@xmission.com,
       winget@google.com, serue@us.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, ckrm-tech@lists.sourceforge.net,
       containers@lists.osdl.org
Subject: Re: Summary of resource management discussion
Message-ID: <20070316014024.GC28692@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070312124226.GD17151@in.ibm.com> <6599ad830703150424t3478cd55mf9d2699f3669c9f0@mail.gmail.com> <20070315170435.GA28692@in.ibm.com> <6599ad830703151212o524af40es6cc6893c4304175f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830703151212o524af40es6cc6893c4304175f@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 12:12:50PM -0700, Paul Menage wrote:
> There are some things that benefit from having an abstract
> container-like object available to store state, e.g. "is this
> container deleted?", "should userspace get a callback when this
> container is empty?". 

IMO we can still get these bits of information using nsproxy itself (I
admit I haven't looked at the callback requirement yet).

But IMO a bigger use of 'struct container' object in your patches is to
store hierarchical information and avoid /repeating/ that information in
each resource object (struct cpuset, struct cpu_limit, struct rss_limit
etc) a 'struct container' is attached to (as pointed out here : 
http://lkml.org/lkml/2007/3/7/356). However I don't know how many
controllers will ever support such hierarchical res mgmt and thats why I
said option 3 [above URL] may not be a bad compromise. 

Also if you find a good answer for my earlier question "what more
task-grouping behavior do you want to implement using an additional pointer 
that you can't reusing ->task_proxy", it would drive home the need for
additional pointers/structures.

> >> >a. Paul Menage's patches:
> >> >
> >> >        (tsk->containers->container[cpu_ctlr.subsys_id] - X)->cpu_limit
> >>
> >> So what's the '-X' that you're referring to
> >
> >Oh ..that's to seek pointer to begining of the cpulimit structure (subsys
> >pointer in 'struct container' points to a structure embedded in a larger
> >structure. -X gets you to point to the larger structure).
> 
> OK, so shouldn't that be listed as an overhead for your rcfs version
> too? 

X shouldn't be needed in rcfs patches, because "->ctlr_data" in nsproxy
can directly point to the larger structure (there is no 'struct
container_subsys_state' equivalent in rcfs patches).

Container patches:

	(tsk->containers->container[cpu_ctlr.subsys_id] - X)->cpu_limit

rcfs:

	tsk->nsproxy->ctlr_data[cpu_ctlr.subsys_id]->cpu_limit

> >Yes me too. But maybe to keep in simple in initial versions, we should
> >avoid that optimisation and at the same time get statistics on duplicates?.
> 
> That's an implementation detail - we have more important points to
> agree on right now ...

yes :)

Eric, did you have any opinion on this thread?

-- 
Regards,
vatsa
