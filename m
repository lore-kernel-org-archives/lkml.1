Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbZIFVKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbZIFVKN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 17:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758554AbZIFVKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 17:10:11 -0400
Received: from server1.wserver.cz ([82.113.45.157]:60207 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758492AbZIFVKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 17:10:08 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: gregkh@suse.de
Cc: akpm@linux-foundation.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/2] USB: serial/mct_u232, fix tty refcnt
Date: Sun,  6 Sep 2009 23:10:10 +0200
Message-Id: <1252271410-26080-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252271410-26080-1-git-send-email-jirislaby@gmail.com>
References: <1252271410-26080-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found a tty refcnt leak in read_int_callback. In fact
it's handled wrong altogether. tty_port_tty_get can return NULL
and it's not checked in that manner.

Fix that by checking the tty_port_tty_get retval and put tty kref
properly.

http://stanse.fi.muni.cz/

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
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

