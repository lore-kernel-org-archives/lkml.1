Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbZKVQBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbZKVQBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 11:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbZKVQBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 11:01:40 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:54118 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbZKVQBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 11:01:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=iqi42C2dKailWRdcOfToJKrVPegZjLtzwm6D9dwwHvLkUxMqNlgIFu98gAt6oI+G0r
         2/1JZISU9VpPpyAI3eLZlRup5g7RuZmpsv5z6CNEgPDDSclKcaQNsfe8OpH8VGHAOksa
         tG2W1FWuqS7I3rKtLjfHx8HJIWjIQBtNL8ppM=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH] USB: ftdi_sio: fix error message on close
Date: Sun, 22 Nov 2009 17:01:13 +0100
Message-Id: <1258905673-6885-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resubmitting read urb fails with -EPERM if completion handler runs while
urb is being killed on close. This should not be reported as an error.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/ftdi_sio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 9c60d6d..b8ff7c5 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1686,7 +1686,7 @@ static int ftdi_submit_read_urb(struct usb_serial_port *port, gfp_t mem_flags)
 			   urb->transfer_buffer_length,
 			   ftdi_read_bulk_callback, port);
 	result = usb_submit_urb(urb, mem_flags);
-	if (result)
+	if (result && result != -EPERM)
 		dev_err(&port->dev,
 			"%s - failed submitting read urb, error %d\n",
 							__func__, result);
-- 
1.6.5.3

