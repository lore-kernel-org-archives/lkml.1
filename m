Return-Path: <linux-kernel-owner+w=401wt.eu-S934579AbXEHIHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934579AbXEHIHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 04:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934563AbXEHIHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 04:07:11 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:39658 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934397AbXEHIHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 04:07:09 -0400
X-Originating-Ip: 72.143.66.196
Date: Tue, 8 May 2007 04:06:30 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][RFC] Create a top-level "Space-critical features" menu.
Message-ID: <Pine.LNX.4.64.0705080356020.10881@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  i've always hated that lower-level menu under "General setup":

Configure standard kernel features (for small systems)  --->

which buries the choice of de-selecting features to save space one
level down without really explaining what it's all about.  so i just
shifted all of that up to the top under what i think is a more
meaningful name.

  this patch is also why i asked earlier why top-level menu entries
have no "help" text -- because, in this case, it would be useful for
someone looking at the config screen to see that choice and be able to
ask, "hey, i wonder what *that's* all about", and get help along the
lines of:

  "these features are normally selected but, if you're strapped for
space, such as with embedded systems, you might consider turning some
of them off.  if space isn't an issue, you might as well just leave
them as they are."  (or something like that.)

---

diff --git a/init/Kconfig b/init/Kconfig
index ebe04f5..5d14096 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -346,23 +346,72 @@ config CC_OPTIMIZE_FOR_SIZE
 config SYSCTL
 	bool

-menuconfig EMBEDDED
-	bool "Configure standard kernel features (for small systems)"
+choice
+	prompt "Choose SLAB allocator"
+	default SLAB
+	help
+	   This option allows to select a slab allocator.
+
+config SLAB
+	bool "SLAB"
+	help
+	  The regular slab allocator that is established and known to work
+	  well in all environments. It organizes chache hot objects in
+	  per cpu and per node queues. SLAB is the default choice for
+	  slab allocator.
+
+config SLUB
+	depends on EXPERIMENTAL && !ARCH_USES_SLAB_PAGE_STRUCT
+	bool "SLUB (Unqueued Allocator)"
 	help
-	  This option allows certain base kernel options and settings
-          to be disabled or tweaked. This is for specialized
-          environments which can tolerate a "non-standard" kernel.
-          Only use this if you really know what you are doing.
+	   SLUB is a slab allocator that minimizes cache line usage
+	   instead of managing queues of cached objects (SLAB approach).
+	   Per cpu caching is realized using slabs of objects instead
+	   of queues of objects. SLUB can use memory efficiently
+	   way and has enhanced diagnostics.
+
+config SLOB
+#
+#	SLOB cannot support SMP because SLAB_DESTROY_BY_RCU does not work
+#	properly.
+#
+	depends on EMBEDDED && !SMP && !SPARSEMEM
+	bool "SLOB (Simple Allocator)"
+	help
+	   SLOB replaces the SLAB allocator with a drastically simpler
+	   allocator.  SLOB is more space efficient that SLAB but does not
+	   scale well (single lock for all operations) and is more susceptible
+	   to fragmentation. SLOB it is a great choice to reduce
+	   memory usage and code size for embedded systems.
+
+endchoice
+
+endmenu		# General setup
+
+config RT_MUTEXES
+	boolean
+	select PLIST
+
+config TINY_SHMEM
+	default !SHMEM
+	bool
+
+config BASE_SMALL
+	int
+	default 0 if BASE_FULL
+	default 1 if !BASE_FULL
+
+menu "Removable space-critical features"

 config UID16
-	bool "Enable 16-bit UID system calls" if EMBEDDED
+	bool "Enable 16-bit UID system calls"
 	depends on ARM || BFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && SPARC32_COMPAT) || UML || (X86_64 && IA32_EMULATION)
 	default y
 	help
 	  This enables the legacy 16-bit UID syscall wrappers.

 config SYSCTL_SYSCALL
-	bool "Sysctl syscall support" if EMBEDDED
+	bool "Sysctl syscall support"
 	default y
 	select SYSCTL
 	---help---
@@ -378,7 +427,7 @@ config SYSCTL_SYSCALL
 	  If unsure say Y here.

 config KALLSYMS
-	 bool "Load all symbols for debugging/ksymoops" if EMBEDDED
+	 bool "Load all symbols for debugging/ksymoops"
 	 default y
 	 help
 	   Say Y here to let the kernel print out symbolic crash information and
@@ -409,7 +458,7 @@ config KALLSYMS_EXTRA_PASS


 config HOTPLUG
-	bool "Support for hot-pluggable devices" if EMBEDDED
+	bool "Support for hot-pluggable devices"
 	default y
 	help
 	  This option is provided for the case where no hotplug or uevent
@@ -419,7 +468,7 @@ config HOTPLUG

 config PRINTK
 	default y
-	bool "Enable support for printk" if EMBEDDED
+	bool "Enable support for printk"
 	help
 	  This option enables normal printk support. Removing it
 	  eliminates most of the message strings from the kernel image
@@ -428,7 +477,7 @@ config PRINTK
 	  strongly discouraged.

 config BUG
-	bool "BUG() support" if EMBEDDED
+	bool "BUG() support"
 	default y
 	help
           Disabling this option eliminates support for BUG and WARN, reducing
@@ -439,20 +488,20 @@ config BUG

 config ELF_CORE
 	default y
-	bool "Enable ELF core dumps" if EMBEDDED
+	bool "Enable ELF core dumps"
 	help
 	  Enable support for generating core dumps. Disabling saves about 4k.

 config BASE_FULL
 	default y
-	bool "Enable full-sized data structures for core" if EMBEDDED
+	bool "Enable full-sized data structures for core"
 	help
 	  Disabling this option reduces the size of miscellaneous core
 	  kernel data structures. This saves memory on small machines,
 	  but may reduce performance.

 config FUTEX
-	bool "Enable futex support" if EMBEDDED
+	bool "Enable futex support"
 	default y
 	select RT_MUTEXES
 	help
@@ -461,14 +510,14 @@ config FUTEX
 	  run glibc-based applications correctly.

 config EPOLL
-	bool "Enable eventpoll support" if EMBEDDED
+	bool "Enable eventpoll support"
 	default y
 	help
 	  Disabling this option will cause the kernel to be built without
 	  support for epoll family of system calls.

 config SHMEM
-	bool "Use full shmem filesystem" if EMBEDDED
+	bool "Use full shmem filesystem"
 	default y
 	depends on MMU
 	help
@@ -480,67 +529,14 @@ config SHMEM

 config VM_EVENT_COUNTERS
 	default y
-	bool "Enable VM event counters for /proc/vmstat" if EMBEDDED
+	bool "Enable VM event counters for /proc/vmstat"
 	help
 	  VM event counters are needed for event counts to be shown.
 	  This option allows the disabling of the VM event counters
 	  on EMBEDDED systems.  /proc/vmstat will only show page counts
 	  if VM event counters are disabled.

-choice
-	prompt "Choose SLAB allocator"
-	default SLAB
-	help
-	   This option allows to select a slab allocator.
-
-config SLAB
-	bool "SLAB"
-	help
-	  The regular slab allocator that is established and known to work
-	  well in all environments. It organizes chache hot objects in
-	  per cpu and per node queues. SLAB is the default choice for
-	  slab allocator.
-
-config SLUB
-	depends on EXPERIMENTAL && !ARCH_USES_SLAB_PAGE_STRUCT
-	bool "SLUB (Unqueued Allocator)"
-	help
-	   SLUB is a slab allocator that minimizes cache line usage
-	   instead of managing queues of cached objects (SLAB approach).
-	   Per cpu caching is realized using slabs of objects instead
-	   of queues of objects. SLUB can use memory efficiently
-	   way and has enhanced diagnostics.
-
-config SLOB
-#
-#	SLOB cannot support SMP because SLAB_DESTROY_BY_RCU does not work
-#	properly.
-#
-	depends on EMBEDDED && !SMP && !SPARSEMEM
-	bool "SLOB (Simple Allocator)"
-	help
-	   SLOB replaces the SLAB allocator with a drastically simpler
-	   allocator.  SLOB is more space efficient that SLAB but does not
-	   scale well (single lock for all operations) and is more susceptible
-	   to fragmentation. SLOB it is a great choice to reduce
-	   memory usage and code size for embedded systems.
-
-endchoice
-
-endmenu		# General setup
-
-config RT_MUTEXES
-	boolean
-	select PLIST
-
-config TINY_SHMEM
-	default !SHMEM
-	bool
-
-config BASE_SMALL
-	int
-	default 0 if BASE_FULL
-	default 1 if !BASE_FULL
+endmenu

 menu "Loadable module support"



-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
