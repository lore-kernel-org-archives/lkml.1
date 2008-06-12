Return-Path: <linux-kernel-owner+w=401wt.eu-S1760502AbYFLM5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760502AbYFLM5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757410AbYFLM5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:57:00 -0400
Received: from relay2.sgi.com ([192.48.171.30]:35218 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757315AbYFLM47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:56:59 -0400
Date: Thu, 12 Jun 2008 07:56:05 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCHv4] SGI UV: TLB shootdown using broadcast assist unit
Message-ID: <20080612125605.GA26760@sgi.com>
References: <E1K6lqI-0006pX-JQ@eag09.americas.sgi.com> <200806122235.29888.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806122235.29888.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Thu, Jun 12, 2008 at 10:35:29PM +1000, Nick Piggin wrote:
> On Thursday 12 June 2008 22:23, Cliff Wickman wrote:
> > From: Cliff Wickman <cpw@sgi.com>
> >
> > TLB shootdown for SGI UV.
> >
> > v1: 6/2 original
> > v2: 6/3 corrections/improvements per Ingo's review
> > v3: 6/4 split atomic operations off to a separate patch (Jeremy's review)
> > v4: 6/12 include <mach_apic.h> rather than <asm/mach-bigsmp/mach_apic.h>
> >          (fixes a !SMP build problem that Ingo found)
> >          fix the index on uv_table_bases[blade]
> > Now depends on patch:
> >     x86 atomic operations: atomic_or_long atomic_inc_short
> >   which was split off (and improved) at the suggestion of
> >   Jeremy Fitzhardinge <jeremy@goop.org>
> >
> > This patch provides the ability to flush TLB's in cpu's that are not on
> > the local node.  The hardware mechanism for distributing the flush
> > messages is the UV's "broadcast assist unit".
> >
> > The hook to intercept TLB shootdown requests is a 2-line change to
> > native_flush_tlb_others() (arch/x86/kernel/tlb_64.c).
> >
> > This code has been tested on a hardware simulator. The real hardware
> > is not yet available.
> >
> > The shootdown statistics are provided through /proc/sgi_uv/ptc_statistics.
> > The use of /sys was considered, but would have required the use of
> > many /sys files.  The debugfs was also considered, but these statistics
> > should be available on an ongoing basis, not just for debugging.
> >
> > Issues to be fixed later:
> > - The IRQ for the messaging interrupt is currently hardcoded as 200
> >   (see UV_BAU_MESSAGE).  It should be dynamically assigned in the future.
> > - The use of appropriate udelay()'s is untested, as they are a problem
> >   in the simulator.
> 
> For someone not too familiar with low level x86 (or UV) code, can
> you explain why you are hooking at this point? I mean, what it
> looks like is either a performance improvement, or for some reason
> UV does not support send_IPI_mask out to CPUs "not on the local node".

Yes, a performance improvement.  The UV machine has hardware for
broadcasting messages to a set of nodes (represented in a bit mask).  The
messages will raise interrupts at each of the target nodes and provide
the message - all in one step.
(IPI is supported.  In fact this patch falls back to the IPI method
 if all the cpus on the remote nodes do not respond.)
> 
> If the former, what sort of improvement to you expect / see?

Good question.  The hardware does not exist yet.  But using IPI there
would be one set of packets exchanged to deliver the interrupts and
another set to pull over the flush address, just to start the operation.
I expect the improvement to be significant.

-Cliff
-- 
Cliff Wickman
Silicon Graphics, Inc.
cpw@sgi.com
(651) 683-3824
