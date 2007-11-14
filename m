Return-Path: <linux-kernel-owner+w=401wt.eu-S1764551AbXKNCLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764551AbXKNCLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761671AbXKNCHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:07:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44945 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761862AbXKNCHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:07:04 -0500
Date: Wed, 14 Nov 2007 03:07:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       Robert Richter <robert.richter@amd.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, William Cohen <wcohen@redhat.com>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071114020702.GB20365@one.firstfloor.org>
References: <4739C42F.8030208@redhat.com> <20071113175545.GD4319@frankl.hpl.hp.com> <4739EE13.2090006@redhat.com> <20071113211345.GB5747@frankl.hpl.hp.com> <20071113212902.GA17593@one.firstfloor.org> <20071113214628.GE5747@frankl.hpl.hp.com> <20071113215056.GB17593@one.firstfloor.org> <20071113222234.GH5747@frankl.hpl.hp.com> <20071113222534.GC17145@one.firstfloor.org> <20071113225848.GK5747@frankl.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113225848.GK5747@frankl.hpl.hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[dropped all these bouncing email lists. Adding closed lists to public
cc lists is just a bad idea]

> int
> main(int argc, char **argv)
> {
> 	int ctx_fd;
> 	pfarg_pmd_t pd[1];
> 	pfarg_pmc_t pc[1];
> 	pfarg_ctx_t ctx;
> 	pfarg_load_t load_args;
> 
> 	memset(&ctx, 0, sizeof(ctx));
> 	memset(pc, 0, sizeof(pc));
> 	memset(pd, 0, sizeof(pd));
> 
> 	/* create session (context) and get file descriptor back (identifier) */
> 	ctx_fd = pfm_create_context(&ctx, NULL, NULL, 0);

There's nothing in your example that makes the file descriptor needed.

> 
> 	/* setup one config register (PMC0) */
> 	pc[0].reg_num   = 0
> 	pc[0].reg_value = 0x1234;

That would be nicer if it was just two arguments.

> 
> 	/* setup one data register (PMD0) */
> 	pd[0].reg_num = 0;
> 	pd[0].reg_value = 0;

Why do you need to set the data register? Wouldn't it make
more sense to let the kernel handle that and just return one.

> 
> 	/* program the registers */
> 	pfm_write_pmcs(ctx_fd, pc, 1);
> 	pfm_write_pmds(ctx_fd, pd, 1);
> 
> 	/* attach the context to self */
> 	load_args.load_pid = getpid();
> 	pfm_load_context(ctx_fd, &load_args);

My replacement would be to just add a flags argument to write_pmcs 
with one flag bit meaning "GLOBAL CONTEXT" versus "MY CONTEXT"
> 
> 	/* activate monitoring */
> 	pfm_start(ctx_fd, NULL);

Why can't that be done by the call setting up the register?

Or if someone needs to do it for a specific region they can read
the register before and then afterwards.

> 
> 	/*
> 	 * run code to measure
> 	 */
> 
> 	/* stop monitoring */
> 	pfm_stop(ctx_fd);
> 
> 	/* read data register */
> 	pfm_read_pmds(ctx_fd, pd, 1);

On x86 i think it would be much simpler to just let the set/alloc
register call return a number and then use RDPMC directly. That would
be actually faster and be much simpler too.

I suppose most architectures have similar facilities, if not a call could be 
added for them but it's not really essential. The call might be also needed
for event multiplexing, but frankly I would just leave that out for now.

e.g. here is one use case I would personally see as useful. We need
a replacement for simple cycle counting since RDTSC doesn't do that anymore
on modern x86 CPUs.  It could be something like:

	/* 0 is the initial value */

	/* could be either library or syscall */
	event = get_event(COUNTER_CYCLES); 
	if (event < 0) 
		/* CPU has no cycle counter */

	reg = setup_perfctr(event, 0 /* value */, LOCAL_EVENT); /* syscall */

	rdpmc(reg, start);
	.... some code to run ...
	rdpmc(reg, end);

	free_perfctr(reg);	/* syscall */

On other architectures rdpmc would be different of course, but 
the rest could be probably similar.

-Andi

