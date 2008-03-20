Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbYCTHog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbYCTHog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 03:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755874AbYCTHn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 03:43:58 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:47956 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864AbYCTHn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 03:43:57 -0400
Date: Thu, 20 Mar 2008 00:43:16 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>, Andi Kleen <ak@suse.de>,
       shai@scalex86.org
Subject: [patch 3/4] x86: vSMP: Use pvops only if platform has the capability to support it
Message-ID: <20080320074316.GD9414@localdomain>
References: <20080320073740.GA9414@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320073740.GA9414@localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-arrange set_vsmp_pv_ops so that pv_ops are set only if
the platform has capability to support paravirtualized irq ops

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>

Index: linux.git.trees/arch/x86/kernel/vsmp_64.c
===================================================================
--- linux.git.trees.orig/arch/x86/kernel/vsmp_64.c	2008-03-19 20:53:34.267707163 -0700
+++ linux.git.trees/arch/x86/kernel/vsmp_64.c	2008-03-19 21:21:47.853254516 -0700
@@ -78,12 +78,6 @@ static void __init set_vsmp_pv_ops(void)
 	void *address;
 	unsigned int cap, ctl, cfg;
 
-	pv_irq_ops.irq_disable = vsmp_irq_disable;
-	pv_irq_ops.irq_enable  = vsmp_irq_enable;
-	pv_irq_ops.save_fl  = vsmp_save_fl;
-	pv_irq_ops.restore_fl  = vsmp_restore_fl;
-	pv_init_ops.patch = vsmp_patch;
-
 	/* set vSMP magic bits to indicate vSMP capable kernel */
 	cfg = read_pci_config(0, 0x1f, 0, PCI_BASE_ADDRESS_0);
 	address = early_ioremap(cfg, 8);
@@ -92,7 +86,13 @@ static void __init set_vsmp_pv_ops(void)
 	printk(KERN_INFO "vSMP CTL: capabilities:0x%08x  control:0x%08x\n",
 	       cap, ctl);
 	if (cap & ctl & (1 << 4)) {
-		/* Turn on vSMP IRQ fastpath handling (see system.h) */
+		/* Setup irq ops and turn on vSMP  IRQ fastpath handling */
+		pv_irq_ops.irq_disable = vsmp_irq_disable;
+		pv_irq_ops.irq_enable  = vsmp_irq_enable;
+		pv_irq_ops.save_fl  = vsmp_save_fl;
+		pv_irq_ops.restore_fl  = vsmp_restore_fl;
+		pv_init_ops.patch = vsmp_patch;
+
 		ctl &= ~(1 << 4);
 		writel(ctl, address + 4);
 		ctl = readl(address + 4);
