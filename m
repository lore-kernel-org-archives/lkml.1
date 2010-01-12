Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110Ab0ALHmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab0ALHmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 02:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619Ab0ALHmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 02:42:45 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:57864 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab0ALHmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 02:42:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:cc:subject:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=UwEUCAZQi3LeZo4C5CGJ29nNlaGAllj8T9qTKaAaTvDqdu9gclY+hmxyDNhc8jEAeH
         65urZWXJC4PAvkBWDJ3bn8GTDe1aj3lmR6toyLIuiCdQcpSExwOlslE+RYP/+/fv2m4p
         aqnpVM6j+Pviwz1iDUPnzP+SAcp6+qMKAl9aE=
Message-ID: <4b4c27f2.0506d00a.3dcb.2f78@mx.google.com>
Date: Tue, 12 Jan 2010 09:41:47 +0200
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, damm@igel.co.jp, peterz@infradead.org,
       ddaney@caviumnetworks.com
Subject: [PATCH] kernel/irq: Reset IRQ desc->depth to 1 when __free_irq
 disables the line
In-Reply-To: <4b4ae343.09a8100a.3b72.ffffda1b@mx.google.com>
References: <4b4ae343.09a8100a.3b72.ffffda1b@mx.google.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reset irq_desc's depth field to 1, indicating IRQ line is disabled, when
__free_irq disables/shuts-down the line (i.e. upon unregistration of
last interrupt handler).

Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
---
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index eb6078c..642a98c 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -877,6 +877,7 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 
 	/* If this was the last handler, shut down the IRQ line: */
 	if (!desc->action) {
+		desc->depth = 1;
 		desc->status |= IRQ_DISABLED;
 		if (desc->chip->shutdown)
 			desc->chip->shutdown(irq);
-- 
Shmulik Ladkani
