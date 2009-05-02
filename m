Return-Path: <linux-kernel-owner+w=401wt.eu-S1755639AbZEBJkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbZEBJkO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 05:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZEBJj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 05:39:59 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:64743 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbZEBJj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 05:39:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=bXeRw77ljWACkfRed6Q6/jKsIxczRWO4vggDY1LCDKoyDJCWet/oPdGBHaClP9979a
         bg/m78WPqbHe+TBraECFq6hxflAiE79h/zbNYjlAVCRcavrXYMoaj64TC/QCBh2srSza
         ccvlr6wz6VYvsbAnoMkc1/p3kBgT6waOKz680=
Date: Sat, 2 May 2009 13:39:56 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jack Steiner <steiner@sgi.com>
Subject: [PATCH -tip] x86: uv io-apic - use BUILD_BUG_ON instead of BUG_ON
Message-ID: <20090502093956.GB4791@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The expression is known to be true/false at compilation
time so we're allowed to use build-time instead of
run-time check. Also align 'entry' items assignment.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Jack Steiner <steiner@sgi.com>
---
 arch/x86/kernel/apic/io_apic.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/apic/io_apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/io_apic.c
@@ -3752,6 +3752,8 @@ int arch_enable_uv_irq(char *irq_name, u
 	unsigned long flags;
 	int err;
 
+	BUILD_BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
+
 	cfg = irq_cfg(irq);
 
 	err = assign_irq_vector(irq, cfg, eligible_cpu);
@@ -3765,15 +3767,13 @@ int arch_enable_uv_irq(char *irq_name, u
 
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
@@ -3791,10 +3791,10 @@ void arch_disable_uv_irq(int mmr_blade, 
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
