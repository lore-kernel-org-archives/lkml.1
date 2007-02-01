Return-Path: <linux-kernel-owner+w=401wt.eu-S1422856AbXBANKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422856AbXBANKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422825AbXBANKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:10:16 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:59579 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422856AbXBANKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:10:15 -0500
From: Magnus Damm <magnus@valinux.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, jlan@sgi.com, nanhai.zou@intel.com, magnus.damm@gmail.com,
       Magnus Damm <magnus@valinux.co.jp>, horms@verge.net.au
Date: Thu, 01 Feb 2007 22:08:48 +0900
Message-Id: <20070201130848.3785.12144.sendpatchset@localhost>
Subject: [PATCH] kexec: Avoid migration of already disabled irqs (ia64)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kexec: Avoid migration of already disabled irqs (ia64)

This patch fixes up ia64 kexec support for HP rx2620 hardware. It does this 
by skipping migration of already disabled irqs. This is most likely a problem
on other ia64 platforms as well, but I've only been able to reproduce it on
one machine so far.

The full story is that handle_bad_irq() gets invoked before starting the new 
kernel without this patch. This seems to happen when fixup_irqs() calls 
generic_handle_irq() on already migrated (and disabled) irqs. So by avoiding
migration of disabled irqs we stay away of handle_bad_irq().

The code has been tested on three different ia64 machines, all with good 
results. It is possible to trigger the same bug by offlining a processor
using echo 0 > /sys/devices/system/cpu/cpuX/online.

More detailed information is available in the following mail thread:
http://lists.osdl.org/pipermail/fastboot/2007-January/thread.html#5774

Signed-off-by: Magnus Damm <magnus@valinux.co.jp>
Acked-by: Simon Horman <horms@verge.net.au>
Acked-by: Zou, Nanhai <nanhai.zou@intel.com>
Acked-by: Jay Lan <jlan@sgi.com>
---

 Tested using kexec-tools-testing 7792798a79b78a5d566f70c9f00237d050b01350
 on HP rx2620 hardware.

 Applies on top of 2.6.20-rc7.

 arch/ia64/kernel/irq.c |    3 +++
 1 file changed, 3 insertions(+)

--- 0001/arch/ia64/kernel/irq.c
+++ 0004/arch/ia64/kernel/irq.c	2007-01-30 12:35:10.000000000 +0900
@@ -122,6 +122,9 @@ static void migrate_irqs(void)
 	for (irq=0; irq < NR_IRQS; irq++) {
 		desc = irq_desc + irq;
 
+		if (desc->status == IRQ_DISABLED)
+			continue;
+
 		/*
 		 * No handling for now.
 		 * TBD: Implement a disable function so we can now
