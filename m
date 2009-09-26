Return-Path: <linux-kernel-owner+w=401wt.eu-S1752456AbZIZSMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbZIZSMf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 14:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbZIZSMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 14:12:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40501 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbZIZSMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 14:12:33 -0400
Date: Sat, 26 Sep 2009 20:12:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: Fix hwpoison code related build failure on 32-bit
	NUMAQ
Message-ID: <20090926181222.GA26884@elte.hu>
References: <20090916125116.GA12751@basil.fritz.box> <20090926141352.GA26117@elte.hu> <20090926151740.GN30185@one.firstfloor.org> <alpine.LFD.2.01.0909260930410.3303@localhost.localdomain> <20090926173522.GA22723@elte.hu> <alpine.LFD.2.01.0909261038510.3303@localhost.localdomain> <20090926181037.GA4666@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090926181037.GA4666@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > But yeah, with that, and some testing, please add my sign-off (or 
> > acked-by, if you end up changing the patch so much that it has 
> > little to do with my original one)
> 
> It's still mostly your patch so i've added your SOB, thanks. Below is 
> the updated patch.

here it is:

---------------->
>From 2b66d09f804b377e5f9441e3ebdf9a8923337a57 Mon Sep 17 00:00:00 2001
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 26 Sep 2009 09:35:07 -0700
Subject: [PATCH] x86: Fix hwpoison code related build failure on 32-bit NUMAQ

This build failure triggers:

 In file included from include/linux/suspend.h:8,
                 from arch/x86/kernel/asm-offsets_32.c:11,
                 from arch/x86/kernel/asm-offsets.c:2:
 include/linux/mm.h:503:2: error: #error SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > BITS_PER_LONG - NR_PAGEFLAGS

Because due to the hwpoison page flag we ran out of page
flags on 32-bit.

Dont turn on hwpoison on 32-bit NUMA (it's rare in any
case).

Also clean up the Kconfig dependencies in the generic MM
code by introducing ARCH_SUPPORTS_MEMORY_FAILURE.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
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
