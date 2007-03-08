Return-Path: <linux-kernel-owner+w=401wt.eu-S1030799AbXCHWTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030799AbXCHWTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 17:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030802AbXCHWTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 17:19:16 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39095 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030799AbXCHWTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 17:19:14 -0500
Date: Thu, 8 Mar 2007 16:19:11 -0600
To: Bino.Sebastian@Emulex.Com, James Smart <james.smart@Emulex.Com>
Cc: linuxppc-dev@ozlabs.org, linux-scsi@vger.kernel.org,
       James.Bottomley@SteelEye.com, rlary@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] lpfc: avoid double-free during PCI error failure
Message-ID: <20070308221911.GC30703@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Bino, James,
Please review, sign-off and forward upstream.

--linas


If a PCI error is detected that cannot be recovered from, there
will be a double call of lpfc_pci_remove_one(), with the second call
resulting in a null-pointer dereference. The first call occurs in 
lpfc_io_error_detected(), and the second call during pci device 
remove. This patch eliminates the first call; its un-needed.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>

----
 drivers/scsi/lpfc/lpfc_init.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6.20-git16/drivers/scsi/lpfc/lpfc_init.c
===================================================================
--- linux-2.6.20-git16.orig/drivers/scsi/lpfc/lpfc_init.c	2007-03-08 15:57:40.000000000 -0600
+++ linux-2.6.20-git16/drivers/scsi/lpfc/lpfc_init.c	2007-03-08 16:03:18.000000000 -0600
@@ -1817,10 +1817,9 @@ static pci_ers_result_t lpfc_io_error_de
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring  *pring;
 
-	if (state == pci_channel_io_perm_failure) {
-		lpfc_pci_remove_one(pdev);
+	if (state == pci_channel_io_perm_failure)
 		return PCI_ERS_RESULT_DISCONNECT;
-	}
+
 	pci_disable_device(pdev);
 	/*
 	 * There may be I/Os dropped by the firmware.
