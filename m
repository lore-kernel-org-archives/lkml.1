Return-Path: <linux-kernel-owner+w=401wt.eu-S1760339AbYBGHjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760339AbYBGHjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 02:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbYBGHij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 02:38:39 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:44033 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbYBGHii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 02:38:38 -0500
Message-ID: <47AAB57C.7090501@web.de>
Date: Thu, 07 Feb 2008 08:38:36 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH] KGDB-8250: fix initial interrupt
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18Rb0Sas1S0ngkf2kjr36y2mRjTyvwX8io46Dg1
	2e7uyAL4KcKmXsCL9dQ7EVCMVTIUocVV/TlPvlmNR7fa9k8Ygt
	8pSSJ7DbY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest rework of kgdb8250_interrupt caused a regression in that the new
code wrongly assumes a ctrl-c character is also sent on initial connect
from the host. Here is a fix.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

---
 drivers/serial/8250_kgdb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: b/drivers/serial/8250_kgdb.c
===================================================================
--- a/drivers/serial/8250_kgdb.c
+++ b/drivers/serial/8250_kgdb.c
@@ -124,10 +124,10 @@ static irqreturn_t kgdb8250_interrupt(in

 	if ((iir & UART_IIR_ID) == UART_IIR_RDI) {
 		c = kgdb8250_ioread(UART_RX);
-		if (c == 0x03)
-			breakpoint();
-		else
+		if (c != 0x03)
 			buffered_char = c;
+		if (c == 0x03 || !kgdb_connected)
+			breakpoint();
 	}
 	return IRQ_HANDLED;
 }
