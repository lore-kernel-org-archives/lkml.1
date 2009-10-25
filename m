Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbZJYNQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbZJYNQs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 09:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbZJYNQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 09:16:48 -0400
Received: from mail-vw0-f184.google.com ([209.85.212.184]:35423 "EHLO
	mail-vw0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbZJYNQr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 09:16:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=AORapp3X85LZb1pyCiBzhHNX55WgwZh/vQsWyw0f++Z0BsfDyJYnE149CBwn//ZUQR
         zey5hmVybBDwQoj/ryMMf14rej3bce1bCIERXaorWyt1GUrP1qwYoNChTCEcAPlnxyKa
         Gp3zYaY2xMKxmzM6w72W+F2q5Rs+549HCFq/0=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sun, 25 Oct 2009 11:16:32 -0200
Message-ID: <b8bf37780910250616g8f204d2h471bd4d511a4816@mail.gmail.com>
Subject: [PATCH 1/2] serial: fix NULL pointer dereference
To: gregkh@suse.de, alan@linux.intel.com,
       Andrew Morton <akpm@linux-foundation.org>, adobriyan@gmail.com,
       linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f90016f1d9186ba44da028201a984735fc9a6672 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Sat, 24 Oct 2009 11:04:25 -0200
Subject: [PATCH 1/2] serial: fix NULL pointer dereference
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If kzalloc() or alloc_tty_driver() fails, we call:
    put_tty_driver(normal = NULL).

Then:
    put_tty_driver -> tty_driver_kref_put -> kref_put(&NULL->kref, ...)

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index dcc7244..885eabe 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2344,7 +2344,7 @@ static const struct tty_operations uart_ops = {
  */
 int uart_register_driver(struct uart_driver *drv)
 {
-	struct tty_driver *normal = NULL;
+	struct tty_driver *normal;
 	int i, retval;

 	BUG_ON(drv->state);
@@ -2354,13 +2354,12 @@ int uart_register_driver(struct uart_driver *drv)
 	 * we have a large number of ports to handle.
 	 */
 	drv->state = kzalloc(sizeof(struct uart_state) * drv->nr, GFP_KERNEL);
-	retval = -ENOMEM;
 	if (!drv->state)
 		goto out;

-	normal  = alloc_tty_driver(drv->nr);
+	normal = alloc_tty_driver(drv->nr);
 	if (!normal)
-		goto out;
+		goto out_kfree;

 	drv->tty_driver = normal;

@@ -2393,12 +2392,14 @@ int uart_register_driver(struct uart_driver *drv)
 	}

 	retval = tty_register_driver(normal);
- out:
-	if (retval < 0) {
-		put_tty_driver(normal);
-		kfree(drv->state);
-	}
-	return retval;
+	if (retval >= 0)
+		return retval;
+
+	put_tty_driver(normal);
+out_kfree:
+	kfree(drv->state);
+out:
+	return -ENOMEM;
 }

 /**
-- 
1.6.5.1.75.g02d56
