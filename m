Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363Ab0A1BAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab0A1BAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 20:00:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243Ab0A1BAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 20:00:01 -0500
Received: from smtp-out.google.com ([216.239.33.17]:50789 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab0A1BAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 20:00:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=IrKV40OBSx7BYp9cnR/6Ofmhe6a7Yv1bjYCwLPAp5vMygOiWnGOfiM5LDLINEdu9v
	Vnp+IxAwbUO9BKMlv0gUQ==
Date: Wed, 27 Jan 2010 16:59:52 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       minchan.kim@gmail.com, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
In-Reply-To: <20100128001636.2026a6bc@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.2.00.1001271652270.17513@chino.kir.corp.google.com>
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com> <20100122152332.750f50d9.kamezawa.hiroyu@jp.fujitsu.com> <20100125151503.49060e74.kamezawa.hiroyu@jp.fujitsu.com> <20100126151202.75bd9347.akpm@linux-foundation.org>
 <20100127085355.f5306e78.kamezawa.hiroyu@jp.fujitsu.com> <20100126161952.ee267d1c.akpm@linux-foundation.org> <20100127095812.d7493a8f.kamezawa.hiroyu@jp.fujitsu.com> <20100128001636.2026a6bc@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jan 2010, Alan Cox wrote:

> > Now, /proc/<pid>/oom_score and /proc/<pid>/oom_adj are used by servers.
> 
> And embedded, and some desktops (including some neat experimental hacks
> where windows slowly get to be bigger bigger oom targes the longer
> they've been non-focussed)
> 

Right, oom_adj is used much more widely than described.

> I can't help feeling this is the wrong approach. IFF we are running out
> of low memory pages then killing stuff for that reason is wrong to begin
> with except in extreme cases and those extreme cases are probably also
> cases the kill won't help.
> 
> If we have a movable user page (even an mlocked one) then if there is
> space in other parts of memory (ie the OOM is due to a single zone
> problem) we should *never* be killing in the first place, we should be
> moving the page. The mlock case is a bit hairy but the non mlock case is
> exactly the same sequence of operations as a page out and page in
> somewhere else skipping the widdling on the disk bit in the middle.
> 

Mel Gorman's memory compaction patchset will preempt direct reclaim and 
the oom killer if it can defragment zones by page migration such that a 
higher order allocation would now succeed.

In this specific context, both compaction and direct reclaim will have 
failed so the oom killer is the only alternative.  For __GFP_NOFAIL, 
that's required.  However, there has been some long-standing debate (and 
not only for lowmem, but for all oom conditions) about when the page 
allocator should simply return NULL.  We've always killed something on 
blocking allocations to favor current at the expense of other memory hogs, 
but that may be changed soon: it may make sense to defer oom killing 
completely unless the badness() score reaches a certain threshold such 
that memory leakers really can be dealt with accordingly.

In the lowmem case, it certainly seems plausible to use the same behavior 
that we currently do for mempolicy-constrained ooms: kill current.
