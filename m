Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab0BMLjm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 06:39:42 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:58142 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab0BMLjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 06:39:40 -0500
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH  0/8] tip related: radix tree for spareseirq and logical flat clean up
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org>
	<m1zl3dre9e.fsf@fess.ebiederm.org> <4B7676BB.8030608@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 13 Feb 2010 03:39:25 -0800
In-Reply-To: <4B7676BB.8030608@kernel.org> (Yinghai Lu's message of "Sat\, 13 Feb 2010 01\:54\:03 -0800")
Message-ID: <m18waxqs9e.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> please check
>
> Subject: [PATCH] x86: use vector_desc instead of vector_irq
>
> Eric pointed out that radix tree version of irq_to_desc will magnify delay on the path
> of handle_irq.
> use vector_desc to reduce the calling of irq_to_desc.

You have missed Xen's handling of handle_irq.  Let's just kill it like:


>From 0fd5a07f0d346aee37524108d74be7d70c0ab753 Mon Sep 17 00:00:00 2001
From: Eric W. Biederman <ebiederm@xmission.com>
Date: Sat, 13 Feb 2010 03:22:59 -0800
Subject: [PATCH] xen: Remove unnecessary arch specific xen irq functions.

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

diff --git a/arch/ia64/include/asm/xen/events.h b/arch/ia64/include/asm/xen/events.h
index b8370c8..baa74c8 100644
--- a/arch/ia64/include/asm/xen/events.h
+++ b/arch/ia64/include/asm/xen/events.h
@@ -36,10 +36,6 @@ static inline int xen_irqs_disabled(struct pt_regs *regs)
 	return !(ia64_psr(regs)->i);
 }
 
-static inline void handle_irq(int irq, struct pt_regs *regs)
-{
-	__do_IRQ(irq);
-}
 #define irq_ctx_init(cpu)	do { } while (0)
 
 #endif /* _ASM_IA64_XEN_EVENTS_H */
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index ce602dd..2f84137 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -649,9 +649,13 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
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
 
-- 
1.6.5.2.143.g8cc62

