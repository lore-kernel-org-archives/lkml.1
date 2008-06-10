Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbYFJSry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbYFJSry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 14:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbYFJSrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 14:47:46 -0400
Received: from smtp-out.google.com ([216.239.33.17]:47364 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbYFJSrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 14:47:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=yeK0JQ4t2xytsEgY0ikR0mJuGu7RTlNK1Nwf+s97CsdAaUqqFoV7oxJyY0ZTkVyvt
	+TDLpHBmhhnZGn8LT484w==
Date: Tue, 10 Jun 2008 11:47:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Max Krasnyansky <maxk@qualcomm.com>
cc: Paul Jackson <pj@sgi.com>, mingo@elte.hu,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, menage@google.com,
       linux-kernel@vger.kernel.org
Subject: Re: cpusets and kthreads, inconsistent behaviour
In-Reply-To: <484EAC2F.5020103@qualcomm.com>
Message-ID: <alpine.DEB.1.10.0806101135050.28953@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com> <20080605152953.dcfefa47.pj@sgi.com> <alpine.DEB.1.10.0806051357480.32537@chino.kir.corp.google.com> <484D99AD.4000306@qualcomm.com> <alpine.DEB.1.10.0806091447300.10680@chino.kir.corp.google.com>
 <484EAC2F.5020103@qualcomm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008, Max Krasnyansky wrote:

> Basically the issue is that current behaviour of the cpusets is inconsistent
> with regards to kthreads. Kthreads inherit cpuset from a parent properly but
> they simply ignore cpuset.cpus when their cpu affinity is set/updated.
> I think the behaviour must be consistent across the board. cpuset.cpus must
> apply to _all_ the tasks in the set, not just some of the tasks. If kthread
> must run on the cpus other than current_cpuset.cpus then it should detach from
> the cpuset.
> 

I disagree that a cpuset's set of allowable cpus should apply to all tasks 
attached to that cpuset.  It's certainly beneficial to be able to further 
constrict the set of allowed cpus for a task using sched_setaffinity().

It makes more sense to argue that for each task p, p->cpus_allowed is a 
subset of task_cs(p)->cpus_allowed.

> To give you an example kthreads like scsi_eh, kswapd, kacpid, pdflush,
> kseriod, etc are all started with cpus_allows=ALL_CPUS even though they
> inherit a cpuset from kthreadd. Yes they can moved manually (with
> sched_setaffinity) but the behaviour is not consistent, and for no good
> reason. kthreads can be stopped/started at any time (module load for example)
> which means that the user will have to keep moving them.
> 

This doesn't seem to be purely a kthread issue.  Tasks can be moved to a 
disjoint set of cpus by any caller to set_cpus_allowed_ptr() in the 
kernel.

		David
