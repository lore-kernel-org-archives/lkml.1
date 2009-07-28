Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbZG1WsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbZG1WsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 18:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbZG1WsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 18:48:22 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:27405 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799AbZG1WsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 18:48:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AoRxQh81ITHM4bt0IxwopzKaDvxRuj0BdAdPpEpIdZ3qtSx1nbgpSY8qwvczUc0OuJ
         nVCfzf0ssVvWHz/ijpT+5cHww0fQAOXsO2L2qigq0hKKf4KJmulVu1/YODXQaLWDmlIl
         SPoE4MC09uAmlF/11zsLzvAxcnkGoP1auk0yQ=
Date: Wed, 29 Jul 2009 00:48:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] Add some trace events for the page allocator
Message-ID: <20090728224805.GB5104@nowhere>
References: <1248819819-14931-1-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248819819-14931-1-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 11:23:36PM +0100, Mel Gorman wrote:
> The following three patches add some trace events for the page allocator under
> the heading of kmem (should there be a pagealloc heading instead?). Testing
> under qemu seems to show up reasonable results but this is a prototype for
> comment that hasn't been very heavily tested. I was able to find at least
> one anomaly looking a the output in relation to anti-fragmentation which
> I'm still thinking about so minimally, it was useful for that but I've made
> an attempt to justify each of the events added.
> 
> The patches are as follows
> 
> 	Patch 1 adds events for plain old allocate and freeing of pages
> 	Patch 2 gives information useful for analysing fragmentation avoidance
> 	Patch 3 tracks pages going to and from the buddy lists as an indirect
> 		indication of zone lock hotness
> 
> The first one could be used as an indicator as to whether the workload was
> heavily dependant on the page allocator or not. You can make a guess based
> on vmstat but you can't get a per-process breakdown. I did have trouble with
> the call-site portion of the allocation. Depending on the path, you might
> just get the address of __get_free_pages() instead of a useful callsite. I
> didn't see a nice way to always report a "useful" call_site.
> 
> The second patch would mainly be useful for users of hugepages and
> particularly dynamic hugepage pool resizing as it could be used to tune
> min_free_kbytes to a level that fragmentation was rarely a problem. My
> main concern is that maybe I'm trying to jam too much into the TP_printk
> that could be extrapolated after the fact if you were familiar with the
> implementation. I couldn't determine if it was best to hold the hand of
> the administrator even if it cost more to figure it out.
> 
> The last patch is trickier to draw conclusions from but high activity on
> those events could explain why there were a large number of cache misses
> on a page-allocator-intensive workload. The coalescing and splitting of
> buddies involves a lot of writing of page metadata and cache line bounces
> not to mention the acquisition of an interrupt-safe lock necessary to enter
> this path. One problem is that one function traced is likely to change its
> name in the future.  When that happens, the trace event will be replaced
> with something similar, but not identical. I've been told this is probably
> ok but there has been whinging in the past about whether debugfs represents
> an ABI or not.
> 
> This is the first time I've looked at adding trace events so apologies
> for any obvious mistakes made as I haven't been keeping a close eye on all
> the tracing discussions describing How Things Should Be Done. checkpatch
> throws major wobblies about this patchset, but it's consistent with the
> style of other events so I ignored it. The "To:" list is based taken from
> another tracepoint mail, if there is a specific list I should have used,
> feel free to slap with clue stick. All comments indicating whether this is
> generally useful and how it might be improved are welcome.


(Adding some other tracing + slab allocator/kmemtrace people in Cc)

