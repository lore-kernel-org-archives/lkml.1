Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbZJ2JBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbZJ2JBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 05:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZJ2JBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 05:01:52 -0400
Received: from smtp-out.google.com ([216.239.45.13]:6323 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbZJ2JBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 05:01:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=T/4aSh0jdDRRJ0gM+icjarb0fhD6Q0lDfh+osuWZ8ODM/Wxh5lk+jMWhyAV2HQaSl
	F7y3wEDwJwSLzamfkiDyA==
Date: Thu, 29 Oct 2009 02:01:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Arcangeli <aarcange@redhat.com>, vedran.furac@gmail.com,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] oom_kill: use rss value instead of vm size for badness
In-Reply-To: <20091029174632.8110976c.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0910290156560.16347@chino.kir.corp.google.com>
References: <20091028175846.49a1d29c.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910280206430.7122@chino.kir.corp.google.com> <abbed627532b26d8d96990e2f95c02fc.squirrel@webmail-b.css.fujitsu.com> <20091029100042.973328d3.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.0910290125390.11476@chino.kir.corp.google.com> <20091029174632.8110976c.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009, KAMEZAWA Hiroyuki wrote:

> > This appears to actually prefer X more than total_vm in Vedran's test 
> > case.  He cited http://pastebin.com/f3f9674a0 in 
> > http://marc.info/?l=linux-kernel&m=125678557002888.
> > 
> > There are 12 ooms in this log, which has /proc/sys/vm/oom_dump_tasks 
> > enabled.  It shows the difference between the top total_vm candidates vs. 
> > the top rss candidates.
> > 
> > total_vm
> > 708945 test
> > 195695 krunner
> > 168881 plasma-desktop
> > 130567 ktorrent
> > 127081 knotify4
> > 125881 icedove-bin
> > 123036 akregator
> > 118641 kded4
> > 
> > rss
> > 707878 test
> > 42201 Xorg
> > 13300 icedove-bin
> > 10209 ktorrent
> > 9277 akregator
> > 8878 plasma-desktop
> > 7546 krunner
> > 4532 mysqld
> > 
> > This patch would pick the memory hogging task, "test", first everytime 
> > just like the current implementation does.  It would then prefer Xorg, 
> > icedove-bin, and ktorrent next as a starting point.
> > 
> > Admittedly, there are other heuristics that the oom killer uses to create 
> > a badness score.  But since this patch is only changing the baseline from 
> > mm->total_vm to get_mm_rss(mm), its behavior in this test case do not 
> > match the patch description.
> > 
> yes, then I wrote "as start point". There are many environments.

And this environment has a particularly bad result.

> But I'm not sure why ntpd can be the first candidate...
> The scores you shown doesn't include children's score, right ?
> 

Right, it's just the get_mm_rss(mm) for each thread shown in the oom dump, 
the same value you've used as the new baseline.  The actual badness scores 
could easily be calculated by cat'ing /proc/*/oom_score prior to oom, but 
this data was meant to illustrate the preference given the rss compared to 
total_vm in a heuristic sense.

> I believe I'll have to remove "adding child's score to parents".
> I'm now considering how to implement fork-bomb detector for removing it.
> 

Agreed, I'm looking forward to your proposal.

> ya, I'm now considering to drop file_rss from calculation.
> 
> some reasons.
> 
>   - file caches remaining in memory at OOM tend to have some trouble to remove it.
>   - file caches tend to be shared.
>   - if file caches are from shmem, we never be able to drop them if no swap/swapfull.
> 
> Maybe we'll have better result.
> 

That sounds more appropriate.

I'm surprised you still don't see a value in using the peak VM and RSS 
sizes, though, as part of your formula as it would indicate the proportion 
of memory resident in RAM at the time of oom.
