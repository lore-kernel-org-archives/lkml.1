Return-Path: <linux-kernel-owner+w=401wt.eu-S1759470AbZA2Vhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470AbZA2Vhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 16:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758570AbZA2Vgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 16:36:43 -0500
Received: from gw.goop.org ([64.81.55.164]:59827 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756861AbZA2Vgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 16:36:42 -0500
Message-ID: <49822168.4020108@goop.org>
Date: Thu, 29 Jan 2009 13:36:40 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] xen: setup percpu data pointers
References: <49818842.5020004@goop.org> <1233236625-17928-1-git-send-email-brgerst@gmail.com>
In-Reply-To: <1233236625-17928-1-git-send-email-brgerst@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to access percpu data fairly early, so set up the percpu
registers as soon as possible.  We only need to load the appropriate
segment register.  We already have a GDT, but its hard to change it
early because we need to manipulate the pagetable to do so, and that
hasn't been set up yet.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |    3 +++
 arch/x86/xen/smp.c       |    5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1646,6 +1640,9 @@
 	have_vcpu_info_placement = 0;
 #endif
 
+	/* setup percpu state */
+	load_percpu_segment(0);
+
 	xen_smp_init();
 
 	/* Get mfn list */
===================================================================
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -170,7 +170,8 @@
 
 	/* We've switched to the "real" per-cpu gdt, so make sure the
 	   old memory can be recycled */
-	make_lowmem_page_readwrite(&per_cpu_var(gdt_page));
+	make_lowmem_page_readwrite(__per_cpu_load +
+				   (unsigned long)&per_cpu_var(gdt_page));
 
 	xen_setup_vcpu_info_placement();
 }
@@ -235,6 +236,8 @@
 	ctxt->user_regs.ss = __KERNEL_DS;
 #ifdef CONFIG_X86_32
 	ctxt->user_regs.fs = __KERNEL_PERCPU;
+#else
+	ctxt->gs_base_kernel = per_cpu_offset(cpu);
 #endif
 	ctxt->user_regs.eip = (unsigned long)cpu_bringup_and_idle;
 	ctxt->user_regs.eflags = 0x1000; /* IOPL_RING1 */


