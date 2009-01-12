Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbZALUSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbZALUSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbZALUSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:18:39 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:43472 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbZALUSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:18:38 -0500
Date: Mon, 12 Jan 2009 13:18:37 -0700
From: David Altobelli <david.altobelli@hp.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, david.altobelli@hp.com
Subject: [PATCH] hpilo open/close fix
Message-ID: <20090112201837.GA19499@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix to hpilo module, patch against 2.6.28.
The device can take a while to respond to an open/close request, so increase
the time kernel will wait for response (1 ms to 10ms).  
Also, properly clean up a channel on a failed open, by calling the 
channel close routine.  Just freeing the memory isn't sufficient, the device
needs to be informed that the channel is no longer open, and the device
memory cleared of references to freed dma buffer.

Please CC me on any replies.

Signed-off-by: David Altobelli <david.altobelli@hp.com>
---

--- drivers/misc/hpilo.c.orig	2009-01-12 10:03:33.000000000 -0600
+++ drivers/misc/hpilo.c	2009-01-12 14:03:40.000000000 -0600
@@ -207,7 +207,7 @@ static void ilo_ccb_close(struct pci_dev
 		  &device_ccb->recv_ctrl);
 
 	/* give iLO some time to process stop request */
-	for (retries = 1000; retries > 0; retries--) {
+	for (retries = MAX_WAIT; retries > 0; retries--) {
 		doorbell_set(driver_ccb);
 		udelay(1);
 		if (!(ioread32(&device_ccb->send_ctrl) & (1 << CTRL_BITPOS_A))
@@ -309,7 +309,7 @@ static int ilo_ccb_open(struct ilo_hwinf
 	doorbell_clr(driver_ccb);
 
 	/* make sure iLO is really handling requests */
-	for (i = 1000; i > 0; i--) {
+	for (i = MAX_WAIT; i > 0; i--) {
 		if (ilo_pkt_dequeue(hw, driver_ccb, SENDQ, &pkt_id, NULL, NULL))
 			break;
 		udelay(1);
@@ -326,7 +326,7 @@ static int ilo_ccb_open(struct ilo_hwinf
 
 	return 0;
 free:
-	pci_free_consistent(pdev, data->dma_size, data->dma_va, data->dma_pa);
+	ilo_ccb_close(pdev, data);
 out:
 	return error;
 }
--- drivers/misc/hpilo.h.orig	2009-01-12 13:49:11.000000000 -0600
+++ drivers/misc/hpilo.h	2009-01-12 13:56:33.000000000 -0600
@@ -19,6 +19,8 @@
 #define MAX_ILO_DEV	1
 /* max number of files */
 #define MAX_OPEN	(MAX_CCB * MAX_ILO_DEV)
+/* spin counter for open/close delay */
+#define MAX_WAIT	10000
 
 /*
  * Per device, used to track global memory allocations.
