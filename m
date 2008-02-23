Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbYBWQfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbYBWQfk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 11:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbYBWQfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 11:35:32 -0500
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:9659 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbYBWQfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 11:35:30 -0500
Date: Sat, 23 Feb 2008 17:30:58 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, mm-commits@vger.kernel.org,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Lump xxxinit together with init if possible (was Re: Solve section mismatch for free_area_init_core.)
Message-ID: <20080223163058.GA11003@mailshack.com>
References: <20080203172148.GA17875@mailshack.com> <20080218210115.GA24592@uranus.ravnborg.org> <Pine.LNX.4.64.0802190930320.25052@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802190930320.25052@anakin>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Sat, 23 Feb 2008 17:31:08 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.67; VDF: 7.0.2.180; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 09:30:42AM +0100, Geert Uytterhoeven wrote:
> On Mon, 18 Feb 2008, Sam Ravnborg wrote:
> > I have (triggered by Geert) spend some time reviewing this patch
> > and I see no better way to fix it.
> > 
> > So it gets my:
> > 
> > Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
> 
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thanks!

I more than less expected people to scream "ugly, ugly!". Maybe you
could consider the following patch, instead?

In non-HOTPLUG configurations, devinit and init sections in vmlinux
are lumped together during the final link. There is no good reason
to warn about section mismatches between them in this case, because
all code is discarded at the same time. This patch moves the lumping-
together to the compile stage, which makes the unnecessary warnings
go away. Same for MEMORY_HOTPLUG/meminit and HOTPLUG_CPU/cpuinit.

On the condition that someone with knowledge in this area confirms
that this approach is right and not for some reason undesirable:

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

 include/asm-generic/vmlinux.lds.h |   98 ++++++++----------------------------
 include/linux/init.h              |   27 ++++++++++
 2 files changed, 49 insertions(+), 76 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f054778..742152b 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -9,46 +9,17 @@
 /* Align . to a 8 byte boundary equals to maximum function alignment. */
 #define ALIGN_FUNCTION()  . = ALIGN(8)
 
-/* The actual configuration determine if the init/exit sections
- * are handled as text/data or they can be discarded (which
- * often happens at runtime)
- */
-#ifdef CONFIG_HOTPLUG
-#define DEV_KEEP(sec)    *(.dev##sec)
-#define DEV_DISCARD(sec)
-#else
-#define DEV_KEEP(sec)
-#define DEV_DISCARD(sec) *(.dev##sec)
-#endif
-
-#ifdef CONFIG_HOTPLUG_CPU
-#define CPU_KEEP(sec)    *(.cpu##sec)
-#define CPU_DISCARD(sec)
-#else
-#define CPU_KEEP(sec)
-#define CPU_DISCARD(sec) *(.cpu##sec)
-#endif
-
-#if defined(CONFIG_MEMORY_HOTPLUG)
-#define MEM_KEEP(sec)    *(.mem##sec)
-#define MEM_DISCARD(sec)
-#else
-#define MEM_KEEP(sec)
-#define MEM_DISCARD(sec) *(.mem##sec)
-#endif
-
-
 /* .data section */
 #define DATA_DATA							\
 	*(.data)							\
 	*(.data.init.refok)						\
 	*(.ref.data)							\
-	DEV_KEEP(init.data)						\
-	DEV_KEEP(exit.data)						\
-	CPU_KEEP(init.data)						\
-	CPU_KEEP(exit.data)						\
-	MEM_KEEP(init.data)						\
-	MEM_KEEP(exit.data)						\
+	*(.devinit.data)						\
+	*(.devexit.data)						\
+	*(.cpuinit.data)						\
+	*(.cpuexit.data)						\
+	*(.meminit.data)						\
+	*(.memexit.data)						\
 	. = ALIGN(8);							\
 	VMLINUX_SYMBOL(__start___markers) = .;				\
 	*(__markers)							\
@@ -171,12 +142,12 @@
 	/* __*init sections */						\
 	__init_rodata : AT(ADDR(__init_rodata) - LOAD_OFFSET) {		\
 		*(.ref.rodata)						\
-		DEV_KEEP(init.rodata)					\
-		DEV_KEEP(exit.rodata)					\
-		CPU_KEEP(init.rodata)					\
-		CPU_KEEP(exit.rodata)					\
-		MEM_KEEP(init.rodata)					\
-		MEM_KEEP(exit.rodata)					\
+		*(.devinit.rodata)					\
+		*(.devexit.rodata)					\
+		*(.cpuinit.rodata)					\
+		*(.cpuexit.rodata)					\
+		*(.meminit.rodata)					\
+		*(.memexit.rodata)					\
 	}								\
 									\
 	/* Built-in module parameters. */				\
@@ -208,12 +179,12 @@
 		*(.ref.text)						\
 		*(.text.init.refok)					\
 		*(.exit.text.refok)					\
-	DEV_KEEP(init.text)						\
-	DEV_KEEP(exit.text)						\
-	CPU_KEEP(init.text)						\
-	CPU_KEEP(exit.text)						\
-	MEM_KEEP(init.text)						\
-	MEM_KEEP(exit.text)
+	*(.devinit.text)						\
+	*(.devexit.text)						\
+	*(.cpuinit.text)						\
+	*(.cpuexit.text)						\
+	*(.meminit.text)						\
+	*(.memexit.text)
 
 
 /* sched.text is aling to function alignment to secure we have same
@@ -242,35 +213,10 @@
 #define HEAD_TEXT  *(.head.text)
 
 /* init and exit section handling */
-#define INIT_DATA							\
-	*(.init.data)							\
-	DEV_DISCARD(init.data)						\
-	DEV_DISCARD(init.rodata)					\
-	CPU_DISCARD(init.data)						\
-	CPU_DISCARD(init.rodata)					\
-	MEM_DISCARD(init.data)						\
-	MEM_DISCARD(init.rodata)
-
-#define INIT_TEXT							\
-	*(.init.text)							\
-	DEV_DISCARD(init.text)						\
-	CPU_DISCARD(init.text)						\
-	MEM_DISCARD(init.text)
-
-#define EXIT_DATA							\
-	*(.exit.data)							\
-	DEV_DISCARD(exit.data)						\
-	DEV_DISCARD(exit.rodata)					\
-	CPU_DISCARD(exit.data)						\
-	CPU_DISCARD(exit.rodata)					\
-	MEM_DISCARD(exit.data)						\
-	MEM_DISCARD(exit.rodata)
-
-#define EXIT_TEXT							\
-	*(.exit.text)							\
-	DEV_DISCARD(exit.text)						\
-	CPU_DISCARD(exit.text)						\
-	MEM_DISCARD(exit.text)
+#define INIT_DATA	*(.init.data)
+#define INIT_TEXT	*(.init.text)
+#define EXIT_DATA	*(.exit.data)
+#define EXIT_TEXT	*(.exit.text)
 
 		/* DWARF debug sections.
 		Symbols in the DWARF debugging sections are relative to
diff --git a/include/linux/init.h b/include/linux/init.h
index fb58c04..8461f8f 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -83,28 +83,55 @@
 #define __exit          __section(.exit.text) __exitused __cold
 
 /* Used for HOTPLUG */
+#if defined(MODULE) || defined(CONFIG_HOTPLUG)
 #define __devinit        __section(.devinit.text) __cold
 #define __devinitdata    __section(.devinit.data)
 #define __devinitconst   __section(.devinit.rodata)
 #define __devexit        __section(.devexit.text) __exitused __cold
 #define __devexitdata    __section(.devexit.data)
 #define __devexitconst   __section(.devexit.rodata)
+#else
+#define __devinit        __section(.init.text) __cold
+#define __devinitdata    __section(.init.data)
+#define __devinitconst   __section(.init.rodata)
+#define __devexit        __section(.exit.text) __exitused __cold
+#define __devexitdata    __section(.exit.data)
+#define __devexitconst   __section(.exit.rodata)
+#endif
 
 /* Used for HOTPLUG_CPU */
+#if defined(MODULE) || defined(CONFIG_HOTPLUG_CPU)
 #define __cpuinit        __section(.cpuinit.text) __cold
 #define __cpuinitdata    __section(.cpuinit.data)
 #define __cpuinitconst   __section(.cpuinit.rodata)
 #define __cpuexit        __section(.cpuexit.text) __exitused __cold
 #define __cpuexitdata    __section(.cpuexit.data)
 #define __cpuexitconst   __section(.cpuexit.rodata)
+#else
+#define __cpuinit        __section(.init.text) __cold
+#define __cpuinitdata    __section(.init.data)
+#define __cpuinitconst   __section(.init.rodata)
+#define __cpuexit        __section(.exit.text) __exitused __cold
+#define __cpuexitdata    __section(.exit.data)
+#define __cpuexitconst   __section(.exit.rodata)
+#endif
 
 /* Used for MEMORY_HOTPLUG */
+#if defined(MODULE) || defined(CONFIG_MEMORY_HOTPLUG)
 #define __meminit        __section(.meminit.text) __cold
 #define __meminitdata    __section(.meminit.data)
 #define __meminitconst   __section(.meminit.rodata)
 #define __memexit        __section(.memexit.text) __exitused __cold
 #define __memexitdata    __section(.memexit.data)
 #define __memexitconst   __section(.memexit.rodata)
+#else
+#define __meminit        __section(.init.text) __cold
+#define __meminitdata    __section(.init.data)
+#define __meminitconst   __section(.init.rodata)
+#define __memexit        __section(.exit.text) __exitused __cold
+#define __memexitdata    __section(.exit.data)
+#define __memexitconst   __section(.exit.rodata)
+#endif
 
 /* For assembly routines */
 #define __HEAD		.section	".head.text","ax"
