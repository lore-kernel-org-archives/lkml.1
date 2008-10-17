Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbYJQAno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbYJQAno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 20:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbYJQAnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 20:43:32 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:54060 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757075AbYJQAnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 20:43:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEANt690hMQWq+/2dsb2JhbACBcsISg2w
Date: Thu, 16 Oct 2008 20:43:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Paul Mackerras <paulus@samba.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, benh@kernel.crashing.org,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC patch 04/15] get_cycles() : powerpc64 HAVE_GET_CYCLES
	(update)
Message-ID: <20081017004328.GA29768@Krystal>
References: <20081016232729.699004293@polymtl.ca> <20081016234656.055839676@polymtl.ca> <18679.56239.74999.534588@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <18679.56239.74999.534588@cargo.ozlabs.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:40:32 up 134 days,  5:20, 10 users,  load average: 0.35, 0.49,
	0.62
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Mackerras (paulus@samba.org) wrote:
> Mathieu Desnoyers writes:
> 
> > This patch selects HAVE_GET_CYCLES and makes sure get_cycles_barrier() and
> > get_cycles_rate() are implemented.
> 
> [snip]
> 
> > +static inline cycles_t get_cycles_rate(void)
> > +{
> > +	return CLOCK_TICK_RATE;
> > +}
> 
> CLOCK_TICK_RATE is certainly wrong.  You want ppc_tb_freq (declared in
> asm/time.h).  Or tb_ticks_per_sec, since we seem to have two variables
> for exactly the same thing, for some reason. :)
> 
> Paul.

Ok, this should work better. Thanks !

Do you know if mtfb implies an instruction synchronization (isync) ? I
think that if it does not, the new get_cycles_barrier() might have to be
used at some locations in the kernel code if more precise timestamp
order is required.

Mathieu


get_cycles() : powerpc64 HAVE_GET_CYCLES

This patch selects HAVE_GET_CYCLES and makes sure get_cycles_barrier() and
get_cycles_rate() are implemented.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: benh@kernel.crashing.org
CC: paulus@samba.org
CC: David Miller <davem@davemloft.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: linux-arch@vger.kernel.org
---
 arch/powerpc/Kconfig             |    1 +
 arch/powerpc/include/asm/timex.h |   14 ++++++++++++++
 2 files changed, 15 insertions(+)

Index: linux-2.6-lttng/arch/powerpc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/Kconfig	2008-10-16 20:31:33.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/Kconfig	2008-10-16 20:31:36.000000000 -0400
@@ -122,6 +122,7 @@ config PPC
 	select HAVE_DMA_ATTRS if PPC64
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_OPROFILE
+	select HAVE_GET_CYCLES if PPC64
 
 config EARLY_PRINTK
 	bool
Index: linux-2.6-lttng/arch/powerpc/include/asm/timex.h
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/include/asm/timex.h	2008-10-16 20:31:33.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/include/asm/timex.h	2008-10-16 20:32:02.000000000 -0400
@@ -9,6 +9,7 @@
 
 #include <asm/cputable.h>
 #include <asm/reg.h>
+#include <asm/time.h>
 
 #define CLOCK_TICK_RATE	1024000 /* Underlying HZ */
 
@@ -46,5 +47,18 @@ static inline cycles_t get_cycles(void)
 #endif
 }
 
+static inline cycles_t get_cycles_rate(void)
+{
+	return tb_ticks_per_sec;
+}
+
+/*
+ * To check : assuming mtfb requires isync to synchronize instruction execution.
+ */
+static inline void get_cycles_barrier(void)
+{
+	isync();
+}
+
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_TIMEX_H */

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
