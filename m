Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668Ab0ARQYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab0ARQYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 11:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464Ab0ARQYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 11:24:20 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:34014 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab0ARQYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 11:24:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Tfo96S92jOhOF6Ag9GLNus8VU82zTxsN/eFBVKrgIeYsubxrlogz+dQfVWTeo4uEl7
         FMmGgHSLoQG8AP73gCxvxeA1Lio7vCNtyA0gH6MH+ruyEX6AC2kQSf4udpXf/+dsjIup
         TDnAA0HZuYyXI8WIM+uSNjOak0s3ovBSu4x6k=
Subject: [PATCH] regulator: mc13783: consider Power Gates as digital
 regulators.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 17:02:03 +0100
Message-ID: <1263830523.3632.22.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPO regulators are digital outputs that can be enabled or disabled by a
dedicated bit in mc13783 POWERMISC register.
In this family can be count in also Power Gates (PWGT1 and 2): enabled by
a dedicated pin a Power Gate is an hardware driven supply where the output
(PWGTnDRV) follow this law:

 Bit PWGTxSPIEN | Pin PWGTxEN | PWGTxDRV |  Read Back
   0 = default  |             |          | PWGTxSPIEN
 ---------------+-------------+----------+------------
       1        |      x      |   Low    |     0
       0        |      0      |   High   |     1
       0        |      1      |   Low    |     0

As read back value of control bit reflects the PWGTxDRV state and not the
control value previously written, a dedicated function to manage bits of 
POWERMISC register is created and the state of PWGTxEN bits is stored in memory.

All POWERMISC users _must_ make use of the new function to not accidentally
disable Power Gates supplies.


Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
---
 drivers/regulator/mc13783-regulator.c |   97 ++++++++++++++++++++++++++++++++-
 include/linux/mfd/mc13783.h           |    2 +
 2 files changed, 98 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index a40e35a..8570fce 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -82,6 +82,10 @@
 #define MC13783_REG_POWERMISC_GPO2EN			(1 << 8)
 #define MC13783_REG_POWERMISC_GPO3EN			(1 << 10)
 #define MC13783_REG_POWERMISC_GPO4EN			(1 << 12)
+#define MC13783_REG_POWERMISC_PWGTSPI_M			(3 << 15)
+#define MC13783_REG_POWERMISC_PWGT1SPIEN		(1 << 15)
+#define MC13783_REG_POWERMISC_PWGT2SPIEN		(1 << 16)
+
 
 struct mc13783_regulator {
 	struct regulator_desc desc;
@@ -163,6 +167,7 @@ static const int const mc13783_vrf_val[] = {
 
 static struct regulator_ops mc13783_regulator_ops;
 static struct regulator_ops mc13783_fixed_regulator_ops;
+static struct regulator_ops mc13783_regulator_ops_gpo;
 
 #define MC13783_DEFINE(prefix, _name, _reg, _vsel_reg, _voltages)	\
 	[MC13783_ ## prefix ## _ ## _name] = {				\
@@ -201,7 +206,7 @@ static struct regulator_ops mc13783_fixed_regulator_ops;
 	[MC13783_ ## prefix ## _ ## _name] = {				\
 		.desc = {						\
 			.name = #prefix "_" #_name,			\
-			.ops = &mc13783_regulator_ops,			\
+			.ops = &mc13783_regulator_ops_gpo,		\
 			.type = REGULATOR_VOLTAGE,			\
 			.id = MC13783_ ## prefix ## _ ## _name,		\
 			.owner = THIS_MODULE,				\
@@ -253,6 +258,8 @@ static struct mc13783_regulator mc13783_regulators[] = {
 	MC13783_GPO_DEFINE(REGU, GPO2, POWERMISC),
 	MC13783_GPO_DEFINE(REGU, GPO3, POWERMISC),
 	MC13783_GPO_DEFINE(REGU, GPO4, POWERMISC),
+	MC13783_GPO_DEFINE(REGU, PWGT1SPI, POWERMISC),
+	MC13783_GPO_DEFINE(REGU, PWGT2SPI, POWERMISC),
 };
 
 struct mc13783_regulator_priv {
@@ -445,6 +452,94 @@ static struct regulator_ops mc13783_fixed_regulator_ops = {
 	.get_voltage = mc13783_fixed_regulator_get_voltage,
 };
 
+int mc13783_state_powermisc_pwgt;
+int mc13783_reg_rmw_powermisc(struct mc13783 *mc13783, u32 mask, u32 val)
+{
+	int ret;
+	u32 valread;
+
+	BUG_ON(val & ~mask);
+
+	/* Update the stored state for Power Gates.
+	 * As from specs the meaning is inverted (0: en, 1: dis) */
+	if (mask & MC13783_REG_POWERMISC_PWGTSPI_M)
+		mc13783_state_powermisc_pwgt =
+			(mc13783_state_powermisc_pwgt & ~mask) |
+			((val ^ mask) & MC13783_REG_POWERMISC_PWGTSPI_M);
+
+	ret = mc13783_reg_read(mc13783, MC13783_REG_POWERMISC, &valread);
+	if (ret)
+		return ret;
+
+	valread = (valread & ~mask) | val;
+
+	/* Re propose the stored state for Power Gates */
+	valread = (valread & ~MC13783_REG_POWERMISC_PWGTSPI_M) |
+						mc13783_state_powermisc_pwgt;
+
+	return mc13783_reg_write(mc13783, MC13783_REG_POWERMISC, valread);
+}
+
+static int mc13783_regulator_enable_gpo(struct regulator_dev *rdev)
+{
+	struct mc13783_regulator_priv *priv = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+	int ret;
+
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
+
+	mc13783_lock(priv->mc13783);
+	ret = mc13783_reg_rmw_powermisc(priv->mc13783,
+			mc13783_regulators[id].enable_bit,
+			mc13783_regulators[id].enable_bit);
+	mc13783_unlock(priv->mc13783);
+
+	return ret;
+}
+
+static int mc13783_regulator_disable_gpo(struct regulator_dev *rdev)
+{
+	struct mc13783_regulator_priv *priv = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+	int ret;
+
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
+
+	mc13783_lock(priv->mc13783);
+	ret = mc13783_reg_rmw_powermisc(priv->mc13783,
+			mc13783_regulators[id].enable_bit, 0);
+	mc13783_unlock(priv->mc13783);
+
+	return ret;
+}
+
+static int mc13783_regulator_is_enabled_gpo(struct regulator_dev *rdev)
+{
+	struct mc13783_regulator_priv *priv = rdev_get_drvdata(rdev);
+	int ret, id = rdev_get_id(rdev);
+	unsigned int val;
+
+	mc13783_lock(priv->mc13783);
+	ret = mc13783_reg_read(priv->mc13783, mc13783_regulators[id].reg, &val);
+	mc13783_unlock(priv->mc13783);
+
+	/* Power Gates state is stored in mc13783_state_powermisc_pwgt
+	 * where the meaning is inverted */
+	val = (val & ~MC13783_REG_POWERMISC_PWGTSPI_M) |
+	      (mc13783_state_powermisc_pwgt ^ MC13783_REG_POWERMISC_PWGTSPI_M);
+
+	if (ret)
+		return ret;
+
+	return (val & mc13783_regulators[id].enable_bit) != 0;
+}
+
+static struct regulator_ops mc13783_regulator_ops_gpo = {
+	.enable = mc13783_regulator_enable_gpo,
+	.disable = mc13783_regulator_disable_gpo,
+	.is_enabled = mc13783_regulator_is_enabled_gpo,
+};
+
 static int __devinit mc13783_regulator_probe(struct platform_device *pdev)
 {
 	struct mc13783_regulator_priv *priv;
diff --git a/include/linux/mfd/mc13783.h b/include/linux/mfd/mc13783.h
index 3568040..94cb51a 100644
--- a/include/linux/mfd/mc13783.h
+++ b/include/linux/mfd/mc13783.h
@@ -108,6 +108,8 @@ int mc13783_adc_do_conversion(struct mc13783 *mc13783, unsigned int mode,
 #define	MC13783_REGU_V2		28
 #define	MC13783_REGU_V3		29
 #define	MC13783_REGU_V4		30
+#define	MC13783_REGU_PWGT1SPI	31
+#define	MC13783_REGU_PWGT2SPI	32
 
 #define MC13783_IRQ_ADCDONE	0
 #define MC13783_IRQ_ADCBISDONE	1
-- 
1.6.3.3



