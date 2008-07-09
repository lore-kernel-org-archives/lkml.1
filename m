Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbYGIVgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbYGIVgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYGIVgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:36:24 -0400
Received: from relay1.sgi.com ([192.48.171.29]:60454 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751574AbYGIVgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:36:23 -0400
Date: Wed, 9 Jul 2008 16:36:22 -0500
From: Russ Anderson <rja@sgi.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [patch] x86 BIOS interface for RTC on SGI UV
Message-ID: <20080709213622.GC22744@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20080709202719.GB22744@sgi.com> <4875266B.4020504@keyaccess.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4875266B.4020504@keyaccess.nl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 10:58:19PM +0200, Rene Herman wrote:
> On 09-07-08 22:27, Russ Anderson wrote:
> 
> >+# define BIOS_CALL(result, a0, a1, a2, a3, a4, a5, a6, a7)		\
> >+	do {								\
> >+		/* XXX - the real call goes here */			\
> >+		result.status = BIOS_STATUS_UNIMPLEMENTED;		\
> >+		isrv.v0 = 0;						\
> >+		isrv.v1 = 0;						\
> 
> isrv? should be "result" I guess?

Yes.
 
> >+static __init void uv_rtc_init(void)
> >+{
> >+	long status, ticks_per_sec, drift;
> >+
> >+	status =
> >+	    x86_bios_freq_base(BIOS_FREQ_BASE_REALTIME_CLOCK, &ticks_per_sec,
> >+					&drift);
> >+	if (status != 0 || ticks_per_sec < 100000) {
> >+		printk(KERN_WARNING
> >+			"unable to determine platform RTC clock frequency, "
> >+			"guessing.\n");
> >+		/* BIOS gives wrong value for clock freq. so guess */
> >+		sn_rtc_cycles_per_second = 1000000000000UL / 30000UL;
> >+	} else
> >+		sn_rtc_cycles_per_second = ticks_per_sec;
> >+}
> 
> It seems ticks_per_sec and drift should be "unsigned long"...

Yes.

> >+const char *
> >+x86_bios_strerror(long status)
> 
> [ ... ]
> 
> >+long
> >+x86_bios_freq_base(unsigned long which, unsigned long *ticks_per_second,
> >+		   unsigned long *drift_info)
> >+{
> >+	struct uv_bios_retval isrv;
> 
> ... and wouldn't uv_bios_strerror/uv_bios_freq_base be better names?

The plan is for both x86 and ia64 versions of uv, with this being
the x86 version.  The ia64 version has ia64_sal_strerror()
and ia64_sal_freq_base().  Hence the x86_bios_* naming convention.
I'm not strongly tied to that convention, it just seemed logical.

Here is the updated patch.

---------------------------------------------------------------------
[patch] x86 BIOS interface for RTC on SGI UV

Real-time code needs to know the number of cycles per second
on SGI UV.  The information is provided via a run time BIOS
call.  This patch provides the linux side of that interface.
This is the first of several run time BIOS calls to be defined
in uv/bios.h and bios_uv.c.

Note that BIOS_CALL() is just a stub for now.  The bios 
side is being worked on.

Signed-off-by: Russ Anderson <rja@sgi.com>

---
 arch/x86/kernel/Makefile         |    1 
 arch/x86/kernel/bios_uv.c        |   48 +++++++++++++++++++++++++++
 arch/x86/kernel/genx2apic_uv_x.c |   23 +++++++++++++
 include/asm-x86/uv/bios.h        |   68 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 140 insertions(+)

Index: linux/include/asm-x86/uv/bios.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/include/asm-x86/uv/bios.h	2008-07-09 16:31:33.000000000 -0500
@@ -0,0 +1,68 @@
+#ifndef _ASM_X86_BIOS_H
+#define _ASM_X86_BIOS_H
+
+/*
+ * BIOS layer definitions.
+ *
+ *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#include <linux/rtc.h>
+
+#define BIOS_FREQ_BASE			0x01000001
+
+enum {
+	BIOS_FREQ_BASE_PLATFORM = 0,
+	BIOS_FREQ_BASE_INTERVAL_TIMER = 1,
+	BIOS_FREQ_BASE_REALTIME_CLOCK = 2
+};
+
+# define BIOS_CALL(result, a0, a1, a2, a3, a4, a5, a6, a7)		\
+	do {								\
+		/* XXX - the real call goes here */			\
+		result.status = BIOS_STATUS_UNIMPLEMENTED;		\
+		result.v0 = 0;						\
+		result.v1 = 0;						\
+	} while (0)
+
+enum {
+	BIOS_STATUS_SUCCESS		=  0,
+	BIOS_STATUS_UNIMPLEMENTED	= -1,
+	BIOS_STATUS_EINVAL		= -2,
+	BIOS_STATUS_ERROR		= -3
+};
+
+struct x86_bios_retval {
+	/*
+	 * A zero status value indicates call completed without error.
+	 * A negative status value indicates reason of call failure.
+	 * A positive status value indicates success but an
+	 * informational value should be printed (e.g., "reboot for
+	 * change to take effect").
+	 */
+	s64 status;
+	u64 v0;
+	u64 v1;
+	u64 v2;
+};
+
+extern long
+x86_bios_freq_base(unsigned long which, unsigned long *ticks_per_second,
+		   unsigned long *drift_info);
+extern const char *x86_bios_strerror(long status);
+
+#endif /* _ASM_X86_BIOS_H */
Index: linux/arch/x86/kernel/genx2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/genx2apic_uv_x.c	2008-07-09 16:05:25.000000000 -0500
+++ linux/arch/x86/kernel/genx2apic_uv_x.c	2008-07-09 16:23:21.000000000 -0500
@@ -22,6 +22,7 @@
 #include <asm/genapic.h>
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
+#include <asm/uv/bios.h>
 
 DEFINE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
 EXPORT_PER_CPU_SYMBOL_GPL(__uv_hub_info);
@@ -38,6 +39,9 @@ EXPORT_SYMBOL_GPL(uv_cpu_to_blade);
 short uv_possible_blades;
 EXPORT_SYMBOL_GPL(uv_possible_blades);
 
+unsigned long sn_rtc_cycles_per_second;
+EXPORT_SYMBOL(sn_rtc_cycles_per_second);
+
 /* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
 
 static cpumask_t uv_target_cpus(void)
@@ -208,6 +212,23 @@ static __init void get_lowmem_redirect(u
 	BUG();
 }
 
+static __init void uv_rtc_init(void)
+{
+	unsigned long status, ticks_per_sec, drift;
+
+	status =
+	    x86_bios_freq_base(BIOS_FREQ_BASE_REALTIME_CLOCK, &ticks_per_sec,
+					&drift);
+	if (status != 0 || ticks_per_sec < 100000) {
+		printk(KERN_WARNING
+			"unable to determine platform RTC clock frequency, "
+			"guessing.\n");
+		/* BIOS gives wrong value for clock freq. so guess */
+		sn_rtc_cycles_per_second = 1000000000000UL / 30000UL;
+	} else
+		sn_rtc_cycles_per_second = ticks_per_sec;
+}
+
 static __init void uv_system_init(void)
 {
 	union uvh_si_addr_map_config_u m_n_config;
@@ -258,6 +279,8 @@ static __init void uv_system_init(void)
 	node_id.v = uv_read_local_mmr(UVH_NODE_ID);
 	gnode_upper = (((unsigned long)node_id.s.node_id) &
 		       ~((1 << n_val) - 1)) << m_val;
+
+	uv_rtc_init();
 
 	for_each_present_cpu(cpu) {
 		nid = cpu_to_node(cpu);
Index: linux/arch/x86/kernel/bios_uv.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/arch/x86/kernel/bios_uv.c	2008-07-09 16:31:08.000000000 -0500
@@ -0,0 +1,48 @@
+/*
+ * BIOS run time interface routines.
+ *
+ *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#include <asm/uv/bios.h>
+
+const char *
+x86_bios_strerror(long status)
+{
+	const char *str;
+	switch (status) {
+	case  0: str = "Call completed without error"; break;
+	case -1: str = "Not implemented"; break;
+	case -2: str = "Invalid argument"; break;
+	case -3: str = "Call completed with error"; break;
+	default: str = "Unknown BIOS status code"; break;
+	}
+	return str;
+}
+
+long
+x86_bios_freq_base(unsigned long which, unsigned long *ticks_per_second,
+		   unsigned long *drift_info)
+{
+	struct x86_bios_retval isrv;
+
+	BIOS_CALL(isrv, BIOS_FREQ_BASE, which, 0, 0, 0, 0, 0, 0);
+	*ticks_per_second = isrv.v0;
+	*drift_info = isrv.v1;
+	return isrv.status;
+}
+EXPORT_SYMBOL_GPL(x86_bios_freq_base);
Index: linux/arch/x86/kernel/Makefile
===================================================================
--- linux.orig/arch/x86/kernel/Makefile	2008-07-09 16:05:25.000000000 -0500
+++ linux/arch/x86/kernel/Makefile	2008-07-09 16:05:58.000000000 -0500
@@ -103,6 +103,7 @@ obj-$(CONFIG_OLPC)		+= olpc.o
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
         obj-y				+= genapic_64.o genapic_flat_64.o genx2apic_uv_x.o tlb_uv.o
+	obj-y				+= bios_uv.o
         obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer_64.o
         obj-$(CONFIG_AUDIT)		+= audit_64.o
 

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
