Return-Path: <linux-kernel-owner+w=401wt.eu-S934486AbZLKX3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934486AbZLKX3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934441AbZLKX33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:29:29 -0500
Received: from kroah.org ([198.145.64.141]:50466 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933911AbZLKX3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:02 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/58] serial: fix NULL pointer dereference
Date: Fri, 11 Dec 2009 15:28:02 -0800
Message-Id: <1260574122-10676-18-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: André Goddard Rosa <andre.goddard@gmail.com>

If kzalloc() or alloc_tty_driver() fails, we call:
    put_tty_driver(normal = NULL).

Then:
    put_tty_driver -> tty_driver_kref_put -> kref_put(&NULL->kref, ...)

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/serial_core.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

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
1.6.5.5

