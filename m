Return-Path: <linux-kernel-owner+w=401wt.eu-S936123AbYD1STe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936123AbYD1STe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932285AbYD1STY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:19:24 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:4387 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765310AbYD1STX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:19:23 -0400
Message-ID: <48161529.2000109@ct.jp.nec.com>
Date: Mon, 28 Apr 2008 11:19:21 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: [PATCH -rt 4/4] wait for finish show_regs() before panic
References: <48161325.1080508@ct.jp.nec.com>
In-Reply-To: <48161325.1080508@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

It might cause kdump failure that the kernel doesn't wait for finish
show_regs(). The nmi_show_regs variable for show_regs() flag is cleared
before show_regs() is really called. This flag should be cleared after
show_regs().
kdump stops all CPUs other than crashing CPU by NMI handler, but if
show_regs() takes a bit time, kdump cannot wait and will continue process.
It means that the 2nd kernel and the old kernel run simultaneously and it
might cause unexpected behavior, such as randomly reboot.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Maxim Uvarov <muvarov@ru.mvista.com>
---
 arch/x86/kernel/nmi_32.c |    2 +-
 arch/x86/kernel/nmi_64.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/nmi_32.c b/arch/x86/kernel/nmi_32.c
index d1f92ca..f46bb6e 100644
--- a/arch/x86/kernel/nmi_32.c
+++ b/arch/x86/kernel/nmi_32.c
@@ -355,13 +355,13 @@ notrace int irq_show_regs_callback(int cpu, struct pt_regs *regs)
 	if (!nmi_show_regs[cpu])
 		return 0;
 
-	nmi_show_regs[cpu] = 0;
 	spin_lock(&nmi_print_lock);
 	printk(KERN_WARNING "NMI show regs on CPU#%d:\n", cpu);
 	printk(KERN_WARNING "apic_timer_irqs: %d\n",
 		per_cpu(irq_stat, cpu).apic_timer_irqs);
 	show_regs(regs);
 	spin_unlock(&nmi_print_lock);
+	nmi_show_regs[cpu] = 0;
 	return 1;
 }
 
diff --git a/arch/x86/kernel/nmi_64.c b/arch/x86/kernel/nmi_64.c
index afc0317..8bc2328 100644
--- a/arch/x86/kernel/nmi_64.c
+++ b/arch/x86/kernel/nmi_64.c
@@ -345,12 +345,12 @@ notrace int irq_show_regs_callback(int cpu, struct pt_regs *regs)
 	if (!nmi_show_regs[cpu])
 		return 0;
 
-	nmi_show_regs[cpu] = 0;
 	spin_lock(&nmi_print_lock);
 	printk(KERN_WARNING "NMI show regs on CPU#%d:\n", cpu);
 	printk(KERN_WARNING "apic_timer_irqs: %d\n", read_pda(apic_timer_irqs));
 	show_regs(regs);
 	spin_unlock(&nmi_print_lock);
+	nmi_show_regs[cpu] = 0;
 	return 1;
 }
 
-- 
1.5.4.1

