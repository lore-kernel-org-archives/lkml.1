Return-Path: <linux-kernel-owner+w=401wt.eu-S936616AbZLQEee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936616AbZLQEee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936585AbZLQEeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:34:09 -0500
Received: from kroah.org ([198.145.64.141]:55567 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935555AbZLQEE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:26 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:51 2009
Message-Id: <20091217035651.053387583@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ian Jackson <ian.jackson@eu.citrix.com>,
       Alan Cox <alan@linux.intel.com>
Subject: [063/151] Serial: Do not read IIR in serial8250_start_tx when UART_BUG_TXEN
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Jackson <ian.jackson@eu.citrix.com>

commit 68cb4f8e246bbbc649980be0628cae9265870a91 upstream.

Do not read IIR in serial8250_start_tx when UART_BUG_TXEN

Reading the IIR clears some oustanding interrupts so it is not safe.
Instead, simply transmit immediately if the buffer is empty without
regard to IIR.

Signed-off-by: Ian Jackson <ian.jackson@eu.citrix.com>
Reviewed-by: Markus Armbruster <armbru@redhat.com>
Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/8250.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1339,14 +1339,12 @@ static void serial8250_start_tx(struct u
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


