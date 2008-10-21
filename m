Return-Path: <linux-kernel-owner+w=401wt.eu-S1752255AbYJUEF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbYJUEF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 00:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750771AbYJUEFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 00:05:47 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:53126 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746AbYJUEFp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 00:05:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EAKPs/EhMQWQ+/2dsb2JhbACBcsFig1A
Date: Tue, 21 Oct 2008 00:05:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Nicolas Pitre <nico@cam.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC patch 00/15] Tracer Timestamping
Message-ID: <20081021040542.GB24142@Krystal>
References: <20081016232729.699004293@polymtl.ca> <1224230353.28131.65.camel@twins> <20081020202517.GF28562@Krystal> <alpine.LFD.2.00.0810202003260.26244@xanadu.home> <20081021013223.GB18751@Krystal> <alpine.LFD.2.00.0810202152030.26244@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.LFD.2.00.0810202152030.26244@xanadu.home>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:46:49 up 138 days,  8:27,  9 users,  load average: 0.13, 0.25,
	0.33
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicolas Pitre (nico@cam.org) wrote:
> On Mon, 20 Oct 2008, Mathieu Desnoyers wrote:
> 
> > * Nicolas Pitre (nico@cam.org) wrote:
> > > On Mon, 20 Oct 2008, Mathieu Desnoyers wrote:
> > > 
> > > > * Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> > > > > Have you looked at the existing 32->63 extention code in
> > > > > include/linux/cnt32_to_63.h and considered unifying it?
> > > > > 
> > > > 
> > > > Yep, I felt this code was dangerous on SMP given it could suffer from
> > > > the following type of race due to lack of proper barriers :
> > > 
> > > You are wrong.
> > > 
> > > > CPU    A                                 B
> > > >        read hw cnt low
> > > >        read __m_cnt_hi
> > > >                                          read hw cnt low
> > > >        (wrap detected)
> > > >        write __m_cnt_hi (incremented)
> > > >                                          read __m_cnt_hi
> > > >                                          (wrap detected)
> > > >                                          write __m_cnt_hi (incremented)
> > > > 
> > > > we therefore increment the high bits twice in the given race.
> > > 
> > > No.  Either you do the _same_ incrementation twice effectively writing 
> > > the _same_ high value twice, or you don't have simultaneous wrap 
> > > detections.  Simulate it on paper with real numbers if you are not 
> > > convinced.
> > > 
> > 
> > Hi Nicolas,
> > 
> > Yup, you are right. However, the case where one CPU sees the clock source
> > a little bit off-sync (late) still poses a problem. Example follows :
> > 
> > CPU    A                                 B
> >        read __m_cnt_hi (0x80000000)
> >        read hw cnt low (0x00000001)
> >        (wrap detected :
> >         (s32)(0x80000000 ^ 0x1) < 0)
> >        write __m_cnt_hi = 0x00000001
> >        return 0x0000000100000001
> >                                             read __m_cnt_hi (0x00000001)
> >                                      (late) read hw cnt low (0xFFFFFFFA)
> >                                             (wrap detected :
> >                                              (s32)(0x00000001 ^ 0xFFFFFFFA) < 0)
> >                                             write __m_cnt_hi = 0x80000001
> >                                             return 0x80000001FFFFFFFA
> >                                                                   (time jumps)
> 
> If this is through a global counter then I have a big problem believing 
> you.
> 

If the global counter read through mmap io insures that the values
monotonically increases and if the proper memory barriers are there, it
should be ok and two consecutive reads done on different CPUs should
never go backward.

> If this is a per-CPU counter then you just need a per-CPU version of 
> __m_cnt_hi.
> 

Counters like MIPS 32-bits timestamp counter is supposedly synchronized
across cores, and could thus be thought to be global, but could suffer
from such small drift due to inexact counter synchronization.

> > A similar situation can be generated by out-of-order hi/low bits reads.
> 
> This, of course, should and can be prevented.  No big deal.
> 
> > > If the low part is a per CPU value then the high part has to be a per 
> > > CPU value too.  There only needs to be a per-CPU variant of the same 
> > > algorithm where the only difference is that __m_cnt_hi would be per CPU.
> > > 
> > > If the low part is global then __m_cnt_hi has to be global, even on SMP.
> > > 
> > 
> > Hrm, given the performance impact of barriers that would need to be
> > added to insure correct read order of hi and low bits, and also
> > considering the risk that a "synchronized" timestamp counter off by a
> > few cycles poses in terms of time jumping forward, I don't see why we
> > would ever want to use a global __m_cnt_hi ?
> 
> I still would like to know just _how_ you could manage to have one CPU 
> perform two reads and one write and manage for another CPU to see that 
> just written value but read an even older value from the global counter 
> than what the first CPU saw.
> 

As I said above, it would be ok with a global mmio counter, given the
proper barriers are used.

> > I would therefore recommend to always use a per-cpu __m_cnt_hi.
> 
> No, not until you convince me of the above nonsense.  Sure it will 
> work with a per-CPU __m_cnt_hi of course, but then the timing constraint 
> to keep the algorithm warm is for each CPU which, if the source counter 
> is global, shouldn't be necessary.
> 

True, with a mmio time source, only a single counter seems necessary.
Only when there are slightly off time sources (such as "almost"
synchronized TSC") would the per-cpu counter be needed.

> If the 63-bit counter is queried often enough on each CPU then it is of 
> course advantageous to go per-CPU to avoid excessive cache bouncing, and 
> if you start worrying about cache bouncing then you certainly call this 
> code often enough to keep everything in synch.  But that needs not to be 
> always the case.

This code should only cache bounce about once or twice per overflow
period. The rest should only read the __m_cnt_hi value for comparison.
Therefore I don't think cache-line bouncing is such an issue here. OTOH,
added barriers can degrade performance a lot.

> 
> > Also, a small nit, to make sure cnt32_to_63 never gets scheduled out
> > with a stale old __m_cnt_hi value, its comments should probably say that
> > it has to be always used with preemption off.
> 
> NO! THAT's THE WHOLE POINT OF THIS CODE: TO NOT NEED ANY KIND OF 
> LOCKING!  The only requirement is that you must not be preempted away 
> for longer than half (or a quarter if you want to play real safe) the 
> period of the base counter.  If you cannot guarantee that then either 
> your base counter is so fast that it wraps so often to be unusable, or 
> you have another and bigger problem for being preempted for so long.
> 

Or maybe you are just unlucky and a user hit CTRL-Z at the wrong time ?
I could be wrong and maybe there is no such thing possible as to "stop"
a thread while it's in kernel-space, but unless there are restrictions
about where a thread can be stopped, I assume such scenario could cause
a very long preemption if preemption is not disabled.

Even if such thread stop is not possible, assuming the scheduler will
never leave _any_ thread out of the runqueue for a few seconds seems
questionable.

Mathieu

> 
> Nicolas

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
