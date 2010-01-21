Return-Path: <linux-kernel-owner+w=401wt.eu-S1754465Ab0AUEZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab0AUEZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245Ab0AUEXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:23:08 -0500
Received: from kroah.org ([198.145.64.141]:60184 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab0AUEXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:23:04 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Jan 20 20:18:35 2010
Message-Id: <20100121041835.601192455@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Jan 2010 20:15:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [24/30] sparc64: Fix NMI programming when perf events are active.
In-Reply-To: <20100121041852.GA9656@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 8183e2b38480672a1f61d416812ac078ce94b67b ]

If perf events are active, we should not reset the %pcr to
PCR_PIC_PRIV.  That perf events code does the management.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/kernel/nmi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/sparc/kernel/nmi.c
+++ b/arch/sparc/kernel/nmi.c
@@ -96,7 +96,6 @@ notrace __kprobes void perfctr_irq(int i
 	int cpu = smp_processor_id();
 
 	clear_softint(1 << irq);
-	pcr_ops->write(PCR_PIC_PRIV);
 
 	local_cpu_data().__nmi_count++;
 
@@ -105,6 +104,8 @@ notrace __kprobes void perfctr_irq(int i
 	if (notify_die(DIE_NMI, "nmi", regs, 0,
 		       pt_regs_trap_type(regs), SIGINT) == NOTIFY_STOP)
 		touched = 1;
+	else
+		pcr_ops->write(PCR_PIC_PRIV);
 
 	sum = kstat_irqs_cpu(0, cpu);
 	if (__get_cpu_var(nmi_touch)) {


