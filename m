Return-Path: <linux-kernel-owner+w=401wt.eu-S1758767AbZFXVd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767AbZFXVd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbZFXVdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:33:36 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:52447 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbZFXVde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:33:34 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, gregkh@suse.de, linux-usb@vger.kernel.org,
       oliver@neukum.name,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 2/3] Fix oops when closing ACM tty device right after open has failed.
Date: Wed, 24 Jun 2009 18:33:30 -0300
Message-Id: <1245879211-10130-2-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1245879211-10130-1-git-send-email-cascardo@holoscopio.com>
References: <1245879211-10130-1-git-send-email-cascardo@holoscopio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit 10077d4a6674f535abdbe25cdecb1202af7948f1 has stopped
checking if there was a valid acm device associated to the tty, which is
not true right after open fails and tty subsystem tries to close the
device.

As an example, open fails with a non-existing device, when probe has
never been called, because the device has never been plugged. This is
common in systems with static modules and no udev.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/usb/class/cdc-acm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 02eb60b..3f10459 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -677,7 +677,7 @@ static void acm_tty_close(struct tty_struct *tty, struct file *filp)
 
 	/* Perform the closing process and see if we need to do the hardware
 	   shutdown */
-	if (tty_port_close_start(&acm->port, tty, filp) == 0)
+	if (!acm || tty_port_close_start(&acm->port, tty, filp) == 0)
 		return;
 	acm_port_down(acm, 0);
 	tty_port_close_end(&acm->port, tty);
-- 
1.6.3

