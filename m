Return-Path: <linux-kernel-owner+w=401wt.eu-S933161AbZJFUNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161AbZJFUNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 16:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933141AbZJFUN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 16:13:29 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:60978 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933122AbZJFUN2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 16:13:28 -0400
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: "Yang, Bo" <Bo.Yang@lsi.com>,
       "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>,
       "James.Bottomley@suse.de" <James.Bottomley@suse.de>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Austria, Winston" <Winston.Austria@lsi.com>,
       "Mukker, Atul" <Atul.Mukker@lsi.com>
Date: Tue, 6 Oct 2009 14:12:21 -0600
Subject: [PATCH 1/12] scsi: megaraid_sas - tape drive support fix
Thread-Topic: [PATCH 1/12] scsi: megaraid_sas - tape drive support fix
Thread-Index: Aco28IhK0BCwqEkwToSTDcG+BIA9kwDb1hagAACJvwADF6mW4A==
Message-ID: <4B6A08C587958942AA3002690DD4F8C35C6861A5@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RESUBMIT:

Add the Tape drive fix to the megaraid_sas driver: If the command is for the tape device, set the FW pthru timeout to the os layer timeout value.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c	2009-05-04 20:06:29.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c	2009-05-04 20:08:26.000000000 -0400
@@ -687,6 +687,17 @@ megasas_build_dcdb(struct megasas_instan
 	memcpy(pthru->cdb, scp->cmnd, scp->cmd_len);
 
 	/*
+	* If the command is for the tape device, set the
+	* pthru timeout to the os layer timeout value.
+	*/
+	if (scp->device->type == TYPE_TAPE) {
+		if ((scp->request->timeout / HZ) > 0xFFFF)
+			pthru->timeout = 0xFFFF;
+		else
+			pthru->timeout = scp->request->timeout / HZ;
+	}
+
+	/*
 	 * Construct SGL
 	 */
 	if (IS_DMA64) {
