Return-Path: <linux-kernel-owner+w=401wt.eu-S1759391AbZANAx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbZANAx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 19:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbZANAxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 19:53:48 -0500
Received: from intermatrixgroup.ru ([195.178.208.66]:37407 "EHLO
	tservice.net.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbZANAxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 19:53:47 -0500
Date: Wed, 14 Jan 2009 03:53:45 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Rientjes <rientjes@google.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090114005345.GB1705@ioremap.net>
References: <20090113115408.GA22289@ioremap.net> <20090113121510.68a55fe9@lxorguk.ukuu.org.uk> <20090113122904.GC25011@ioremap.net> <alpine.DEB.2.00.0901131116220.8522@chino.kir.corp.google.com> <20090113214627.GC27227@ioremap.net> <alpine.DEB.2.00.0901131459001.22290@chino.kir.corp.google.com> <20090113233502.GA31490@ioremap.net> <alpine.DEB.2.00.0901131539050.30953@chino.kir.corp.google.com> <20090113235529.GB32190@ioremap.net> <alpine.DEB.2.00.0901131622530.25707@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901131622530.25707@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 04:32:41PM -0800, David Rientjes (rientjes@google.com) wrote:
> > Out of curiousity, how feature can be used, if no one except hardcore
> > kernel hackers know how to work with it? I do not insult, no, I'm really
> > curious. This may explain, why admins I worked with about this issue did
> > not fully succeeded with tuning.
> 
> You read the code.

Not the best solution actually and at least not the simplest :)

> You're treating each oom constraint like they are on the same; in a 
> cpuset-constrained oom, which can be much more common than system-wide 
> unconstrained ooms, we want to target a task that will allow for future 
> memory freeing in that cpuset.

I do not break the way oom problem is addressed currently. I just
extend it from the different angle, which can not be resolved in some
cases. Those who do not need the feature, can safely disable the check
and rely on the old algorithms.

What you are talking here is a different problem. Completely different
case. We may have the problem case you described, and we will think on
how to resolve the issue, but approach used in the patch does not
enforce the new policy, it extends it adding new global tunable.

> So in these cases, to avoid needlessly killing your victim, you would be 
> forced to set oom_victim_name to NULL.  That's hardly useful if the same 
> problem you're trying to fix still exists both globally and within a 
> cpuset.  Your patch doesn't address this use case, so it's already 
> incomplete.

Incorrect point of view. If administrator wants to select victim task by
name, this patch allows this. If he does not want this, it is turned
off. There are perfectly split areas where each approach applies: global
name-based selection and more specific to the areas where problem
arises.

> In a mempolicy-constrained oom as the result of MPOL_BIND, which can also 
> be much more common than system-wide unconstrained ooms, we want to target 
> current because it has allocations from the bound nodes.  Your patch 
> doesn't touch this path, so it's already inconsistent.

And again wrong conclusion: patch is intended to work in the area it was
created for. It is the simplest (and the only btw) solution for the showed
problem. In the systems where it is not needed, it will not be used and
old algorithms will work fine, apparently since no one proposed it
before, other areas work ok without it. While the problem (quite common
actually) I showed was not addressed at all and all proposed solutions
just failed if we start checking requrements more precisely.

> I'm comfortable that this patch will not be merged, so I'll silently point 
> to past posts for the duration of this thread.  I definitely think the 
> documentation can be improved and I don't think you'll have any opposition 
> to sane heuristic changes that also rely on userspace input via 
> /proc/pid/oom_adj.  Thank you for working on this!

So you agree that no existing solution can solve the oom problem when
parent task has to stay and children have to be differentiated. And
agree that not merging the solution for this commonly happened problem
is the right way. And while we can reread the whole thread multiple
times, we will find again and again that proposed approaches do not
work. This patch does its simple task without breaking others and in the
systems where this feature is not needed, it can be safely turned off,
while still fixing the problem for those who care.

I will update documentation tomorrow if there will be no patches.

-- 
	Evgeniy Polyakov
