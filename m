Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbZBYRmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbZBYRmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 12:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbZBYRm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 12:42:29 -0500
Received: from gw.goop.org ([64.81.55.164]:55190 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbZBYRm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 12:42:29 -0500
Message-ID: <49A58301.2030109@goop.org>
Date: Wed, 25 Feb 2009 09:42:25 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark McLoughlin <markmc@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Stable Kernel <stable@kernel.org>
Subject: [PATCH] xen: disable interrupts early, as start_kernel expects
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids a lockdep warning from:
	if (DEBUG_LOCKS_WARN_ON(unlikely(!early_boot_irqs_enabled)))
		return;
in trace_hardirqs_on_caller();

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 95ff6a0..905cc1c 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -939,6 +939,9 @@ asmlinkage void __init xen_start_kernel(void)
 	   possible map and a non-dummy shared_info. */
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
 
+	local_irq_disable();
+	early_boot_irqs_off();
+
 	xen_raw_console_write("mapping kernel into physical memory\n");
 	pgd = xen_setup_kernel_pagetable(pgd, xen_start_info->nr_pages);
 


