Return-Path: <linux-kernel-owner+w=401wt.eu-S1760840AbXJLVrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760840AbXJLVrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 17:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760459AbXJLVol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 17:44:41 -0400
Received: from 224.sub-75-208-255.myvzw.com ([75.208.255.224]:42270 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760402AbXJLVoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 17:44:39 -0400
Message-Id: <20071012211148.741961000@goop.org>
References: <20071012211132.198718000@goop.org>
User-Agent: quilt/0.46-1
Date: Fri, 12 Oct 2007 14:11:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Keir Fraser <keir@xensource.com>
Subject: [PATCH 09/10] xen: add some debug output for failed multicalls
Content-Disposition: inline; filename=xen-mc-debug.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Multicalls are expected to never fail, and the normal response to a
failed multicall is very terse.  In the interests of better
debuggability, add some more verbose output.  It may be worth turning
this off once it all seems more tested.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/xen/multicalls.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

===================================================================
--- a/arch/i386/xen/multicalls.c
+++ b/arch/i386/xen/multicalls.c
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

