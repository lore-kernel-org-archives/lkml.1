Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbZAVK2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbZAVK2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 05:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755108AbZAVK2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 05:28:00 -0500
Received: from smtp-out.google.com ([216.239.45.13]:4094 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbZAVK17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 05:27:59 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=v8M3MmEN11Uxk0uke0U+AxzQpWU4f8woPjZIGrNAaIAR+AaSj2X0tAbggz8dJORTQ
	MwWYr1TzU2HVV2qnaEvqg==
Date: Thu, 22 Jan 2009 02:27:19 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Evgeniy Polyakov <zbr@ioremap.net>
cc: Nikanth Karthikesan <knikanth@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
In-Reply-To: <20090122101424.GA12317@ioremap.net>
Message-ID: <alpine.DEB.2.00.0901220218120.2851@chino.kir.corp.google.com>
References: <200901211638.23101.knikanth@suse.de> <200901212054.34929.knikanth@suse.de> <alpine.DEB.2.00.0901211241040.21080@chino.kir.corp.google.com> <200901221042.30957.knikanth@suse.de> <alpine.DEB.2.00.0901220036440.28850@chino.kir.corp.google.com>
 <20090122095026.GA10579@ioremap.net> <alpine.DEB.2.00.0901220156310.1738@chino.kir.corp.google.com> <20090122101424.GA12317@ioremap.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.25.146.37
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2009, Evgeniy Polyakov wrote:

> > In an exclusive cpuset, a task's memory is restricted to a set of mems 
> > that the administrator has designated.  If it is oom, the kernel must free 
> > memory on those nodes or the next allocation will again trigger an oom 
> > (leading to a needlessly killed task that was in a disjoint cpuset).
> > 
> > Really.
> 
> The whole point of oom-killer is to kill the most appropriate task to
> free the memory. And while task is selected system-wide and some
> tunables are added to tweak the behaviour local to some subsystems, this
> cpuset feature is hardcoded into the selection algorithm.

Of course, because the oom killer must be aware that tasks in disjoint 
cpusets are more likely than not to result in no memory freeing for 
current's subsequent allocations.

> And when some tunable starts doing own calculation, behaviour of this
> hardcoded feature changes.
> 

Yes, it is possible to elevate oom_adj scores to override the cpuset 
preference.  That's actually intended since it is now possible for the 
administrator to specify that, against the belief of the kernel, that 
killing a task will free memory in these cpuset-constrained ooms.  That's 
probably because it has either been moved to a different cpuset or its set 
of allowable nodes is dynamic.

> > Then the scope of this new cgroup is restricted to not being used with 
> > cpusets that could oom.
> 
> These are perpendicular tasks - cpusets limit one area of the oom
> handling, cgroup order - another. Some people needs cpusets, others want
> cgroups. cpusets are not something exceptional so that only they have to
> be taken into account when doing system-wide operation like OOM
> condition handling.
> 

A cpuset is a cgroup.  If I am using cpusets, this patch fails to 
adequately allow me to describe my oom preferences for both 
cpuset-constrained ooms and global unconstrained ooms, which is a major 
drawback.

I would encourage you to look at the per-cgroup oom notifier patch[*] that 
defers most of these decisions to userspace.  Given your interest in 
priority based oom preferences as exhibited by your oom_victim patch, I 
think you'll find it of interest since it allows you much greater 
flexibility than you could ever hope for from the kernel's heuristics.

 [*] http://marc.info/?l=linux-mm&m=122575082227252
