Return-Path: <linux-kernel-owner+w=401wt.eu-S1758845AbYBJKrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbYBJKrc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 05:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758269AbYBJKrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 05:47:19 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:33530 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758261AbYBJKrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 05:47:05 -0500
Date: Sun, 10 Feb 2008 11:47:09 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [0/6] kgdb light
Message-ID: <20080210104709.GB10790@uranus.ravnborg.org>
References: <20080210071304.GA3788@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210071304.GA3788@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo.

A few comments based on the git tree pulled as of
~11:00.

We have following header files in the core part:

linux/kgdb.h
asm-generic/kgdb.h

I would expect linux/kgdb.h to contain all the common definitions
needed by an arch.
And asm-generic/kgdb.h to list everything that the arch needs to
provide to support kgdb. + anything that rely on the arch
definitions provided by the arch.

Yet linux/kgdb.h says:
+/*
+ * Functions each KGDB-supporting architecture must provide:
+ */

So I am obviously wrong here. What triggered the division
in the two header files?


Some minor specific comments:
+/**
+ *	kgdb_skipexception - Bail of of KGDB when we've been triggered.
+ *	@exception: Exception vector number
+ *	@regs: Current &struct pt_regs.
+ *
+ *	On some architectures we need to skip a breakpoint exception when
+ *	it occurs after a breakpoint has been removed.
+ */
+int kgdb_skipexception(int exception, struct pt_regs *regs);
+
+/**
+ *	kgdb_post_master_code - Save error vector/code numbers.
+ *	@regs: Original pt_regs.
+ *	@e_vector: Original error vector.
+ *	@err_code: Original error code.
+ *
+ *	This is needed on architectures which support SMP and KGDB.
+ *	This function is called after all the slave cpus have been put
+ *	to a know spin state and the master CPU has control over KGDB.
+ */
+extern void kgdb_post_master_code(struct pt_regs *regs, int e_vector,
+				  int err_code);
+

Please be consistent in use of extern.
Either drop it all over or use it all over.

+#ifndef _KGDB_H_
+#define _KGDB_H_
+
+#include <asm/atomic.h>
+
+#ifdef CONFIG_KGDB
+
+#include <linux/serial_8250.h>
+#include <linux/linkage.h>
+#include <linux/init.h>
+
+#include <asm/kgdb.h>

I do not really see the point of the CONFIG_KGDB ifdef.
And if we want it then why not above the inclusion
of atomic.h?

Looking a bit closer it looks like all content from asm-generic/kgdb.h
is included in linux/kgdb.h - correct?
I assume the header file in asm-generic should have been deleted?

+ */
+void
+sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *p);
+
Make return value visible on same line as the function to be consistent in
style.

+/* Is a host GDB connected to us? */
+int				kgdb_connected;
+EXPORT_SYMBOL_GPL(kgdb_connected);
Kernel-doc comments for EXPORTs.

+extern int kgdb_may_fault;
I searched but I could not find any places this
variable were set to anuthing else than 0 neither where it was tested.

diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
new file mode 100644
index 0000000..00263c0
--- /dev/null
+++ b/lib/Kconfig.kgdb
@@ -0,0 +1,37 @@
+
+menuconfig KGDB
+	bool "KGDB: kernel debugging with remote gdb"
+	select FRAME_POINTER
+	depends on HAVE_ARCH_KGDB
+	depends on DEBUG_KERNEL && EXPERIMENTAL
+	help
+	  If you say Y here, it will be possible to remotely debug the
+	  kernel using gdb.  Documentation of kernel debugger is available
+	  at http://kgdb.sourceforge.net as well as in DocBook form
+	  in Documentation/DocBook/.  If unsure, say N.
+
+config HAVE_ARCH_KGDB_SHADOW_INFO
+	bool
+

Please add:
config HAVE_ARCH_KGDB
	bool

So we later in x86/Kconfig can do:
config X86
	select HAVE_ARCH_KGDB

And we can get rid of (from x86/Kconfig):
+config HAVE_ARCH_KGDB
+	def_bool y


Back to Kconfig.kgdb:

+config KGDBOC
+	tristate "KGDB: use kgdb over the serial console"
+	depends on KGDB

Can we have a more descriptive name here.
For example:
config KGDB_SERIAL_CONSOLE
It is only used in one place so there is no
specific need for such a magic short name.


I see that all my other comments were addresses - thanks.

	Sam
