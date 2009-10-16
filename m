Return-Path: <linux-kernel-owner+w=401wt.eu-S1758310AbZJPR1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310AbZJPR1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbZJPR13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:27:29 -0400
Received: from kroah.org ([198.145.64.141]:48473 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbZJPRST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:19 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:11:52 2009
Message-Id: <20091016171152.052543321@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johan Hovold <jhovold@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [11/46] USB: pl2303: fix error characters not being reported to ldisc
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=usb-pl2303-fix-error-characters-not-being-reported-to-ldisc.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Johan Hovold <jhovold@gmail.com>

commit 9388e2e71a51fab0aa2309bbb45e8a23d89a95a9 upstream.

Fix regression introduced by commit
d4fc4a7bfc2dee626f4fec1e209e58eaa4312de6 (tty: Fix the PL2303 private
methods for sysrq).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/pl2303.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -995,13 +995,15 @@ static void pl2303_push_data(struct tty_
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
 


