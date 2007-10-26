Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbXJZJYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbXJZJYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 05:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbXJZJYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 05:24:10 -0400
Received: from smtp-out.google.com ([216.239.33.17]:42548 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbXJZJYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 05:24:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=vjfEf+nOPuDbieE2W6su6xDFnMwkHHsU0JbdeSP+wWAcWhFiv+oE38eW83sFcSj21
	NNCOnzE0h+ZufBE29x/GQ==
Date: Fri, 26 Oct 2007 02:23:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: akpm@linux-foundation.org, ak@suse.de, clameter@sgi.com,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] cpusets: add memory_spread_user option
In-Reply-To: <20071025230409.81f20ed3.pj@sgi.com>
Message-ID: <alpine.DEB.0.9999.0710260204590.8261@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251912300.30400@chino.kir.corp.google.com> <alpine.DEB.0.9999.0710251913130.30400@chino.kir.corp.google.com> <alpine.DEB.0.9999.0710251913350.30400@chino.kir.corp.google.com> <20071025230409.81f20ed3.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007, Paul Jackson wrote:

> I'm figuring that when someone looks at the cpuset flag:
> 
> 	memory_spread_user
> 
> they will expect that turning it on will cause user space memory to be
> spread over the nodes of the cpuset.  Sure makes sense that it would
> mean that.
> 
> But, for the most part, it doesn't.  Only tasks that have
> previously called set_mempolicy(MPOL_INTERLEAVE), and only
> after the 'mems' of the cpuset are subsequently changed,
> will have their user memory forced to be spread across the
> cpuset as a result of this flag setting.
> 

And also tasks which are attached to a cpuset that has memory_spread_user 
enabled and had preexisting MPOL_INTERLEAVE memory policies.  
cpuset_attach() rebinds memory policies; if memory_spread_user is set, the 
the interleaved nodemask for the task's mempolicy will be set to the 
cpuset's mems_allowed.

> Any chance, David, that you could have this flag mean:
> 
>   	Spread user memory allocations over the cpuset,
> 	period, anytime it is set, regardless of what
> 	mempolicy calls the task has made and regardless
> 	of whether or not or when the cpusets 'mems' were
> 	last changed.
> 

This would override the custom mempolicies of all tasks attached to the 
cpuset.  All tasks would have MPOL_INTERLEAVE memory policies with a 
nodemask of the cpuset's mems_allowed and could not be changed.

With my current proposal, tasks receive the full interleaved nodemask of 
the cpuset's mems_allowed when they have preexisting MPOL_INTERLEAVE 
memory policies and:

 - the 'mems' change in a cpuset enabled with memory_spread_user,

 - it is attached to a cpuset enabled with memory_spread_user, or

 - memory_spread_page is enabled for its cpuset.

We respect the changes that tasks make to their mempolicies with 
MPOL_INTERLEAVE after any of those three scenarios.

Your change would force all tasks in a memory_spread_user cpuset to have 
MPOL_INTERLEAVE with a nodemask of mems_allowed.  That's very easy to 
define but is going to require additional cpusets to be created with 
duplicate settings (excluding memory_spread_user) if you want different 
behavior for its tasks.  I won't argue against that.

> Most power, or excessive confusion?  Straight forward consistency and
> simple predictability are far more important in almost all cases.  The
> usual exception is when you have a serious use case requiring
> something that can only be done in a more obscure fashion.
> 

I don't think cpuset files such as memory_spread_{page,slab,user} or 
memory_pressure, etc, are completely and accurately descriptive of what 
they do anyway.  That's why anybody who is going to use cpusets is going 
to refer to Documentation/cpusets.txt where the semantics are explicitly 
written.

> There is always a price paid for supporting such complexities in an API
> however, the price being increased confusion, frustration, errors and
> bugs on the part of most users of the API.
> 

We can certainly code it the way you suggested: memory_spread_user 
requires all tasks to be MPOL_INTERLEAVE with a static nodemask of 
mems_allowed.  If this use-case is so narrow that any sane implementation 
would never want several different tasks with different contextualized 
interleaved memory policies in a dynamically changing cpuset, that's the 
perfect way to code it.

> ... Now most likely you will claim you have such a use case, and when
> I ask for it, I will be frustrated at the lack of compelling detail of
> what is going on in user space - what sorts of users, apps and systems
> involved.  Ok, no biggie.  If this goes down that path, then perhaps
> at least I need to reconsider the name:
> 
> 	memory_spread_user
> 

I don't actually have any use-cases where I want two different 
MPOL_INTERLEAVE tasks sharing the same cpuset and only one of them 
adjusted on a mems change and the other to remain static unless I 
explicitly call set_mempolicy().

It all comes down to the decision of whether we want to permit 
set_mempolicy() calls for tasks and respect the nodemask passed in a 
memory_spread_user cpuset.  If so, we must do it my way where the 
set_mempolicy() occurs after attachment or the setting of the flag.  
There's just no other time where you can allow them to differ from the 
memory_spread_user behavior that the cpuset is configured with.

So if you don't have any issue with a hard and fast rule of requiring 
tasks in memory_spread_user cpusets to have MPOL_INTERLEAVE policies with 
the nodemask of mems_allowed and not giving them the option of changing 
it, I have no objection.  I simply coded it so that you could work around 
the cpuset flag through the mempolicy interface.  I don't have any express 
need for it.

		David
