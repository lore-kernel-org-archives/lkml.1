Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbYKGSOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbYKGSOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbYKGSOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:14:17 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:37657 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753144AbYKGSOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:14:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEAP0TFElMQWxa/2dsb2JhbACBdsd8g1Y
Date: Fri, 7 Nov 2008 13:14:12 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       paulus@samba.org, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 04/18] get_cycles() : powerpc64 HAVE_GET_CYCLES
Message-ID: <20081107181412.GH22134@Krystal>
References: <20081107052336.652868737@polymtl.ca> <20081107053349.215096700@polymtl.ca> <20081107145636.GA5021@yoda.jdub.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081107145636.GA5021@yoda.jdub.homelinux.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:03:15 up 155 days, 22:43,  6 users,  load average: 0.81, 0.76,
	0.64
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Josh Boyer (jwboyer@linux.vnet.ibm.com) wrote:
> On Fri, Nov 07, 2008 at 12:23:40AM -0500, Mathieu Desnoyers wrote:
> >This patch selects HAVE_GET_CYCLES and makes sure get_cycles_barrier() and
> >get_cycles_rate() are implemented.
> >
> >Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> >CC: benh@kernel.crashing.org
> >CC: paulus@samba.org
> >CC: David Miller <davem@davemloft.net>
> >CC: Linus Torvalds <torvalds@linux-foundation.org>
> >CC: Andrew Morton <akpm@linux-foundation.org>
> >CC: Ingo Molnar <mingo@redhat.com>
> >CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >CC: Thomas Gleixner <tglx@linutronix.de>
> >CC: Steven Rostedt <rostedt@goodmis.org>
> >CC: linux-arch@vger.kernel.org
> >---
> > arch/powerpc/Kconfig             |    1 +
> > arch/powerpc/include/asm/timex.h |   11 +++++++++++
> > 2 files changed, 12 insertions(+)
> >
> >Index: linux.trees.git/arch/powerpc/Kconfig
> >===================================================================
> >--- linux.trees.git.orig/arch/powerpc/Kconfig	2008-11-07 00:09:44.000000000 -0500
> >+++ linux.trees.git/arch/powerpc/Kconfig	2008-11-07 00:09:46.000000000 -0500
> >@@ -121,6 +121,7 @@ config PPC
> > 	select HAVE_DMA_ATTRS if PPC64
> > 	select USE_GENERIC_SMP_HELPERS if SMP
> > 	select HAVE_OPROFILE
> >+	select HAVE_GET_CYCLES if PPC64
> 
> So maybe it's just me because it's Friday and I'm on vacation, but I don't
> see anything overly specific to ppc64 here.  In fact, you use get_cycles_rate
> for all of powerpc in a later patch in the series.
> 
> Is there something special about HAVE_GET_CYCLES that I'm missing that would
> make it only apply to ppc64 and not ppc32?
> 
> josh

Hi Josh,

powerpc32 only uses the 32 LSBs for the TSC in the current get_cycles()
implementation. We could either define HAVE_GET_CYCLES_32 like I did on
mips32, or change get_cycles so it also reads the 32 MSBs in a loop like
this (it does not take care of the CPU_FTR_CELL_TB_BUG though) :

typedef unsigned long long cycles_t;

cycles_t get_cycles_ppc32(void)
{
  union {
    cycles_t v;
    struct {
      u32 ms32, ls32; /* powerpc is big endian */
    } s;
  } cycles;

  do {
    cycles.ls32 = mftbu();
    cycles.ms32 = mftbl();
  } while (cycles.ls32 != mftbu());
  return cycles.v;
}

I'd prefer this second solution. If one needs a specific get_cycles() to
be only 32-bits (but really really fast) for the scheduler, then this
could be a get_cycles_sched() or something like this which does not
guarantee that it returns full 64-bits...

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
