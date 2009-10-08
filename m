Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbZJHJh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbZJHJh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 05:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbZJHJh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 05:37:27 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:40548 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986AbZJHJh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 05:37:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=vTUOQUaybG/9eOjubTkUb4dftLPJeO+1qrppWH/y4PqkqjNz1TYagB5fuSmf6puuWS
         bjMUzR/2zNfYlbK5zkwLqrKX7jnginKRgqjqkTL4XFAK5JDu8uufRHVTgXVvXtp+ZmeD
         0IVOe3vmmAfEg5AjBzNFKocg81mNx2NgXWQUI=
Date: Thu, 8 Oct 2009 11:36:46 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>
Cc: Frank Schaefer <schaefer.frank@gmx.net>,
       Jason Wessel <jason.wessel@windriver.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] USB: pl2303: fix error characters not being reported to
 ldisc
Message-ID: <20091008093646.GA14695@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix regression introduced by commit
d4fc4a7bfc2dee626f4fec1e209e58eaa4312de6 (tty: Fix the PL2303 private
methods for sysrq).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/pl2303.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 1128e01..9ec1a49 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -1046,13 +1046,15 @@ static void pl2303_push_data(struct tty_struct *tty,
 	/* overrun is special, not associated with a char */
 	if (line_status & UART_OVERRUN_ERROR)
 		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
-	if (port->console && port->sysrq) {
+
+	if (tty_flag == TTY_NORMAL && !(port->console && port->sysrq))
+		tty_insert_flip_string(tty, data, urb->actual_length);
+	else {
 		int i;
 		for (i = 0; i < urb->actual_length; ++i)
 			if (!usb_serial_handle_sysrq_char(tty, port, data[i]))
 				tty_insert_flip_char(tty, data[i], tty_flag);
-	} else
-		tty_insert_flip_string(tty, data, urb->actual_length);
+	}
 	tty_flip_buffer_push(tty);
 }
 
-- 
1.6.5.rc2

