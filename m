Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbXEaUoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbXEaUoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 16:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbXEaUoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 16:44:37 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:54289 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbXEaUog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 16:44:36 -0400
Date: Thu, 31 May 2007 13:44:04 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/22] 2.6.22-rc3 perfmon2 : common core functions
Message-ID: <20070531204404.GE24230@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <200705291348.l4TDmRvL019775@frankl.hpl.hp.com> <p73ira9ca0d.fsf@bingen.suse.de> <20070531171616.GC23939@frankl.hpl.hp.com> <20070531172828.GC2538@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531172828.GC2538@one.firstfloor.org>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Thu, May 31, 2007 at 07:28:28PM +0200, Andi Kleen wrote:
> 
> > All the features currently supported are used by some tools and have
> > been requested by users.
> 
> But are they actually all used? Is there something you would
> like to get rid of because it turned out more trouble than gain?
> Now is the time to do it.
> 
I need to take a look but I thikn there are two features I can remove
without too much trouble: counter remapping, explicit set switching.
That would remove some code and should they really be needed in the
future we could add them.

> > > > +#define ulp(_x) ((unsigned long *)_x)
> > > 
> > > Don't use such non standard macros please.
> > 
> > That goes back to the argument earlier about bitmap.h using unsigned long
> > and not u64. To avoid compiler warning, I used this macro. I do want
> > to use the bitmap macros (instead of inventing my own). Andrew once
> > asked if we should not fix bitmap.h instead.
> 
> I mean just use the cast if you mean the cast. That makes the readers'
> life much easier.
The issue is that the code get more difficult to read and format
because of all the (unsigned long *) cast. What about I rename the
macro to cast_ulp() to make this more explicit?

> 
> > There parameter is checked on entry from perfmon syscalls to fail
> > if necessary. So there can potentially be a race with the perfmon init.
> 
> A simple flag is not racy.
> 
I'll fix that.

> > Are you talking about the overflow of the message queue?
> 
> Yes.
> 
No, monitoring will stop when the queue is full.

> > I made sure there was enough features in perfmon to support Oprofile and reuse its
> > kernel code base. The changes to the user level daemon are fairly limited. It was my
> > goal to ensure that Oprofile users would not see major disruptions. The wording is
> > the documentation was maybe too strong.
> 
> I would prefer if oprofile would still work. It doesn't need to work
> in parallel but it should be possible to use it when perfmon
> is not active, but compiled in. That shouldn't be that difficult,
> should it?
> 
What I did (this is how it works on IA-64) is that Oprofile works on top
of perfmon.  Perfmon handles read/write of the PMU registers and low-level
interrupt handling. Higher level interrupt handling, sampling buffers, event
buffers and export of the buffer via /dev/oprofile works like before.
Until the user level oprofile code gets updated to work on perfmon
on x86, we could do what you suggest. Mutual exclusion between the
two subsystem would not be too hard. 

> > > Weird thing to export. That's purely an internal implementation detail isn't it?
> > 
> > Yes, but that could be leveraged by tools to optimize the number of argument they
> > want to pass per call.
> 
> Well is it?  And how would that be implemented? assembler stubs? 
> switch statements? Doesn't make much sense to me.
> 
The pfm_read_Pmds() call takes a vector argument, the /sys info simply reports
the maximum number of entries in the vector that would not cause a kmalloc() 
but instead would be handled on the kernel stack. On x86, it is set to 4.
so if you have 8 register to read, it may be more interesting to make two
calls of 4 entries each. This is purely for optimization.


> > > > +   * smpl_buffer_mem_max(RW): maximum amount of memory usable for sampling buffers.
> > > > +   		-1 means all that is available.
> > > 
> > > -1 seems dangerous. 
> > 
> > I could use a % of available memory. Is there another subsystem that ttries to size
> > its buffer based on available memory at boot time?
> 
> Yes plenty, e.g. for hash tables. But then the heuristics
> tend to be wrong. Just because I have 16GB of RAM doesn't 
> mean I really want 8GB of perfmon tables.
> 
Agreed.

> But how about using mlock per process limits instead?
> 
The kernel level sampling buffer is allocated via kmalloc() when the 
perfmon context is created. The buffer cannot be paged out, so this is 
as if the memory was locked. I do the accounting with RLIMIT_MEMLOCK,
even if the buffer is never explicitly mmapped by the user.
Don't you need some privilege to issue a mlock()?
So in fact you have two levels: a per-process limit controlled
by RLIMIT_MEMLOCK and a system-wide limit controlled by smpl_buffer_mem_max.

-- 
-Stephane
