Return-Path: <linux-kernel-owner+w=401wt.eu-S1757079AbZF3UvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbZF3UvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 16:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbZF3UvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 16:51:15 -0400
Received: from smtp-out.google.com ([216.239.33.17]:61440 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbZF3UvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 16:51:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=oP6LSNYJo1HKnYIGaYSlLuwFL4FKuLr0P7KkV0K4Iecw1g/49n514STZGHKiyCQYX
	R+qzZ2lUl/MZeSBRRMm8A==
Date: Tue, 30 Jun 2009 13:51:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, arjan@infradead.org,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <20090630203249.GC6689@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.0906301339290.22084@chino.kir.corp.google.com>
References: <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org>
 <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <20090624145615.2ff9e56e.akpm@linux-foundation.org> <20090629153007.GD5065@csn.ul.ie> <20090629122029.93cdcc39.akpm@linux-foundation.org> <20090630110011.GB17561@csn.ul.ie>
 <alpine.DEB.2.00.0906301216180.16312@chino.kir.corp.google.com> <20090630203249.GC6689@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009, Mel Gorman wrote:

> > This will panic the machine if current is the only user thread running or 
> > eligible for oom kill (all others could have mm's with OOM_DISABLE set).  
> > Currently, such tasks can exit or kthreads can free memory so that the oom 
> > is recoverable.
> > 
> 
> Good point, would the following be ok instead?
> 
> +           if (test_tsk_thread_flag(p, TIF_MEMDIE)) {
> +                   if (p == current) {
> +			    chosen = ERR_PTR(-1UL);
> +                           continue;
> +                   } else
> +                           return ERR_PTR(-1UL);
> 

Yes, if you wanted to allow multiple threads to have TIF_MEMDIE set.

> > The problem with this approach is that it increases the liklihood that 
> > memory reserves will be totally depleted when several threads are 
> > competing for them.
> > 
> 
> How so? 
> 

We automatically oom kill current if it's PF_EXITING to give it TIF_MEMDIE 
because we know it's on the exit path, this avoids allowing them to 
allocate below the min watermark for the allocation that triggered the 
oom, which could be significant.

If several threads are ooming at the same time, which happens quite often 
for non-cpuset and non-memcg constrained ooms (and those not restricted to 
lowmem), we could now potentially have nr_cpus threads with TIF_MEMDIE set 
simultaneously, which increases the liklihood that memory reserves will be 
fully depleted after each allocation that triggered the oom killer now 
succeeds because of ALLOC_NO_WATERMARKS.  This is somewhat mitigated by 
the oom killer serialization done on the zonelist, but nothing guarantees 
that reserves aren't empty before one of the threads has detached its 
->mm.

oom_kill_task() SIGKILLs threads sharing ->mm with different tgid's 
instead of giving them access to memory reserves specifically to avoid 
this.
