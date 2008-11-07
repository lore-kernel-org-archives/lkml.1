Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbYKGUzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbYKGUzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 15:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYKGUzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 15:55:33 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:55007 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142AbYKGUzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 15:55:32 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEANk0FElMQWxa/2dsb2JhbACBdsheg1Y
Date: Fri, 7 Nov 2008 15:55:29 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Nicolas Pitre <nico@cam.org>
Cc: David Howells <dhowells@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Message-ID: <20081107205528.GA2654@Krystal>
References: <20081107053349.861709786@polymtl.ca> <20081107052336.652868737@polymtl.ca> <25257.1226055312@redhat.com> <20081107170902.GD22134@Krystal> <alpine.LFD.2.00.0811071522270.13034@xanadu.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811071522270.13034@xanadu.home>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:48:01 up 156 days,  1:28,  6 users,  load average: 0.15, 0.41,
	0.53
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicolas Pitre (nico@cam.org) wrote:
> On Fri, 7 Nov 2008, Mathieu Desnoyers wrote:
> 
> > I want to make sure
> > 
> >   __m_cnt_hi
> >  is read before
> >   mmio cnt_lo read
> > 
> > for the detailed reasons explained in my previous discussion with
> > Nicolas here :
> > http://lkml.org/lkml/2008/10/21/1
> > 
> > I use smp_rmb() to do this on SMP systems (hrm, actually, a rmb() could
> > be required so it works also on UP systems safely wrt interrupts).
> > 
> > The write side is between the hardware counter, which is assumed to
> > increment monotonically between each read, and the value __m_cnt_hi
> > updated by the CPU. I don't see where we could put a wmb() there.
> > 
> > Without barrier, the smp race looks as follow :
> > 
> > 
> > CPU    A                                    B
> >                                             read hw cnt low (0xFFFFFFFA)
> >        read __m_cnt_hi (0x80000000)
> >        read hw cnt low (0x00000001)
> >        (wrap detected :
> >         (s32)(0x80000000 ^ 0x1) < 0)
> >        write __m_cnt_hi = 0x00000001
> >                                             read __m_cnt_hi (0x00000001)
> >        return 0x0000000100000001
> >                                             (wrap detected :
> >                                              (s32)(0x00000001 ^ 0xFFFFFFFA) < 0)
> >                                             write __m_cnt_hi = 0x80000001
> >                                             return 0x80000001FFFFFFFA
> >                                                                   (time jumps)
> 
> Could you have hardware doing such things?  You would get a non cached 
> and more expensive read on CPU B which is not in program order with the 
> read that should have happened before, and before that second out of 
> order read could be performed, you'd have a full sequence in program 
> order performed on CPU A.
> 

Hrm, yes ? Well, it's the whole point in barriers/cache coherency
mechanisms, out-of-order reads... etc.

First off, read hw cnt low _is_ an uncached memory read (this is the
mmio read). __m_cnt_hi is a cached read, and therefore can be delayed if
the cache-line is busy. And we have no control on how much time can pass
between the two reads given the CPU may stall waiting for a cache-line.

So the scenario above happens if CPU A have __m_cnt_hi in its cacheline,
but for come reason CPU B have to defer the cacheline read of __m_cnt_hi
due to heavy cacheline traffic and decides to proceed to mmio read
before the cacheline has been brought to the CPU because "hey, there is
no data dependency between those two reads !".

See Documentation/memory-barriers.txt.

Mathieu

> 
> Nicolas

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
