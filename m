Return-Path: <linux-kernel-owner+w=401wt.eu-S1760147AbZGIMgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbZGIMgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 08:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757708AbZGIMf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 08:35:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41354 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758558AbZGIMf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 08:35:58 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/3] tty: Sort out the USB sysrq changes that wrecked
	performance
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Thu, 09 Jul 2009 13:35:52 +0100
Message-ID: <20090709123523.15654.15754.stgit@localhost.localdomain>
In-Reply-To: <20090709123301.15654.4698.stgit@localhost.localdomain>
References: <20090709123301.15654.4698.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We can't go around calling all sorts of magic per character functions at
full rate 3G data speed.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/usb/serial/generic.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)


diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 932d624..e9aa7a4 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -424,10 +424,17 @@ static void flush_and_resubmit_read_urb(struct usb_serial_port *port)
 	if (!tty)
 		goto done;
 
-	/* Push data to tty */
-	for (i = 0; i < urb->actual_length; i++, ch++) {
-		if (!usb_serial_handle_sysrq_char(port, *ch))
-			tty_insert_flip_char(tty, *ch, TTY_NORMAL);
+	/* The per character mucking around with sysrq path it too slow for
+	   stuff like 3G modems, so shortcircuit it in the 99.9999999% of cases
+	   where the USB serial is not a console anyway */	
+	if (!port->console || !port->sysrq)
+		tty_insert_flip_string(tty, ch, urb->actual_length);
+	else {	
+		/* Push data to tty */
+		for (i = 0; i < urb->actual_length; i++, ch++) {
+			if (!usb_serial_handle_sysrq_char(port, *ch))
+				tty_insert_flip_char(tty, *ch, TTY_NORMAL);
+		}
 	}
 	tty_flip_buffer_push(tty);
 	tty_kref_put(tty);

