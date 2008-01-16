Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbYAPCxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbYAPCxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 21:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbYAPCxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 21:53:46 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:46609 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752586AbYAPCxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 21:53:45 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAB8AjUdMROHU/2dsb2JhbACBWKsY
Date: Tue, 15 Jan 2008 21:53:41 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ananth@in.ibm.com,
       dhowells@redhat.com, jdike@addtoit.com, sam@ravnborg.org,
       Adrian Bunk <adrian.bunk@movial.fi>,
       Randy Dunlap <randy.dunlap@oracle.com>, rmk@arm.linux.org.uk,
       phil.el@wanadoo.fr, oprofile-list@lists.sourceforge.net
Subject: [PATCH for -mm] Fix ARM to play nicely with generic
	Instrumentation menu
Message-ID: <20080116025341.GA31346@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:48:26 up 73 days,  7:53,  3 users,  load average: 0.08, 0.29,
	0.38
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The conflicting commit for 
move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch
is the ARM fix from Linus :

commit 38ad9aebe70dc72df08851bbd1620d89329129ba

He just seemed to agree that my approach (just putting the missing ARM
config options in arch/arm/Kconfig) works too. The main advantage it has
is that it is smaller, does not need a cleanup in the future and does
not break the following patches unnecessarily.

It's just been discussed here

http://lkml.org/lkml/2008/1/15/267

However, Linus might prefer to stay with his own patch and I would
totally understand it that late in the release cycle. Therefore I submit
this for the next release cycle.

This patch cleans up the fix from Linus so it does not conflict with the
following patches in -mm.

It applies on top of the current 2.6.24-rc7-git8 + possibly some more
git commits (at commit 0938e7586440ac97cedc0f5528a8684ebfa4ce43).

After applying this patch,
move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch
applies nicely in the -mm tree without any modification.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: ananth@in.ibm.com
CC: dhowells@redhat.com
CC: jdike@addtoit.com
CC: sam@ravnborg.org
CC: Adrian Bunk <adrian.bunk@movial.fi>
CC: Randy Dunlap <randy.dunlap@oracle.com>
CC: rmk@arm.linux.org.uk
CC: phil.el@wanadoo.fr
CC: oprofile-list@lists.sourceforge.net
---
 arch/arm/Kconfig                 |    2 -
 arch/arm/Kconfig.instrumentation |   52 ---------------------------------------
 2 files changed, 1 insertion(+), 53 deletions(-)

Index: linux-2.6-lttng/arch/arm/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/arm/Kconfig	2008-01-15 21:37:06.000000000 -0500
+++ linux-2.6-lttng/arch/arm/Kconfig	2008-01-15 21:45:23.000000000 -0500
@@ -130,6 +130,23 @@ config FIQ
 config ARCH_MTD_XIP
 	bool
 
+if OPROFILE
+
+config OPROFILE_ARMV6
+	def_bool y
+	depends on CPU_V6 && !SMP
+	select OPROFILE_ARM11_CORE
+
+config OPROFILE_MPCORE
+	def_bool y
+	depends on CPU_V6 && SMP
+	select OPROFILE_ARM11_CORE
+
+config OPROFILE_ARM11_CORE
+	bool
+
+endif
+
 config VECTORS_BASE
 	hex
 	default 0xffff0000 if MMU || CPU_HIGH_VECTOR
@@ -1076,7 +1093,7 @@ endmenu
 
 source "fs/Kconfig"
 
-source "arch/arm/Kconfig.instrumentation"
+source "kernel/Kconfig.instrumentation"
 
 source "arch/arm/Kconfig.debug"
 
Index: linux-2.6-lttng/arch/arm/Kconfig.instrumentation
===================================================================
--- linux-2.6-lttng.orig/arch/arm/Kconfig.instrumentation	2008-01-15 21:37:06.000000000 -0500
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,52 +0,0 @@
-menuconfig INSTRUMENTATION
-	bool "Instrumentation Support"
-	default y
-	---help---
-	  Say Y here to get to see options related to performance measurement,
-	  system-wide debugging, and testing. This option alone does not add any
-	  kernel code.
-
-	  If you say N, all options in this submenu will be skipped and
-	  disabled. If you're trying to debug the kernel itself, go see the
-	  Kernel Hacking menu.
-
-if INSTRUMENTATION
-
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING && !UML
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-config OPROFILE_ARMV6
-	bool
-	depends on OPROFILE && CPU_V6 && !SMP
-	default y
-	select OPROFILE_ARM11_CORE
-
-config OPROFILE_MPCORE
-	bool
-	depends on OPROFILE && CPU_V6 && SMP
-	default y
-	select OPROFILE_ARM11_CORE
-
-config OPROFILE_ARM11_CORE
-	bool
-
-config MARKERS
-	bool "Activate markers"
-	help
-	  Place an empty function call at each marker site. Can be
-	  dynamically changed for a probe function.
-
-endif # INSTRUMENTATION

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
