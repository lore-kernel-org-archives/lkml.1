Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbYGHXaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbYGHXaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757030AbYGHXPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:18 -0400
Received: from gw.goop.org ([64.81.55.164]:51214 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757413AbYGHXOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:46 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 41 of 55] xen64: add identity irq->vector map
X-Mercurial-Node: e273cd1f23f7efc9f907384b08fac2ac84d26440
Message-Id: <e273cd1f23f7efc9f907.1215554823@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:07:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86_64 interrupt subsystem is oriented towards vectors, as opposed
to a flat irq space as it is in x86-32.  This patch adds a simple
identity irq->vector mapping so that we can continue to feed irqs into
do_IRQ() and get a good result.

Ideally x86_32 will unify with the 64-bit code and use vectors too.
At that point we can move to mapping event channels to vectors, which
will allow us to economise on irqs (so per-cpu event channels can
share irqs, rather than having to allocte one per cpu, for example).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1085,8 +1085,25 @@
 	},
 };
 
+static void __init __xen_init_IRQ(void)
+{
+#ifdef CONFIG_X86_64
+	int i;
+
+	/* Create identity vector->irq map */
+	for(i = 0; i < NR_VECTORS; i++) {
+		int cpu;
+
+		for_each_possible_cpu(cpu)
+			per_cpu(vector_irq, cpu)[i] = i;
+	}
+#endif	/* CONFIG_X86_64 */
+
+	xen_init_IRQ();
+}
+
 static const struct pv_irq_ops xen_irq_ops __initdata = {
-	.init_IRQ = xen_init_IRQ,
+	.init_IRQ = __xen_init_IRQ,
 	.save_fl = xen_save_fl,
 	.restore_fl = xen_restore_fl,
 	.irq_disable = xen_irq_disable,


