Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788AbYDTLzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbYDTLzv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 07:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYDTLzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 07:55:40 -0400
Received: from port-212-202-105-50.static.qsc.de ([212.202.105.50]:58391 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758938AbYDTLzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 07:55:33 -0400
Date: Sun, 20 Apr 2008 12:27:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix VIDIOCGAP corruption in ivtv
Message-ID: <20080420122736.20d60eff@the-village.bc.nu>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Bennett reported that ivtv was causing skype to crash. With help
from one of their developers he showed it was a kernel problem.
VIDIOCGCAP copies a name into a fixed length buffer - ivtv uses names
that are too long and does not truncate them so corrupts a few bytes of
the app data area.

Possibly the names also want trimming but for now this should fix the
corruption case.

Signed-off-by: Alan Cox <alan@redhat.com>

--- linux.vanilla-2.6.25-rc8-mm2/drivers/media/video/ivtv/ivtv-ioctl.c	2008-04-13 15:36:53.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/media/video/ivtv/ivtv-ioctl.c	2008-04-20 12:15:33.000000000 +0100
@@ -742,7 +742,8 @@
 
 		memset(vcap, 0, sizeof(*vcap));
 		strcpy(vcap->driver, IVTV_DRIVER_NAME);     /* driver name */
-		strcpy(vcap->card, itv->card_name); 	    /* card type */
+		strncpy(vcap->card, itv->card_name,
+				sizeof(vcap->card)-1); 	    /* card type */
 		strcpy(vcap->bus_info, pci_name(itv->dev)); /* bus info... */
 		vcap->version = IVTV_DRIVER_VERSION; 	    /* version */
 		vcap->capabilities = itv->v4l2_cap; 	    /* capabilities */

--
		"Hello, welcome to Jon Masters' house of pain"
				- Jon after a particularly good night
