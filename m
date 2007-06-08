Return-Path: <linux-kernel-owner+w=401wt.eu-S970271AbXFHQRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970271AbXFHQRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969438AbXFHQRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:17:12 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:24611 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756539AbXFHQRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:17:11 -0400
X-Greylist: delayed 1646 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Jun 2007 12:17:11 EDT
Date: Fri, 08 Jun 2007 09:52:45 -0600
From: dougthompson@xmission.com
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH 2/6]
Message-ID: <46697b4d.pS5U14EbmDptHEuZ%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Jason Uhlenkott <juhlenko@akamai.com>

If ERRSTS indicates that there's no error then we don't need to bother
reading the other registers.

In addition to making the common case faster, this actually fixes a
small race where we don't see an error but we clear the error bits
anyway, potentially wiping away info on an error that happened in the
interim (or where a CE arrives between the first and second read of
ERRSTS, causing us to falsely claim "UE overwrote CE").

Signed-off-by:	Jason Uhlenkott <juhlenko@akamai.com>
Signed-off-by:	Douglas Thompson <dougthompson@xmission.com>
Cc:	alan@lxorguk.ukuu.org.uk
---
 i82875p_edac.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- linux.orig/drivers/edac/i82875p_edac.c	2007-05-21 00:46:31.568356390 -0400
+++ linux/drivers/edac/i82875p_edac.c	2007-05-21 00:46:36.637650484 -0400
@@ -198,27 +198,28 @@
 	 * overwritten by UE.
 	 */
 	pci_read_config_word(pdev, I82875P_ERRSTS, &info->errsts);
+
+	if (!(info->errsts & 0x0081))
+		return;
+
 	pci_read_config_dword(pdev, I82875P_EAP, &info->eap);
 	pci_read_config_byte(pdev, I82875P_DES, &info->des);
 	pci_read_config_byte(pdev, I82875P_DERRSYN, &info->derrsyn);
 	pci_read_config_word(pdev, I82875P_ERRSTS, &info->errsts2);
 
-	pci_write_bits16(pdev, I82875P_ERRSTS, 0x0081, 0x0081);
-
 	/*
 	 * If the error is the same then we can for both reads then
 	 * the first set of reads is valid.  If there is a change then
 	 * there is a CE no info and the second set of reads is valid
 	 * and should be UE info.
 	 */
-	if (!(info->errsts2 & 0x0081))
-		return;
-
 	if ((info->errsts ^ info->errsts2) & 0x0081) {
 		pci_read_config_dword(pdev, I82875P_EAP, &info->eap);
 		pci_read_config_byte(pdev, I82875P_DES, &info->des);
 		pci_read_config_byte(pdev, I82875P_DERRSYN, &info->derrsyn);
 	}
+
+	pci_write_bits16(pdev, I82875P_ERRSTS, 0x0081, 0x0081);
 }
 
 static int i82875p_process_error_info(struct mem_ctl_info *mci,
@@ -229,7 +230,7 @@
 
 	multi_chan = mci->csrows[0].nr_channels - 1;
 
-	if (!(info->errsts2 & 0x0081))
+	if (!(info->errsts & 0x0081))
 		return 0;
 
 	if (!handle_errors)

