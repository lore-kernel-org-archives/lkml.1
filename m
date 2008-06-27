Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbYF0H7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbYF0H7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 03:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbYF0H7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 03:59:40 -0400
Received: from DSL212-235-53-3.bb.netvision.net.il ([212.235.53.3]:33616 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757342AbYF0H7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 03:59:39 -0400
From: Benny Halevy <bhalevy@panasas.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Alen Cox <alan@lxorguk.ukuu.org.uk>,
       Benny Halevy <bhalevy@panasas.com>
Subject: [PATCH] usb: fix uninitialized variables in keyspan_pda
Date: Fri, 27 Jun 2008 10:58:54 +0300
Message-Id: <1214553534-9970-1-git-send-email-bhalevy@panasas.com>
X-Mailer: git-send-email 1.5.6.GIT
In-Reply-To: <4864944B.5020601@panasas.com>
References: <4864944B.5020601@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compiler (gcc 4.3.0) warns that status might be used uninitialized
in keyspan_pda_tiocmget and keyspan_pda_tiocmset.

It is technically correct and therefore this patch initializes
status to 0 in both cases.

Note that keyspan_pda_get_modem_info sets *value only when
usb_control_msg returns rc > 0, otherwise it must
return an error rc < 0, and it must never return rc == 0, hence
a WARN_ON(rc == 0) was added in case usb_control_msg ever return 0.

Both its callers bail out for rc < 0 and use the value
of "status" in the rc >= 0 case.  If the WARN_ON is ever seen,
status will be set to the initial value of 0.

Signed-off-by: Benny Halevy <bhalevy@panasas.com>
---
 drivers/usb/serial/keyspan_pda.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index ff54203..97ce8a3 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -420,6 +420,7 @@ static int keyspan_pda_get_modem_info(struct usb_serial *serial,
 			     3, /* get pins */
 			     USB_TYPE_VENDOR|USB_RECIP_INTERFACE|USB_DIR_IN,
 			     0, 0, &data, 1, 2000);
+	WARN_ON(rc == 0);
 	if (rc > 0)
 		*value = data;
 	return rc;
@@ -441,7 +442,7 @@ static int keyspan_pda_tiocmget(struct usb_serial_port *port, struct file *file)
 {
 	struct usb_serial *serial = port->serial;
 	int rc;
-	unsigned char status;
+	unsigned char status = 0;
 	int value;
 
 	rc = keyspan_pda_get_modem_info(serial, &status);
@@ -462,7 +463,7 @@ static int keyspan_pda_tiocmset(struct usb_serial_port *port, struct file *file,
 {
 	struct usb_serial *serial = port->serial;
 	int rc;
-	unsigned char status;
+	unsigned char status = 0;
 
 	rc = keyspan_pda_get_modem_info(serial, &status);
 	if (rc < 0)
-- 
1.5.6.GIT

