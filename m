Return-Path: <linux-kernel-owner+w=401wt.eu-S1752400AbYFSToY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbYFSToY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 15:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750792AbYFSToQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 15:44:16 -0400
Received: from bq8.dotserv.com ([193.201.35.47]:34049 "EHLO bq8.dotserv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbYFSToQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 15:44:16 -0400
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jun 2008 15:44:15 EDT
Message-ID: <485AB581.9070509@doredevelopment.dk>
Date: Thu, 19 Jun 2008 21:37:37 +0200
From: Esben Haabendal <eha@doredevelopment.dk>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Add support for IRQ_NOAUTOEN in __set_irq_handler
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any reason for __set_irq_handler not supporting the IRQ_NOAUTOEN flag?

/Esben

 kernel/irq/chip.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 964964b..42bb163 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -584,10 +584,15 @@ __set_irq_handler(unsigned int irq,
irq_flow_handler_t handle, int is_chained,
 	desc->name = name;

 	if (handle != handle_bad_irq && is_chained) {
-		desc->status &= ~IRQ_DISABLED;
 		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
-		desc->depth = 0;
-		desc->chip->unmask(irq);
+		if (!(desc->status & IRQ_NOAUTOEN)) {
+			desc->depth = 0;
+			desc->status &= ~IRQ_DISABLED;
+			desc->chip->unmask(irq);
+		} else {
+			/* Undo nested disables: */
+			desc->depth = 1;
+		}
 	}
 	spin_unlock_irqrestore(&desc->lock, flags);
 }

-- 
Esben Haabendal, Senior Software Consultant
DoréDevelopment ApS, Ved Stranden 1, 9560 Hadsund, DK-Denmark
Tlf: +45 51 92 53 93, mail: eha@doredevelopment.dk
WWW: http://www.doredevelopment.dk
