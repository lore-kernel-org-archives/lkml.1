Return-Path: <linux-kernel-owner+w=401wt.eu-S933277AbXJOVwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277AbXJOVwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761522AbXJOVtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:49:53 -0400
Received: from zrnetservice.com ([209.133.52.163]:33164 "EHLO
	wifi.zrnetservice.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757590AbXJOVtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:49:50 -0400
Message-Id: <20071015210115.429058413@goop.org>
References: <20071015204840.074767068@goop.org>
User-Agent: quilt/0.46-1
Date: Mon, 15 Oct 2007 13:48:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Keir Fraser <keir@xensource.com>,
       Stable Kernel <stable@kernel.org>
Subject: [PATCH 11/12] xen: add some debug output for failed multicalls
Content-Disposition: inline; filename=xen-mc-debug.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Multicalls are expected to never fail, and the normal response to a
failed multicall is very terse.  In the interests of better
debuggability, add some more verbose output.  It may be worth turning
this off once it all seems more tested.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/x86/xen/multicalls.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

===================================================================
--- a/arch/x86/xen/multicalls.c
+++ b/arch/x86/xen/multicalls.c
@@ -26,11 +26,16 @@
 
 #include "multicalls.h"
 
+#define MC_DEBUG	1
+
 #define MC_BATCH	32
 #define MC_ARGS		(MC_BATCH * 16 / sizeof(u64))
 
 struct mc_buffer {
 	struct multicall_entry entries[MC_BATCH];
+#if MC_DEBUG
+	struct multicall_entry debug[MC_BATCH];
+#endif
 	u64 args[MC_ARGS];
 	struct callback {
 		void (*fn)(void *);
@@ -56,11 +61,31 @@ void xen_mc_flush(void)
 	local_irq_save(flags);
 
 	if (b->mcidx) {
+#if MC_DEBUG
+		memcpy(b->debug, b->entries,
+		       b->mcidx * sizeof(struct multicall_entry));
+#endif
+
 		if (HYPERVISOR_multicall(b->entries, b->mcidx) != 0)
 			BUG();
 		for (i = 0; i < b->mcidx; i++)
 			if (b->entries[i].result < 0)
 				ret++;
+
+#if MC_DEBUG
+		if (ret) {
+			printk(KERN_ERR "%d multicall(s) failed: cpu %d\n",
+			       ret, smp_processor_id());
+			for(i = 0; i < b->mcidx; i++) {
+				printk("  call %2d/%d: op=%lu arg=[%lx] result=%ld\n",
+				       i+1, b->mcidx,
+				       b->debug[i].op,
+				       b->debug[i].args[0],
+				       b->entries[i].result);
+			}
+		}
+#endif
+
 		b->mcidx = 0;
 		b->argidx = 0;
 	} else

-- 

