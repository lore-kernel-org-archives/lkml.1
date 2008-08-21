Return-Path: <linux-kernel-owner+w=401wt.eu-S1760888AbYHUS0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760888AbYHUS0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbYHUS0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:26:47 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:55682 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753369AbYHUS0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:26:46 -0400
Subject: x86: VMI: Fix bug, do_IRQ: cannot handle...
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>
Cc: Zachary Amsden <zach@vmware.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 21 Aug 2008 11:26:43 -0700
Message-Id: <1219343203.18349.39.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the patch which needs to be applied to x86-tip/master, to fix
the VMI bug caused by 
commit 9c3f2468d8339866d9ef6a25aae31a8909c6be0d.
x86: make 32bit support per_cpu vector

Thanks to Yinghai, for giving a heads up.

Please apply.

Alok

--
From: Alok N Kataria <akataria@vmware.com>

x86: VMI, Initialize IRQ vector.

Initialize vector_irq for the vmi used vector, to point to correct irq.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Cc: Zachary Amsden <zach@vmware.com>
---

 arch/x86/kernel/vmiclock_32.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
index 6953859..254ee07 100644
--- a/arch/x86/kernel/vmiclock_32.c
+++ b/arch/x86/kernel/vmiclock_32.c
@@ -235,11 +235,14 @@ static void __devinit vmi_time_init_clockevent(void)
 
 void __init vmi_time_init(void)
 {
+	unsigned int cpu;
 	/* Disable PIT: BIOSes start PIT CH0 with 18.2hz peridic. */
 	outb_pit(0x3a, PIT_MODE); /* binary, mode 5, LSB/MSB, ch 0 */
 
 	vmi_time_init_clockevent();
 	setup_irq(0, &vmi_clock_action);
+	for_each_possible_cpu(cpu)
+		per_cpu(vector_irq, cpu)[vmi_get_timer_vector()] = 0;
 }
 
 #ifdef CONFIG_X86_LOCAL_APIC


