Return-Path: <linux-kernel-owner+w=401wt.eu-S1759635AbYDAWyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635AbYDAWyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 18:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYDAWyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 18:54:25 -0400
Received: from relay2.sgi.com ([192.48.171.30]:39588 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751685AbYDAWyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 18:54:23 -0400
Message-Id: <20080401225422.244656000@polaris-admin.engr.sgi.com>
References: <20080401225422.064890000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 01 Apr 2008 15:54:23 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Paul Jackson <pj@sgi.com>,
       Bert Wesarg <bert.wesarg@googlemail.com>
Subject: [PATCH 1/3] x86: add cpuset_scnprintf function
Content-Disposition: inline; filename=add-cpuset_scnprintf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new cpuset_scnprintf() function and a sysctl flag to control
how cpumask sets are printed.  The default is to use the current
cpumask_scnprintf().  If kernel.compat_cpuset_printf is '0' (default 1),
then cpulist_scnprintf() is used.  A nodeset_scnprintf() function is
also provided for compatibilty.

This is introduced with a CONFIG_KERN_COMPAT_CPUSET_PRINTF flag which
currently is only defined for X86_64_SMP architecture.

In addition, remove the cpumask_scnprintf_len() function.

This is all needed to accomodate large NR_CPUS count and the usage has
been added to Documentation/sysctl/kernel.txt.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Cc: Bert Wesarg <bert.wesarg@googlemail.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 Documentation/sysctl/kernel.txt |   34 ++++++++++++++++++++++++++++++++++
 arch/x86/Kconfig                |    4 ++++
 arch/x86/kernel/setup.c         |    5 +++++
 include/linux/bitmap.h          |    1 -
 include/linux/cpumask.h         |   22 +++++++++++++++-------
 include/linux/nodemask.h        |   17 +++++++++++++++++
 kernel/sysctl.c                 |   11 +++++++++++
 lib/bitmap.c                    |   16 ----------------
 8 files changed, 86 insertions(+), 24 deletions(-)

--- linux-2.6.x86.orig/Documentation/sysctl/kernel.txt
+++ linux-2.6.x86/Documentation/sysctl/kernel.txt
@@ -18,6 +18,7 @@ Currently, these files might (depending 
 show up in /proc/sys/kernel:
 - acpi_video_flags
 - acct
+- compat_cpuset_printf
 - core_pattern
 - core_uses_pid
 - ctrl-alt-del
@@ -85,6 +86,39 @@ valid for 30 seconds.
 
 ==============================================================
 
+compat_cpuset_printf:
+
+compat_cpuset_printf is used to alter the way cpumask_t cpusets
+are printed.  To maintain compatibility with the current output
+format, the default is '1', which results in a lengthy printout
+when the number of cpus in a system is large.  An example when
+NR_CPUS=4096 and compat_cpuset_printf = '1':
+
+    # cat /sys/devices/system/cpu/cpu3/cache/index0/shared_cpu_map
+    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
+    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
+    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
+    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
+    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
+    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
+    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
+    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
+    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
+    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
+    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
+    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
+    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
+    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
+    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
+    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000008
+
+The same example when compat_cpuset_printf = '0':
+
+    # cat /sys/devices/system/cpu/cpu3/cache/index0/shared_cpu_map
+    3
+
+==============================================================
+
 core_pattern:
 
 core_pattern is used to specify a core dumpfile pattern name.
--- linux-2.6.x86.orig/arch/x86/Kconfig
+++ linux-2.6.x86/arch/x86/Kconfig
@@ -189,6 +189,10 @@ config X86_TRAMPOLINE
 	depends on X86_SMP || (X86_VOYAGER && SMP)
 	default y
 
+config KERN_COMPAT_CPUSET_PRINTF
+	bool
+	default X86_64_SMP
+
 config KTIME_SCALAR
 	def_bool X86_32
 source "init/Kconfig"
--- linux-2.6.x86.orig/arch/x86/kernel/setup.c
+++ linux-2.6.x86/arch/x86/kernel/setup.c
@@ -10,6 +10,11 @@
 #include <asm/setup.h>
 #include <asm/topology.h>
 
+#ifdef CONFIG_KERN_COMPAT_CPUSET_PRINTF
+/* select cpuset_scnprintf output */
+int compat_cpuset_printf = 1;
+#endif
+
 #if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_SMP)
 /*
  * Copy data used in early init routines from the initial arrays to the
--- linux-2.6.x86.orig/include/linux/bitmap.h
+++ linux-2.6.x86/include/linux/bitmap.h
@@ -108,7 +108,6 @@ extern int __bitmap_weight(const unsigne
 
 extern int bitmap_scnprintf(char *buf, unsigned int len,
 			const unsigned long *src, int nbits);
-extern int bitmap_scnprintf_len(unsigned int len);
 extern int __bitmap_parse(const char *buf, unsigned int buflen, int is_user,
 			unsigned long *dst, int nbits);
 extern int bitmap_parse_user(const char __user *ubuf, unsigned int ulen,
--- linux-2.6.x86.orig/include/linux/cpumask.h
+++ linux-2.6.x86/include/linux/cpumask.h
@@ -273,13 +273,6 @@ static inline int __cpumask_scnprintf(ch
 	return bitmap_scnprintf(buf, len, srcp->bits, nbits);
 }
 
-#define cpumask_scnprintf_len(len) \
-			__cpumask_scnprintf_len((len))
-static inline int __cpumask_scnprintf_len(int len)
-{
-	return bitmap_scnprintf_len(len);
-}
-
 #define cpumask_parse_user(ubuf, ulen, dst) \
 			__cpumask_parse_user((ubuf), (ulen), &(dst), NR_CPUS)
 static inline int __cpumask_parse_user(const char __user *buf, int len,
@@ -302,6 +295,21 @@ static inline int __cpulist_parse(const 
 	return bitmap_parselist(buf, dstp->bits, nbits);
 }
 
+#ifdef	CONFIG_KERN_COMPAT_CPUSET_PRINTF
+#define	cpuset_scnprintf(buf, len, src) __cpuset_scnprintf((buf), (len), &(src))
+static inline int __cpuset_scnprintf(char *buf, int len, const cpumask_t *srcp)
+{
+	extern int compat_cpuset_printf;
+
+	if (compat_cpuset_printf)
+		return __cpumask_scnprintf(buf, len, srcp, NR_CPUS);
+	else
+		return __cpulist_scnprintf(buf, len, srcp, NR_CPUS);
+}
+#else
+#define cpuset_scnprintf(buf, len, src)	cpumask_scnprintf(buf, len, src)
+#endif
+
 #define cpu_remap(oldbit, old, new) \
 		__cpu_remap((oldbit), &(old), &(new), NR_CPUS)
 static inline int __cpu_remap(int oldbit,
--- linux-2.6.x86.orig/include/linux/nodemask.h
+++ linux-2.6.x86/include/linux/nodemask.h
@@ -310,6 +310,23 @@ static inline int __nodelist_parse(const
 	return bitmap_parselist(buf, dstp->bits, nbits);
 }
 
+#ifdef	CONFIG_KERN_COMPAT_CPUSET_PRINTF
+#define	nodeset_scnprintf(buf, len, src) \
+			__nodeset_scnprintf((buf), (len), &(src))
+static inline int __nodeset_scnprintf(char *buf, int len, const nodemask_t *srcp)
+{
+	extern int compat_cpuset_printf;
+
+	if (compat_cpuset_printf)
+		return __nodemask_scnprintf(buf, len, srcp, MAX_NUMNODES);
+	else
+		return __nodelist_scnprintf(buf, len, srcp, MAX_NUMNODES);
+}
+#else
+#define nodeset_scnprintf(buf, len, src) nodemask_scnprintf(buf, len, src)
+#endif
+
+
 #define node_remap(oldbit, old, new) \
 		__node_remap((oldbit), &(old), &(new), MAX_NUMNODES)
 static inline int __node_remap(int oldbit,
--- linux-2.6.x86.orig/kernel/sysctl.c
+++ linux-2.6.x86/kernel/sysctl.c
@@ -82,6 +82,7 @@ extern int compat_log;
 extern int maps_protect;
 extern int sysctl_stat_interval;
 extern int latencytop_enabled;
+extern int compat_cpuset_printf;
 
 /* Constants used for minimum and  maximum */
 #if defined(CONFIG_DETECT_SOFTLOCKUP) || defined(CONFIG_HIGHMEM)
@@ -831,6 +832,16 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_KERN_COMPAT_CPUSET_PRINTF
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "compat_cpuset_printf",
+		.data		= &compat_cpuset_printf,
+		.maxlen		= sizeof (int),
+	 	.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
 
 /*
  * NOTE: do not add new entries to this table unless you have read
--- linux-2.6.x86.orig/lib/bitmap.c
+++ linux-2.6.x86/lib/bitmap.c
@@ -316,22 +316,6 @@ int bitmap_scnprintf(char *buf, unsigned
 EXPORT_SYMBOL(bitmap_scnprintf);
 
 /**
- * bitmap_scnprintf_len - return buffer length needed to convert
- * bitmap to an ASCII hex string.
- * @len: number of bits to be converted
- */
-int bitmap_scnprintf_len(unsigned int len)
-{
-	/* we need 9 chars per word for 32 bit words (8 hexdigits + sep/null) */
-	int bitslen = ALIGN(len, CHUNKSZ);
-	int wordlen = CHUNKSZ / 4;
-	int buflen = (bitslen / wordlen) * (wordlen + 1) * sizeof(char);
-
-	return buflen;
-}
-EXPORT_SYMBOL(bitmap_scnprintf_len);
-
-/**
  * __bitmap_parse - convert an ASCII hex string into a bitmap.
  * @buf: pointer to buffer containing string.
  * @buflen: buffer size in bytes.  If string is smaller than this

-- 
