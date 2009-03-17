Return-Path: <linux-kernel-owner+w=401wt.eu-S1762873AbZCQImT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762873AbZCQImT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 04:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbZCQImH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 04:42:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:46518 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbZCQImG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 04:42:06 -0400
Subject: Re: [PATCH/RFC 2/2] perfcounters: add an mmap method to allow
 userspace to read hardware counters
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <18879.24309.827081.959346@cargo.ozlabs.ibm.com>
References: <18879.14431.733358.248755@drongo.ozlabs.ibm.com>
	 <1237275515.5189.71.camel@laptop>
	 <18879.24309.827081.959346@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 09:41:57 +0100
Message-Id: <1237279317.5189.150.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-17 at 19:27 +1100, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > While I think mmap'ed counters is a great idea, I really dont like this
> > patch. It adds a second output format unrelated to the regular output
> > format, and it doesn't appear to honor the regular output rules either.
> > PERF_RECORD_GROUP thingies won't work for example.
> > 
> > Nor is there any kind of queuing, one might want to have multiple events
> > in the mmap buffer..
> 
> I think you have misunderstood.  This is not about sampling counters
> *at all*.  This is about simple counting counters.

I think I did indeed.

> On powerpc, userspace can read the hardware counters directly.  This
> stuff lets a program that is counting hardware events on itself do
> that and translate the result into a full 64-bit value.  The
> information the program needs in order to do this is (a) which
> hardware counter (if any) has been assigned to this particular
> perf_counter and (b) what the offset between the hardware counter
> value and the full 64-bit perf_counter value is.  That, plus a
> seqlock-style lock, is what's in the mmapped page.

Ah, right. I think some of the intel chips can do similar things with
rdpmc instructions.

> > I was planning to do this after cleaning up the normal output bits, as
> > our current output stuff is a mess:
> >  - its spread out over arch code (seems daft to me, we should all output
> >    the same)
> >  - its useless for pretty much anything but the two apps we currently
> >    have
> > 
> > In particular, it lacks the tid information for sampled data I hinted to
> > in the previous email.
> 
> Ingo has talked about reusing some of the tracing infrastructure for
> reporting perf_counter events to userspace.  That sounds like an
> excellent idea to me, and that is why I didn't bother with putting the
> event queue into the mmapped page at this stage.  If it makes sense to
> add it, it can be added later.

Yeah, I've been looking into that, but so far I'm a bit at a loss, all
that tracing stuff is per-cpu, and that's massive overkill for us, since
we're dealing with single cpu streams.

One worry though, supposedly we want to mmap() such buffers too at some
point, how would that interact with that you proposed?

