Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbYLSWhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbYLSWhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYLSWh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:37:26 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:45248 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbYLSWhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:37:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=K4ayFXZWj9nYlgmRszoxnj1ajtpBY7f38uMqlWdo8hz3JtCRsRenqgIYk8LIWurzgi
         XaBwor09egtjSu14jNdrwRMz/KdWxHtyHxQCL5lg5G/HWaAf5MHVliraLmdOngl9c1Bx
         Mwtlx8UK5dEdC9/8esGnfHpgG1WshXZjt5Oq0=
Message-ID: <494C222A.8050507@gmail.com>
Date: Fri, 19 Dec 2008 23:37:30 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] usbip_start_threads(): handle kernel_thread failure
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel_thread may fail, notice this.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/staging/usbip/usbip_common.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index 72e2092..3d099e8 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -406,8 +406,20 @@ void usbip_start_threads(struct usbip_device *ud)
 	/*
 	 * threads are invoked per one device (per one connection).
 	 */
-	kernel_thread(usbip_thread, (void *)&ud->tcp_rx, 0);
-	kernel_thread(usbip_thread, (void *)&ud->tcp_tx, 0);
+	int retval;
+
+	retval = kernel_thread(usbip_thread, (void *)&ud->tcp_rx, 0);
+	if (retval < 0) {
+		printk(KERN_ERR "Creating tcp_rx thread for ud %p failed.\n",
+				ud); 
+		return;
+	}
+	retval = kernel_thread(usbip_thread, (void *)&ud->tcp_tx, 0);
+	if (retval < 0) {
+		printk(KERN_ERR "Creating tcp_tx thread for ud %p failed.\n",
+				ud); 
+		return;
+	}
 
 	/* confirm threads are starting */
 	wait_for_completion(&ud->tcp_rx.thread_done);

