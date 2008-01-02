Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbYABUGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbYABUGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYABUGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:06:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37602 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbYABUGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:06:13 -0500
Date: Wed, 2 Jan 2008 21:05:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: [patch] x86 compat_binfmt_elf, Makefile fixes (was: Re:
	2.6.24-rc6-mm1)
Message-ID: <20080102200511.GA3722@elte.hu>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <200712231453.35497.rjw@sisk.pl> <20071223200946.GA21826@uranus.ravnborg.org> <200712232344.39302.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712232344.39302.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > Try to delete your fs/ directory in your output dir. Then I expect 
> > the same bug to surface again.
> 
> It does surface indeed.

could you try the patch from Sam below - does it fix the problem? 
Thanks,

	Ingo

---------->
Subject: x86 compat_binfmt_elf, Makefile fixes
From: Sam Ravnborg <sam@ravnborg.org>

fix the build rules of compat-binfmt_elf.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig       |    1 +
 arch/x86/ia32/Makefile |    5 ++---
 fs/Kconfig.binfmt      |   10 ++++++++++
 fs/Makefile            |    1 +
 4 files changed, 14 insertions(+), 3 deletions(-)

Index: linux-x86.q/arch/x86/Kconfig
===================================================================
--- linux-x86.q.orig/arch/x86/Kconfig
+++ linux-x86.q/arch/x86/Kconfig
@@ -1546,6 +1546,7 @@ source "fs/Kconfig.binfmt"
 config IA32_EMULATION
 	bool "IA32 Emulation"
 	depends on X86_64
+	select HAVE_COMPAT_BINFMT_ELF
 	help
 	  Include code to run 32-bit programs under a 64-bit kernel. You should
 	  likely turn this on, unless you're 100% sure that you don't have any
Index: linux-x86.q/arch/x86/ia32/Makefile
===================================================================
--- linux-x86.q.orig/arch/x86/ia32/Makefile
+++ linux-x86.q/arch/x86/ia32/Makefile
@@ -2,7 +2,8 @@
 # Makefile for the ia32 kernel emulation subsystem.
 #
 
-obj-$(CONFIG_IA32_EMULATION) := ia32entry.o sys_ia32.o ia32_signal.o
+obj-$(CONFIG_IA32_EMULATION) := ia32entry.o sys_ia32.o ia32_signal.o \
+	ia32_binfmt.o
 
 sysv-$(CONFIG_SYSVIPC) := ipc32.o
 obj-$(CONFIG_IA32_EMULATION) += $(sysv-y)
@@ -11,5 +12,3 @@ obj-$(CONFIG_IA32_AOUT) += ia32_aout.o
 
 audit-class-$(CONFIG_AUDIT) := audit.o
 obj-$(CONFIG_IA32_EMULATION) += $(audit-class-y)
-
-obj-$(CONFIG_IA32_EMULATION)		+= ../../../fs/compat_binfmt_elf.o
Index: linux-x86.q/fs/Kconfig.binfmt
===================================================================
--- linux-x86.q.orig/fs/Kconfig.binfmt
+++ linux-x86.q/fs/Kconfig.binfmt
@@ -23,6 +23,16 @@ config BINFMT_ELF
 	  ld.so (check the file <file:Documentation/Changes> for location and
 	  latest version).
 
+# Archs supporting compatibility binfmt_elf shall select HAVE_COMPAT_BINFMT_ELF
+config HAVE_COMPAT_BINFMT_ELF
+
+config COMPAT_BINFMT_ELF
+	bool "Bla"
+	depends on HAVE_COMPAT_BINFMT_ELF
+	depends on MMU
+	help
+	  Bla
+
 config BINFMT_ELF_FDPIC
 	bool "Kernel support for FDPIC ELF binaries"
 	default y
Index: linux-x86.q/fs/Makefile
===================================================================
--- linux-x86.q.orig/fs/Makefile
+++ linux-x86.q/fs/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_BINFMT_ELF)	+= binfmt_elf.o
 obj-$(CONFIG_BINFMT_ELF_FDPIC)	+= binfmt_elf_fdpic.o
 obj-$(CONFIG_BINFMT_SOM)	+= binfmt_som.o
 obj-$(CONFIG_BINFMT_FLAT)	+= binfmt_flat.o
+obj-$(CONFIG_COMPAT_BINFMT_ELF) += compat_binfmt_elf.o
 
 obj-$(CONFIG_FS_MBCACHE)	+= mbcache.o
 obj-$(CONFIG_FS_POSIX_ACL)	+= posix_acl.o xattr_acl.o
