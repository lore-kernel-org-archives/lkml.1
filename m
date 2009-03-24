Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbZCXVTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbZCXVTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZCXVSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:18:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:60301 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013AbZCXVSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:18:34 -0400
Message-ID: <49C94DDF.2010703@kernel.org>
Date: Tue, 24 Mar 2009 14:17:19 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] x86: Correct behaviour of irq affinity
References: <200903241619.03517.rusty@rustcorp.com.au> <m1k56frt6e.fsf@fess.ebiederm.org> <49C94134.4000408@kernel.org> <49C94D82.1040708@kernel.org>
In-Reply-To: <49C94D82.1040708@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Impact: get correct smp_affinity as user requested

The effect of setting desc->affinity (ie. from userspace via sysfs) has varied
over time.  In 2.6.27, the 32-bit code anded the value with cpu_online_map,
and both 32 and 64-bit did that anding whenever a cpu was unplugged.

2.6.29 consolidated this into one routine (and fixed hotplug) but introduced
another variation: anding the affinity with cfg->domain.  Is this right, or
should we just set it to what the user said?  Or as now, indicate that we're
restricting it.

If we should change it, here's what the patch looks like against x86 tip
(cpu_mask_to_apicid_and already takes cpu_online_mask into account)

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

---
 arch/x86/kernel/apic/io_apic.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -594,9 +594,10 @@ set_desc_affinity(struct irq_desc *desc,
 
 	/* check that before desc->addinity get updated */
 	set_extra_move_desc(desc, mask);
-	cpumask_and(desc->affinity, cfg->domain, mask);
 
-	return apic->cpu_mask_to_apicid_and(desc->affinity, cpu_online_mask);
+	cpumask_copy(desc->affinity, mask);
+
+	return apic->cpu_mask_to_apicid_and(desc->affinity, cfg->cpu_domain);
 }
 
 static void
