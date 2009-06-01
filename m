Return-Path: <linux-kernel-owner+w=401wt.eu-S1757674AbZFAMBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674AbZFAMBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 08:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756827AbZFAMBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 08:01:17 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:39412 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190AbZFAMBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 08:01:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-uid:x-length:to
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=EdT/msf7FNqbGFtuLScdDugrVBI6pbqS3cMW8cpXBQhpIdR33NJNwdFFygcH7TlRm/
         0g4ejSSr/1gxy7xs93iHkzSZFXbSNQ9TsaFfyV12fqXi+EDKW7ROKiM3d1z0L/jljL5p
         5lLp4HXko7ELCz75mT1NvGz44CciaA4JJF044=
From: Florian Fainelli <florian@openwrt.org>
Date: Mon, 1 Jun 2009 14:01:15 +0200
Subject: [PATCH 6/9] serial: workaround TI AR7 silicon bug
MIME-Version: 1.0
X-Length: 1455
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       akpm <akpm@linux-foundation.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906011401.15991.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch make the serial8250_console_putchar work
on TI AR7 hardware which has a hardware bug clobbering
serial characters resulting in an almost unusable
kernel console.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 03376b0..16b5a7e 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2694,7 +2694,11 @@ static void serial8250_console_putchar(struct uart_port *port, int ch)
 {
 	struct uart_8250_port *up = (struct uart_8250_port *)port;
 
+#ifdef CONFIG_AR7
+	wait_for_xmitr(up, BOTH_EMPTY);
+#else
 	wait_for_xmitr(up, UART_LSR_THRE);
+#endif
 	serial_out(up, UART_TX, ch);
 }
 
