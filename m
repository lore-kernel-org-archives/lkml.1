Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbXEaPUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbXEaPUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 11:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbXEaPUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 11:20:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:41068 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbXEaPUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 11:20:41 -0400
Subject: [PATCH] ACPI Debug - for test, devel and possibly even for
	production kernels
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: linux-acpi <linux-acpi@vger.kernel.org>
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi
Content-Type: multipart/mixed; boundary="=-xyvU1g5qwTRQNL2OS8Wi"
Organization: Novell/SUSE
Date: Thu, 31 May 2007 17:20:39 +0200
Message-Id: <1180624839.10908.71.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xyvU1g5qwTRQNL2OS8Wi
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

we only make use of a small subset of current ACPI tables.
ACPI spreads more and more over different parts of the kernel and it's
likely that this will hold on.

ACPI_DEBUG=y is a powerful debug facility, that can ease up bug
communication with less (ACPI) experienced bug submitters and can shed
some light behind ACPI magic.

I've done some measurements and found out that most of the performance
costs are due the function tracing support in the ACPICA debug
subsystem.

This patch offers the possibility to compile out ACPI function tracing
support which is of none use for ordinary kernel debugging (is only used
for Intel internal debugging AFAIK), but takes most of the performance
costs.
(This should efficiently be the same as the proposed big patch a year
ago from Pekka Enberg, just a bit smaller and should make ACPICA and
kernel/linux people happy:
http://marc.info/?l=linux-kernel&m=113699535303722&w=2
)


Kernel image size (compiled on x86_64):
Full acpi debug:
1618277 bytes (+3.1%, +48k)
acpi debug function trace compiled out:
1605359 bytes (+2.3%, +35k)
acpi debug not compiled in at all
1569803 bytes (100%)


Speed measures on one specific machine (x86_64, laptop):

A) ACPI_DEBUG compiled in
B) ACPI_DEBUG compiled in, but Function trace compiled out
C) ACPI_DEBUG compiled out
D) ACPI_DEBUG compiled out (control run)

The time has been taken at following functions:

1) drivers/acpi/bus.c:acpi_early_init (load tables and initialize
                                       ACPI namespace)
2) drivers/acpi/bus.c:acpi_init (some more initialisation
                                 -> enable ACPI HW mode
                                 -> read PIC/APIC table, ...)
3) drivers/acpi/scan.c:scan_init (Enumerate devices in the
                                  ACPI namespace)

register driver for acpi drivers:
4)  ec
5)  pci_root
6)  pci_link

-----------------------------------------------------------------------
  |      A         |       B        |       C        |     D          | 
-----------------------------------------------------------------------
1 | 434711 (+1.0%) | 432652 (+0.4%) |  430522 (100%) |  430512 (-0.00%)
-----------------------------------------------------------------------
2 |  69156 (+3.7%) |  67007 (+0.4%) |   66696 (100%) |   66703 (+0.01%)
-----------------------------------------------------------------------
3 |   8769(+63.3%) |   7363(+37.1%) |    5369 (100%) |    5369 ( 0.00%)
-----------------------------------------------------------------------
4 |  15999 (+0.7%) |  15950 (+0.4%) |   15879 (100%) |   15878 (-0.01%)
-----------------------------------------------------------------------
5 |   9492(+75.4%) |   7657(+41.5%) |    5411 (100%) |    5405 (-0.11%)
-----------------------------------------------------------------------
6 |   1717(+64.0%) |   1494(+42.6%) |    1047 (100%) |    1046 (-0.10%)
-----------------------------------------------------------------------
All measured values are in us. TSC was used to obtain the values.
do_gettimeofday did only provide valid values after hpet got setup
(after pci_link).

I wonder why only the short time taking measures show that extreme
performance loss, maybe someone has an idea. However if you summarize
all additional time with ACPI_DEBUG without function trace, you get
about +5 ms boot time (which may vary from machine to machine...).
This should be acceptable for test and develop kernels.
If nothing bad happens in Beta phase I'd like to include this one into
the final OpenSUSE kernel to get detailed bug reports.
It would be great if others with their latest test/devel kernels follow,
so that even ordinary users can easily provide essential, detailed debug
information easily(e.g. Linus' Compaq and Andrew's Vaio are well known
on the acpi list, others do not have the luck to get that much of
support and they do not have the knowledge to compile kernel and so
on...).

I can also add a file "Documentation/acpi_debug" and add some debug
hints if this one gets accepted...

This one should not be really dangerous. If the patch is ok, can Len
still merge this in .22 time?
If not, can you take it for some testing, Andrew?

Thanks,

   Thomas



Split ACPI_DEBUG into function trace enabled and not enabled.

Function trace is most of the ACPI_DEBUG costs, but is
not much of use for kernel ACPI debugging.

Size of kernel image increased on test compile:
+ 48k  (Full ACPI_DEBUG)
+ 35k  (ACPI_DEBUG with function trace compiled out)

Performance without function trace is also much better.

Also remove ACPI_LV_DEBUG_OBJECT from default debug level as
a lot vendors let Store (value, debug) in their code and this
might confuse users when it pops up in syslog.

---
 drivers/acpi/Kconfig    |    8 ++++++++
 include/acpi/acmacros.h |   23 +++++++++++++++++++++++
 include/acpi/acoutput.h |    4 ++--
 3 files changed, 33 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc3/drivers/acpi/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/drivers/acpi/Kconfig
+++ linux-2.6.22-rc3/drivers/acpi/Kconfig
@@ -280,6 +280,14 @@ config ACPI_DEBUG
 	  of verbosity. Saying Y enables these statements. This will increase
 	  your kernel size by around 50K.
 
+config ACPI_DEBUG_FUNC_TRACE
+	bool "Additionally enable ACPI function tracing"
+	default n
+	depends on ACPI_DEBUG
+	help
+	  ACPI Debug Statements slow down ACPI processing. Function trace
+	  is about half of the penalty and is rarely useful.
+
 config ACPI_EC
 	bool
 	default y
Index: linux-2.6.22-rc3/include/acpi/acmacros.h
===================================================================
--- linux-2.6.22-rc3.orig/include/acpi/acmacros.h
+++ linux-2.6.22-rc3/include/acpi/acmacros.h
@@ -486,6 +486,8 @@
 #define ACPI_FUNCTION_NAME(name)
 #endif
 
+#ifdef DEBUG_FUNC_TRACE
+
 #define ACPI_FUNCTION_TRACE(a)          ACPI_FUNCTION_NAME(a) \
 			  acpi_ut_trace(ACPI_DEBUG_PARAMETERS)
 #define ACPI_FUNCTION_TRACE_PTR(a,b)    ACPI_FUNCTION_NAME(a) \
@@ -563,6 +565,27 @@
 
 #endif				/* ACPI_SIMPLE_RETURN_MACROS */
 
+#else /* !DEBUG_FUNC_TRACE */
+
+#define ACPI_FUNCTION_TRACE(a)
+#define ACPI_FUNCTION_TRACE_PTR(a,b)
+#define ACPI_FUNCTION_TRACE_U32(a,b)
+#define ACPI_FUNCTION_TRACE_STR(a,b)
+#define ACPI_FUNCTION_EXIT
+#define ACPI_FUNCTION_STATUS_EXIT(s)
+#define ACPI_FUNCTION_VALUE_EXIT(s)
+#define ACPI_FUNCTION_TRACE(a)
+#define ACPI_FUNCTION_ENTRY()
+
+#define return_VOID                     return
+#define return_ACPI_STATUS(s)           return(s)
+#define return_VALUE(s)                 return(s)
+#define return_UINT8(s)                 return(s)
+#define return_UINT32(s)                return(s)
+#define return_PTR(s)                   return(s)
+
+#endif /* DEBUG_FUNC_TRACE */
+
 /* Conditional execution */
 
 #define ACPI_DEBUG_EXEC(a)              a
Index: linux-2.6.22-rc3/include/acpi/acoutput.h
===================================================================
--- linux-2.6.22-rc3.orig/include/acpi/acoutput.h
+++ linux-2.6.22-rc3/include/acpi/acoutput.h
@@ -178,8 +178,8 @@
 
 /* Defaults for debug_level, debug and normal */
 
-#define ACPI_DEBUG_DEFAULT          (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR | ACPI_LV_DEBUG_OBJECT)
-#define ACPI_NORMAL_DEFAULT         (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR | ACPI_LV_DEBUG_OBJECT)
+#define ACPI_DEBUG_DEFAULT          (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR)
+#define ACPI_NORMAL_DEFAULT         (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR)
 #define ACPI_DEBUG_ALL              (ACPI_LV_AML_DISASSEMBLE | ACPI_LV_ALL_EXCEPTIONS | ACPI_LV_ALL)
 
 #endif				/* __ACOUTPUT_H__ */


--=-xyvU1g5qwTRQNL2OS8Wi
Content-Disposition: attachment; filename=acpi_differ_function_trace_in_debug.patch
Content-Type: text/x-patch; name=acpi_differ_function_trace_in_debug.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Split ACPI_DEBUG into function trace enabled and not enabled.

Function trace is most of the ACPI_DEBUG costs, but is
not much of use for kernel ACPI debugging.

Size of kernel image increased on test compile:
+ 48k  (Full ACPI_DEBUG)
+ 35k  (ACPI_DEBUG with function trace compiled out)

Performance without function trace is also much better.

Also remove ACPI_LV_DEBUG_OBJECT from default debug level as
a lot vendors let Store (value, debug) in their code and this
might confuse users when it pops up in syslog.

---
 drivers/acpi/Kconfig    |    8 ++++++++
 include/acpi/acmacros.h |   23 +++++++++++++++++++++++
 include/acpi/acoutput.h |    4 ++--
 3 files changed, 33 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc3/drivers/acpi/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/drivers/acpi/Kconfig
+++ linux-2.6.22-rc3/drivers/acpi/Kconfig
@@ -280,6 +280,14 @@ config ACPI_DEBUG
 	  of verbosity. Saying Y enables these statements. This will increase
 	  your kernel size by around 50K.
 
+config ACPI_DEBUG_FUNC_TRACE
+	bool "Additionally enable ACPI function tracing"
+	default n
+	depends on ACPI_DEBUG
+	help
+	  ACPI Debug Statements slow down ACPI processing. Function trace
+	  is about half of the penalty and is rarely useful.
+
 config ACPI_EC
 	bool
 	default y
Index: linux-2.6.22-rc3/include/acpi/acmacros.h
===================================================================
--- linux-2.6.22-rc3.orig/include/acpi/acmacros.h
+++ linux-2.6.22-rc3/include/acpi/acmacros.h
@@ -486,6 +486,8 @@
 #define ACPI_FUNCTION_NAME(name)
 #endif
 
+#ifdef DEBUG_FUNC_TRACE
+
 #define ACPI_FUNCTION_TRACE(a)          ACPI_FUNCTION_NAME(a) \
 			  acpi_ut_trace(ACPI_DEBUG_PARAMETERS)
 #define ACPI_FUNCTION_TRACE_PTR(a,b)    ACPI_FUNCTION_NAME(a) \
@@ -563,6 +565,27 @@
 
 #endif				/* ACPI_SIMPLE_RETURN_MACROS */
 
+#else /* !DEBUG_FUNC_TRACE */
+
+#define ACPI_FUNCTION_TRACE(a)
+#define ACPI_FUNCTION_TRACE_PTR(a,b)
+#define ACPI_FUNCTION_TRACE_U32(a,b)
+#define ACPI_FUNCTION_TRACE_STR(a,b)
+#define ACPI_FUNCTION_EXIT
+#define ACPI_FUNCTION_STATUS_EXIT(s)
+#define ACPI_FUNCTION_VALUE_EXIT(s)
+#define ACPI_FUNCTION_TRACE(a)
+#define ACPI_FUNCTION_ENTRY()
+
+#define return_VOID                     return
+#define return_ACPI_STATUS(s)           return(s)
+#define return_VALUE(s)                 return(s)
+#define return_UINT8(s)                 return(s)
+#define return_UINT32(s)                return(s)
+#define return_PTR(s)                   return(s)
+
+#endif /* DEBUG_FUNC_TRACE */
+
 /* Conditional execution */
 
 #define ACPI_DEBUG_EXEC(a)              a
Index: linux-2.6.22-rc3/include/acpi/acoutput.h
===================================================================
--- linux-2.6.22-rc3.orig/include/acpi/acoutput.h
+++ linux-2.6.22-rc3/include/acpi/acoutput.h
@@ -178,8 +178,8 @@
 
 /* Defaults for debug_level, debug and normal */
 
-#define ACPI_DEBUG_DEFAULT          (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR | ACPI_LV_DEBUG_OBJECT)
-#define ACPI_NORMAL_DEFAULT         (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR | ACPI_LV_DEBUG_OBJECT)
+#define ACPI_DEBUG_DEFAULT          (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR)
+#define ACPI_NORMAL_DEFAULT         (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR)
 #define ACPI_DEBUG_ALL              (ACPI_LV_AML_DISASSEMBLE | ACPI_LV_ALL_EXCEPTIONS | ACPI_LV_ALL)
 
 #endif				/* __ACOUTPUT_H__ */

--=-xyvU1g5qwTRQNL2OS8Wi--

