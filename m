Return-Path: <linux-kernel-owner+w=401wt.eu-S934460AbZLKX3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934460AbZLKX3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933916AbZLKX3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:29:31 -0500
Received: from kroah.org ([198.145.64.141]:50441 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933974AbZLKX3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:07 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ian Jackson <ian.jackson@eu.citrix.com>, Alan Cox <alan@linux.intel.com>,
       stable <stable@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 23/58] Serial: Do not read IIR in serial8250_start_tx when UART_BUG_TXEN
Date: Fri, 11 Dec 2009 15:28:07 -0800
Message-Id: <1260574122-10676-23-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Jackson <ian.jackson@eu.citrix.com>

Do not read IIR in serial8250_start_tx when UART_BUG_TXEN

Reading the IIR clears some oustanding interrupts so it is not safe.
Instead, simply transmit immediately if the buffer is empty without
regard to IIR.

Signed-off-by: Ian Jackson <ian.jackson@eu.citrix.com>
Reviewed-by: Markus Armbruster <armbru@redhat.com>
Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/8250.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index b75e63e..c3e37c8 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1339,14 +1339,12 @@ static void serial8250_start_tx(struct uart_port *port)
 		serial_out(up, UART_IER, up->ier);
 
 		if (up->bugs & UART_BUG_TXEN) {
-			unsigned char lsr, iir;
+			unsigned char lsr;
 			lsr = serial_in(up, UART_LSR);
 			up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
-			iir = serial_in(up, UART_IIR) & 0x0f;
 			if ((up->port.type == PORT_RM9000) ?
-				(lsr & UART_LSR_THRE &&
-				(iir == UART_IIR_NO_INT || iir == UART_IIR_THRI)) :
-				(lsr & UART_LSR_TEMT && iir & UART_IIR_NO_INT))
+				(lsr & UART_LSR_THRE) :
+				(lsr & UART_LSR_TEMT))
 				transmit_chars(up);
 		}
 	}
-- 
1.6.5.5

