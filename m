Return-Path: <linux-kernel-owner+w=401wt.eu-S933842AbZDHTh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933842AbZDHTh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 15:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933158AbZDHThD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 15:37:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:3032 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933303AbZDHThA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 15:37:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=a6iKhYFamdU8BJI48VH3MqmnfvT0n3UixSii1W/MqyX0hUfLi5rvkg8pdRF6B7nPqv
         2WkfWLn2YO6f9MrJrmLCVchFIFdiOD/KjEi2E7N02syqhC5lDMwLZyyBbD6up6J6HHJj
         n9sVQV4CMAKyMj9TSyizsCJfq4u65vsGjIO7A=
Date: Wed, 8 Apr 2009 23:36:56 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH -tip] x86: do_IRQ - send EOI for x86-32 on irq without
	handler v3
Message-ID: <20090408193656.GI7556@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For X86-32 if IRQ has no handler it remains non-Ack'ed
even if APIC is not requested for being disabled.

Since disable_apic depends on CONFIG_X86_LOCAL_APIC rather
then CONFIG_X86_64 we could bring tiny fix here.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/irq.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Ingo it's an interim fix.

I didn't manage yet to implement what you proposed
(marked http://lkml.org/lkml/2009/4/8/549).

Index: linux-2.6.git/arch/x86/kernel/irq.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/irq.c
+++ linux-2.6.git/arch/x86/kernel/irq.c
@@ -223,10 +223,16 @@ unsigned int __irq_entry do_IRQ(struct p
 	irq = __get_cpu_var(vector_irq)[vector];
 
 	if (!handle_irq(irq, regs)) {
-#ifdef CONFIG_X86_64
+		/*
+		 * FIXME: Actually we could go further and replace
+		 * ack_APIC_irq->apic_write->apic->write with a NOP
+		 * operation as only disable_apic is set and happily call
+		 * ack_APIC_irq after that without any tests
+		 */
+#ifdef CONFIG_X86_LOCAL_APIC
 		if (!disable_apic)
-			ack_APIC_irq();
 #endif
+			ack_APIC_irq();
 
 		if (printk_ratelimit())
 			printk(KERN_EMERG "%s: %d.%d No irq handler for vector (irq %d)\n",
