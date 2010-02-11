Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab0BKWmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 17:42:47 -0500
Received: from smtp-out.google.com ([216.239.44.51]:58275 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab0BKWmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 17:42:45 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=LgmltZ3bTI7b16JtodJV5Zom05Fp+MbECx6GcfIqG2OA2ssJLDTnAkpkudrJphGqo
	mccqhHlT1fsRiEOAEncCA==
Date: Thu, 11 Feb 2010 14:42:39 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 4/7 -mm] oom: badness heuristic rewrite
In-Reply-To: <20100211143105.dea3861a.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1002111437060.21107@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com> <alpine.DEB.2.00.1002100228540.8001@chino.kir.corp.google.com> <4B73833D.5070008@redhat.com> <alpine.DEB.2.00.1002102332200.22152@chino.kir.corp.google.com>
 <20100211134343.4886499c.akpm@linux-foundation.org> <alpine.DEB.2.00.1002111346050.8809@chino.kir.corp.google.com> <20100211143105.dea3861a.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010, Andrew Morton wrote:

> > Sigh, this is going to require the amount of system memory to be 
> > partitioned into OOM_ADJUST_MAX, 15, chunks and that's going to be the 
> > granularity at which we'll be able to either bias or discount memory usage 
> > of individual tasks by: instead of being able to do this with 0.1% 
> > granularity we'll now be limited to 100 / 15, or ~7%.  That's ~9GB on my 
> > 128GB system just because this was originally a bitshift.  The upside is 
> > that it's now linear and not exponential.
> 
> Can you add newly-named knobs (rather than modifying the existing
> ones), deprecate the old ones and then massage writes to the old ones
> so that they talk into the new framework?
> 

That's what I was thinking, add /proc/pid/oom_score_adj that is just added 
into the badness score (and is then exported with /proc/pid/oom_score) 
like this patch did with oom_adj and then scale it into oom_adj units for 
that tunable.  A write to either oom_adj or oom_score_adj would change the 
other, the same thing I did for /proc/sys/vm/dirty_{bytes,ratio} and
/proc/sys/vm/dirty_background_{bytes,ratio} which I guess we have to 
support forever since the predecessors are part of the ABI and there's no 
way to deprecate them since they'll never be removed for that reason.
