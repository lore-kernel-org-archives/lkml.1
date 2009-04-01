Return-Path: <linux-kernel-owner+w=401wt.eu-S1764653AbZDARJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764653AbZDARJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 13:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbZDARJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 13:09:25 -0400
Received: from relay3.ptmail.sapo.pt ([212.55.154.23]:34740 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753941AbZDARJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 13:09:24 -0400
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Wed, 1 Apr 2009 18:06:35 +0100
From: Luis Henriques <henrix@sapo.pt>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [RESEND][PATCH -tip] irq: DEBUG_SHIRQ executed on irq setup failure
Message-ID: <20090401170635.GA4392@hades.domain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When requesting an IRQ, the DEBUG_SHIRQ code executes a fake IRQ just to make
sure the driver is ready to receive an IRQ immediately.  The problem was that
this fake IRQ was being executed even if interrupt line failed to be allocated
by __setup_irq.

Signed-off-by: Luis Henriques <henrix@sapo.pt>
---
 kernel/irq/manage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index a3eb7ba..39a0f4d 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -914,7 +914,7 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 		kfree(action);
 
 #ifdef CONFIG_DEBUG_SHIRQ
-	if (irqflags & IRQF_SHARED) {
+	if (!retval & (irqflags & IRQF_SHARED)) {
 		/*
 		 * It's a shared IRQ -- the driver ought to be prepared for it
 		 * to happen immediately, so let's make sure....
-- 
1.6.2.1

