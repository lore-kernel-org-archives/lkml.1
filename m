Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbZGTO2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbZGTO2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 10:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbZGTO2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 10:28:43 -0400
Received: from relay1.sgi.com ([192.48.179.29]:45183 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751822AbZGTO2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 10:28:43 -0400
Date: Mon, 20 Jul 2009 09:28:41 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] - Complete IRQ interrupt migration in arch_enable_uv_irq()
Message-ID: <20090720142840.GA8885@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In uv_setup_irq(), the call to create_irq() initially assigns IRQ
vectors to cpu 0. The subsequent call to assign_irq_vector() in
arch_enable_uv_irq() migrates the IRQ to another cpu and frees the cpu
0 vector - at least it will be freed as soon as the "IRQ move"
completes. 

arch_enable_uv_irq() needs to send a cleanup IPI to complete the IRQ move.
Otherwise, assignment of GRU interrupts on large systems (>200 cpus)
will exhaust the cpu 0 interrupt vectors and initialization of the GRU
driver will fail.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 arch/x86/kernel/apic/io_apic.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/io_apic.c	2009-07-20 07:55:46.000000000 -0500
+++ linux/arch/x86/kernel/apic/io_apic.c	2009-07-20 07:56:33.000000000 -0500
@@ -3737,6 +3737,9 @@ int arch_enable_uv_irq(char *irq_name, u
 	mmr_pnode = uv_blade_to_pnode(mmr_blade);
 	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
 
+	if (cfg->move_in_progress)
+		send_cleanup_vector(cfg);
+
 	return irq;
 }
 
