Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbZAWUrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbZAWUrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 15:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbZAWUrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 15:47:00 -0500
Received: from smtp-out.google.com ([216.239.33.17]:1250 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbZAWUq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 15:46:59 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=ESDKnuGSzOLlmfsOC3YVgLLA2Gk1M+LK6nxWh0qduxt36QD1pNrKWX8kwC7GpJeG9
	A7LmcmzXzmxWmPG+Nnn0g==
Date: Fri, 23 Jan 2009 12:44:59 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nikanth Karthikesan <knikanth@suse.de>
cc: Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
In-Reply-To: <200901232026.16778.knikanth@suse.de>
Message-ID: <alpine.DEB.2.00.0901231230370.14231@chino.kir.corp.google.com>
References: <200901211638.23101.knikanth@suse.de> <200901231515.37442.knikanth@suse.de> <alpine.DEB.2.00.0901230223500.15719@chino.kir.corp.google.com> <200901232026.16778.knikanth@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.24.198.73
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2009, Nikanth Karthikesan wrote:

> In other instances, It can actually also kill some innocent tasks unless the 
> administrator tunes oom_adj, say something like kvm which would have a huge 
> memory accounted, but might be from a different node altogether. Killing a 
> single vm is killing all of the processes in that OS ;)  Don't you think this 
> has to be fixed^Wimproved?
> 

As previously stated, I think the heuristic to penalize tasks for not 
having an intersection with the set of allowable nodes of the oom 
triggering task could be made slightly more severe.  That's irrelevant to 
your patch, though.

> > That's my objection to the proposal: it doesn't behave appropriately for
> > both global unconstrained ooms and cpuset-constrained ooms at the same
> > time.
> >
> 
> So you are against specifying order when it is a cpuset-constrained oom. Here 
> is a revised version of the patch which adds oom.cpuset_constraint, when set 
> to 1 would disable the ordering imposed by this controller for cpuset 
> constrained ooms! Will this work for you?
> 

No, I don't think it's appropriate to add special exemptions for specific 
subsystems to what should be a generic cgroup.  I think it is much more 
powerful to defer these decisions to userspace so each cgroup can attach 
its own handler and implement the necessary decision-making that the 
kernel could never perfectly handle for all possible workloads.

It is trivial to implement the equivalent of this particular change as a 
userspace handler to SIGKILL all tasks in a specific cgroup when the 
cgroup oom handler is woken up at the time of oom.  Additionally, it could 
also respond in other ways such as adding a node to a cpuset, killing a 
less important cgroup, elevate a memory controller limit, send a signal to 
your application to release memory, etc.

We also talked about a cgroup /dev/mem_notify device file that you can 
poll() and learn of low memory situations so that appropriate action can 
be taken even in lowmem situations as opposed to simply oom conditions.

These types of policy decisions belong in userspace.
