Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbZDFTFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbZDFTFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 15:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbZDFTF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 15:05:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:37368 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbZDFTF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 15:05:28 -0400
Subject: Re: [PATCH 5/6] perf_counter: add more context information
From: Peter Zijlstra <peterz@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <49DA4FA0.6090902@linux.vnet.ibm.com>
References: <20090402091158.291810516@chello.nl>
	 <20090402091319.493101305@chello.nl> <1238763023.798.27.camel@twins>
	 <49D654AB.4030207@linux.vnet.ibm.com>  <1239015668.798.4243.camel@twins>
	 <1239016035.798.4254.camel@twins>  <49DA4FA0.6090902@linux.vnet.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 06 Apr 2009 21:06:58 +0200
Message-Id: <1239044818.798.4775.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-06 at 11:53 -0700, Corey Ashford wrote:
> 
> Peter Zijlstra wrote:
> > On Mon, 2009-04-06 at 13:01 +0200, Peter Zijlstra wrote:
> >> On Fri, 2009-04-03 at 11:25 -0700, Corey Ashford wrote:
> >>> Peter Zijlstra wrote:
> >>>> On Thu, 2009-04-02 at 11:12 +0200, Peter Zijlstra wrote:
> >>>>> plain text document attachment (perf_counter_callchain_context.patch)
> >>>>> Put in counts to tell which ips belong to what context.
> >>>>>
> >>>>>   -----
> >>>>>    | |  hv
> >>>>>    | --
> >>>>> nr | |  kernel
> >>>>>    | --
> >>>>>    | |  user
> >>>>>   -----
> >>>> Right, just realized that PERF_RECORD_IP needs something similar if one
> >>>> if not able to derive the context from the IP itself..
> >>>>
> >>> Three individual bits would suffice, or you could use a two-bit code -
> >>> 00 = user
> >>> 01 = kernel
> >>> 10 = hypervisor
> >>> 11 = reserved (or perhaps unknown)
> >>>
> >>> Unfortunately, because of alignment, it would need to take up another 64 
> >>> bit word, wouldn't it?  Too bad you cannot sneak the bits into the IP in 
> >>> a machine independent way.
> >>>
> >>> And since you probably need a separate word, that effectively doubles 
> >>> the amount of space taken up by IP samples (if we add a "no event 
> >>> header" option).  Should we add another bit in the record_type field - 
> >>> PERF_RECORD_IP_LEVEL (or similar) so that user-space apps don't have to 
> >>> get this if they don't need it?
> >> If we limit the event size to 64k (surely enough, right? :-), then we
> >> have 16 more bits to play with in the header, and we could do something
> >> like the below.
> >>
> >> A further possibility would also be to add an overflow bit in there,
> >> making the full 32bit PERF_RECORD space available to output events as
> >> well.
> >>
> >> Index: linux-2.6/include/linux/perf_counter.h
> >> ===================================================================
> >> --- linux-2.6.orig/include/linux/perf_counter.h
> >> +++ linux-2.6/include/linux/perf_counter.h
> >> @@ -201,9 +201,17 @@ struct perf_counter_mmap_page {
> >>  	__u32   data_head;		/* head in the data section */
> >>  };
> >>  
> >> +enum {
> >> +	PERF_EVENT_LEVEL_HV	= 0,
> >> +	PERF_EVENT_LEVEL_KERNEL = 1,
> >> +	PERF_EVENT_LEVEL_USER	= 2,
> >> +};
> >> +
> >>  struct perf_event_header {
> >>  	__u32	type;
> >> -	__u32	size;
> >> +	__u16	level		:  2,
> >> +		__reserved	: 14;
> >> +	__u16	size;
> >>  };
> > 
> > Except we should probably use masks again instead of bitfields so that
> > the thing is portable when streamed to disk, such as would be common
> > with splice().
> 
> One downside of this approach is that you if you specify "no header" 
> (currently not possible, but maybe later?), you will not be able to get 
> the level bits.

Would this be desirable? I know we've mentioned it before, but it would
mean one cannot mix various event types (currently that means !mmap and
callchain with difficulty).

As long as we mandate this header, we can have 16 misc bits.

> How about adding an optional, 64-bit "miscellaneous" word to the event 
> record which could contain a number of small bit fields, any or all of 
> which could be enabled with a PERF_RECORD_* bit.  If one or more of the 
> miscellaneous PERF_RECORD_* bits are set to enable, this assembled word 
> would be added to the record.  So the space cost of the level field goes 
> down as we add more small fields that need to be recorded.
> 
> Something like:
> 
>   PERF_RECORD_LEVEL = 1U << 4,
>   PERF_RECORD_INTR_DEPTH = 1U << 5,
>   PERF_RECORD_STUFF = 1U << 6,
>   ...
> 
> #define __PERF_MISC_MASK(name)                       \
>          (((1ULL << PERF_MISC_##name##_BITS) - 1) <<  \
>           PERF_MISC_##name##_SHIFT)
> 
> #define PERF_MISC_LEVEL_BITS 2
> #define PERF_MISC_LEVEL_SHIFT 0
> #define PERF_MISC_LEVEL_MASK __PERF_MISC_MASK(LEVEL)
> 
> #define PERF_MISC_INTR_DEPTH_BITS 8
> #define PERF_MISC_INTR_DEPTH_SHIFT 2
> #define PERF_MISC_INTR_DEPTH_MASK __PERF_MISC_MASK(INTR_DEPTH)

Yeah, that's the alternative.
