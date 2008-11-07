Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbYKGTSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbYKGTSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbYKGTSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:18:37 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:42309 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750974AbYKGTSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:18:36 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEAAsiFElMQWxa/2dsb2JhbACBdsd+g1Y
Date: Fri, 7 Nov 2008 14:18:34 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Howells <dhowells@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Nicolas Pitre <nico@cam.org>, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Message-ID: <20081107191833.GA31809@Krystal>
References: <20081107053349.861709786@polymtl.ca> <20081107052336.652868737@polymtl.ca> <25257.1226055312@redhat.com> <20081107170902.GD22134@Krystal> <alpine.DEB.1.10.0811071229570.28548@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811071229570.28548@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:17:59 up 155 days, 23:58,  6 users,  load average: 0.59, 1.48,
	1.54
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Fri, 7 Nov 2008, Mathieu Desnoyers wrote:
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
> 
> smp_rmb turns into a compiler barrier on UP and should prevent the below
> description.
> 

Ah, right, preserving program order on UP should be enough. smp_rmb()
then.

Thanks,

Mathieu

> -- Steve
> 
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
> > 
> > And UP interrupt race :
> > 
> >        Thread context                       Interrupts
> >        read hw cnt low (0xFFFFFFFA)
> >                                             read __m_cnt_hi (0x80000000)
> >                                             read hw cnt low (0x00000001)
> >                                             (wrap detected :
> >                                              (s32)(0x80000000 ^ 0x1) < 0)
> >                                             write __m_cnt_hi = 0x00000001
> >        read __m_cnt_hi (0x00000001)
> >                                             return 0x0000000100000001
> >        (wrap detected :
> >         (s32)(0x00000001 ^ 0xFFFFFFFA) < 0)
> >        write __m_cnt_hi = 0x80000001
> >        return 0x80000001FFFFFFFA
> >                 (time jumps)
> > 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
