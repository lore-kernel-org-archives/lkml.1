Return-Path: <linux-kernel-owner+w=401wt.eu-S1758320AbZLQBi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320AbZLQBi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbZLQBhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:37:51 -0500
Received: from kroah.org ([198.145.64.141]:47976 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbZLQBU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:26 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:03 2009
Message-Id: <20091217011603.362701500@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ian Jackson <ian.jackson@eu.citrix.com>,
       Alan Cox <alan@linux.intel.com>
Subject: [42/90] Serial: Do not read IIR in serial8250_start_tx when UART_BUG_TXEN
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1337,14 +1337,12 @@ static void serial8250_start_tx(struct u
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


