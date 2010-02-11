Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab0BKVvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 16:51:47 -0500
Received: from smtp-out.google.com ([216.239.44.51]:41507 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757131Ab0BKVvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 16:51:45 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=SvbLv/NTkjSMTTK6+urX7Y1bvMMlWEGganYh7+ZlLfv+OODmWRG80PBAjMoCduq1s
	QPU62cu9W3nLPpcjbq2YA==
Date: Thu, 11 Feb 2010 13:51:36 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 4/7 -mm] oom: badness heuristic rewrite
In-Reply-To: <20100211134343.4886499c.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1002111346050.8809@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com> <alpine.DEB.2.00.1002100228540.8001@chino.kir.corp.google.com> <4B73833D.5070008@redhat.com> <alpine.DEB.2.00.1002102332200.22152@chino.kir.corp.google.com>
 <20100211134343.4886499c.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010, Andrew Morton wrote:

> > Changing any value that may have a tendency to be hardcoded elsewhere is 
> > always controversial, but I think the nature of /proc/pid/oom_adj allows 
> > us to do so for two specific reasons:
> > 
> >  - hardcoded values tend not the fall within a range, they tend to either
> >    always prefer a certain task for oom kill first or disable oom killing
> >    entirely.  The current implementation uses this as a bitshift on a
> >    seemingly unpredictable and unscientific heuristic that is very 
> >    difficult to predict at runtime.  This means that fewer and fewer
> >    applications would hardcode a value of '8', for example, because its 
> >    semantics depends entirely on RAM capacity of the system to begin with
> >    since badness() scores are only useful when used in comparison with
> >    other tasks.
> 
> You'd be amazed what dumb things applications do.  Get thee to
> http://google.com/codesearch?hl=en&lr=&q=[^a-z]oom_adj[^a-z]&sbtn=Search
> and start reading.  All 641 matches ;)
> 
> Here's one which which writes -16:
> http://google.com/codesearch/p?hl=en#eN5TNOm7KtI/trunk/wlan/vendor/asus/eeepc/init.rc&q=[^a-z]oom_adj[^a-z]&sa=N&cd=70&ct=rc
> 
> Let's not change the ABI please.
> 

Sigh, this is going to require the amount of system memory to be 
partitioned into OOM_ADJUST_MAX, 15, chunks and that's going to be the 
granularity at which we'll be able to either bias or discount memory usage 
of individual tasks by: instead of being able to do this with 0.1% 
granularity we'll now be limited to 100 / 15, or ~7%.  That's ~9GB on my 
128GB system just because this was originally a bitshift.  The upside is 
that it's now linear and not exponential.
