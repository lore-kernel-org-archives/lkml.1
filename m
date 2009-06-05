Return-Path: <linux-kernel-owner+w=401wt.eu-S1758615AbZFEI1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615AbZFEI1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbZFEIHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:07:18 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37598 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755789AbZFEIGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:06:13 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 62/62] Blackfin: fix sparseirq/kstat_irqs fallout
Date: Fri,  5 Jun 2009 04:05:11 -0400
Message-Id: <1244189111-19639-63-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sparseirq changes (d7e51e66) played poorly with the Blackfin irqchip
implementation as we're still using the old hardirq method.  Our bad irq
structure had a NULL kstat_irqs field so when all the common code tries
to increment this field, everything goes big bada boom.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/irqchip.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/kernel/irqchip.c b/arch/blackfin/kernel/irqchip.c
index 401bd32..6e31e93 100644
--- a/arch/blackfin/kernel/irqchip.c
+++ b/arch/blackfin/kernel/irqchip.c
@@ -59,12 +59,14 @@ static struct irq_chip bad_chip = {
 	.unmask = dummy_mask_unmask_irq,
 };
 
+static int bad_stats;
 static struct irq_desc bad_irq_desc = {
 	.status = IRQ_DISABLED,
 	.chip = &bad_chip,
 	.handle_irq = handle_bad_irq,
 	.depth = 1,
 	.lock = __SPIN_LOCK_UNLOCKED(irq_desc->lock),
+	.kstat_irqs = &bad_stats,
 #ifdef CONFIG_SMP
 	.affinity = CPU_MASK_ALL
 #endif
-- 
1.6.3.1

