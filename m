Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbYDUGXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbYDUGXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 02:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750792AbYDUGXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 02:23:24 -0400
Received: from www.tglx.de ([62.245.132.106]:36434 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbYDUGXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 02:23:24 -0400
Date: Mon, 21 Apr 2008 08:22:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Roman Zippel <zippel@linux-m68k.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT pull] (hr)timer updates feed from Andrew
In-Reply-To: <200804201922.46749.zippel@linux-m68k.org>
Message-ID: <alpine.LFD.1.10.0804210756350.3243@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0804192247580.3261@apollo.tec.linutronix.de> <200804201922.46749.zippel@linux-m68k.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Apr 2008, Roman Zippel wrote:
> On Saturday 19. April 2008, Thomas Gleixner wrote:
> 
> > John Stultz (1):
> >       time: close small window for vsyscall time inconsistencies
> 
> Out of curiosity: why did you merge this patch despite my objections?
> Why couldn't you wait a little while longer? You knew I was waiting for more 
> information to analyze this properly...
> (Especially as it turns out that this patch doesn't really close the window, 
> it only makes it smaller.)

I did not follow the discussion as I was burried in other work, so I
assumed that the contention was resolved, when Andrew forwarded a
bunch of patches from -mm.

As Linus did not pull yet, I dropped it. Can we please resolve this
issue ASAP ?

Find below the experimental clock source which made this easy
reproducible. Select the new clock source and run Ingos time-warp test
on a SMP machine.

Thanks,
	tglx
---

Subject: fast-gtod-hack.patch
From: Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 29 Mar 2008 12:03:26 +0100

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/clocksource/acpi_pm.c |   71 +++++++++++++++++++++++++++++++++++++++---
 include/asm-x86/vgtod.h       |    1 
 include/linux/seqlock.h       |   46 +++++++++++++++++----------
 3 files changed, 96 insertions(+), 22 deletions(-)

Index: linux-2.6/drivers/clocksource/acpi_pm.c
===================================================================
--- linux-2.6.orig/drivers/clocksource/acpi_pm.c
+++ linux-2.6/drivers/clocksource/acpi_pm.c
@@ -56,14 +56,72 @@ u32 acpi_pm_read_verified(void)
 	return v2;
 }
 
+#ifdef CONFIG_X86_64
+#include <asm/vgtod.h>
+
+static cycle_t __vsyscall_fn vread_pm_timer(void)
+{
+	return (cycle_t) __vsyscall_gtod_data.clocksource_data;
+}
+
+static cycle_t acpi_pm_lowres_read_slow(void)
+{
+	unsigned long vdata, now, *p = &vsyscall_gtod_data.clocksource_data;
+
+	do {
+		vdata = vsyscall_gtod_data.clocksource_data;
+		now = acpi_pm_read_verified();
+	} while (cmpxchg(p, vdata, now) != vdata);
+
+	return (cycle_t) now;
+}
+
+static cycle_t acpi_pm_lowres_read(void)
+{
+	unsigned long vdata, now, *p = &vsyscall_gtod_data.clocksource_data;
+
+	do {
+		vdata = vsyscall_gtod_data.clocksource_data;
+		now = read_pmtmr();
+	} while (cmpxchg(p, vdata, now) != vdata);
+
+	return (cycle_t) now;
+}
+
+static struct clocksource clocksource_acpi_pm_lowres = {
+	.name		= "acpi_pm-lowres",
+	.rating		= 180,
+	.read		= acpi_pm_lowres_read,
+	.mask		= (cycle_t)ACPI_PM_MASK,
+	.mult		= 0, /*to be calculated*/
+	.shift		= 22,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.vread		= vread_pm_timer,
+};
+
+static int __init register_lowres(u32 mult, int use_slow)
+{
+	if (use_slow)
+		clocksource_acpi_pm_lowres.read = acpi_pm_lowres_read_slow;
+
+	clocksource_acpi_pm_lowres.mult = mult;
+	return clocksource_register(&clocksource_acpi_pm_lowres);
+};
+
+#else
+
+static inline int register_lowres(u32 mult, int use_slow) { return 0; }
+
+#endif
+
 static cycle_t acpi_pm_read_slow(void)
 {
-	return (cycle_t)acpi_pm_read_verified();
+	return (cycle_t) acpi_pm_read_verified();
 }
 
 static cycle_t acpi_pm_read(void)
 {
-	return (cycle_t)read_pmtmr();
+	return (cycle_t) read_pmtmr();
 }
 
 static struct clocksource clocksource_acpi_pm = {
@@ -74,7 +132,6 @@ static struct clocksource clocksource_ac
 	.mult		= 0, /*to be calculated*/
 	.shift		= 22,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
-
 };
 
 
@@ -178,7 +235,7 @@ static int verify_pmtmr_rate(void)
 static int __init init_acpi_pm_clocksource(void)
 {
 	u32 value1, value2;
-	unsigned int i;
+	unsigned int i, ret;
 
 	if (!pmtmr_ioport)
 		return -ENODEV;
@@ -208,7 +265,11 @@ pm_good:
 	if (verify_pmtmr_rate() != 0)
 		return -ENODEV;
 
-	return clocksource_register(&clocksource_acpi_pm);
+	ret = clocksource_register(&clocksource_acpi_pm);
+	if (!ret)
+		ret = register_lowres(clocksource_acpi_pm.mult,
+				      clocksource_acpi_pm.read != acpi_pm_read);
+	return ret;
 }
 
 /* We use fs_initcall because we want the PCI fixups to have run
Index: linux-2.6/include/asm-x86/vgtod.h
===================================================================
--- linux-2.6.orig/include/asm-x86/vgtod.h
+++ linux-2.6/include/asm-x86/vgtod.h
@@ -21,6 +21,7 @@ struct vsyscall_gtod_data {
 		u32	shift;
 	} clock;
 	struct timespec wall_to_monotonic;
+	unsigned long	clocksource_data;
 };
 extern struct vsyscall_gtod_data __vsyscall_gtod_data
 __section_vsyscall_gtod_data;
Index: linux-2.6/include/linux/seqlock.h
===================================================================
--- linux-2.6.orig/include/linux/seqlock.h
+++ linux-2.6/include/linux/seqlock.h
@@ -85,23 +85,29 @@ static inline int write_tryseqlock(seqlo
 /* Start of read calculation -- fetch last complete writer token */
 static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
 {
-	unsigned ret = sl->sequence;
+	unsigned ret;
+
+repeat:
+	ret = sl->sequence;
 	smp_rmb();
+	if (unlikely(ret & 1)) {
+		cpu_relax();
+		goto repeat;
+	}
+
 	return ret;
 }
 
-/* Test if reader processed invalid data.
- * If initial values is odd, 
- *	then writer had already started when section was entered
- * If sequence value changed
- *	then writer changed data while in section
- *    
- * Using xor saves one conditional branch.
+/*
+ * Test if reader processed invalid data.
+ *
+ * If sequence value changed then writer changed data while in section.
  */
-static __always_inline int read_seqretry(const seqlock_t *sl, unsigned iv)
+static __always_inline int read_seqretry(const seqlock_t *sl, unsigned start)
 {
 	smp_rmb();
-	return (iv & 1) | (sl->sequence ^ iv);
+
+	return (sl->sequence != start);
 }
 
 
@@ -122,20 +128,26 @@ typedef struct seqcount {
 /* Start of read using pointer to a sequence counter only.  */
 static inline unsigned read_seqcount_begin(const seqcount_t *s)
 {
-	unsigned ret = s->sequence;
+	unsigned ret;
+
+repeat:
+	ret = s->sequence;
 	smp_rmb();
+	if (unlikely(ret & 1)) {
+		cpu_relax();
+		goto repeat;
+	}
 	return ret;
 }
 
-/* Test if reader processed invalid data.
- * Equivalent to: iv is odd or sequence number has changed.
- *                (iv & 1) || (*s != iv)
- * Using xor saves one conditional branch.
+/*
+ * Test if reader processed invalid data because sequence number has changed.
  */
-static inline int read_seqcount_retry(const seqcount_t *s, unsigned iv)
+static inline int read_seqcount_retry(const seqcount_t *s, unsigned start)
 {
 	smp_rmb();
-	return (iv & 1) | (s->sequence ^ iv);
+
+	return s->sequence != start;
 }
 
 
