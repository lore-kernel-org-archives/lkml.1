Return-Path: <linux-kernel-owner+w=401wt.eu-S1761901AbZAWJsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761901AbZAWJsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 04:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756473AbZAWJsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 04:48:11 -0500
Received: from ns1.suse.de ([195.135.220.2]:59359 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303AbZAWJsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 04:48:10 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: David Rientjes <rientjes@google.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Date: Fri, 23 Jan 2009 15:15:36 +0530
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org
References: <200901211638.23101.knikanth@suse.de> <20090122101424.GA12317@ioremap.net> <alpine.DEB.2.00.0901220218120.2851@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0901220218120.2851@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901231515.37442.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 January 2009 15:57:19 David Rientjes wrote:
> On Thu, 22 Jan 2009, Evgeniy Polyakov wrote:
> > > In an exclusive cpuset, a task's memory is restricted to a set of mems
> > > that the administrator has designated.  If it is oom, the kernel must
> > > free memory on those nodes or the next allocation will again trigger an
> > > oom (leading to a needlessly killed task that was in a disjoint
> > > cpuset).
> > >
> > > Really.
> >
> > The whole point of oom-killer is to kill the most appropriate task to
> > free the memory. And while task is selected system-wide and some
> > tunables are added to tweak the behaviour local to some subsystems, this
> > cpuset feature is hardcoded into the selection algorithm.
>
> Of course, because the oom killer must be aware that tasks in disjoint
> cpusets are more likely than not to result in no memory freeing for
> current's subsequent allocations.
>

Yes, the problem is cpuset does not track the tasks which has allocated from 
this node - who has either moved or changed it set of allowable nodes. And 
because of that it does not limit oom killing to the tasks with in those tasks 
and could kill some innocent tasks at times.

As it is unable to take deterministic decision as memcg does, it plays with 
badness value and only suggests but does not restricts within those tasks that 
has to be killed.

This bug is present even without this patch.

> > And when some tunable starts doing own calculation, behaviour of this
> > hardcoded feature changes.
>
> Yes, it is possible to elevate oom_adj scores to override the cpuset
> preference.  That's actually intended since it is now possible for the
> administrator to specify that, against the belief of the kernel, that
> killing a task will free memory in these cpuset-constrained ooms.  That's
> probably because it has either been moved to a different cpuset or its set
> of allowable nodes is dynamic.
>

This patch adds one more easier way for the administrator to over-ride.

> > > Then the scope of this new cgroup is restricted to not being used with
> > > cpusets that could oom.
> >
> > These are perpendicular tasks - cpusets limit one area of the oom
> > handling, cgroup order - another. Some people needs cpusets, others want
> > cgroups. cpusets are not something exceptional so that only they have to
> > be taken into account when doing system-wide operation like OOM
> > condition handling.
>
> A cpuset is a cgroup.  If I am using cpusets, this patch fails to
> adequately allow me to describe my oom preferences for both
> cpuset-constrained ooms and global unconstrained ooms, which is a major
> drawback.
>

The current cpuset oom handling has to be fixed and the exact problem of 
killing innocent processes exists even without the oom-controller.

Thanks
Nikanth
