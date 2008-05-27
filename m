Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbYE0NZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbYE0NZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 09:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757168AbYE0NZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 09:25:24 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:60152 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbYE0NZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 09:25:23 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: akpm@linux-foundation.org
Cc: linux@maxim.org.za, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] atmel_serial: Filter out FP during baud rate detection
Date: Tue, 27 May 2008 15:24:43 +0200
Message-Id: <1211894683-20934-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.1
X-OriginalArrivalTime: 27 May 2008 13:24:36.0457 (UTC) FILETIME=[0232BD90:01C8BFFD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I made a change to u-boot that used the FP (Fractional Part) field of
BRGR to achieve more accurate baud rate generation. Unfortunately, the
atmel_serial driver looks at the whole BRGR register when trying to
detect the baud rate that the port is currently running at, so setting
FP to a nonzero value breaks the baud rate detection.

I'll sit on the u-boot patch for a while longer, but this is clearly a
bug in the atmel_serial driver which should be fixed.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/serial/atmel_serial.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index c065a70..42be8b0 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -1318,7 +1318,7 @@ static void __init atmel_console_get_options(struct uart_port *port, int *baud,
 	 * If the baud rate generator isn't running, the port wasn't
 	 * initialized by the boot loader.
 	 */
-	quot = UART_GET_BRGR(port);
+	quot = UART_GET_BRGR(port) & ATMEL_US_CD;
 	if (!quot)
 		return;
 
-- 
1.5.5.1

