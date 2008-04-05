Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYDEB0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYDEB0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 21:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbYDEBZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 21:25:24 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34837 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751362AbYDEBYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 21:24:49 -0400
Message-Id: <20080405012447.631132000@polaris-admin.engr.sgi.com>
References: <20080405012447.440875000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 18:24:48 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] x86: add cpus_scnprintf function v2
Content-Disposition: inline; filename=add-cpus_scnprintf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Add a new cpus_scnprintf() function and a sysctl flag to control
    how cpumask sets are printed.  The default is to use the current
    cpumask_scnprintf().  If kernel.compat_cpus_printf is '0' (default 1),
    then cpulist_scnprintf() is used.  A nodes_scnprintf() function is
    also provided for compatibilty.

    Note that setting the kernel.compat_cpus_printf to '0' also makes the
    syntax compatible with the setting and showing of cpuset parameters
    such as cpu_exclusive and mem_exclusive.

    This is introduced with a CONFIG_KERN_COMPAT_CPUSET_PRINTF flag which
    currently is only defined for X86_64_SMP architecture.

  * In addition, remove the cpumask_scnprintf_len() function.

This is all needed to accomodate large NR_CPUS count and the usage has
been added to Documentation/sysctl/kernel.txt.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
v2:
    Renamed cpuset_scnprintf() to cpus_scnprintf to avoid confusion with
    "cpusets", and changed the other names to match.

    Added a sentinel character ('+') for the cpulist type output so scripts
    can be written to handle both cases.

    Added a warning in the Documentation/sysctl/kernel.txt that changing this
    option may break scripts and programs that rely on the current format.
    Also provided example on how to process the output.
---
 Documentation/sysctl/kernel.txt |   56 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/Kconfig                |    4 ++
 arch/x86/kernel/setup.c         |    5 +++
 include/linux/bitmap.h          |    1 
 include/linux/cpumask.h         |   35 ++++++++++++++++++++-----
 include/linux/nodemask.h        |   31 ++++++++++++++++++++++
 kernel/sysctl.c                 |   11 +++++++
 lib/bitmap.c                    |   16 -----------
 8 files changed, 135 insertions(+), 24 deletions(-)

--- linux-2.6.x86.orig/Documentation/sysctl/kernel.txt
+++ linux-2.6.x86/Documentation/sysctl/kernel.txt
@@ -18,6 +18,7 @@ Currently, these files might (depending 
 show up in /proc/sys/kernel:
 - acpi_video_flags
 - acct
+- compat_cpus_printf
 - core_pattern
 - core_uses_pid
 - ctrl-alt-del
@@ -85,6 +86,61 @@ valid for 30 seconds.
 
 ==============================================================
 
+compat_cpus_printf:
+
+compat_cpus_printf is used to alter the way cpumask_t cpu bits
+are printed.  To maintain compatibility with the current output
+format, the default is '1'.
+
+** DO NOT CHANGE THIS ** if you run programs or scripts which may
+rely on the current format until you are certain they can handle the
+newer, more compact format.  If you change the format, it will apply
+to all programs that access common /proc and /sys interfaces.
+
+The current format results in the following print when the number
+of cpus in a system is large.  An example when NR_CPUS is 4096 and
+compat_cpus_printf is '1':
+
+    # cat /sys/devices/system/cpu/cpu92/cache/index2/shared_cpu_map
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
+    00000000,00000000,00000000,00000000,00000000,33000000,00000000,00000000
+
+The same example when compat_cpus_printf = '0':
+
+    # echo 0 > /proc/sys/kernel/compat_cpus_printf
+    # cat /sys/devices/system/cpu/cpu3/cache/index0/shared_cpu_map
+    +88-89,92-93
+
+Note that when the "non-compatibile" (or "cpulist") format is  specified,
+a preceeding '+' is output.  This allows user scripts and programs that
+process the output to distinguish which format is present:
+
+	if (buf[0] == '+')
+		bitmask_parselist(&buf[1], ...);
+	else
+		bitmask_parsehex(buf, ...);
+
+See libbitmask(3) for details on parsing the output.
+
+In addition to conversion of cpumask_t cpu bits, nodemask_t bits are
+handled the same way.
+
+==============================================================
+
 core_pattern:
 
 core_pattern is used to specify a core dumpfile pattern name.
--- linux-2.6.x86.orig/arch/x86/Kconfig
+++ linux-2.6.x86/arch/x86/Kconfig
@@ -192,6 +192,10 @@ config X86_TRAMPOLINE
 	depends on X86_SMP || (X86_VOYAGER && SMP)
 	default y
 
+config KERN_COMPAT_CPUS_PRINTF
+	bool
+	default X86_64_SMP
+
 config KTIME_SCALAR
 	def_bool X86_32
 source "init/Kconfig"
--- linux-2.6.x86.orig/arch/x86/kernel/setup.c
+++ linux-2.6.x86/arch/x86/kernel/setup.c
@@ -25,6 +25,11 @@ static void __init setup_nr_cpu_ids(void
 static inline void setup_nr_cpu_ids(void) { }
 #endif
 
+#ifdef CONFIG_KERN_COMPAT_CPUS_PRINTF
+/* select cpus_scnprintf output */
+int compat_cpus_printf = 1;
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
@@ -14,6 +14,8 @@
  * bitmap_scnlistprintf() and bitmap_parselist(), also in bitmap.c.
  * For details of cpu_remap(), see bitmap_bitremap in lib/bitmap.c
  * For details of cpus_remap(), see bitmap_remap in lib/bitmap.c.
+ * For details of cpus_scnprintf(), see compat_cpus_printf in
+ * Documentation/sysctl/kernel.txt.
  *
  * The available cpumask operations are:
  *
@@ -52,6 +54,9 @@
  * int cpumask_parse_user(ubuf, ulen, mask)	Parse ascii string as cpumask
  * int cpulist_scnprintf(buf, len, mask) Format cpumask as list for printing
  * int cpulist_parse(buf, map)		Parse ascii string as cpulist
+ * int cpus_scnprintf(buf, len, mask)	Format cpumask with either
+ *					cpumask_scnprintf or cpulist_scnprintf
+ *					based on the value of compat_cpus_printf
  * int cpu_remap(oldbit, old, new)	newbit = map(old, new)(oldbit)
  * int cpus_remap(dst, src, old, new)	*dst = map(old, new)(src)
  *
@@ -285,13 +290,6 @@ static inline int __cpumask_scnprintf(ch
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
@@ -314,6 +312,29 @@ static inline int __cpulist_parse(const 
 	return bitmap_parselist(buf, dstp->bits, nbits);
 }
 
+#ifdef	CONFIG_KERN_COMPAT_CPUS_PRINTF
+#define	cpus_scnprintf(buf, len, src) __cpus_scnprintf((buf), (len), &(src))
+static inline int __cpus_scnprintf(char *buf, int len, const cpumask_t *srcp)
+{
+	extern int compat_cpus_printf;
+
+	if (compat_cpus_printf)
+		return __cpumask_scnprintf(buf, len, srcp, NR_CPUS);
+	else {
+		int n = 0;
+		if (len > 1) {
+			*buf++ = '+';
+			*buf = '\0';
+			n = __cpulist_scnprintf(buf, len-1, srcp, NR_CPUS);
+			n++;
+		}
+		return n;
+	}
+}
+#else
+#define cpus_scnprintf(buf, len, src)	cpumask_scnprintf(buf, len, src)
+#endif
+
 #define cpu_remap(oldbit, old, new) \
 		__cpu_remap((oldbit), &(old), &(new), NR_CPUS)
 static inline int __cpu_remap(int oldbit,
--- linux-2.6.x86.orig/include/linux/nodemask.h
+++ linux-2.6.x86/include/linux/nodemask.h
@@ -14,6 +14,8 @@
  * bitmap_scnlistprintf() and bitmap_parselist(), also in bitmap.c.
  * For details of node_remap(), see bitmap_bitremap in lib/bitmap.c.
  * For details of nodes_remap(), see bitmap_remap in lib/bitmap.c.
+ * For details of nodes_scnprintf(), see compat_cpus_printf in
+ * Documentation/sysctl/kernel.txt.
  *
  * The available nodemask operations are:
  *
@@ -54,6 +56,9 @@
  * int nodemask_parse_user(ubuf, ulen, mask)	Parse ascii string as nodemask
  * int nodelist_scnprintf(buf, len, mask) Format nodemask as list for printing
  * int nodelist_parse(buf, map)		Parse ascii string as nodelist
+ * int nodes_scnprintf(buf, len, mask)	Format nodemask with either
+ *					nodemask_scnprintf or nodelist_scnprintf
+ *					based on the value of compat_cpus_printf
  * int node_remap(oldbit, old, new)	newbit = map(old, new)(oldbit)
  * int nodes_remap(dst, src, old, new)	*dst = map(old, new)(dst)
  *
@@ -310,6 +315,32 @@ static inline int __nodelist_parse(const
 	return bitmap_parselist(buf, dstp->bits, nbits);
 }
 
+#ifdef	CONFIG_KERN_COMPAT_CPUS_PRINTF
+#define	nodes_scnprintf(buf, len, src) \
+			__nodes_scnprintf((buf), (len), &(src))
+static inline int __nodes_scnprintf(char *buf, int len, const nodemask_t *srcp)
+{
+	extern int compat_cpus_printf;
+
+	if (compat_cpus_printf)
+		return __nodemask_scnprintf(buf, len, srcp, MAX_NUMNODES);
+	else {
+		int n = 0;
+		if (len > 1) {
+			*buf++ = '+';
+			*buf = '\0';
+			n = __nodelist_scnprintf(buf, len-1, srcp,
+								MAX_NUMNODES);
+			n++;
+		}
+		return n;
+	}
+}
+#else
+#define nodes_scnprintf(buf, len, src) nodemask_scnprintf(buf, len, src)
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
+extern int compat_cpus_printf;
 
 /* Constants used for minimum and  maximum */
 #if defined(CONFIG_DETECT_SOFTLOCKUP) || defined(CONFIG_HIGHMEM)
@@ -831,6 +832,16 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_KERN_COMPAT_CPUS_PRINTF
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "compat_cpus_printf",
+		.data		= &compat_cpus_printf,
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
