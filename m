Return-Path: <linux-kernel-owner+w=401wt.eu-S932724AbYGQVG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724AbYGQVG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 17:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758767AbYGQVGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 17:06:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757890AbYGQVGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 17:06:48 -0400
Date: Thu, 17 Jul 2008 17:05:32 -0400
From: Jason Baron <jbaron@redhat.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       joe@perches.com, greg@kroah.com, nick@nick-andrew.net,
       randy.dunlap@oracle.com
Subject: Re: [PATCH 6/7] dynamic debug v2 - convert cpufreq
Message-ID: <20080717210531.GA13252@redhat.com>
References: <20080715213613.GG23331@redhat.com> <20080715230731.GA15208@isilmar.linta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715230731.GA15208@isilmar.linta.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 01:07:31AM +0200, Dominik Brodowski wrote:
> 
> Hi,
> 
> On Tue, Jul 15, 2008 at 05:36:13PM -0400, Jason Baron wrote:
> > +#include <linux/dynamic_debug_cpufreq.h>
> 
> what's contained in this file (couldn't find it in this or one of the other
> diffs, but may have missed it).
> 

i forgot to include it. A full patch is found below.

> > -#define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "cpufreq-nforce2", msg)
> > +#define dprintk(msg...) do { \
> > +	if (dynamic_dbg_enabled(TYPE_FLAG, CPUFREQ_DEBUG_DRIVER, cpufreq_debug)) \
> > +		cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "cpufreq-nforce2", msg); \
> > +	} while (0)
> 
> Hm.... What about leaving this as it is, renaming the
> drivers/cpufreq/cpufreq.c function to __cpufreq_debug_printk(), and then
> adding to include/linux/cpufreq.h
> 
> #define cpufreq_debug_printk(type, prefix, msg...) do { \
> 	if (dynamic_dbg_enabled(TYPE_FLAG, type, cpufreq_debug))
> 		cpufreq_debug_printk(type, prefix, msg); \
> 	} while (0)
> 

i agree that would be a bit cleaner. the new patch below includes this suggestion.


> > +#if defined(CONFIG_CPU_FREQ_DEBUG) || defined (CONFIG_DYNAMIC_PRINTK_DEBUG)
> ...
> > +#if defined(CONFIG_CPU_FREQ_DEBUG) || defined (CONFIG_DYNAMIC_PRINTK_DEBUG)
> 
> can't we just depend on thing on another?
> 

We could make CONFIG_CPU_FREQ_DEBUG force CONFIG_DYNAMIC_PRINTK_DEBUG to be on.
However, i'm trying to allow CONFIG_CPU_FREQ_DEBUG to be turned on without
enabling CONFIG_DYNAMIC_PRINTK_DEBUG. That's consistent with how i'm trying to
do this patch series. That is, individual subsystems can turn their respective
debugging on without forcing on CONFIG_DYNAMIC_PRINTK_DEBUG.

> > -module_param(debug, uint, 0644);
> > -MODULE_PARM_DESC(debug, "CPUfreq debugging: add 1 to debug core,"
> > +module_param(cpufreq_debug, uint, 0644);
> > +MODULE_PARM_DESC(cpufreq_debug, "CPUfreq debugging: add 1 to debug core,"
> >  			" 2 to debug drivers, and 4 to debug governors.");
> 
> cpufreq.cpufreq_debug is ugly and not backwards compatible... what about 
> 
> module_param_named(debug, cpufreq_debug, uint, 0644) [or the other way
> around, I always forget...])
> 

makes sense. 

thanks,

-Jason


diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index e2d870d..549edbd 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -25,6 +25,7 @@
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
 
+#include <linux/dynamic_debug_cpufreq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
diff --git a/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c b/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
index f03e915..3eb343d 100644
--- a/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
+++ b/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
@@ -7,6 +7,7 @@
  *  BIG FAT DISCLAIMER: Work in progress code. Possibly *dangerous*
  */
 
+#include <linux/dynamic_debug_cpufreq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
diff --git a/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c b/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c
index 9d9eae8..212204f 100644
--- a/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c
+++ b/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c
@@ -73,6 +73,7 @@
  *			Suspend Modulation - Definitions		*
  ************************************************************************/
 
+#include <linux/dynamic_debug_cpufreq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
diff --git a/arch/x86/kernel/cpu/cpufreq/longhaul.c b/arch/x86/kernel/cpu/cpufreq/longhaul.c
index 06fcce5..b910935 100644
--- a/arch/x86/kernel/cpu/cpufreq/longhaul.c
+++ b/arch/x86/kernel/cpu/cpufreq/longhaul.c
@@ -21,6 +21,7 @@
  *  BIG FAT DISCLAIMER: Work in progress code. Possibly *dangerous*
  */
 
+#include <linux/dynamic_debug_cpufreq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
diff --git a/arch/x86/kernel/cpu/cpufreq/longrun.c b/arch/x86/kernel/cpu/cpufreq/longrun.c
index af4a867..11ce4fa 100644
--- a/arch/x86/kernel/cpu/cpufreq/longrun.c
+++ b/arch/x86/kernel/cpu/cpufreq/longrun.c
@@ -6,6 +6,7 @@
  *  BIG FAT DISCLAIMER: Work in progress code. Possibly *dangerous*
  */
 
+#include <linux/dynamic_debug_cpufreq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
diff --git a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
index 199e4e0..868cda4 100644
--- a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
+++ b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
@@ -20,6 +20,7 @@
  *
  */
 
+#include <linux/dynamic_debug_cpufreq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k7.c b/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
index 0a61159..1305afb 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
@@ -12,6 +12,7 @@
  * - We disable half multipliers if ACPI is used on A0 stepping CPUs.
  */
 
+#include <linux/dynamic_debug_cpufreq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 46d4034..d18f9bd 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -24,6 +24,7 @@
  *     http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/30430.pdf
  */
 
+#include <linux/dynamic_debug_cpufreq.h>
 #include <linux/kernel.h>
 #include <linux/smp.h>
 #include <linux/module.h>
diff --git a/arch/x86/kernel/cpu/cpufreq/sc520_freq.c b/arch/x86/kernel/cpu/cpufreq/sc520_freq.c
index 42da9bd..7da87dd 100644
--- a/arch/x86/kernel/cpu/cpufreq/sc520_freq.c
+++ b/arch/x86/kernel/cpu/cpufreq/sc520_freq.c
@@ -13,6 +13,7 @@
  *	2005-03-30: - initial revision
  */
 
+#include <linux/dynamic_debug_cpufreq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
index 908dd34..6fcd23f 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -13,6 +13,7 @@
  * Copyright (C) 2003 Jeremy Fitzhardinge <jeremy@goop.org>
  */
 
+#include <linux/dynamic_debug_cpufreq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
index 1b50244..43dd80e 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -18,6 +18,7 @@
  *                        SPEEDSTEP - DEFINITIONS                    *
  *********************************************************************/
 
+#include <linux/dynamic_debug_cpufreq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c b/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
index 8a85c93..8aef4bf 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
@@ -12,6 +12,7 @@
  *                        SPEEDSTEP - DEFINITIONS                    *
  *********************************************************************/
 
+#include <linux/dynamic_debug_cpufreq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 35a26a3..c4b0666 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -15,6 +15,7 @@
  *
  */
 
+#include <linux/dynamic_debug_cpufreq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -179,10 +180,7 @@ EXPORT_SYMBOL_GPL(cpufreq_cpu_put);
 /*********************************************************************
  *                     UNIFIED DEBUG HELPERS                         *
  *********************************************************************/
-#ifdef CONFIG_CPU_FREQ_DEBUG
-
-/* what part(s) of the CPUfreq subsystem are debugged? */
-static unsigned int debug;
+#if defined(CONFIG_CPU_FREQ_DEBUG) || defined (CONFIG_DYNAMIC_PRINTK_DEBUG)
 
 /* is the debug output ratelimit'ed using printk_ratelimit? User can
  * set or modify this value.
@@ -215,7 +213,7 @@ static void cpufreq_debug_disable_ratelimit(void)
 	spin_unlock_irqrestore(&disable_ratelimit_lock, flags);
 }
 
-void cpufreq_debug_printk(unsigned int type, const char *prefix,
+void __cpufreq_debug_printk(unsigned int type, const char *prefix,
 							const char *fmt, ...)
 {
 	char s[256];
@@ -224,32 +222,32 @@ void cpufreq_debug_printk(unsigned int type, const char *prefix,
 	unsigned long flags;
 
 	WARN_ON(!prefix);
-	if (type & debug) {
-		spin_lock_irqsave(&disable_ratelimit_lock, flags);
-		if (!disable_ratelimit && debug_ratelimit
-					&& !printk_ratelimit()) {
-			spin_unlock_irqrestore(&disable_ratelimit_lock, flags);
-			return;
-		}
+	spin_lock_irqsave(&disable_ratelimit_lock, flags);
+	if (!disable_ratelimit && debug_ratelimit
+				&& !printk_ratelimit()) {
 		spin_unlock_irqrestore(&disable_ratelimit_lock, flags);
+		return;
+	}	
+	spin_unlock_irqrestore(&disable_ratelimit_lock, flags);
 
-		len = snprintf(s, 256, KERN_DEBUG "%s: ", prefix);
+	len = snprintf(s, 256, KERN_DEBUG "%s: ", prefix);
 
-		va_start(args, fmt);
-		len += vsnprintf(&s[len], (256 - len), fmt, args);
-		va_end(args);
+	va_start(args, fmt);
+	len += vsnprintf(&s[len], (256 - len), fmt, args);
+	va_end(args);
 
-		printk(s);
+	printk(s);
 
-		WARN_ON(len < 5);
-	}
+	WARN_ON(len < 5);
 }
-EXPORT_SYMBOL(cpufreq_debug_printk);
+EXPORT_SYMBOL(__cpufreq_debug_printk);
 
 
-module_param(debug, uint, 0644);
+unsigned int cpufreq_debug;
+EXPORT_SYMBOL_GPL(cpufreq_debug);
+module_param_named(debug, cpufreq_debug, uint, 0644);
 MODULE_PARM_DESC(debug, "CPUfreq debugging: add 1 to debug core,"
-			" 2 to debug drivers, and 4 to debug governors.");
+				" 2 to debug drivers, and 4 to debug governors.");
 
 module_param(debug_ratelimit, uint, 0644);
 MODULE_PARM_DESC(debug_ratelimit, "CPUfreq debugging:"
diff --git a/drivers/cpufreq/cpufreq_performance.c b/drivers/cpufreq/cpufreq_performance.c
index e8e1451..cee0e66 100644
--- a/drivers/cpufreq/cpufreq_performance.c
+++ b/drivers/cpufreq/cpufreq_performance.c
@@ -10,6 +10,7 @@
  *
  */
 
+#include <linux/dynamic_debug_cpufreq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/cpufreq.h>
diff --git a/drivers/cpufreq/cpufreq_powersave.c b/drivers/cpufreq/cpufreq_powersave.c
index 13fe06b..4680ccc 100644
--- a/drivers/cpufreq/cpufreq_powersave.c
+++ b/drivers/cpufreq/cpufreq_powersave.c
@@ -10,6 +10,7 @@
  *
  */
 
+#include <linux/dynamic_debug_cpufreq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/cpufreq.h>
diff --git a/drivers/cpufreq/cpufreq_userspace.c b/drivers/cpufreq/cpufreq_userspace.c
index cb2ac01..8a33636 100644
--- a/drivers/cpufreq/cpufreq_userspace.c
+++ b/drivers/cpufreq/cpufreq_userspace.c
@@ -11,6 +11,7 @@
  *
  */
 
+#include <linux/dynamic_debug_cpufreq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/smp.h>
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index ae6cd60..506cc33 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2002 - 2003 Dominik Brodowski
  */
 
+#include <linux/dynamic_debug_cpufreq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index ddd8652..74ce70f 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -366,14 +366,19 @@ void cpufreq_frequency_table_put_attr(unsigned int cpu);
 #define CPUFREQ_DEBUG_DRIVER	2
 #define CPUFREQ_DEBUG_GOVERNOR	4
 
-#ifdef CONFIG_CPU_FREQ_DEBUG
+#define cpufreq_debug_printk(flag, name, msg...) do { \
+	if (dynamic_dbg_enabled(TYPE_FLAG, flag, cpufreq_debug)) \
+		__cpufreq_debug_printk(flag, name, msg); \
+	} while (0)
 
-extern void cpufreq_debug_printk(unsigned int type, const char *prefix, 
-				 const char *fmt, ...);
+#if defined(CONFIG_CPU_FREQ_DEBUG) || defined (CONFIG_DYNAMIC_PRINTK_DEBUG)
 
+extern unsigned int cpufreq_debug;
+extern void __cpufreq_debug_printk(unsigned int type, const char *prefix, 
+				 const char *fmt, ...);
 #else
 
-#define cpufreq_debug_printk(msg...) do { } while(0)
+#define __cpufreq_debug_printk(msg...) do { } while(0)
 
 #endif /* CONFIG_CPU_FREQ_DEBUG */
 
diff --git a/include/linux/dynamic_debug_cpufreq.h b/include/linux/dynamic_debug_cpufreq.h
new file mode 100644
index 0000000..b0cff6d
--- /dev/null
+++ b/include/linux/dynamic_debug_cpufreq.h
@@ -0,0 +1,8 @@
+#define DYNAMIC_DEBUG_NUM_FLAGS "3"
+#define DYNAMIC_DEBUG_FLAG_NAMES "CPUFREQ_DEBUG_CORE,CPUFREQ_DEBUG_DRIVER,CPUFREQ_DEBUG_GOVERNOR"
+#define DYNAMIC_DEBUG_TYPE "2"
+#define DYNAMIC_DEBUG_MODNAME "cpufreq_shared"
+
+#ifdef CONFIG_CPU_FREQ_DEBUG
+#define DEBUG 1
+#endif



