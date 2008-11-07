Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbYKGROU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbYKGROU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 12:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbYKGROI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 12:14:08 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:33306 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814AbYKGROH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 12:14:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEAJkDFElMQWxa/2dsb2JhbACBdsgig1Y
Date: Fri, 7 Nov 2008 12:09:02 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: David Howells <dhowells@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Nicolas Pitre <nico@cam.org>, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Message-ID: <20081107170902.GD22134@Krystal>
References: <20081107053349.861709786@polymtl.ca> <20081107052336.652868737@polymtl.ca> <25257.1226055312@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <25257.1226055312@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:51:58 up 155 days, 21:32,  6 users,  load average: 1.20, 1.00,
	0.82
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Howells (dhowells@redhat.com) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Assume the time source is a global clock which insures that time will never
> > *ever* go backward. Use a smp_rmb() to make sure the cnt_lo value is read before
> > __m_cnt_hi.
> 
> If you have an smp_rmb(), then don't you need an smp_wmb()/smp_mb() to match
> it to make it work?  And is your assumption valid that smp_rmb() will affect
> memory vs the I/O access to read the clock?  There's no requirement that
> cnt_lo will have been read from an MMIO location at all.
> 
> David

I want to make sure

  __m_cnt_hi
 is read before
  mmio cnt_lo read

for the detailed reasons explained in my previous discussion with
Nicolas here :
http://lkml.org/lkml/2008/10/21/1

I use smp_rmb() to do this on SMP systems (hrm, actually, a rmb() could
be required so it works also on UP systems safely wrt interrupts).

The write side is between the hardware counter, which is assumed to
increment monotonically between each read, and the value __m_cnt_hi
updated by the CPU. I don't see where we could put a wmb() there.

Without barrier, the smp race looks as follow :


CPU    A                                    B
                                            read hw cnt low (0xFFFFFFFA)
       read __m_cnt_hi (0x80000000)
       read hw cnt low (0x00000001)
       (wrap detected :
        (s32)(0x80000000 ^ 0x1) < 0)
       write __m_cnt_hi = 0x00000001
                                            read __m_cnt_hi (0x00000001)
       return 0x0000000100000001
                                            (wrap detected :
                                             (s32)(0x00000001 ^ 0xFFFFFFFA) < 0)
                                            write __m_cnt_hi = 0x80000001
                                            return 0x80000001FFFFFFFA
                                                                  (time jumps)

And UP interrupt race :

       Thread context                       Interrupts
       read hw cnt low (0xFFFFFFFA)
                                            read __m_cnt_hi (0x80000000)
                                            read hw cnt low (0x00000001)
                                            (wrap detected :
                                             (s32)(0x80000000 ^ 0x1) < 0)
                                            write __m_cnt_hi = 0x00000001
       read __m_cnt_hi (0x00000001)
                                            return 0x0000000100000001
       (wrap detected :
        (s32)(0x00000001 ^ 0xFFFFFFFA) < 0)
       write __m_cnt_hi = 0x80000001
       return 0x80000001FFFFFFFA
                (time jumps)

New code to fix it here with full rmb() :

static inline u64 cnt32_to_63(u32 io_addr, u32 *__m_cnt_hi)
{
        union cnt32_to_63 __x;
        __x.hi = *__m_cnt_hi;   /* memory read for high bits internal state */
        rmb();                  /*
                                 * read high bits before low bits insures time
                                 * does not go backward. Sync across
                                 * CPUs and for interrupts.
                                 */
        __x.lo = readl(cnt_lo); /* mmio read */
        if (unlikely((s32)(__x.hi ^ __x.lo) < 0))
                *__m_cnt_hi =
                        __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31);
        return __x.val;
}

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
