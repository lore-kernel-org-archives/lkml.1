Return-Path: <linux-kernel-owner+w=401wt.eu-S933145AbXDZG4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145AbXDZG4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933159AbXDZG4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:56:48 -0400
Received: from imx9.toshiba.co.jp ([202.33.96.51]:36214 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145AbXDZG4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:56:47 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1/2] Fix the memory leak Intel RNG driver for 2.6.21-rc7-mm1
X-MimeOLE: Produced By Microsoft Exchange V6.5.7226.0
Date: Thu, 26 Apr 2007 15:27:31 +0900
Message-ID: <BF571719A4041A478005EF3F08EA6DF004332395@pcsmail03.pcs.pc.ome.toshiba.co.jp>
Thread-Topic: [PATCH 1/2] Fix the memory leak Intel RNG driver for 2.6.21-rc7-mm1
Thread-Index: AceHy/hf0RX9TfBUThqH3zXk+OE0Hg==
From: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
To: <prarit@redhat.com>, <jbeulich@novell.com>
Cc: "lkml" <linux-kernel@vger.kernel.org>,
       "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a memory leak in mod_init().
In the error, intel_rng_hw was freed.

 intel-rng.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.21-rc7-mm1/drivers/char/hw_random/intel-rng.c.orig	2007-04-26 11:56:03.000000000 +0900
+++ linux-2.6.21-rc7-mm1/drivers/char/hw_random/intel-rng.c	2007-04-26 13:39:50.000000000 +0900
@@ -345,11 +345,11 @@ static int __init mod_init(void)
 	}
 
 	err = intel_init_hw_struct(intel_rng_hw, dev);
-	if (err == -ENODEV) {
-		pci_dev_put(dev);
-		goto fwh_done;
-	} else if (err < 0) {
+	if (err) {
 		pci_dev_put(dev);
+		kfree(intel_rng_hw);
+		if (err == -ENODEV) 
+			goto fwh_done;
 		goto out;
 	}
