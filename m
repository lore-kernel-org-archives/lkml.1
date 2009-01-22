Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbZAVVgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbZAVVgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 16:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZAVVf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 16:35:59 -0500
Received: from smtp-out.google.com ([216.239.33.17]:6956 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbZAVVf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 16:35:58 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=K9xNExpcz5oylmyYnizC/571Iu4yG5lv73dlrlf5YzTgeYIm1VBU95KxPu69+UryI
	uLBjtiCdg88gElLsxZM2A==
Date: Thu, 22 Jan 2009 13:35:13 -0800 (PST)
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
In-Reply-To: <20090122210613.GA10158@ioremap.net>
Message-ID: <alpine.DEB.2.00.0901221314010.6145@chino.kir.corp.google.com>
References: <200901212054.34929.knikanth@suse.de> <alpine.DEB.2.00.0901211241040.21080@chino.kir.corp.google.com> <200901221042.30957.knikanth@suse.de> <alpine.DEB.2.00.0901220036440.28850@chino.kir.corp.google.com> <20090122095026.GA10579@ioremap.net>
 <alpine.DEB.2.00.0901220156310.1738@chino.kir.corp.google.com> <20090122101424.GA12317@ioremap.net> <alpine.DEB.2.00.0901220218120.2851@chino.kir.corp.google.com> <20090122132133.GA17524@ioremap.net> <alpine.DEB.2.00.0901221216330.2085@chino.kir.corp.google.com>
 <20090122210613.GA10158@ioremap.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.28.16.141
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2009, Evgeniy Polyakov wrote:

> Only the fact that cpusets have _very_ special meaning in the oom-killer
> codepath, while it should be just another tunable (if it should be
> special code at all at the first place, why there were no objection and
> argument, that tasks could have different oom_adj?).
> 

That's because the oom killer needs to kill a task that will allow future 
memory freeing on current->mems_allowed in these cases.  Appropriate 
oom_adj scores can override that preference, it's up to the administrator.

> > The oom.victim priority may well be valid for a system-wide condition 
> > where a specific aggregate of tasks are less critical than others and 
> > would be preferred to be killed.  But that doesn't help in a 
> > cpuset-constrained oom on the same machine if it doesn't lead to future 
> > memory freeing.
> 
> And that is The Main Point. Not to help some subsystem, but be useful
> for others. It is different tunable. It has really nothing with cpusets.

It doesn't work with any system that is running with cpusets, that's the 
problem with accepting such code.  There needs to be clear and convincing 
evidence that a userspace oom notifier, which could handle all possible 
cases and is much more robust and flexible, would not suffice for such 
situations.

> Then do not use anything else when cpusets are enabled.
> Do not compile SuperH cpu support when you do not have such processes.
> Do not enable iscsi support if you do not need this.
> Do not enable cgroup oom-killer tunable when you want cpuset.
> 

How do I prioritize oom killing if my system is running cpusets, then?  
Your answer is that I can't, since this new cgroup doesn't work with them; 
so this solution is incomplete.  The oom killer notification patch[*] is 
much more functional and does allow this problem to be solved on all types 
of systems because the implementation of such a handler is left to the 
administrator.

 [*] http://marc.info/?l=linux-mm&m=122575082227252

> Please explain, how task will make that decision (like freeing some
> ram), when it can not be even swapped out? It is a great idea to be able
> to monitor memory usage, but relying on that just does not work.
> 

The userspace handler is a schedulable task resident in memory that, with 
any sane implementation, would not require additional memory when running.

> > This is completely and utterly wrong.  If you had read the code 
> > thoroughly, you would see that the page allocation is deferred until 
> > userspace has the opportunity to respond.  That time in deferral isn't 
> > absurd, it would take time for the oom killer's exiting task to free 
> > memory anyway.  The change simply allows a delay between a page 
> > allocation failure and invoking the oom killer.
> > 
> > It will even work on UP systems since the page allocator has multiple 
> > reschedule points where a dedicated or monitoring application attached to 
> > the cgroup could add or free memory itself so the allocation succeeds when 
> > current is rescheduled.
> 
> Yup, it will wait for some timeout while userspace will respond. The
> problem is that it will not in some cases. And so far I think (and I may
> be wrong), that it will not be able to respond most of the time.
> 

We've used it quite successfully for over a year, so your hypothesis in 
this case may be less than accurate.

> In every oom-condition I worked with, system was completely unusable
> before oom-killer started to berserk several processes. They were not
> able to allocate some data to read network input (atomic context) and to
> even read a console input.
> 

If your system failed to allocate GFP_ATOMIC memory, then those are page 
allocation failures in the buddy allocator and will actually never invoke 
the oom killer since it cannot sleep in that context.
