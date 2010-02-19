Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab0BSBhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 20:37:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:33045 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089Ab0BSBhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 20:37:09 -0500
Date: Fri, 19 Feb 2010 01:36:38 GMT
From: "tip-bot for Eric W. Biederman" <ebiederm@xmission.com>
Cc: jeremy@goop.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, Ian.Campbell@citrix.com, tglx@linutronix.de,
       ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jeremy@goop.org, Ian.Campbell@citrix.com, tglx@linutronix.de,
       ebiederm@xmission.com
In-Reply-To: <4B7CAAD2.10803@kernel.org>
References: <4B7CAAD2.10803@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] xen: Remove unnecessary arch specific xen irq functions.
Message-ID: <tip-ca4dbc668412d5fe039be3e26e8e717a616d1ca5@git.kernel.org>
Git-Commit-ID: ca4dbc668412d5fe039be3e26e8e717a616d1ca5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 19 Feb 2010 01:36:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca4dbc668412d5fe039be3e26e8e717a616d1ca5
Gitweb:     http://git.kernel.org/tip/ca4dbc668412d5fe039be3e26e8e717a616d1ca5
Author:     Eric W. Biederman <ebiederm@xmission.com>
AuthorDate: Wed, 17 Feb 2010 18:49:54 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 18 Feb 2010 17:17:58 -0800

xen: Remove unnecessary arch specific xen irq functions.

Right now xen's use of the x86 and ia64 handle_irq is just bizarre and very
fragile as it is very non-obvious the function exists and is is used by
code out in drivers/....  Luckily using handle_irq is completely unnecessary,
and we can just use the generic irq apis instead.

This still leaves drivers/xen/events.c as a problematic user of the generic
irq apis it has "static struct irq_info irq_info[NR_IRQS]" but that can be
fixed some other time.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <4B7CAAD2.10803@kernel.org>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ian Campbell <Ian.Campbell@citrix.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
 
