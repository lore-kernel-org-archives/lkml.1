Return-Path: <linux-kernel-owner+w=401wt.eu-S1758480AbZABKpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480AbZABKpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757610AbZABKlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:41:50 -0500
Received: from harold.telenet-ops.be ([195.130.133.65]:48837 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938AbZABKli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:41:38 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Enver Haase <A2232@gmx.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] m68k: ser_a2232 - kill warn_unused_result warnings
Date: Fri,  2 Jan 2009 11:41:23 +0100
Message-Id: <1230892892-25751-11-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1230892892-25751-10-git-send-email-geert@linux-m68k.org>
References: <1230892892-25751-1-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-2-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-3-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-4-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-5-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-6-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-7-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-8-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-9-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-10-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: ignoring return value of 'request_irq', declared with attribute
warn_unused_result

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Enver Haase <A2232@gmx.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/char/ser_a2232.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ser_a2232.c b/drivers/char/ser_a2232.c
index 7b0c352..a4e0a04 100644
--- a/drivers/char/ser_a2232.c
+++ b/drivers/char/ser_a2232.c
@@ -717,6 +717,7 @@ static int __init a2232board_init(void)
 	u_char *from;
 	volatile u_char *to;
 	volatile struct a2232memory *mem;
+	int error, i;
 
 #ifdef CONFIG_SMP
 	return -ENODEV;	/* This driver is not SMP aware. Is there an SMP ZorroII-bus-machine? */
@@ -796,8 +797,15 @@ static int __init a2232board_init(void)
 	*/
 	if (a2232_init_drivers()) return -ENODEV; // maybe we should use a different -Exxx?
 
-	request_irq(IRQ_AMIGA_VERTB, a2232_vbl_inter, 0, "A2232 serial VBL", a2232_driver_ID);
-	return 0;
+	error = request_irq(IRQ_AMIGA_VERTB, a2232_vbl_inter, 0,
+			    "A2232 serial VBL", a2232_driver_ID);
+	if (error) {
+		for (i = 0; i < nr_a2232; i++)
+			zorro_release_device(zd_a2232[i]);
+		tty_unregister_driver(a2232_driver);
+		put_tty_driver(a2232_driver);
+	}
+	return error;
 }
 
 static void __exit a2232board_exit(void)
-- 
1.5.6.5

