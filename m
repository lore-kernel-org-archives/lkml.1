Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbZBQPDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbZBQPDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZBQPDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:03:22 -0500
Received: from exprod7og110.obsmtp.com ([64.18.2.173]:45716 "EHLO
	exprod7og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbZBQPDV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:03:21 -0500
X-Greylist: delayed 1102 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Feb 2009 10:03:20 EST
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Austria, Winston" <Winston.Austria@lsi.com>,
       "Yang, Bo" <Bo.Yang@lsi.com>
Date: Tue, 17 Feb 2009 06:44:24 -0800
Subject: [PATCH 1/9] scsi: megaraid_sas - Fix the tape drive support
Thread-Topic: [PATCH 1/9] scsi: megaraid_sas - Fix the tape drive support
Thread-Index: AciIcSnS7H5xFQtCQzyNHR19nlBrTUImYsQg
Message-ID: <4B6A08C587958942AA3002690DD4F8C33A07FB03@cosmail02.lsi.com>
In-Reply-To: <1205787285.6767.185.camel@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the Tape drive fix to the megaraid_sas driver: If the command is for the tape device, set the FW pthru timeout to the os layer timeout value.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2009-02-12 15:24:58.000000000 -0500
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2009-02-12 15:33:57.000000000 -0500
@@ -687,6 +687,17 @@ megasas_build_dcdb(struct megasas_instan
        memcpy(pthru->cdb, scp->cmnd, scp->cmd_len);

        /*
+       * If the command is for the tape device, set the
+       * pthru timeout to the os layer timeout value.
+       */
+       if (scp->device->type == TYPE_TAPE) {
+               if ((scp->request->timeout / HZ) > 0xFFFF)
+                       pthru->timeout = 0xFFFF;
+               else
+                       pthru->timeout = scp->request->timeout / HZ;
+       }
+
+       /*
         * Construct SGL
         */
        if (IS_DMA64) {
