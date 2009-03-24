Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbZCXFtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbZCXFtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 01:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbZCXFtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 01:49:10 -0400
Received: from ozlabs.org ([203.10.76.45]:57619 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbZCXFtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 01:49:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: x86@kernel.org
Subject: [RFC] Correct behaviour of irq affinity?
Date: Tue, 24 Mar 2009 16:19:03 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903241619.03517.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The effect of setting desc->affinity (ie. from userspace via sysfs) has varied
over time.  In 2.6.27, the 32-bit code anded the value with cpu_online_map,
and both 32 and 64-bit did that anding whenever a cpu was unplugged.

2.6.29 consolidated this into one routine (and fixed hotplug) but introduced
another variation: anding the affinity with cfg->domain.  Is this right, or
should we just set it to what the user said?  Or as now, indicate that we're
restricting it.

If we should change it, here's what the patch looks like against x86 tip
(cpu_mask_to_apicid_and already takes cpu_online_mask into account):

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 86827d8..30906cd 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -592,10 +592,10 @@ set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask)
 	if (assign_irq_vector(irq, cfg, mask))
 		return BAD_APICID;
 
-	cpumask_and(desc->affinity, cfg->domain, mask);
+	cpumask_copy(desc->affinity, mask);
 	set_extra_move_desc(desc, mask);
 
-	return apic->cpu_mask_to_apicid_and(desc->affinity, cpu_online_mask);
+	return apic->cpu_mask_to_apicid_and(desc->affinity, cfg->domain);
 }
 
 static void

