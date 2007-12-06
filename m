Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbXLFQyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbXLFQyD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 11:54:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbXLFQxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 11:53:54 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:55614 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbXLFQxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 11:53:54 -0500
Date: Thu, 6 Dec 2007 16:53:19 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: [PATCH] Fix oprofile configuration breakage
Message-ID: <20071206165319.GA21553@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cleanup 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9 broke the oprofile
configuration for MIPS by allowing oprofile support to be built for
kernel models where oprofile doesn't have a chance in hell to work.

Just a dependecy list on a number of architectures is - surprise - broken
and should as per past discussions probably in most considered to be
broken in most cases.  So I introduce a dependency for the oprofile
configuration on ARCH_SUPPORTS_OPROFILE.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
---

Since we're already in -rc4 I try to keep things minimally intrusive and
use ARCH_SUPPORTS_OPROFILE only for MIPS for now instead of touching a
dozen architectures.

 arch/mips/Kconfig              |    4 ++++
 kernel/Kconfig.instrumentation |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 455bd1f..c6fc405 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -714,6 +714,10 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
+config ARCH_SUPPORTS_OPROFILE
+	bool
+	default y if !MIPS_MT_SMTC
+
 config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
diff --git a/kernel/Kconfig.instrumentation b/kernel/Kconfig.instrumentation
index 2ea1e34..12a9f74 100644
--- a/kernel/Kconfig.instrumentation
+++ b/kernel/Kconfig.instrumentation
@@ -21,7 +21,7 @@ config PROFILING
 config OPROFILE
 	tristate "OProfile system profiling (EXPERIMENTAL)"
 	depends on PROFILING
-	depends on (ALPHA || ARM || BLACKFIN || X86_32 || IA64 || M32R || MIPS || PARISC || PPC || S390 || SUPERH || SPARC || X86_64) && !UML
+	depends on (ARCH_SUPPORTS_OPROFILE || ALPHA || ARM || BLACKFIN || X86_32 || IA64 || M32R || PARISC || PPC || S390 || SUPERH || SPARC || X86_64) && !UML
 	help
 	  OProfile is a profiling system capable of profiling the
 	  whole system, include the kernel, kernel modules, libraries,
