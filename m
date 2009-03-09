Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbZCIW5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbZCIW5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 18:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbZCIW4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 18:56:55 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:11750 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbZCIW4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 18:56:54 -0400
Date: Mon, 9 Mar 2009 16:56:52 -0600
From: David Altobelli <david.altobelli@hp.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, david.altobelli@hp.com
Subject: [PATCH] tweak spin logic for hpilo
Message-ID: <20090309225651.GA13702@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change hpilo open and close logic to spin for 10usec between checking device, 
rather than every usec.  Applies to 2.6.29.

Please CC me on any replies.

Signed-off-by: David Altobelli <david.altobelli@hp.com>
---

--- linux-2.6.28/drivers/misc/hpilo.h.orig	2009-03-09 13:24:25.000000000 -0500
+++ linux-2.6.28/drivers/misc/hpilo.h	2009-03-09 13:28:22.000000000 -0500
@@ -19,8 +19,12 @@
 #define MAX_ILO_DEV	1
 /* max number of files */
 #define MAX_OPEN	(MAX_CCB * MAX_ILO_DEV)
+/* total wait time in usec */
+#define MAX_WAIT_TIME	10000
+/* per spin wait time in usec */
+#define WAIT_TIME	10
 /* spin counter for open/close delay */
-#define MAX_WAIT	10000
+#define MAX_WAIT	(MAX_WAIT_TIME / WAIT_TIME)
 
 /*
  * Per device, used to track global memory allocations.
--- linux-2.6.28/drivers/misc/hpilo.c.orig	2009-03-09 13:24:31.000000000 -0500
+++ linux-2.6.28/drivers/misc/hpilo.c	2009-03-09 13:57:08.000000000 -0500
@@ -209,7 +209,7 @@ static void ilo_ccb_close(struct pci_dev
 	/* give iLO some time to process stop request */
 	for (retries = MAX_WAIT; retries > 0; retries--) {
 		doorbell_set(driver_ccb);
-		udelay(1);
+		udelay(WAIT_TIME);
 		if (!(ioread32(&device_ccb->send_ctrl) & (1 << CTRL_BITPOS_A))
 		    &&
 		    !(ioread32(&device_ccb->recv_ctrl) & (1 << CTRL_BITPOS_A)))
@@ -312,7 +312,7 @@ static int ilo_ccb_open(struct ilo_hwinf
 	for (i = MAX_WAIT; i > 0; i--) {
 		if (ilo_pkt_dequeue(hw, driver_ccb, SENDQ, &pkt_id, NULL, NULL))
 			break;
-		udelay(1);
+		udelay(WAIT_TIME);
 	}
 
 	if (i) {
@@ -759,7 +759,7 @@ static void __exit ilo_exit(void)
 	class_destroy(ilo_class);
 }
 
-MODULE_VERSION("1.0");
+MODULE_VERSION("1.1");
 MODULE_ALIAS(ILO_NAME);
 MODULE_DESCRIPTION(ILO_NAME);
 MODULE_AUTHOR("David Altobelli <david.altobelli@hp.com>");
