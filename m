Return-Path: <linux-kernel-owner+w=401wt.eu-S1759863AbZANAdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759863AbZANAdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 19:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbZANAdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 19:33:00 -0500
Received: from smtp-out.google.com ([216.239.45.13]:5641 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022AbZANAc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 19:32:59 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=HYOOPckm1nlrFw1WLvNK1grNn1DT3AvNRebeI4IFNiI6BCrBuBVdTondoPPZ8uR0r
	zmrjvfvvas1nunghOo8iA==
Date: Tue, 13 Jan 2009 16:32:41 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Evgeniy Polyakov <zbr@ioremap.net>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
In-Reply-To: <20090113235529.GB32190@ioremap.net>
Message-ID: <alpine.DEB.2.00.0901131622530.25707@chino.kir.corp.google.com>
References: <20090113085244.GA13796@ioremap.net> <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com> <20090113115408.GA22289@ioremap.net> <20090113121510.68a55fe9@lxorguk.ukuu.org.uk> <20090113122904.GC25011@ioremap.net>
 <alpine.DEB.2.00.0901131116220.8522@chino.kir.corp.google.com> <20090113214627.GC27227@ioremap.net> <alpine.DEB.2.00.0901131459001.22290@chino.kir.corp.google.com> <20090113233502.GA31490@ioremap.net> <alpine.DEB.2.00.0901131539050.30953@chino.kir.corp.google.com>
 <20090113235529.GB32190@ioremap.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.28.16.146
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009, Evgeniy Polyakov wrote:

> Out of curiousity, how feature can be used, if no one except hardcore
> kernel hackers know how to work with it? I do not insult, no, I'm really
> curious. This may explain, why admins I worked with about this issue did
> not fully succeeded with tuning.
> 

You read the code.

It's always great to improve the documentation of a kernel feature, and I 
agree that it certainly applies in this case.

I think you could also improve how the badness() scoring is implemented to 
make it easier to predict from userspace.  I doubt you would find much 
opposition to improving the heuristic; we cannot, however, change 
/proc/pid/oom_adj since it already has users who depend on it.

> > Being ignorant about cpusets doesn't justify you breaking their oom 
> > handling.
> 
> I did not break cpuset oom-handling, I provided a way to implement it
> differently to solve the problem. Yes, this may have side effects, if
> people care, they will not use the feature and leave victim name as NULL
> (although allowing Kenny to live breaks the absolute fundamentals).
> Those people who do need this functionality will work with it.
> 

You're treating each oom constraint like they are on the same; in a 
cpuset-constrained oom, which can be much more common than system-wide 
unconstrained ooms, we want to target a task that will allow for future 
memory freeing in that cpuset.

So in these cases, to avoid needlessly killing your victim, you would be 
forced to set oom_victim_name to NULL.  That's hardly useful if the same 
problem you're trying to fix still exists both globally and within a 
cpuset.  Your patch doesn't address this use case, so it's already 
incomplete.

In a mempolicy-constrained oom as the result of MPOL_BIND, which can also 
be much more common than system-wide unconstrained ooms, we want to target 
current because it has allocations from the bound nodes.  Your patch 
doesn't touch this path, so it's already inconsistent.

I'm comfortable that this patch will not be merged, so I'll silently point 
to past posts for the duration of this thread.  I definitely think the 
documentation can be improved and I don't think you'll have any opposition 
to sane heuristic changes that also rely on userspace input via 
/proc/pid/oom_adj.  Thank you for working on this!
