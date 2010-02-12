Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab0BLKFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 05:05:41 -0500
Received: from cantor.suse.de ([195.135.220.2]:53103 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab0BLKFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 05:05:39 -0500
Date: Fri, 12 Feb 2010 21:05:19 +1100
From: Nick Piggin <npiggin@suse.de>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com,
       thoss@de.ibm.com, hare@suse.de, gregkh@novell.com
Subject: Re: Performance regression in scsi sequential throughput (iozone)
 due to "e084b - page-allocator: preserve PFN ordering when	__GFP_COLD
 is set"
Message-ID: <20100212100519.GA29085@laptop>
References: <20091218174250.GC21194@csn.ul.ie>
 <4B4F0E60.1020601@linux.vnet.ibm.com>
 <20100119113306.GA23881@csn.ul.ie>
 <4B6C3E6E.6050303@linux.vnet.ibm.com>
 <20100205174917.GB11512@csn.ul.ie>
 <4B70192C.3070601@linux.vnet.ibm.com>
 <20100208152131.GC23680@csn.ul.ie>
 <4B7184B5.6040400@linux.vnet.ibm.com>
 <20100209175707.GB5098@csn.ul.ie>
 <4B742C2C.5080305@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B742C2C.5080305@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 05:11:24PM +0100, Christian Ehrhardt wrote:
> > 2. Test with the patch below rmqueue_bulk-fewer-parameters to see if the
> > 	number of parameters being passed is making some unexpected large
> > 	difference
> 
> BINGO - this definitely hit something.
> This experimental patch does two things - on one hand it closes the race we had:
> 
>                                                                 4 THREAD READ   8 THREAD READ    16 THREAD READ	    %ofcalls
> perf_count_congestion_wait                                         13              27                52
> perf_count_call_congestion_wait_from_alloc_pages_high_priority      0               0                 0	
> perf_count_call_congestion_wait_from_alloc_pages_slowpath          13              27                52              99.52%
> perf_count_pages_direct_reclaim                                 30867           56811            131552	
> perf_count_failed_pages_direct_reclaim                             14              24                52	
> perf_count_failed_pages_direct_reclaim_but_progress                14              21                52              0.04% !!!
> 
> On the other hand we see that the number of direct_reclaim calls increased by ~x4.
> 
> I assume (might be totally wrong) that the x4 increase of direct_reclaim calls could be caused by the fact that before we used higher orders which worked on x4 number of pages at once.

But the order parameter was always passed as constant 0 by the caller?

 
> This leaves me with two ideas what the real issue could be:
> 1. either really the 6th parameter as this is the first one that needs to go on stack and that way might open a race and rob gcc a big pile of optimization chances

It must be something to do wih code generation AFAIKS. I'm surprised
the function isn't inlined, giving exactly the same result regardless
of the patch.

Unlikely to be a correctness issue with code generation, but I'm
really surprised that a small difference in performance could have
such a big (and apparently repeatable) effect on behaviour like this.

What's the assembly look like?

