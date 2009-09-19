Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbZISVlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbZISVlb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbZISVl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:41:28 -0400
Received: from kroah.org ([198.145.64.141]:40463 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836AbZISVl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:41:26 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 37/79] tty: USB hangup is racy
Date: Sat, 19 Sep 2009 14:36:42 -0700
Message-Id: <1253396244-7885-37-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The USB layer uses tty_hangup to deal with unplugs of the physical hardware
(analogous to loss of carrier) and then frees the resources. However the
tty_hangup is asynchronous. As the hangup can sleep we can use tty_vhangup
which is the non async version to avoid freeing resources too early.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/serial/usb-serial.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 99188c9..21dd72a 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1161,10 +1161,7 @@ void usb_serial_disconnect(struct usb_interface *interface)
 		if (port) {
 			struct tty_struct *tty = tty_port_tty_get(&port->port);
 			if (tty) {
-				/* The hangup will occur asynchronously but
-				   the object refcounts will sort out all the
-				   cleanup */
-				tty_hangup(tty);
+				tty_vhangup(tty);
 				tty_kref_put(tty);
 			}
 			kill_traffic(port);
-- 
1.6.4.2

