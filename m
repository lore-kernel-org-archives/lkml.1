Return-Path: <linux-kernel-owner+w=401wt.eu-S1161191AbXBAF5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161191AbXBAF5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 00:57:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161177AbXBAF5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 00:57:13 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35780 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161191AbXBAF5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 00:57:12 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: "Luigi Genoni" <luigi.genoni@pirelli.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86_64:  Survive having no irq mapping for a vector
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<Pine.LNX.4.64.0701232052330.32111@baldios.it.pirelli.com>
	<m1bqkfbnep.fsf@ebiederm.dsl.xmission.com>
	<200701311549.22512.luigi.genoni@pirelli.com>
Date: Wed, 31 Jan 2007 22:56:09 -0700
In-Reply-To: <200701311549.22512.luigi.genoni@pirelli.com> (Luigi Genoni's
	message of "Wed, 31 Jan 2007 15:49:22 +0100")
Message-ID: <m1ps8u8lqe.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Occasionally the kernel has bugs that result in no irq being found for
a given cpu vector.  If we acknowledge the irq the system has a good
chance of continuing even though we dropped an irq message.  If we
continue to simply print a message and not acknowledge the irq the
system is likely to become non-responsive shortly there after. 

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86_64/kernel/irq.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86_64/kernel/irq.c b/arch/x86_64/kernel/irq.c
index 0c06af6..648055a 100644
--- a/arch/x86_64/kernel/irq.c
+++ b/arch/x86_64/kernel/irq.c
@@ -120,9 +120,14 @@ asmlinkage unsigned int do_IRQ(struct pt_regs *regs)
 
 	if (likely(irq < NR_IRQS))
 		generic_handle_irq(irq);
-	else if (printk_ratelimit())
-		printk(KERN_EMERG "%s: %d.%d No irq handler for vector\n",
-			__func__, smp_processor_id(), vector);
+	else {
+		if (!disable_apic)
+			ack_APIC_irq();
+
+		if (printk_ratelimit())
+			printk(KERN_EMERG "%s: %d.%d No irq handler for vector\n",
+				__func__, smp_processor_id(), vector);
+	}
 
 	irq_exit();
 
-- 
1.4.4.1.g278f

