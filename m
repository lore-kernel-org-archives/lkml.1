Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab0BXVGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 16:06:55 -0500
Received: from smtp-out.google.com ([216.239.33.17]:29568 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757693Ab0BXVGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 16:06:54 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=K/IE4eytDaUbW4qafW7EScWy0fJ2s7H5afC5/1/bJYyR6iPTdE8Wv0P8HR64or4ip
	MZ6gBynimcZ0nWT3Dk9sw==
Date: Wed, 24 Feb 2010 13:06:44 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Miao Xie <miaox@cn.fujitsu.com>
cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [regression] cpuset,mm: update tasks' mems_allowed in time
 (58568d2)
In-Reply-To: <4B84F645.6030404@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002241253560.30870@chino.kir.corp.google.com>
References: <20100218134921.GF9738@laptop> <alpine.DEB.2.00.1002181302430.13707@chino.kir.corp.google.com> <20100219033126.GI9738@laptop> <alpine.DEB.2.00.1002190143040.6293@chino.kir.corp.google.com> <20100222121222.GV9738@laptop>
 <alpine.DEB.2.00.1002221400060.23881@chino.kir.corp.google.com> <4B839103.2060901@cn.fujitsu.com> <alpine.DEB.2.00.1002230041240.12015@chino.kir.corp.google.com> <4B84F645.6030404@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Feb 2010, Miao Xie wrote:

> >> Sorry, Could you explain what you advised?
> >> I think it is hard to fix this problem by adding a variant, because it is
> >> hard to avoid loading a word of the mask before
> >>
> >> 	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
> >>
> >> and then loading another word of the mask after
> >>
> >> 	tsk->mems_allowed = *newmems;
> >>
> >> unless we use lock.
> >>
> >> Maybe we need a rw-lock to protect task->mems_allowed.
> >>
> > 
> > I meant that we need to define synchronization only for configurations 
> > that do not do atomic nodemask_t stores, it's otherwise unnecessary.  
> > We'll need to load and store tsk->mems_allowed via a helper function that 
> > is defined to take the rwlock for such configs and only read/write the 
> > nodemask for others.
> > 
> 
> By investigating, we found that it is hard to guarantee the consistent between
> mempolicy and mems_allowed because mempolicy was designed as a self-update function.
> it just can be changed by one's self. Maybe we must change the implement of mempolicy.
> 

Before your change, cpuset nodemask changes were serialized on 
manage_mutex which would, in turn, serialize the rebinding of each 
attached task's mempolicy.  update_nodemask() is now serialized on 
cgroup_lock(), which also protects scan_for_empty_cpusets(), so the cpuset 
code protects it adequately.  If a concurrent mempolicy change from a 
user's set_mempolicy() happens, however, it could introduce an 
inconsistency between them.

If we protect current->mems_allowed with a rwlock or seqlock for configs 
where MAX_NUMNODES > BITS_PER_LONG, then we can always guarantee that we 
get the entire nodemask.  The same problem is present for 
current->cpus_allowed, however, with NR_CPUS > BITS_PER_LONG.  We must be 
able to safely dereference both masks without the chance of returning 
nodes_empty() or cpus_empty().
