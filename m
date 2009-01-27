Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbZA0Kx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbZA0Kx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 05:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbZA0Kxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 05:53:50 -0500
Received: from smtp-out.google.com ([216.239.45.13]:2356 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbZA0Kxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 05:53:49 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=hM1q1Jsn0I50mOsU4xz1y+5Py93iCMaJriik69PbzbhjFyBfK1CMfaK+c1OcIUE+Y
	lhNFofxC3qWZuDSNIZybw==
Date: Tue, 27 Jan 2009 02:53:00 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nikanth Karthikesan <knikanth@suse.de>
cc: Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
In-Reply-To: <200901271550.16902.knikanth@suse.de>
Message-ID: <alpine.DEB.2.00.0901270244380.23757@chino.kir.corp.google.com>
References: <200901211638.23101.knikanth@suse.de> <200901232026.16778.knikanth@suse.de> <alpine.DEB.2.00.0901231230370.14231@chino.kir.corp.google.com> <200901271550.16902.knikanth@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.24.198.88
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009, Nikanth Karthikesan wrote:

> > As previously stated, I think the heuristic to penalize tasks for not
> > having an intersection with the set of allowable nodes of the oom
> > triggering task could be made slightly more severe.  That's irrelevant to
> > your patch, though.
> >
> 
> But the heuristic makes it non-deterministic, unlike memcg case. And this 
> mandates special handling for cpuset constrained OOM conditions in this patch.
> 

Dividing a badness score by 8 if a task's set of allowable nodes do not 
insect with the oom triggering task's set does not make an otherwise 
deterministic algorithm non-deterministic.

I don't understand what you're arguing for here.  Are you suggesting that 
we should not prefer tasks that intersect the set of allowable nodes?  
That makes no sense if the goal is to allow for future memory freeing.

> > We also talked about a cgroup /dev/mem_notify device file that you can
> > poll() and learn of low memory situations so that appropriate action can
> > be taken even in lowmem situations as opposed to simply oom conditions.
> >
> 
> Userspace also needs to handle the cpuset constrained _almost-oom_'s 
> specially? I wonder how easily userspace can handle that.
> 

It handles it very well, cpusets are a client of cgroups and the 
/dev/mem_notify extension would be as well.  So to handle lowmem 
notifications for your cpuset, you would mount both cgroup subsystems at 
the same time and then poll() on the mem_notify file.  It would be 
responsible for the aggregate of tasks that the cgroup represents.

If lowmem notifications are implemented in the reclaim path, this is much 
easier for cpusets than for the memory controller, actually, since we 
already collect per-node ZVC information.

> > These types of policy decisions belong in userspace.
> 
> Yes, policy decisions will be made in user-space using this oom-controller. 
> This is just a framework/means to enforce policies. We do not make any 
> decisions inside the kernel.
> 
> But yes, the badness calculation by the oom killer implements some kind of 
> policy inside the kernel, but I guess it can stay, as this oom-controller lets 
> user policy over-ride kernel policy. ;-)
> 

The goal should not be to override the kernel's choice, because that 
decision depends heavily on the type of oom and the state of the machine 
at the time.  Appropriate changes to the oom killer's heuristics are 
always welcome; in my opinion, we should probably penalize tasks that do 
not intersect the triggering task's set of allowable nodes more than we 
currently do.

I think you'll find that your goals can be accomplished with a mem_notify 
cgroup and that it is a much more powerful interface so that your 
userspace policy can be better informed, especially if it is aware of 
lowmem situations where oom conditions are imminent.
