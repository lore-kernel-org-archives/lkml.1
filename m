Return-Path: <linux-kernel-owner+w=401wt.eu-S1753073AbYKWUOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbYKWUOg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 15:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbYKWUOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 15:14:23 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37209 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbYKWUOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 15:14:22 -0500
Date: Sun, 23 Nov 2008 21:24:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/4] trace: profile all if conditionals
Message-ID: <20081123202434.GU6703@one.firstfloor.org>
References: <20081121071213.365288293@goodmis.org> <20081121071328.462456268@goodmis.org> <87iqqei5ys.fsf@basil.nowhere.org> <alpine.DEB.1.10.0811231455090.13888@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811231455090.13888@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 02:56:42PM -0500, Steven Rostedt wrote:

You snipped my earlier suggestion? Can't you just use kernel gcov
for this? Frankly it's output is infinitely more useful than
the one from your patch. It also addresses Andrew's suggestion
of profiling other control flow constructs.

I know it's not ftrace, but not everything is bad just because it's
not seen through the ftrace spectacles @)

> On Sun, 23 Nov 2008, Andi Kleen wrote:
> > Steven Rostedt <rostedt@goodmis.org> writes:
> 
> > > This adds a significant amount of overhead and should only be used
> > > by those analyzing their system.
> > 
> > Often this can be also done using CPU performance counters. Might 
> > be a cheaper option. 
> 
> I'd love to add an option that could hook into any arch with HW support 
> for this. We could dump out the same information, but just a different way 
> to gather it.  But I'm still ignorant to the use of CPU performance 
> counters and how to find which branch matches which if.

The theory is quite simple. Typically there are events for 
"taken branches" and others for "non taken". So you set up
two counters using the existing oprofile support and collect
the samples.  Then combine these two sample streams.

[Sometimes you have to also synthesize these 
events because CPUs like to count predicted and mispredicted
(in the CPU sense) differently, but that's also quite simple
(on x86/core these can be all specified in the unit mask for
the same event)]

The sampling will be statistical (not every branch counted),
but that's ok because only branches that are executed a significant
time are interesting anyways.

The only problem is you have to map back to source code lines, which
can be done in user space based on the oprofile output and some
addr2line or similar hacks. oprofile can also do this,
although it gives this information only indirectly so a custom
tool might be easier.

Note it doesn't even need new kernel code, assuming 
the architecture already has a working full oprofile implementation.

The main advantage over gcov would be lower runtime overhead,
although gcov is giving the better output (and is already working
too)

-Andi



> 
> -- Steve
> 

-- 
ak@linux.intel.com
