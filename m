Return-Path: <linux-kernel-owner+w=401wt.eu-S1757766AbZA1Xc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766AbZA1Xc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbZA1X2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:28:20 -0500
Received: from kroah.org ([198.145.64.141]:57000 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753902AbZA1X2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:28:18 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Roel Kluin <roel.kluin@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/10] Staging: usbip: usbip_start_threads(): handle kernel_thread failure
Date: Wed, 28 Jan 2009 15:26:49 -0800
Message-Id: <1233185210-23098-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <20090128232319.GA23009@kroah.com>
References: <20090128232319.GA23009@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>

kernel_thread may fail, notice this.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/usbip/usbip_common.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index 72e2092..22f93dd 100644
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
-- 
1.6.0.2

