Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbZD1TF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbZD1TF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 15:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbZD1TFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 15:05:14 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:47489 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbZD1TFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 15:05:12 -0400
X-IronPort-AV: E=Sophos;i="4.40,261,1238976000"; 
   d="scan'208";a="73713561"
From: Roland Dreier <rdreier@cisco.com>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de
Cc: David Miller <davem@davemloft.net>, h.mitake@gmail.com,
       rpjday@crashcourse.ca, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Remove readq()/writeq() on 32-bit
References: <49EE19E0.8040405@zytor.com> <adaocupvhid.fsf@cisco.com>
	<49EE37AF.4020507@zytor.com>
	<20090421.173123.191021055.davem@davemloft.net>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 28 Apr 2009 12:05:10 -0700
In-Reply-To: <20090421.173123.191021055.davem@davemloft.net> (David Miller's
	message of "Tue, 21 Apr 2009 17:31:23 -0700 (PDT)")
Message-ID: <adak55438gp.fsf_-_@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Apr 2009 19:05:11.0195 (UTC) FILETIME=[410C4EB0:01C9C834]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed in <http://lkml.org/lkml/2009/4/19/164> and follow-ups,
readq()/writeq() for 32-bit x86 are implemented as two readl()/writel()
operations.  This is not atomic (in the sense that another MMIO
operation from another CPU or thread can be done in the middle of the
two read/writes), and may not access the two halves of the register in
the correct order to work with hardware.

Rather than silently providing a 32-bit fallback that leaves a
possibility for strange driver bugs, it's better to provide readq()
and writeq() only for 64-bit architectures, and have a compile failure
on 32-bit architectures that forces driver authors to think about what
the correct solution is.

This essentially reverts 2c5643b1 ("x86: provide readq()/writeq() on
32-bit too") and follow-on commits.  If in the future someone wants to
provide a generic solution for all 32-bit architectures, that's great,
but there's not much point in providing (arguably broken)
implementations for only one architecture, since any portable driver
will have to implement fallbacks for other architectures anyway.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
We never seemed to reach closure on this.  I would strongly suggest
merging something like this, and then if someone has a grand plan to
unify all fallbacks, we can add that when it shows up.  As it stands,
the x86-32 situation is not progress towards that grand unified plans,
and does nothing that I can tell beyond setting a trap for drivers.

 arch/x86/Kconfig          |    2 --
 arch/x86/include/asm/io.h |   23 ++---------------------
 2 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index df9e885..0be277b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -19,8 +19,6 @@ config X86_64
 config X86
 	def_bool y
 	select HAVE_AOUT if X86_32
-	select HAVE_READQ
-	select HAVE_WRITEQ
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_IDE
 	select HAVE_OPROFILE
diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 7373932..199c7b9 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -51,27 +51,6 @@ build_mmio_write(__writel, "l", unsigned int, "r", )
 build_mmio_read(readq, "q", unsigned long, "=r", :"memory")
 build_mmio_write(writeq, "q", unsigned long, "r", :"memory")
 
-#else
-
-static inline __u64 readq(const volatile void __iomem *addr)
-{
-	const volatile u32 __iomem *p = addr;
-	u32 low, high;
-
-	low = readl(p);
-	high = readl(p + 1);
-
-	return low + ((u64)high << 32);
-}
-
-static inline void writeq(__u64 val, volatile void __iomem *addr)
-{
-	writel(val, addr);
-	writel(val >> 32, addr+4);
-}
-
-#endif
-
 #define readq_relaxed(a)	readq(a)
 
 #define __raw_readq(a)		readq(a)
@@ -81,6 +60,8 @@ static inline void writeq(__u64 val, volatile void __iomem *addr)
 #define readq			readq
 #define writeq			writeq
 
+#endif
+
 /**
  *	virt_to_phys	-	map virtual addresses to physical
  *	@address: address to remap
