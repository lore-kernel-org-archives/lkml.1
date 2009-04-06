Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbZDFLGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbZDFLGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 07:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbZDFLFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 07:05:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53158 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbZDFLFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 07:05:47 -0400
Subject: Re: [PATCH 5/6] perf_counter: add more context information
From: Peter Zijlstra <peterz@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1239015668.798.4243.camel@twins>
References: <20090402091158.291810516@chello.nl>
	 <20090402091319.493101305@chello.nl> <1238763023.798.27.camel@twins>
	 <49D654AB.4030207@linux.vnet.ibm.com>  <1239015668.798.4243.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 06 Apr 2009 13:07:15 +0200
Message-Id: <1239016035.798.4254.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-06 at 13:01 +0200, Peter Zijlstra wrote:
> On Fri, 2009-04-03 at 11:25 -0700, Corey Ashford wrote:
> > Peter Zijlstra wrote:
> > > On Thu, 2009-04-02 at 11:12 +0200, Peter Zijlstra wrote:
> > >> plain text document attachment (perf_counter_callchain_context.patch)
> > >> Put in counts to tell which ips belong to what context.
> > >>
> > >>   -----
> > >>    | |  hv
> > >>    | --
> > >> nr | |  kernel
> > >>    | --
> > >>    | |  user
> > >>   -----
> > > 
> > > Right, just realized that PERF_RECORD_IP needs something similar if one
> > > if not able to derive the context from the IP itself..
> > > 
> > Three individual bits would suffice, or you could use a two-bit code -
> > 00 = user
> > 01 = kernel
> > 10 = hypervisor
> > 11 = reserved (or perhaps unknown)
> > 
> > Unfortunately, because of alignment, it would need to take up another 64 
> > bit word, wouldn't it?  Too bad you cannot sneak the bits into the IP in 
> > a machine independent way.
> > 
> > And since you probably need a separate word, that effectively doubles 
> > the amount of space taken up by IP samples (if we add a "no event 
> > header" option).  Should we add another bit in the record_type field - 
> > PERF_RECORD_IP_LEVEL (or similar) so that user-space apps don't have to 
> > get this if they don't need it?
> 
> If we limit the event size to 64k (surely enough, right? :-), then we
> have 16 more bits to play with in the header, and we could do something
> like the below.
> 
> A further possibility would also be to add an overflow bit in there,
> making the full 32bit PERF_RECORD space available to output events as
> well.
> 
> Index: linux-2.6/include/linux/perf_counter.h
> ===================================================================
> --- linux-2.6.orig/include/linux/perf_counter.h
> +++ linux-2.6/include/linux/perf_counter.h
> @@ -201,9 +201,17 @@ struct perf_counter_mmap_page {
>  	__u32   data_head;		/* head in the data section */
>  };
>  
> +enum {
> +	PERF_EVENT_LEVEL_HV	= 0,
> +	PERF_EVENT_LEVEL_KERNEL = 1,
> +	PERF_EVENT_LEVEL_USER	= 2,
> +};
> +
>  struct perf_event_header {
>  	__u32	type;
> -	__u32	size;
> +	__u16	level		:  2,
> +		__reserved	: 14;
> +	__u16	size;
>  };

Except we should probably use masks again instead of bitfields so that
the thing is portable when streamed to disk, such as would be common
with splice().
