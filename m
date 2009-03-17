Return-Path: <linux-kernel-owner+w=401wt.eu-S1762782AbZCQI17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762782AbZCQI17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 04:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbZCQI1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 04:27:43 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:46841 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbZCQI1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 04:27:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18879.24309.827081.959346@cargo.ozlabs.ibm.com>
Date: Tue, 17 Mar 2009 19:27:33 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH/RFC 2/2] perfcounters: add an mmap method to allow
 userspace to read hardware counters
In-Reply-To: <1237275515.5189.71.camel@laptop>
References: <18879.14431.733358.248755@drongo.ozlabs.ibm.com>
	<1237275515.5189.71.camel@laptop>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> While I think mmap'ed counters is a great idea, I really dont like this
> patch. It adds a second output format unrelated to the regular output
> format, and it doesn't appear to honor the regular output rules either.
> PERF_RECORD_GROUP thingies won't work for example.
> 
> Nor is there any kind of queuing, one might want to have multiple events
> in the mmap buffer..

I think you have misunderstood.  This is not about sampling counters
*at all*.  This is about simple counting counters.

On powerpc, userspace can read the hardware counters directly.  This
stuff lets a program that is counting hardware events on itself do
that and translate the result into a full 64-bit value.  The
information the program needs in order to do this is (a) which
hardware counter (if any) has been assigned to this particular
perf_counter and (b) what the offset between the hardware counter
value and the full 64-bit perf_counter value is.  That, plus a
seqlock-style lock, is what's in the mmapped page.

> I was planning to do this after cleaning up the normal output bits, as
> our current output stuff is a mess:
>  - its spread out over arch code (seems daft to me, we should all output
>    the same)
>  - its useless for pretty much anything but the two apps we currently
>    have
> 
> In particular, it lacks the tid information for sampled data I hinted to
> in the previous email.

Ingo has talked about reusing some of the tracing infrastructure for
reporting perf_counter events to userspace.  That sounds like an
excellent idea to me, and that is why I didn't bother with putting the
event queue into the mmapped page at this stage.  If it makes sense to
add it, it can be added later.

Paul.
