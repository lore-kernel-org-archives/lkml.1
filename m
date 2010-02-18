Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab0BRCvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 21:51:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:32955 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932755Ab0BRCvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 21:51:44 -0500
Message-ID: <4B7CAAD2.10803@kernel.org>
Date: Wed, 17 Feb 2010 18:49:54 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 1/3] xen: Remove unnecessary arch specific xen irq functions.
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org>	<m1zl3dre9e.fsf@fess.ebiederm.org> <4B7676BB.8030608@kernel.org>	<m1ljexpcjp.fsf@fess.ebiederm.org> <4B772A54.1000000@kernel.org>	<m16360ohi2.fsf@fess.ebiederm.org> <4B773CEB.9010609@kernel.org> <m1sk94mzg0.fsf@fess.ebiederm.org>
In-Reply-To: <m1sk94mzg0.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>


Right now xen's use of the x86 and ia64 handle_irq is just bizarre and very
fragile as it is very non-obvious the function exists and is is used by
code out in drivers/....  Luckily using handle_irq is completly unnecessary,
and we can just use the generic irq apis instead.

This still leaves drivers/xen/events.c as a problematic user of the generic
irq apis it has "static struct irq_info irq_info[NR_IRQS]" but that can be
fixed some other time.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/ia64/include/asm/xen/events.h |    4 ----
 drivers/xen/events.c               |    8 ++++++--
 2 files changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/ia64/include/asm/xen/events.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/xen/events.h
+++ linux-2.6/arch/ia64/include/asm/xen/events.h
@@ -36,10 +36,6 @@ static inline int xen_irqs_disabled(stru
 	return !(ia64_psr(regs)->i);
 }
 
-static inline void handle_irq(int irq, struct pt_regs *regs)
-{
-	__do_IRQ(irq);
-}
 #define irq_ctx_init(cpu)	do { } while (0)
 
 #endif /* _ASM_IA64_XEN_EVENTS_H */
Index: linux-2.6/drivers/xen/events.c
===================================================================
--- linux-2.6.orig/drivers/xen/events.c
+++ linux-2.6/drivers/xen/events.c
@@ -649,9 +649,13 @@ void xen_evtchn_do_upcall(struct pt_regs
 				int bit_idx = __ffs(pending_bits);
 				int port = (word_idx * BITS_PER_LONG) + bit_idx;
 				int irq = evtchn_to_irq[port];
+				struct irq_desc *desc;
 
-				if (irq != -1)
-					handle_irq(irq, regs);
+				if (irq != -1) {
+					desc = irq_to_desc(irq);
+					if (desc)
+						generic_handle_irq_desc(irq, desc);
+				}
 			}
 		}
 
