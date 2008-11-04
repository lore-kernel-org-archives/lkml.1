Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbYKDQzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbYKDQzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757148AbYKDQzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:55:07 -0500
Received: from gate.crashing.org ([63.228.1.57]:37170 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757029AbYKDQzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:55:06 -0500
Date: Tue, 4 Nov 2008 10:54:32 -0600 (CST)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: Linus Torvalds <torvalds@osdl.org>
cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Andrew Morton <akpm@osdl.org>, linuxppc-dev@ozlabs.org
Subject: [PATCH 1/1][resend] irq: Maintain user set affinity
Message-ID: <Pine.LNX.4.64.0811041053400.17102@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This addresses a regression in that if a user specified an affinity
for an interrupt that affinity information would get reset between
a request_irq(), free_irq() and request_irq() for the same irq.

On example of this is bringing up an ethernet interface, taking
it down and bringing it back up again.

Instead of always using the irq_default_affinity we use the
previous setting of the IRQs affinity with the assumption that
at boot the IRQs affinity will be set to irq_default_affinity.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---

reposting since the first patch I forgot to cull some header info from the
body of the emai.

- k

 kernel/irq/manage.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index c498a1b..ea7d11b 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -115,9 +115,12 @@ int irq_select_affinity(unsigned int irq)
 	if (!irq_can_set_affinity(irq))
 		return 0;

-	cpus_and(mask, cpu_online_map, irq_default_affinity);
-
 	desc = irq_to_desc(irq);
+
+	mask = desc->affinity;
+
+	cpus_and(mask, cpu_online_map, mask);
+
 	desc->affinity = mask;
 	desc->chip->set_affinity(irq, mask);

-- 
1.5.5.1

