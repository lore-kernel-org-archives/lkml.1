Return-Path: <linux-kernel-owner+w=401wt.eu-S1758594AbZB0AEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594AbZB0AEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 19:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbZB0AEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 19:04:11 -0500
Received: from n6b.bullet.sp1.yahoo.com ([69.147.64.163]:45032 "HELO
	n6b.bullet.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754494AbZB0AEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 19:04:10 -0500
X-yahoo-newman-spamcop: yes
X-Yahoo-Newman-Id: 867290.89402.bm@omp403.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qzeYW57o0kfdBdPdIhJGxO/zv1Tk6PXFapRXDpsV6RxGv+ebHu1DixrbkucApA16iXVWjxUn5CF0v5UZyE08DPJWzri99FI1Ffx1TJHap+d2EGU7Id1c+PsyDPRV0v+4em16QxL/y97CNO5P8R7lHVSadX8BeQBSMg0LWEZ/5lM=  ;
X-YMail-OSG: 1wFvOZIVM1kXNnprMx4hi_KngbOrXkKH_Gc3w0FatAqgP9NwXORc37gCqhCkmvbRSl4hHtgo1EOjyfPYWpYU1Yut66op_JNK1rW5I0vTqR0yQ4Cu7udgHyb5jr1KD1X6a42wyZb4L8DsdalHUAapKOtrVQFFnLa5VDaWm2LsA3Whid1SOg6xGNLdjaALSMcCx8INp4xggBdrTa1zUglNiF1ZNUvBpK8-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [patch/rfc 2.6.29-rc6 2/2] regulator: twl4030 voltage enumeration (v2)
Date: Thu, 26 Feb 2009 16:02:58 -0800
User-Agent: KMail/1.9.10
Cc: Mark Brown <broonie@sirena.org.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <200902261150.15125.david-b@pacbell.net> <1235686618.31223.107.camel@vega.slimlogic.co.uk>
In-Reply-To: <1235686618.31223.107.camel@vega.slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902261602.58832.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 February 2009, Liam Girdwood wrote:
> > 
> > Note that the twl4030 regulator patch referred to will need a
> > minor patch to work with the -next tree, because of interface
> > change in the regulator framework.
> > 
> >  drivers/regulator/twl4030-regulator.c |   62 +++++++++++---------------------
> >  1 file changed, 23 insertions(+), 39 deletions(-)
> 
> Applied.

..... and here's that "minor patch".

====== CUT HERE
From: David Brownell <dbrownell@users.sourceforge.net>

Catch up the twl4030 regulator driver to the regulator
interface change adding another parameter.  Also, fix
some comments, and take this opportunity to shrink the
associated per-regulator memory usage by a word.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/regulator/twl4030-regulator.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/regulator/twl4030-regulator.c
+++ b/drivers/regulator/twl4030-regulator.c
@@ -36,13 +36,13 @@ struct twlreg_info {
 	/* twl4030 resource ID, for resource control state machine */
 	u8			id;
 
+	/* FIXED_LDO voltage */
+	u8			deciV;
+
 	/* voltage in mV = table[VSEL]; table_len must be a power-of-two */
 	u8			table_len;
 	const u16		*table;
 
-	/* chip constraints on regulator behavior */
-	u16			min_mV;
-
 	/* used by regulator core */
 	struct regulator_desc	desc;
 };
@@ -329,14 +329,14 @@ static int twl4030fixed_list_voltage(str
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
 
-	return info->min_mV * 1000;
+	return info->deciV * 100 * 1000;
 }
 
 static int twl4030fixed_get_voltage(struct regulator_dev *rdev)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
 
-	return info->min_mV * 1000;
+	return info->deciV * 100 * 1000;
 }
 
 static struct regulator_ops twl4030fixed_ops = {
@@ -373,7 +373,7 @@ static struct regulator_ops twl4030fixed
 #define TWL_FIXED_LDO(label, offset, mVolts, num) { \
 	.base = offset, \
 	.id = num, \
-	.min_mV = mVolts, \
+	.deciV = mVolts / 100 , \
 	.desc = { \
 		.name = #label, \
 		.id = TWL4030_REG_##label, \
@@ -385,7 +385,7 @@ static struct regulator_ops twl4030fixed
 	}
 
 /*
- * We list regulators here if systems need some level of
+ * We expose regulators here if systems need some level of
  * software control over them after boot.
  */
 static struct twlreg_info twl4030_regs[] = {
@@ -439,6 +439,7 @@ static int twl4030reg_probe(struct platf
 
 	/* Constrain board-specific capabilities according to what
 	 * this driver and the chip itself can actually do.
+	 * (Regulator core now does this for voltage constraints.)
 	 */
 	c = &initdata->constraints;
 	c->valid_modes_mask &= REGULATOR_MODE_NORMAL | REGULATOR_MODE_STANDBY;
@@ -446,7 +447,7 @@ static int twl4030reg_probe(struct platf
 				| REGULATOR_CHANGE_MODE
 				| REGULATOR_CHANGE_STATUS;
 
-	rdev = regulator_register(&info->desc, &pdev->dev, info);
+	rdev = regulator_register(&info->desc, &pdev->dev, initdata, info);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "can't register %s, %ld\n",
 				info->desc.name, PTR_ERR(rdev));



