Return-Path: <linux-kernel-owner+w=401wt.eu-S1752296AbZL3Wcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbZL3Wcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 17:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZL3Wcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 17:32:54 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55526 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbZL3Wcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 17:32:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=L1gs/ItQvgVRknijQPb5tMoUsHPgGYsRVr1G587RZS0GkVXq4Idp3m160ofyZx9aTL
         WNQYPTxqmUeJcmuUvByyL6TYW6QbjkzHyxYWBxPSB5KJJrfky8xxn1Cou8QJ2unVjIaE
         QuXgxYEdy4PV48mGcm6LNhard4KYbJJMLWET8=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>, stable <stable@kernel.org>
Subject: [PATCH] USB: serial: fix memory leak in generic driver
Date: Wed, 30 Dec 2009 23:32:00 +0100
Message-Id: <1262212320-4793-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

URB transfer buffer was never freed when using multi-urb writes.

Regression introduced by commit 715b1dc01fe44537e8fce9566e4bb48d6821d84b
(USB: usb_debug, usb_generic_serial: implement multi urb write).

Currently the only driver enabling multi-urb writes is usb_debug.

Cc: stable <stable@kernel.org>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/generic.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index f1ea3a3..187259c 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -489,6 +489,8 @@ void usb_serial_generic_write_bulk_callback(struct urb *urb)
 	dbg("%s - port %d", __func__, port->number);
 
 	if (port->serial->type->max_in_flight_urbs) {
+		kfree(urb->transfer_buffer);
+
 		spin_lock_irqsave(&port->lock, flags);
 		--port->urbs_in_flight;
 		port->tx_bytes_flight -= urb->transfer_buffer_length;
-- 
1.6.6

