Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbYJ3Bnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbYJ3Bnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 21:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbYJ3BnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 21:43:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43169 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbYJ3BnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 21:43:22 -0400
Date: Wed, 29 Oct 2008 21:43:19 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH][RFC] x86: add non x86 build configuration
In-Reply-To: <20081029091857.GA4414@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.DEB.1.10.0810292139170.6145@gandalf.stny.rr.com>
References: <200810281802.m9SI2fYX030138@hera.kernel.org> <20081029091857.GA4414@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A lot of developers develop on x86 architectures, and do things that
sometimes breaks non x86 archs. This patch adds a debug option to
turn off all the CONFIG_HAVE_ options that x86 sets. This allows
developers to easily test their code to make sure that it compiles
without a lot of the assumptions that x86 makes.

Note: Recently the ftrace code had an issue where a depend was set
  by the wrong select, but that select was not set by all archs.
  This patch catches that issue when compiling on x86.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/Kconfig |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

Index: linux-tip.git/arch/x86/Kconfig
===================================================================
--- linux-tip.git.orig/arch/x86/Kconfig	2008-10-29 20:49:11.000000000 -0400
+++ linux-tip.git/arch/x86/Kconfig	2008-10-29 21:28:52.000000000 -0400
@@ -18,11 +18,20 @@ config X86_64
 ### Arch settings
 config X86
 	def_bool y
+	# configs needed by arch/x86 code
+	select HAVE_IOREMAP_PROT
+
+# make a choice to keep allyesconfig from choosing non x86
+choice
+	prompt "Configuration Model"
+	default NORMAL_X86_CONFIGURATION
+
+config NORMAL_X86_CONFIGURATION
+	prompt "Normal Configuration Model"
 	select HAVE_AOUT if X86_32
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_IDE
 	select HAVE_OPROFILE
-	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_KRETPROBES
@@ -35,6 +44,22 @@ config X86
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 
+config SIMULATE_NON_X86_CONFIGURATION
+	bool "Simulate non x86 configuration"
+	depends on DEBUG_KERNEL
+	help
+	  Several developers just test on a x86 architecture, and sometimes
+	  break non x86 architectures without realizing it. This config
+	  option disables a lot of configurations that are set by
+	  being x86. Any development should compile an allyesconfig
+	  with this setting enabled.
+
+	  Note, the kernel should compile, there's no guarantee that it
+	  will boot.
+
+	  If unsure, select "Normal Operation Model"
+endchoice
+
 config ARCH_DEFCONFIG
 	string
 	default "arch/x86/configs/i386_defconfig" if X86_32


