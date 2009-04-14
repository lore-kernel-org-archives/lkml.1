Return-Path: <linux-kernel-owner+w=401wt.eu-S1752014AbZDNBMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbZDNBMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 21:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbZDNBL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 21:11:57 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:43460 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbZDNBL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 21:11:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:date:user-agent:mime-version:content-disposition:to:cc
         :content-type:content-transfer-encoding:message-id;
        b=QORygmo/cAbq7YJHG9cIiBmeeklXfJlBpO5TlXNd+AKAIwVAXXPJTM4YqVzwKhyDXj
         QEWUGVDx7ZB9VJygaRWyiw8WlLkrDo1zNaTbKBF//qiahBoOUmpuSykb6HHWLryYr5re
         VAoDf/Gx+e5cLuw7ITn7go6WH3A9l5rJWPghw=
From: Christoph Mair <christoph.mair@gmail.com>
Subject: tty: usb-serial krefs - ti_usb returns EIO when reopening the device
Date: Tue, 14 Apr 2009 03:14:39 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Disposition: inline
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200904140314.46647.christoph.mair@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

commit 4a90f09b20f4622dcbff1f0e1e6bae1704f8ad8c

tty: usb-serial krefs

Use kref in the USB serial drivers so that we don't free tty structures
from under the URB receive handlers as has historically been the case if
you were unlucky. This also gives us a framework for general tty drivers to
use tty_port objects and refcount.

Contains two err->dev_err changes merged together to fix clashes in the
-next tree.

Signed-off-by: Alan Cox <alan@xxxxxxxxxx>
Signed-off-by: Linus Torvalds <torvalds@xxxxxxxxxxxxxxxxxxxx>

----

introduced a problem to the TI USB to serial converter code, which is needed 
for the debug interface device MSP-FET430UIF from Texas Instruments.
The driver works as expected until you close the device and try to reopen it. 
All you get from now on, is an I/O error. It seems that something
isn't released correctly, because the refcount of the usbserial module does 
not drop to zero, even when unloading all dependend drivers.

A "it works for me now" patch is attached. I've tested it with a vanilla 
2.6.29.

Christoph


diff --git a/drivers/usb/serial/ti_usb_3410_5052.c 
b/drivers/usb/serial/ti_usb_3410_5052.c
index 2620bf6..f11d8ac 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1229,8 +1229,8 @@ static void ti_bulk_in_callback(struct urb *urb)
                spin_lock(&tport->tp_lock);
                tport->tp_icount.rx += urb->actual_length;
                spin_unlock(&tport->tp_lock);
-               tty_kref_put(tty);
        }
+       tty_kref_put(tty);

 exit:
        /* continue to read unless stopping */
