Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbYHUGD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbYHUGD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 02:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbYHUGDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 02:03:48 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:51516 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbYHUGDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 02:03:47 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: Serial of guest kernel complain "too much work" in kvm/qemu
Date: Thu, 21 Aug 2008 14:03:56 +0800
Message-ID: <C6FABC699EA2354EB260110329F4B35506A4A3@zch01exm26.fsl.freescale.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Serial of guest kernel complain "too much work" in kvm/qemu
Thread-Index: AckDU7J/HvRMarWYTA+3GrWdHsuICw==
From: "Liu Yu" <Yu.Liu@freescale.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
       <kvm-ppc@vger.kernel.org>, <qemu-devel@nongnu.org>
Cc: "Hollis Blanchard" <hollisb@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m7L642dq024492


Hi all,

How is this going?
http://www.archivum.info/qemu-devel@nongnu.org/2008-02/msg00169.html

I use serial as guest's default stdio on powerpc platform.
When displaying a number of characters, e.g. cat a big ascii file,
the serial always hangs as it encounters overwhelming interrupts,
and then complains "serial8250: too much work for irq 42".

The problem is that:
serial in qemu generate an interrupt on every output character,
while Linux driver reads serial data in a loop but gives up after a fixed number (256) of iterations.
So if serial output more than 256 characters in a short time, the serial die.

I had to use the patch below to get it worked around.

So what is the best way to solve it?

---
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c index be95e55..af3e569 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -70,7 +70,7 @@ static unsigned int nr_uarts = CONFIG_SERIAL_8250_RUNTIME_UARTS;
 #define DEBUG_INTR(fmt...)	do { } while (0)
 #endif
 
-#define PASS_LIMIT	256
+#define PASS_LIMIT	65536
 
 /*
  * We default to IRQ0 for the "no irq" hack.   Some
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
