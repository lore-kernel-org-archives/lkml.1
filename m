Return-Path: <linux-kernel-owner+w=401wt.eu-S1762416AbXESOJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762416AbXESOJq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 10:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758012AbXESOJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 10:09:39 -0400
Received: from as3.cineca.com ([130.186.84.211]:44918 "EHLO as3.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758174AbXESOJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 10:09:38 -0400
Message-ID: <464F0515.80304@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070326 Thunderbird/2.0.0.0 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: rgooch@atnf.csiro.au
Cc: LKML <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
Subject: 2.6.22-rc2: bug in i386 MTRR initialization
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Date: Sat, 19 May 2007 16:09:35 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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

--- linux-2.6.22-rc2/arch/i386/kernel/cpu/mtrr/generic.c.orig	2007-05-19 15:55:24.000000000 +0200
+++ linux-2.6.22-rc2/arch/i386/kernel/cpu/mtrr/generic.c	2007-05-19 15:57:51.000000000 +0200
@@ -84,6 +84,9 @@ void get_mtrr_state(void)
 	struct mtrr_var_range *vrs;
 	unsigned lo, dummy;
 
+	if (!num_var_ranges)
+		return;
+
 	if (!mtrr_state.var_ranges) {
 		mtrr_state.var_ranges = kmalloc(num_var_ranges * sizeof (struct mtrr_var_range), 
 						GFP_KERNEL);
--- linux-2.6.22-rc2/arch/i386/kernel/cpu/mtrr/main.c.orig	2007-05-19 15:55:12.000000000 +0200
+++ linux-2.6.22-rc2/arch/i386/kernel/cpu/mtrr/main.c	2007-05-19 15:55:42.000000000 +0200
@@ -120,6 +120,11 @@ static void __init init_table(void)
 {
 	int i, max;
 
+        if (!num_var_ranges) {
+		printk(KERN_ERR "mtrr: no MTRR range found.\n");
+		return;
+        }
+
 	max = num_var_ranges;
 	if ((usage_table = kmalloc(max * sizeof *usage_table, GFP_KERNEL))
 	    == NULL) {
