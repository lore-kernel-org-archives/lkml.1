Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbYAOQ0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbYAOQ0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 11:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYAOQ0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 11:26:14 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33782 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496AbYAOQ0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 11:26:13 -0500
Date: Tue, 15 Jan 2008 08:24:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: Adrian Bunk <adrian.bunk@movial.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Randy Dunlap <randy.dunlap@oracle.com>, phil.el@wanadoo.fr,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Fwd: Re: [2.6.24 patch] restore ARMv6 OProfile support
In-Reply-To: <20080115104526.GA32067@flint.arm.linux.org.uk>
Message-ID: <alpine.LFD.1.00.0801150811250.2806@woody.linux-foundation.org>
References: <20071228195841.GA3945@flint.arm.linux.org.uk> <20080115104526.GA32067@flint.arm.linux.org.uk>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jan 2008, Russell King wrote:
> 
> I don't particularly like stuffing the options into some random place
> in the architectures Kconfig file when they should stay along side the
> instrumentation configuration entries.

Well, I have to say that I don't particularly like obviously 
architecture-specific stuff in an obviously non-architecture file..

I'd almost prefer to revert the thing that caused the problem, because 
with Adrian's patch, I think the end result may *work*, but it's uglier 
than what we started out with.

However, I think the *cleanest* solution right now may be something like 
the appended. Totally untested, of course. It basically just copies the 
generic kernel/Kconfig.instrumentation file into the arm directory, makes 
arm use its own instead of the generic one, and removes the dependencies 
on ARM in there (including all of the KPROBES entry that apparently isn't 
an issue on ARM anyway). It then adds back the ARM-specific ones.

This follows the sacred rules of good code:

 - generic code is either generic or not. If it's not generic, don't claim 
   it is.

 - don't *force* people to use generic code if it doesn't suit them. Make 
   it available for the cases it makes sense for, but don't shoe-horn it 
   into cases where it doesn't work well.

So it allows the sharing of the common case and *many* architectures end 
up using the generic Kconfig file, but hey, if it doesn't make sense for 
ARM, it doesn't make sense for ARM. It's that simple.

But as mentioned, it's totally untested and I don't have (or really want 
to have) a cross-compiling environment. And I don't care *that* much. I 
just want something we can all live with.

So does something like this work for people?

		Linus

---
 arch/arm/Kconfig                 |    2 +-
 arch/arm/Kconfig.instrumentation |   52 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 1 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c4de2d4..3a75a0b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1076,7 +1076,7 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
+source "arch/arm/Kconfig.instrumentation"
 
 source "arch/arm/Kconfig.debug"
 
diff --git a/arch/arm/Kconfig.instrumentation b/arch/arm/Kconfig.instrumentation
new file mode 100644
index 0000000..63b8c6d
--- /dev/null
+++ b/arch/arm/Kconfig.instrumentation
@@ -0,0 +1,52 @@
+menuconfig INSTRUMENTATION
+	bool "Instrumentation Support"
+	default y
+	---help---
+	  Say Y here to get to see options related to performance measurement,
+	  system-wide debugging, and testing. This option alone does not add any
+	  kernel code.
+
+	  If you say N, all options in this submenu will be skipped and
+	  disabled. If you're trying to debug the kernel itself, go see the
+	  Kernel Hacking menu.
+
+if INSTRUMENTATION
+
+config PROFILING
+	bool "Profiling support (EXPERIMENTAL)"
+	help
+	  Say Y here to enable the extended profiling support mechanisms used
+	  by profilers such as OProfile.
+
+config OPROFILE
+	tristate "OProfile system profiling (EXPERIMENTAL)"
+	depends on PROFILING && !UML
+	help
+	  OProfile is a profiling system capable of profiling the
+	  whole system, include the kernel, kernel modules, libraries,
+	  and applications.
+
+	  If unsure, say N.
+
+config OPROFILE_ARMV6
+	bool
+	depends on OPROFILE && CPU_V6 && !SMP
+	default y
+	select OPROFILE_ARM11_CORE
+
+config OPROFILE_MPCORE
+	bool
+	depends on OPROFILE && CPU_V6 && SMP
+	default y
+	select OPROFILE_ARM11_CORE
+
+config OPROFILE_ARM11_CORE
+	bool
+
+config MARKERS
+	bool "Activate markers"
+	help
+	  Place an empty function call at each marker site. Can be
+	  dynamically changed for a probe function.
+
+endif # INSTRUMENTATION
