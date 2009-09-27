Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbZI0ICg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbZI0ICg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 04:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZI0ICf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 04:02:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57941 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427AbZI0ICd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 04:02:33 -0400
Date: Sun, 27 Sep 2009 10:02:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] x86 fix
Message-ID: <20090927080227.GA15666@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus


out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
mm/Kconfig                         # d949f36: x86: Fix hwpoison code related bu

 Thanks,

	Ingo

------------------>
Linus Torvalds (1):
      x86: Fix hwpoison code related build failure on 32-bit NUMAQ


 arch/x86/Kconfig |   11 +++++++++++
 mm/Kconfig       |    4 +++-
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9369879..8da9374 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -432,6 +432,17 @@ config X86_NUMAQ
 	  of Flat Logical.  You will need a new lynxer.elf file to flash your
 	  firmware with - send email to <Martin.Bligh@us.ibm.com>.
 
+config X86_SUPPORTS_MEMORY_FAILURE
+	bool
+	# MCE code calls memory_failure():
+	depends on X86_MCE
+	# On 32-bit this adds too big of NODES_SHIFT and we run out of page flags:
+	depends on !X86_NUMAQ
+	# On 32-bit SPARSEMEM adds too big of SECTIONS_WIDTH:
+	depends on X86_64 || !SPARSEMEM
+	select ARCH_SUPPORTS_MEMORY_FAILURE
+	default y
+
 config X86_VISWS
 	bool "SGI 320/540 (Visual Workstation)"
 	depends on X86_32 && PCI && X86_MPPARSE && PCI_GODIRECT
diff --git a/mm/Kconfig b/mm/Kconfig
index 2477607..edd300a 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -244,10 +244,12 @@ config DEFAULT_MMAP_MIN_ADDR
 	  This value can be changed after boot using the
 	  /proc/sys/vm/mmap_min_addr tunable.
 
+config ARCH_SUPPORTS_MEMORY_FAILURE
+	bool
 
 config MEMORY_FAILURE
 	depends on MMU
-	depends on X86_MCE
+	depends on ARCH_SUPPORTS_MEMORY_FAILURE
 	bool "Enable recovery from hardware memory errors"
 	help
 	  Enables code to recover from some memory failures on systems
