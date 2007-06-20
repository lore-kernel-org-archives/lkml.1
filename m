Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbXFTKZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbXFTKZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 06:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759901AbXFTKXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 06:23:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36154 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757211AbXFTKXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 06:23:38 -0400
From: Andi Kleen <ak@suse.de>
References: <200706201223.443613000@suse.de>
In-Reply-To: <200706201223.443613000@suse.de>
To: righiandr@users.sourceforge.net, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH for 2.6.22] [1/10] i386: bug in i386 MTRR initialization
Message-Id: <20070620102329.9248A14ACF@wotan.suse.de>
Date: Wed, 20 Jun 2007 12:23:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Andrea Righi <righiandr@users.sourceforge.net>
BUG: at include/linux/slub_def.h:77 kmalloc_index()
 [<c0168eb0>] get_slab+0x1d0/0x260
 [<c0169056>] __kmalloc+0x16/0x70
 [<c042b0ff>] sysenter_setup+0x6f/0x330
 [<c010baed>] mtrr_bp_init+0xcd/0x270
 [<c041a480>] unknown_bootoption+0x0/0x250
 [<c041a480>] unknown_bootoption+0x0/0x250
 [<c0423f78>] check_bugs+0x8/0x160
 [<c01a644c>] proc_sys_init+0xc/0x30
 [<c041a8ef>] start_kernel+0x21f/0x2b0
 [<c041a480>] unknown_bootoption+0x0/0x250
 =======================

Reproduced running 2.6.22-rc2 (using SLUB) in a virtual machine with qemu 0.9.0
+ kqemu 1.3.0pre11. It occurs only using "-kernel-kqemu" option (full
virtualization mode).

In this case mtrr is supported by the real cpu, but no mtrr range is found,
resulting in a kmalloc(0, GFP_KERNEL) in get_mtrr_state() and init_table().

I don't know if it's an incorrect behaviour of qemu in the mtrr emulation, but I
think it should be handled properly.

Signed-off-by: Andrea Righi <a.righi@cineca.it>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/cpu/mtrr/generic.c |    3 +++
 arch/i386/kernel/cpu/mtrr/main.c    |    5 +++++
 2 files changed, 8 insertions(+)

Index: linux/arch/i386/kernel/cpu/mtrr/generic.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mtrr/generic.c
+++ linux/arch/i386/kernel/cpu/mtrr/generic.c
@@ -84,6 +84,9 @@ void get_mtrr_state(void)
 	struct mtrr_var_range *vrs;
 	unsigned lo, dummy;
 
+	if (!num_var_ranges)
+		return;
+
 	if (!mtrr_state.var_ranges) {
 		mtrr_state.var_ranges = kmalloc(num_var_ranges * sizeof (struct mtrr_var_range), 
 						GFP_KERNEL);
Index: linux/arch/i386/kernel/cpu/mtrr/main.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mtrr/main.c
+++ linux/arch/i386/kernel/cpu/mtrr/main.c
@@ -120,6 +120,11 @@ static void __init init_table(void)
 {
 	int i, max;
 
+	if (!num_var_ranges) {
+		printk(KERN_ERR "mtrr: no MTRR range found.\n");
+		return;
+	}
+
 	max = num_var_ranges;
 	if ((usage_table = kmalloc(max * sizeof *usage_table, GFP_KERNEL))
 	    == NULL) {
