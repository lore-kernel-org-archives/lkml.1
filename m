Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964802Ab0COKLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 06:11:21 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:15614 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936051Ab0COKLU convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Mon, 15 Mar 2010 06:11:20 -0400
Message-Id: <4B9E15D30200007800034D23@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 15 Mar 2010 10:11:15 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <justinmattock@gmail.com>, <stable@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH, resend] x86: fix placement of FIX_OHCI1394_BASE
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ever for 32-bit with sufficiently high NR_CPUS, and starting with
commit 789d03f584484af85dbdc64935270c8e45f36ef7 also for 64-bit, the
statically allocated early fixmap page tables were not covering
FIX_OHCI1394_BASE, leading to a boot time crash when
"ohci1394_dma=early" was used. Despite this entry not being a
permanently used one, it needs to be moved into the permanent range
since it has to be close to FIX_DBGP_BASE and FIX_EARLYCON_MEM_BASE.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: <stable@kernel.org>
Fixes-bug: http://bugzilla.kernel.org/show_bug.cgi?id=14487 
Reported-bisected-and-tested-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/x86/include/asm/fixmap.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.34-rc1/arch/x86/include/asm/fixmap.h	2010-03-15 10:46:04.000000000 +0100
+++ 2.6.34-rc1-ohci1394-fixmap/arch/x86/include/asm/fixmap.h	2010-03-15 00:00:00.000000000 +0100
@@ -82,6 +82,9 @@ enum fixed_addresses {
 #endif
 	FIX_DBGP_BASE,
 	FIX_EARLYCON_MEM_BASE,
+#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
+	FIX_OHCI1394_BASE,
+#endif
 #ifdef CONFIG_X86_LOCAL_APIC
 	FIX_APIC_BASE,	/* local (CPU) APIC) -- required for SMP or not */
 #endif
@@ -132,9 +135,6 @@ enum fixed_addresses {
 	   (__end_of_permanent_fixed_addresses & (TOTAL_FIX_BTMAPS - 1))
 	 : __end_of_permanent_fixed_addresses,
 	FIX_BTMAP_BEGIN = FIX_BTMAP_END + TOTAL_FIX_BTMAPS - 1,
-#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
-	FIX_OHCI1394_BASE,
-#endif
 #ifdef CONFIG_X86_32
 	FIX_WP_TEST,
 #endif



