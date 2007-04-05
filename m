Return-Path: <linux-kernel-owner+w=401wt.eu-S1766977AbXDENHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766977AbXDENHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 09:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766975AbXDENHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 09:07:12 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45349 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766977AbXDENHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 09:07:11 -0400
Date: Thu, 5 Apr 2007 14:09:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pcmcia: irq probe can be done without risking an IRQ storm
Message-ID: <20070405140936.46fb6ba4@the-village.bc.nu>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nowdays you can ask for an IRQ to be allocated but not enabled, when
PCMCIA was written this was not true and this feature is thus not used

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc5-mm4/drivers/pcmcia/pcmcia_resource.c linux-2.6.21-rc5-mm4/drivers/pcmcia/pcmcia_resource.c
--- linux.vanilla-2.6.21-rc5-mm4/drivers/pcmcia/pcmcia_resource.c	2007-04-03 16:52:14.000000000 +0100
+++ linux-2.6.21-rc5-mm4/drivers/pcmcia/pcmcia_resource.c	2007-04-03 17:10:42.000000000 +0100
@@ -810,8 +810,11 @@
 		type = IRQF_SHARED;
 	if (req->Attributes & IRQ_TYPE_DYNAMIC_SHARING)
 		type = IRQF_SHARED;	
 #ifdef CONFIG_PCMCIA_PROBE
+	if (!(req->Attributes & IRQ_HANDLE_PRESENT))
+		type |= IRQ_NOAUTOEN;
+
 	if (s->irq.AssignedIRQ != 0) {
 		/* If the interrupt is already assigned, it must be the same */
 		irq = s->irq.AssignedIRQ;
