Return-Path: <linux-kernel-owner+w=401wt.eu-S932072AbZEDQ7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbZEDQ7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758313AbZEDQ6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:58:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:37504 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757943AbZEDQ6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:58:44 -0400
Date: Mon, 4 May 2009 16:57:57 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090502093956.GB4791@lenovo>
References: <20090502093956.GB4791@lenovo>
Subject: [tip:x86/apic] x86: uv io-apic - use BUILD_BUG_ON instead of BUG_ON
Message-ID: <tip-1cbac972ba28e706fa9ce4d4c81830040bc811ee@git.kernel.org>
Git-Commit-ID: 1cbac972ba28e706fa9ce4d4c81830040bc811ee
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 04 May 2009 16:57:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1cbac972ba28e706fa9ce4d4c81830040bc811ee
Gitweb:     http://git.kernel.org/tip/1cbac972ba28e706fa9ce4d4c81830040bc811ee
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Sat, 2 May 2009 13:39:56 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 3 May 2009 10:38:21 +0200

x86: uv io-apic - use BUILD_BUG_ON instead of BUG_ON

The expression is known to be true/false at compilation
time so we're allowed to use build-time instead of
run-time check. Also align 'entry' items assignment.

[ Impact: shrink kernel a bit, cleanup ]

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20090502093956.GB4791@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/io_apic.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8aef5f9..a80335b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3749,6 +3749,8 @@ int arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 	unsigned long flags;
 	int err;
 
+	BUILD_BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
+
 	cfg = irq_cfg(irq);
 
 	err = assign_irq_vector(irq, cfg, eligible_cpu);
@@ -3762,15 +3764,13 @@ int arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 
 	mmr_value = 0;
 	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
-	BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
-
-	entry->vector = cfg->vector;
-	entry->delivery_mode = apic->irq_delivery_mode;
-	entry->dest_mode = apic->irq_dest_mode;
-	entry->polarity = 0;
-	entry->trigger = 0;
-	entry->mask = 0;
-	entry->dest = apic->cpu_mask_to_apicid(eligible_cpu);
+	entry->vector		= cfg->vector;
+	entry->delivery_mode	= apic->irq_delivery_mode;
+	entry->dest_mode	= apic->irq_dest_mode;
+	entry->polarity		= 0;
+	entry->trigger		= 0;
+	entry->mask		= 0;
+	entry->dest		= apic->cpu_mask_to_apicid(eligible_cpu);
 
 	mmr_pnode = uv_blade_to_pnode(mmr_blade);
 	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
@@ -3788,10 +3788,10 @@ void arch_disable_uv_irq(int mmr_blade, unsigned long mmr_offset)
 	struct uv_IO_APIC_route_entry *entry;
 	int mmr_pnode;
 
+	BUILD_BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
+
 	mmr_value = 0;
 	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
-	BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
-
 	entry->mask = 1;
 
 	mmr_pnode = uv_blade_to_pnode(mmr_blade);
