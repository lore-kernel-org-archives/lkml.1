Return-Path: <linux-kernel-owner+w=401wt.eu-S932211AbZLNRNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbZLNRNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 12:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932144AbZLNRNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 12:13:07 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:64110 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbZLNRND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 12:13:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=onm1KfjnNFMZlHtGMEGQVQx8++/kDO7rrImtkPxY1CNMsqoipiwWoaymx3oqhY54UQ
         RWBxhYHZlXbeu+xgf1oYfRRrJlj9izZ0hCC9tBX1JgqpEvvo7/CH+e07+pBNgf9tHmh1
         x5lcP6d4S7y2zesvJS0BdOkBeW+8/Xrct2gFM=
Subject: [PATCH 1/4] mfd: mc13783: Take care of semantic inversion between
 read and write value of two bits in POWER_MISCELLANEUS register.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Sascha linux-arm <s.hauer@pengutronix.de>
In-Reply-To: <1260808880.2022.98.camel@climbing-alby>
References: <1260808880.2022.98.camel@climbing-alby>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 18:12:56 +0100
Message-ID: <1260810776.2022.130.camel@climbing-alby>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PWGT1DRV and PWGT1DRV are two digital output controlled by two corresponding
hardware signals (Pin PWGTnEN) that are meant to be used to control core power
supplies.
The register MC13783_REG_POWER_MISCELLANEOUS contain the two control and
status bit (PWGTnSPIEN) where write and read meaning is summarised by 
the following table:

 Bit PWGTxSPIEN | Pin PWGTxEN | PWGTxDRV |  Read Back
   0 = default  |             |          | PWGTxSPIEN
 ---------------+-------------+----------+------------
       1        |      x      |   Low    |     0
       0        |      0      |   High   |     1
       0        |      1      |   Low    |     0

Writing a 1 to those bits will turn off the corresponding core
power supply. As there is no way to read back the value of 
PWGTnSPIEN, the behaviour chosen is to let always the hardware
control itself leaving those bits at the default value.

This patch is especially needed for manipulate the other bits
in the same register, where the read-modify-write operation
can produce unwanted power fault.

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
---
 drivers/mfd/mc13783-core.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/mc13783-core.c b/drivers/mfd/mc13783-core.c
index a1ade23..3953297 100644
--- a/drivers/mfd/mc13783-core.c
+++ b/drivers/mfd/mc13783-core.c
@@ -171,6 +171,9 @@ int mc13783_reg_read(struct mc13783 *mc13783, unsigned int offset, u32 *val)
 }
 EXPORT_SYMBOL(mc13783_reg_read);
 
+#define MC13783_REG_POWER_MISCELLANEOUS	34
+#define MC13783_REGCTRL_PWGT1SPIEN	(1 << 15)
+#define MC13783_REGCTRL_PWGT2SPIEN	(1 << 16)
 int mc13783_reg_write(struct mc13783 *mc13783, unsigned int offset, u32 val)
 {
 	u32 buf;
@@ -187,6 +190,13 @@ int mc13783_reg_write(struct mc13783 *mc13783, unsigned int offset, u32 val)
 
 	buf = 1 << 31 | offset << MC13783_REGOFFSET_SHIFT | val;
 
+	/* Take care of table 4-24 in Freescale MC13783IGPLDRM.pdf making
+	 * the assumption that PWGTnDRV signals controls core power supplies
+	 * that software must not disable. */
+	if (offset == MC13783_REG_POWER_MISCELLANEOUS)
+		buf &= !(MC13783_REGCTRL_PWGT1SPIEN |
+			 MC13783_REGCTRL_PWGT2SPIEN);
+
 	memset(&t, 0, sizeof(t));
 
 	t.tx_buf = &buf;
-- 
1.6.3.3




