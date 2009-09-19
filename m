Return-Path: <linux-kernel-owner+w=401wt.eu-S1755125AbZISVr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbZISVr1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbZISVoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:44:13 -0400
Received: from kroah.org ([198.145.64.141]:40558 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736AbZISVoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:44:11 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 67/79] tty: USB: serial/mct_u232, fix tty refcnt
Date: Sat, 19 Sep 2009 14:37:12 -0700
Message-Id: <1253396244-7885-67-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Stanse found a tty refcnt leak in read_int_callback. In fact
it's handled wrong altogether. tty_port_tty_get can return NULL
and it's not checked in that manner.

Fix that by checking the tty_port_tty_get retval and put tty kref
properly.

http://stanse.fi.muni.cz/

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/serial/mct_u232.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/mct_u232.c b/drivers/usb/serial/mct_u232.c
index d501aef..ad4998b 100644
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -566,10 +566,13 @@ static void mct_u232_read_int_callback(struct urb *urb)
 	 * Work-a-round: handle the 'usual' bulk-in pipe here
 	 */
 	if (urb->transfer_buffer_length > 2) {
-		tty = tty_port_tty_get(&port->port);
 		if (urb->actual_length) {
-			tty_insert_flip_string(tty, data, urb->actual_length);
-			tty_flip_buffer_push(tty);
+			tty = tty_port_tty_get(&port->port);
+			if (tty) {
+				tty_insert_flip_string(tty, data,
+						urb->actual_length);
+				tty_flip_buffer_push(tty);
+			}
 			tty_kref_put(tty);
 		}
 		goto exit;
-- 
1.6.4.2

