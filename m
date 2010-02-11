Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab0BKXbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:31:22 -0500
Received: from smtp-out.google.com ([216.239.44.51]:11517 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab0BKXbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:31:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=tVJnkgGpkYSCaKwwOj6pO0hy+E4V1D0I7BOQtnGMtwhaUtZduFJwMLC161bqu6f82
	wFhyJk2dz4unyK9PW1XBA==
Date: Thu, 11 Feb 2010 15:31:14 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 4/7 -mm] oom: badness heuristic rewrite
In-Reply-To: <20100211151135.91586cd1.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1002111524470.4438@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com> <alpine.DEB.2.00.1002100228540.8001@chino.kir.corp.google.com> <4B73833D.5070008@redhat.com> <alpine.DEB.2.00.1002102332200.22152@chino.kir.corp.google.com>
 <20100211134343.4886499c.akpm@linux-foundation.org> <alpine.DEB.2.00.1002111346050.8809@chino.kir.corp.google.com> <20100211143105.dea3861a.akpm@linux-foundation.org> <alpine.DEB.2.00.1002111437060.21107@chino.kir.corp.google.com>
 <20100211151135.91586cd1.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010, Andrew Morton wrote:

> > > > Sigh, this is going to require the amount of system memory to be 
> > > > partitioned into OOM_ADJUST_MAX, 15, chunks and that's going to be the 
> > > > granularity at which we'll be able to either bias or discount memory usage 
> > > > of individual tasks by: instead of being able to do this with 0.1% 
> > > > granularity we'll now be limited to 100 / 15, or ~7%.  That's ~9GB on my 
> > > > 128GB system just because this was originally a bitshift.  The upside is 
> > > > that it's now linear and not exponential.
> > > 
> > > Can you add newly-named knobs (rather than modifying the existing
> > > ones), deprecate the old ones and then massage writes to the old ones
> > > so that they talk into the new framework?
> > > 
> > 
> > That's what I was thinking, add /proc/pid/oom_score_adj that is just added 
> > into the badness score (and is then exported with /proc/pid/oom_score) 
> > like this patch did with oom_adj and then scale it into oom_adj units for 
> > that tunable.  A write to either oom_adj or oom_score_adj would change the 
> > other,
> 
> How ugly is all this?
> 

The advantages outweigh the disadvantages, users need to be able to 
specify how much memory vital tasks should be able to use compared to 
others without getting penalized and that needs to be done as a fraction 
of available memory.  I wanted to avoid it originally by not having to 
introduce another tunable, but I understand the need for a stable ABI and 
backwards compatability.  The way /proc/pid/oom_adj currently works as a 
bitshift on the badness score is nearly impossible to tune correctly so  
change in scoring is inevitable.  Luckily, users who tune either can 
ignore the other until such time as oom_adj can be removed.

> There _are_ things we can do though.  Detect a write to the old file and
> emit a WARN_ON_ONCE("you suck").  Wait a year, turn it into
> WARN_ON("you really suck").  Wait a year, then remove it.
> 

Ok, I'll use WARN_ON_ONCE() to let the user know of the deprecation and 
then add an entry to Documentation/feature-removal-schedule.txt.
