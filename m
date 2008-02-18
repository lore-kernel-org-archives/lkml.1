Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbYBRQ6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbYBRQ6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 11:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYBRQ6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 11:58:13 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:46322 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbYBRQ6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 11:58:12 -0500
X-IronPort-AV: E=Sophos;i="4.25,372,1199682000"; 
   d="scan'208";a="48679412"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: [BUG][RFC] [GENERIC IRQ] irq_chip_set_defaults shutdown / disable
Date: Mon, 18 Feb 2008 16:58:02 -0000
Message-ID: <600D5CB4DFD93545BF61FF01473D11AC125CC333@limkexm2.ad.analog.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [BUG][RFC] [GENERIC IRQ] irq_chip_set_defaults shutdown / disable
Thread-Index: Achv3H69FqF5wehTQiWegSOtpRTnUwCbe7vw
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: <tglx@linutronix.de>, <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Feb 2008 16:58:11.0140 (UTC) FILETIME=[7172F040:01C8724F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RESENT: Add Maintainers 

free_irq() does not disable/mask the irq, in case disable or shutdown in struct irq_chip is left uninitilazied.

/**
 * struct irq_chip - hardware interrupt chip descriptor
 *
 * @name:	name for /proc/interrupts
 * @startup:	start up the interrupt (defaults to ->enable if NULL)
 * @shutdown:	shut down the interrupt (defaults to ->disable if NULL)
 * @enable:		enable the interrupt (defaults to chip->unmask if NULL)
 * @disable:	disable the interrupt (defaults to chip->mask if NULL)


According to linux/irq.h struct irq_chip information,
chip->disable should default to chip->mask if NULL.
However irq_chip_set_defaults(struct irq_chip *chip) will set it to default_disable an empty function.

In earlier kernel versions such as 2.6.19 default_disable called chip->mask.
In 2.6.22 and 2.6.24 default_disable is an empty function.

Looking through various architectures, it's still pretty common that disable and shutdown is NULL.

Do I miss something here?

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>

Index: irq/chip.c
===================================================================
--- irq/chip.c  (revision 4276)
+++ irq/chip.c  (working copy)
@@ -233,6 +233,10 @@
  */
 static void default_disable(unsigned int irq)  {
+       struct irq_desc *desc = irq_desc + irq;
+
+       desc->chip->mask(irq);
+       desc->status |= IRQ_MASKED;
 }

 /*

Best regards,
Michael

------------------------------------------------------------------
********* Analog Devices GmbH         michael.hennerich@analog.com
**  *****                                      Systems Engineering
**     ** Wilhelm-Wagenfeld-Strasse 6       
**  ***** D-80807 Munich                      
********* Germany                          
Registergericht München HRB 40368,  Geschäftsführer:  Thomas Wessel,  Vincent Roche,  Joseph E. McDonough
