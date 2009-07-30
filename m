Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbZG3HGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbZG3HGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 03:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbZG3HGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 03:06:49 -0400
Received: from smtp-out.google.com ([216.239.33.17]:1697 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbZG3HGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 03:06:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=tmwB+o5ygtpYVnNPHXb5EPAplqn7ZClyqP7bzQgude3duCoPjUcpgdpHQS18pIAmw
	MG18Ub9y/A8tMtOH01O9A==
Date: Thu, 30 Jul 2009 00:06:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch -mm v2] mm: introduce oom_adj_child
In-Reply-To: <20090730090855.E415.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907292356410.5581@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907282125260.554@chino.kir.corp.google.com> <20090730090855.E415.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jul 2009, KOSAKI Motohiro wrote:

> > diff --git a/kernel/fork.c b/kernel/fork.c
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -426,7 +426,7 @@ static struct mm_struct * mm_init(struct mm_struct * mm, struct task_struct *p)
> >  	init_rwsem(&mm->mmap_sem);
> >  	INIT_LIST_HEAD(&mm->mmlist);
> >  	mm->flags = (current->mm) ? current->mm->flags : default_dump_filter;
> > -	mm->oom_adj = (current->mm) ? current->mm->oom_adj : 0;
> > +	mm->oom_adj = p->oom_adj_child;
> 
> This code doesn't fix anything.
> mm->oom_adj assignment still change vfork() parent process oom_adj value.
> (Again, vfork() parent and child use the same mm)
> 

That's because the oom killer only really considers the highest oom_adj 
value amongst all threads that share the same mm.  Allowing those threads 
to each have different oom_adj values leads (i) to an inconsistency in 
reporting /proc/pid/oom_score for how the oom killer selects a task to 
kill and (ii) the oom killer livelock that it fixes when one thread 
happens to be OOM_DISABLE.

So, yes, changing the oom_adj value for a thread may have side-effects 
on other threads that didn't exist prior to 2.6.31-rc1 because the oom_adj 
value now represents a killable quantity of memory instead of a being a 
characteristic of the task itself.  But we now provide the inheritance 
property in a new way, via /proc/pid/oom_adj_child, that gives you all the 
functionality that the previous way did but without the potential for 
livelock.

> IOW, in vfork case, oom_adj_child parameter doesn't only change child oom_adj,
> but also parent oom_adj value.

Changing oom_adj_child for a task never changes oom_adj for any mm, it 
simply specifies what default value shall be given for a child's newly 
initialized mm.  Chaning oom_adj, on the other hand, will 

> IOW, oom_adj_child is NOT child effective parameter.
> 

It's not meant to be, it's only meant to specify a default value for newly 
initialized mm's of its descendants.  What happens after that is governed 
completely by the child's own /proc/pid/oom_adj.  That's pretty clearly 
explained in Documentation/filesystems/proc.txt.
