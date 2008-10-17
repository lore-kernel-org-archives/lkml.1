Return-Path: <linux-kernel-owner+w=401wt.eu-S1753613AbYJQCsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbYJQCsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 22:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYJQCs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 22:48:27 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:64012 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752162AbYJQCs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 22:48:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAJSY90hMQWq+/2dsb2JhbACBcsIHg2w
Date: Thu, 16 Oct 2008 22:48:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC patch 03/15] get_cycles() : sparc64 HAVE_GET_CYCLES
	(update)
Message-ID: <20081017024824.GB32468@Krystal>
References: <20081016232729.699004293@polymtl.ca> <20081016234655.893647148@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081016234655.893647148@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:46:10 up 134 days,  7:26, 10 users,  load average: 0.61, 0.54,
	0.44
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch selects HAVE_GET_CYCLES and makes sure get_cycles_barrier() and
get_cycles_rate() are implemented.

Changelog :
- Use tb_ticks_per_usec * 1000000 in get_cycles_rate().

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: David Miller <davem@davemloft.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: linux-arch@vger.kernel.org
---
 arch/sparc/include/asm/timex_64.h |   19 ++++++++++++++++++-
 arch/sparc64/Kconfig              |    1 +
 arch/sparc64/kernel/time.c        |    3 ++-
 3 files changed, 21 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/arch/sparc64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc64/Kconfig	2008-10-16 22:29:43.000000000 -0400
+++ linux-2.6-lttng/arch/sparc64/Kconfig	2008-10-16 22:29:53.000000000 -0400
@@ -14,6 +14,7 @@ config SPARC64
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE
 	select HAVE_IDE
+	select HAVE_GET_CYCLES
 	select HAVE_LMB
 	select HAVE_ARCH_KGDB
 	select USE_GENERIC_SMP_HELPERS if SMP
Index: linux-2.6-lttng/arch/sparc/include/asm/timex_64.h
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/include/asm/timex_64.h	2008-10-16 22:29:43.000000000 -0400
+++ linux-2.6-lttng/arch/sparc/include/asm/timex_64.h	2008-10-16 22:33:48.000000000 -0400
@@ -12,7 +12,24 @@
 
 /* Getting on the cycle counter on sparc64. */
 typedef unsigned long cycles_t;
-#define get_cycles()	tick_ops->get_tick()
+
+static inline cycles_t get_cycles(void)
+{
+	return tick_ops->get_tick();
+}
+
+/* get_cycles instruction is synchronized on sparc64 */
+static inline void get_cycles_barrier(void)
+{
+	return;
+}
+
+extern unsigned long tb_ticks_per_usec;
+
+static inline cycles_t get_cycles_rate(void)
+{
+	return tb_ticks_per_usec * 1000000UL;
+}
 
 #define ARCH_HAS_READ_CURRENT_TIMER
 
Index: linux-2.6-lttng/arch/sparc64/kernel/time.c
===================================================================
--- linux-2.6-lttng.orig/arch/sparc64/kernel/time.c	2008-10-16 22:30:36.000000000 -0400
+++ linux-2.6-lttng/arch/sparc64/kernel/time.c	2008-10-16 22:30:58.000000000 -0400
@@ -1008,7 +1008,8 @@ static void __init setup_clockevent_mult
 	sparc64_clockevent.mult = mult;
 }
 
-static unsigned long tb_ticks_per_usec __read_mostly;
+unsigned long tb_ticks_per_usec __read_mostly;
+EXPORT_SYMBOL_GPL(tb_ticks_per_usec);
 
 void __delay(unsigned long loops)
 {

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
