Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbZA0KW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbZA0KW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 05:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbZA0KWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 05:22:48 -0500
Received: from ns.suse.de ([195.135.220.2]:54482 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbZA0KWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 05:22:48 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: David Rientjes <rientjes@google.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Date: Tue, 27 Jan 2009 15:50:16 +0530
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
References: <200901211638.23101.knikanth@suse.de> <200901232026.16778.knikanth@suse.de> <alpine.DEB.2.00.0901231230370.14231@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0901231230370.14231@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901271550.16902.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 January 2009 02:14:59 David Rientjes wrote:
> On Fri, 23 Jan 2009, Nikanth Karthikesan wrote:
> > In other instances, It can actually also kill some innocent tasks unless
> > the administrator tunes oom_adj, say something like kvm which would have
> > a huge memory accounted, but might be from a different node altogether.
> > Killing a single vm is killing all of the processes in that OS ;)  Don't
> > you think this has to be fixed^Wimproved?
>
> As previously stated, I think the heuristic to penalize tasks for not
> having an intersection with the set of allowable nodes of the oom
> triggering task could be made slightly more severe.  That's irrelevant to
> your patch, though.
>

But the heuristic makes it non-deterministic, unlike memcg case. And this 
mandates special handling for cpuset constrained OOM conditions in this patch.

> > > That's my objection to the proposal: it doesn't behave appropriately
> > > for both global unconstrained ooms and cpuset-constrained ooms at the
> > > same time.
> >
> > So you are against specifying order when it is a cpuset-constrained oom.
> > Here is a revised version of the patch which adds oom.cpuset_constraint,
> > when set to 1 would disable the ordering imposed by this controller for
> > cpuset constrained ooms! Will this work for you?
>
> No, I don't think it's appropriate to add special exemptions for specific
> subsystems to what should be a generic cgroup.  I think it is much more
> powerful to defer these decisions to userspace so each cgroup can attach
> its own handler and implement the necessary decision-making that the
> kernel could never perfectly handle for all possible workloads.
>
> It is trivial to implement the equivalent of this particular change as a
> userspace handler to SIGKILL all tasks in a specific cgroup when the
> cgroup oom handler is woken up at the time of oom.  Additionally, it could
> also respond in other ways such as adding a node to a cpuset, killing a
> less important cgroup, elevate a memory controller limit, send a signal to
> your application to release memory, etc.
>
> We also talked about a cgroup /dev/mem_notify device file that you can
> poll() and learn of low memory situations so that appropriate action can
> be taken even in lowmem situations as opposed to simply oom conditions.
>

Userspace also needs to handle the cpuset constrained _almost-oom_'s 
specially? I wonder how easily userspace can handle that.

> These types of policy decisions belong in userspace.

Yes, policy decisions will be made in user-space using this oom-controller. 
This is just a framework/means to enforce policies. We do not make any 
decisions inside the kernel.

But yes, the badness calculation by the oom killer implements some kind of 
policy inside the kernel, but I guess it can stay, as this oom-controller lets 
user policy over-ride kernel policy. ;-)

Thanks
Nikanth
