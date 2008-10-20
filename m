Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbYJTUZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbYJTUZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 16:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbYJTUZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 16:25:21 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:45120 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752471AbYJTUZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 16:25:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAMCF/EhMQWQ+/2dsb2JhbACBcsF3g2w
Date: Mon, 20 Oct 2008 16:25:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC patch 00/15] Tracer Timestamping
Message-ID: <20081020202517.GF28562@Krystal>
References: <20081016232729.699004293@polymtl.ca> <1224230353.28131.65.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1224230353.28131.65.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:57:06 up 138 days, 37 min, 11 users,  load average: 1.06,
	0.59, 0.66
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> On Thu, 2008-10-16 at 19:27 -0400, Mathieu Desnoyers wrote:
> > Hi,
> > 
> > Starting with the bottom of my LTTng patchset
> > (git://git.kernel.org/pub/scm/linux/kernel/git/compudj/linux-2.6-lttng.git)
> > I post as RFC the timestamping infrastructure I have been using for a while in
> > the tracer. It integrates get_cycles() standardization following David Miller's
> > comments I did more recently.
> > 
> > It also deals with 32 -> 64 bits timestamp counter extension with a RCU-style
> > algorithm, which is especially useful on MIPS and SuperH architectures.
> 
> Have you looked at the existing 32->63 extention code in
> include/linux/cnt32_to_63.h and considered unifying it?
> 

Yep, I felt this code was dangerous on SMP given it could suffer from
the following type of race due to lack of proper barriers :

CPU    A                                 B
       read hw cnt low
       read __m_cnt_hi
                                         read hw cnt low
       (wrap detected)
       write __m_cnt_hi (incremented)
                                         read __m_cnt_hi
                                         (wrap detected)
                                         write __m_cnt_hi (incremented)

we therefore increment the high bits twice in the given race.

On UP, the same race could happen if the code is called with preemption
enabled.

I don't think the "volatile" statement would necessarily make sure the
compiler and CPU would do the __m_cnt_hi read before the hw cnt low
read. A real memory barrier to order mmio reads wrt memory reads (or
instruction sync barrier if the value is taken from the cpu registers)
would be required to insure such order.

I also felt it would be more solid to have per-cpu structures to keep
track of 32->64 bits TSC updates, given the TSCs can always be slightly
out-of-sync :

CPU    A                                 B
       read __m_cnt_hi
       read hw cnt low (+200 cycles)
       (wrap detected)
       write __m_cnt_hi (incremented)
                                         read __m_cnt_hi
                                         read hw cnt low (-200 cycles)
                                         (no wrap)
                                         -> bogus value returned.




> > There is also a TSC synchronization test within this patchset to detect
> > unsynchronized TSCs. 
> 
> We already have such code, no? Does this code replace that one or just
> add a second test?
> 

It adds a second test, which seems more solid to me than the existing
x86 tsc_sync detection code.

> > See comments in this specific patch to figure out the
> > difference between the current x86 tsc_sync.c and the one I propose in this
> > patch.
> 
> Right so you don't unify, that's a missed opportunity, no?
> 

Yep, If we can switch the current x86 tsc_sync code to use my
architecture agnostic implementation, that would be a gain. We could
probably port other tsc sync detect code (ia64 ?) to use this
infrastructure too.


> > It also provides an architecture-agnostic fallback in case there is no
> > timestamp counter available : basically, it's
> > (jiffies << 13) | atomically_incremented_counter (if there are more than 8192
> > events per jiffy, time will still be monotonic, but will increment faster than
> > the actual system frequency).
> > 
> > Comments are welcome. Note that this is only the beginning of the patchset. I
> > plan to submit the event ID allocation/portable event typing aimed at exporting
> > the data to userspace and buffering mechanism as soon as I integrate a core
> > version of the LTTV userspace tools to the kernel build tree. Other than that, I
> > currently have a tracer which fulfills most of the requirements expressed
> > earlier. I just fear that if I release only the kernel part without foolproof
> > binary-to-ascii trace decoder within the kernel, people might be a bit reluctant
> > to fetch a separate userspace package.
> 
> It might be good to drop all the ltt naming and pick more generic names,
> esp. as ftrace could use a lot of this infrastructure as well.
> 

Sure. I've done all this development as part of the LTTng project, but I
don't care about renaming stuff. trace_clock() seems like a good name
for trace clock source. The unsync TSC detection and the 23->64 bits TSC
extension would also probably require more generic names (and would
benefit to be moved to kernel/).

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
