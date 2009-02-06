Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbZBFIzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbZBFIzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 03:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbZBFIzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 03:55:09 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:45233 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104AbZBFIzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 03:55:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIEABWIi0nCTtAn/2dsb2JhbACBbs0ShBYG
Date: Fri, 6 Feb 2009 09:55:01 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hancockrwd@gmail.com, abelay@mit.edu, lenb@kernel.org,
       stable@kernel.org
Subject: [PATCH] floppy: release only the ports we actually requested
Message-ID: <20090206085501.GA18125@frolo.macqel>
References: <20090205174859.18396.68512.stgit@bob.kio> <200902051055.34149.bjorn.helgaas@hp.com> <20090205142948.1a48d983.akpm@linux-foundation.org> <200902051643.32591.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902051643.32591.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn, Andrew,

--

With the last floppy patch, the floppy driver requests only the ports that
it really uses, but the code contains yet places where it releases those
unrequested ports.  I don't know if it is harmfull, but I think it is cleaner
that the parameters of the release_region calls match the request_region ones.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>

--- a/drivers/block/floppy.c	2009-02-06 08:56:33.000000000 +0100
+++ b/drivers/block/floppy.c	2009-02-06 09:05:55.000000000 +0100
@@ -4274,7 +4274,8 @@ static int __init floppy_init(void)
 		FDCS->rawcmd = 2;
 		if (user_reset_fdc(-1, FD_RESET_ALWAYS, 0)) {
 			/* free ioports reserved by floppy_grab_irq_and_dma() */
-			release_region(FDCS->address + 2, 4);
+			release_region(FDCS->address + 2, 1);
+			release_region(FDCS->address + 4, 2);
 			release_region(FDCS->address + 7, 1);
 			FDCS->address = -1;
 			FDCS->version = FDC_NONE;
@@ -4284,7 +4285,8 @@ static int __init floppy_init(void)
 		FDCS->version = get_fdc_version();
 		if (FDCS->version == FDC_NONE) {
 			/* free ioports reserved by floppy_grab_irq_and_dma() */
-			release_region(FDCS->address + 2, 4);
+			release_region(FDCS->address + 2, 1);
+			release_region(FDCS->address + 4, 2);
 			release_region(FDCS->address + 7, 1);
 			FDCS->address = -1;
 			continue;
@@ -4510,7 +4512,8 @@ static void floppy_release_irq_and_dma(v
 	old_fdc = fdc;
 	for (fdc = 0; fdc < N_FDC; fdc++)
 		if (FDCS->address != -1) {
-			release_region(FDCS->address + 2, 4);
+			release_region(FDCS->address + 2, 1);
+			release_region(FDCS->address + 4, 2);
 			release_region(FDCS->address + 7, 1);
 		}
 	fdc = old_fdc;
