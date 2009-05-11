Return-Path: <linux-kernel-owner+w=401wt.eu-S1759425AbZEKU03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425AbZEKU03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759117AbZEKUZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:25:15 -0400
Received: from mail.windriver.com ([147.11.1.11]:52602 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601AbZEKUZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:25:12 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: greg@kroah.com
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 4/4] ftd_sio usb: implement sysrq handling on break
Date: Mon, 11 May 2009 15:24:10 -0500
Message-Id: <1242073450-3794-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1242073450-3794-4-git-send-email-jason.wessel@windriver.com>
References: <1242073450-3794-1-git-send-email-jason.wessel@windriver.com>
 <1242073450-3794-2-git-send-email-jason.wessel@windriver.com>
 <1242073450-3794-3-git-send-email-jason.wessel@windriver.com>
 <1242073450-3794-4-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 11 May 2009 20:25:08.0684 (UTC) FILETIME=[93F1C8C0:01C9D276]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change driver to make use of the new functions in
include/linux/usb/serial.h so as to allow the driver to handle the
sysrq when the .config has CONFIG_USB_SERIAL_SYSRQ=y.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/usb/serial/ftdi_sio.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 3a1b84d..a93b76a 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1991,6 +1991,7 @@ static void ftdi_process_read(struct work_struct *work)
 		if (data[packet_offset+1] & FTDI_RS_BI) {
 			error_flag = TTY_BREAK;
 			dbg("BREAK received");
+			usb_serial_handle_break(port);
 		}
 		if (data[packet_offset+1] & FTDI_RS_PE) {
 			error_flag = TTY_PARITY;
@@ -2005,8 +2006,11 @@ static void ftdi_process_read(struct work_struct *work)
 				/* Note that the error flag is duplicated for
 				   every character received since we don't know
 				   which character it applied to */
-				tty_insert_flip_char(tty,
-					data[packet_offset + i], error_flag);
+				if (!usb_serial_handle_sysrq_char(port,
+						data[packet_offset + i]))
+					tty_insert_flip_char(tty,
+						data[packet_offset + i],
+						error_flag);
 			}
 			need_flip = 1;
 		}
-- 
1.6.3.rc0.1.gf800

