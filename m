Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbZLRKFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbZLRKFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 05:05:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbZLRKFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 05:05:08 -0500
Received: from smtp-out.google.com ([216.239.44.51]:35475 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbZLRKFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 05:05:06 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=g+0PzuKy51y3Dlmle40w7EUy2RrUPcGckorPRvB6zZl9Yaaq3WD5iSYXJkDVIFc9+
	Q7zlfrFaM6kwEKn1mSEeA==
Date: Fri, 18 Dec 2009 02:04:52 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] oom-kill: fix NUMA consraint check with nodemask
 v4.2
In-Reply-To: <20091218094359.652F.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0912180158040.26019@chino.kir.corp.google.com>
References: <20091215135902.CDD6.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0912171412280.4089@chino.kir.corp.google.com> <20091218094359.652F.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009, KOSAKI Motohiro wrote:

> > That is contrast to using rss as a baseline where we prefer on killing the 
> > application with the most resident RAM.  It is not always ideal to kill a 
> > task with 8GB of rss when we fail to allocate a single page for a low 
> > priority task.
> 
> VSZ has the same problem if low priority task allocate last single page.
> 

I don't understand what you're trying to say, sorry.  Why, in your mind, 
do we always want to prefer to kill the application with the largest 
amount of memory present in physical RAM for a single, failed order-0 
allocation attempt from a lower priority task?

Additionally, when would it be sufficient to simply fail a ~__GFP_NOFAIL 
allocation instead of killing anything?

> yes, possible. however its heuristic is intensional. the code comment says:
> 
>         /*
>          * If p's nodes don't overlap ours, it may still help to kill p
>          * because p may have allocated or otherwise mapped memory on
>          * this node before. However it will be less likely.
>          */
> 
> do you have alternative plan? How do we know the task don't have any
> page in memory busted node? we can't add any statistics for oom because
> almost systems never ever use oom. thus, many developer oppose such slowdown.
> 

There's nothing wrong with that currently (except it doesn't work for 
mempolicies), I'm stating that it is a requirement that we keep such a 
penalization in our heuristic if we plan on rewriting it.  I was 
attempting to get a list of requirements for oom killing decisions so that 
we can write a sane heuristic and you're simply defending the status quo 
which you insist we should change.

> > We need to be able to polarize tasks so they are always killed regardless 
> > of any kernel heuristic (/proc/pid/oom_adj of +15, currently) or always 
> > chosen last (-16, currently).  We also need a way of completely disabling 
> > oom killing for certain tasks such as with OOM_DISABLE.
> 
> afaik, when admin use +15 or -16 adjustment, usually they hope to don't use
> kernel heuristic.

That's exactly what I said above.

> This is the reason that I proposed /proc/pid/oom_priority
> new tunable knob.
> 

In addition to /proc/pid/oom_adj??  oom_priority on it's own does not 
allow us to define when a task is a memory leaker based on the expected 
memory consumption of a single application.  That should be the single 
biggest consideration in the new badness heuristic: to define when a task 
should be killed because it is rogue.
