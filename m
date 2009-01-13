Return-Path: <linux-kernel-owner+w=401wt.eu-S1758499AbZAMXOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499AbZAMXOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:14:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbZAMXLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:11:38 -0500
Received: from smtp-out.google.com ([216.239.45.13]:61934 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757579AbZAMXLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:11:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=KdNmMLl3gvvP1Bl5s5wA0kMgUlZzfcGmkcpOMjlw/Ve513nVKBm5CNzgzrOkyIzPp
	ilJqPDR8gRHtjgJouVmnA==
Date: Tue, 13 Jan 2009 15:10:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Evgeniy Polyakov <zbr@ioremap.net>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
In-Reply-To: <20090113214627.GC27227@ioremap.net>
Message-ID: <alpine.DEB.2.00.0901131459001.22290@chino.kir.corp.google.com>
References: <20090112162938.GA22647@ioremap.net> <496BCB7A.2010804@tmr.com> <20090112231728.GA23803@ioremap.net> <alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com> <20090113085244.GA13796@ioremap.net> <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com>
 <20090113115408.GA22289@ioremap.net> <20090113121510.68a55fe9@lxorguk.ukuu.org.uk> <20090113122904.GC25011@ioremap.net> <alpine.DEB.2.00.0901131116220.8522@chino.kir.corp.google.com> <20090113214627.GC27227@ioremap.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.24.198.65
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009, Evgeniy Polyakov wrote:

> > Your patch simply allows users to specify a task by name that will always 
> > be killed first when the oom killer is invoked.  That's terribly 
> > insufficient if another task uses an excessive amount of memory that you 
> > didn't expect; a rogue task may be leaking memory and the task you've 
> > identified by name with your patch is repeatedly forked and killed when 
> > the rogue task goes untouched.
> 
> It is up to user to decide, exactly the same will happen if you tune the
> oom_adj for the task.
> 

It is up to the user to decide, using oom_adj scores as influence, how to 
define when a task should be selected by the oom killer.  Your 
name-parsing hack can do that for a single global task, but oom_adj scores 
are actually much more powerful.

> No, you can not. Did you try that? The only sane way to use oom_adj is
> to disable oom killer for the task or make its score very small or very
> big, there is really no way to make a finegrained tuning, since score
> changes and userspace does not know the algorithm.
> 

We finely tune oom_adj scores so that we get the desired results, yes.  
What you're complaining about here is purely a documentation issue.

> > Additionally, your patch completely breaks cpuset oom killing since 
> > candidacy is determined in badness() because a task may have allocated 
> > non-migrated memory elsewhere before being moved to a different cpuset.  
> > Your oom_victim_name task may exist globally, but will always be 
> > identified for oom kill even when the oom exists exclusively in a disjoint 
> > cpuset.  That does _not_ lead to future memory freeing that current can 
> > use, and if the parent of the killed task decides to immediately fork 
> > another instance, this cpuset will be completely livelocked. 
> 
> Please check the patch first. It selects process according to the
> badness, check memory group first and fallbacks to scan other processes
> if process with the given name was not found or name is null.
> 

Again, your patch _completely_ breaks cpuset oom killing.  That is a 
completely separate issue than the memory controller, and it's 
disappointing you still don't see it.

In a cpuset constrained oom condition, we do not explicitly exclude all 
tasks that are in a disjoint, exclusive cpuset since it's quite possible 
that a task has allocated memory outside its cpuset (either because its 
cpuset assignment has changed or because its cpuset's mems has changed) 
and killing it would free memory in current's cpuset.  We do, however, 
prefer to kill a task within the same cpuset; that preference is 
implemented in the badness() scoring.

If a task exists on the system in a disjoint, exclusive cpuset that 
matches oom_victim_name, your patch will cause it to be killed even though 
badness() has penalized it for not sharing a cpuset (dividing its score by 
eight).  That probably needlessly killed oom_victim_name since it won't 
allow for future memory freeing in the oom-triggering cpuset and the 
original oom condition persists.

Now if the parent of that task or another system task forks 
oom_victim_name again, the same thing will happen on the next iteration of 
the oom killer.  This will not free any memory in current's cpuset and it 
will effectively be livelocked.
