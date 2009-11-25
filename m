Return-Path: <linux-kernel-owner+w=401wt.eu-S1758976AbZKYSUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbZKYSUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 13:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758880AbZKYSUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 13:20:12 -0500
Received: from www.tglx.de ([62.245.132.106]:50020 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568AbZKYSUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 13:20:11 -0500
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] MXC: set GPIO IRQ handler
From: John Ogness <john.ogness@linutronix.de>
Date: Wed, 25 Nov 2009 19:19:58 +0100
Message-ID: <807htelb5d.fsf@merkur.tec.linutronix.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq chip function gpio_set_irq_type() correctly sets the i.MX
registers but does not set the irq handler. This means that all
gpio-based irq's are handled with handle_edge_irq().

This patch corrects this by also setting the appropriate handler.

This patch is against 2.6.32-rc8.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
---
 arch/arm/plat-mxc/gpio.c |    5 +++++
 1 file changed, 5 insertions(+)
--- a/arch/arm/plat-mxc/gpio.c
+++ b/arch/arm/plat-mxc/gpio.c
@@ -126,6 +126,11 @@ static int gpio_set_irq_type(u32 irq, u3
 	__raw_writel(val | (edge << (bit << 1)), reg);
 	_clear_gpio_irqstatus(port, gpio & 0x1f);
 
+	if (type & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH))
+		__set_irq_handler_unlocked(irq, handle_level_irq);
+	else if (type & (IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
+		__set_irq_handler_unlocked(irq, handle_edge_irq);
+
 	return 0;
 }
 
