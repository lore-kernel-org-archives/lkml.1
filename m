Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbZCXVql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbZCXVql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbZCXVoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:44:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:57739 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755419AbZCXVoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:44:37 -0400
Message-ID: <49C953D0.5000104@kernel.org>
Date: Tue, 24 Mar 2009 14:42:40 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, rusty@rustcorp.com.au,
       ebiederm@xmission.com, akpm@linux-foundation.org, tglx@linutronix.de
Subject: [PATCH 3/3] x86: Correct behaviour of irq affinity -v2
References: <49C94DAE.9070300@kernel.org> <tip-f56e5034121c4911a155ba907076ab920754626d@git.kernel.org> <20090324213458.GA29440@elte.hu>
In-Reply-To: <20090324213458.GA29440@elte.hu>
Content-Type: text/plain; charset=UTF-8
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
+	return apic->cpu_mask_to_apicid_and(desc->affinity, cfg->domain);
 }
 
 static void
