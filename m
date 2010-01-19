Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536Ab0ASLtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab0ASLtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 06:49:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306Ab0ASLtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 06:49:06 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:62880 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab0ASLtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 06:49:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=LdhiHWP12zNpfHqgvFAP4hQbhMm/iPKSxWwjXzyMCEBjQJG2Xo2p/TP90bS/VIfCzH
         GLkgpiuYrGZ8AUVU/VU0LvebFbEBke48qRsVj3eRZ0MpoWsAJQf4M9jyOzkZ5Pmbu+mT
         LoUAfrzvQKuDvwSuKG1c0EtuKskctd4vil57E=
Subject: [PATCH v2] regulator: mc13783: consider Power Gates as digital
 regulators.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 12:48:54 +0100
Message-ID: <1263901734.6669.28.camel@realization>
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

As read back value of control bit reflects the PWGTxDRV state (not the
control value previously written) and mc13783 POWERMISC register contain
only regulator related bits, a dedicated function to manage these bits is 
created here with the aim of tracing the real value of PWGTxSPIEN bits
and reproduce it on next writes.

All POWERMISC users _must_ use the new function to not accidentally
disable Power Gates supplies.

v2 changes:
-Better utilization of abstraction layers.
-Voltage query support. GPO's and PWGTxDRV are fixed voltage regulator
 with voltage value of 3.1V and 5.5V respectively.

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
---
 drivers/regulator/mc13783-regulator.c |  132 +++++++++++++++++++++++++++++++--
 include/linux/mfd/mc13783.h           |    2 +
 2 files changed, 128 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index a40e35a..f7b8184 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -82,6 +82,11 @@
 #define MC13783_REG_POWERMISC_GPO2EN			(1 << 8)
 #define MC13783_REG_POWERMISC_GPO3EN			(1 << 10)
 #define MC13783_REG_POWERMISC_GPO4EN			(1 << 12)
+#define MC13783_REG_POWERMISC_PWGT1SPIEN		(1 << 15)
+#define MC13783_REG_POWERMISC_PWGT2SPIEN		(1 << 16)
+
+#define MC13783_REG_POWERMISC_PWGTSPI_M			(3 << 15)
+
 
 struct mc13783_regulator {
 	struct regulator_desc desc;
@@ -161,8 +166,17 @@ static const int const mc13783_vrf_val[] = {
 	1500000, 1875000, 2700000, 2775000,
 };
 
+static const int const mc13783_gpo_val[] = {
+	3100000,
+};
+
+static const int const mc13783_pwgtdrv_val[] = {
+	5500000,
+};
+
 static struct regulator_ops mc13783_regulator_ops;
 static struct regulator_ops mc13783_fixed_regulator_ops;
+static struct regulator_ops mc13783_gpo_regulator_ops;
 
 #define MC13783_DEFINE(prefix, _name, _reg, _vsel_reg, _voltages)	\
 	[MC13783_ ## prefix ## _ ## _name] = {				\
@@ -197,17 +211,19 @@ static struct regulator_ops mc13783_fixed_regulator_ops;
 		.voltages =  _voltages,					\
 	}
 
-#define MC13783_GPO_DEFINE(prefix, _name, _reg)				\
+#define MC13783_GPO_DEFINE(prefix, _name, _reg,  _voltages)		\
 	[MC13783_ ## prefix ## _ ## _name] = {				\
 		.desc = {						\
 			.name = #prefix "_" #_name,			\
-			.ops = &mc13783_regulator_ops,			\
+			.n_voltages = ARRAY_SIZE(_voltages),		\
+			.ops = &mc13783_gpo_regulator_ops,		\
 			.type = REGULATOR_VOLTAGE,			\
 			.id = MC13783_ ## prefix ## _ ## _name,		\
 			.owner = THIS_MODULE,				\
 		},							\
 		.reg = MC13783_REG_ ## _reg,				\
 		.enable_bit = MC13783_REG_ ## _reg ## _ ## _name ## EN,	\
+		.voltages =  _voltages,					\
 	}
 
 #define MC13783_DEFINE_SW(_name, _reg, _vsel_reg, _voltages)		\
@@ -249,14 +265,17 @@ static struct mc13783_regulator mc13783_regulators[] = {
 			    mc13783_vmmc_val),
 	MC13783_DEFINE_REGU(VMMC2, REGULATORMODE1, REGULATORSETTING1,	\
 			    mc13783_vmmc_val),
-	MC13783_GPO_DEFINE(REGU, GPO1, POWERMISC),
-	MC13783_GPO_DEFINE(REGU, GPO2, POWERMISC),
-	MC13783_GPO_DEFINE(REGU, GPO3, POWERMISC),
-	MC13783_GPO_DEFINE(REGU, GPO4, POWERMISC),
+	MC13783_GPO_DEFINE(REGU, GPO1, POWERMISC, mc13783_gpo_val),
+	MC13783_GPO_DEFINE(REGU, GPO2, POWERMISC, mc13783_gpo_val),
+	MC13783_GPO_DEFINE(REGU, GPO3, POWERMISC, mc13783_gpo_val),
+	MC13783_GPO_DEFINE(REGU, GPO4, POWERMISC, mc13783_gpo_val),
+	MC13783_GPO_DEFINE(REGU, PWGT1SPI, POWERMISC, mc13783_pwgtdrv_val),
+	MC13783_GPO_DEFINE(REGU, PWGT2SPI, POWERMISC, mc13783_pwgtdrv_val),
 };
 
 struct mc13783_regulator_priv {
 	struct mc13783 *mc13783;
+	u32 powermisc_pwgt_state;
 	struct regulator_dev *regulators[];
 };
 
@@ -445,6 +464,107 @@ static struct regulator_ops mc13783_fixed_regulator_ops = {
 	.get_voltage = mc13783_fixed_regulator_get_voltage,
 };
 
+int mc13783_powermisc_rmw(struct mc13783_regulator_priv *priv, u32 mask,
+									u32 val)
+{
+	struct mc13783 *mc13783 = priv->mc13783;
+	int ret;
+	u32 valread;
+
+	BUG_ON(val & ~mask);
+
+	ret = mc13783_reg_read(mc13783, MC13783_REG_POWERMISC, &valread);
+	if (ret)
+		return ret;
+
+	/* Update the stored state for Power Gates. */
+	priv->powermisc_pwgt_state =
+				(priv->powermisc_pwgt_state & ~mask) | val;
+	priv->powermisc_pwgt_state &= MC13783_REG_POWERMISC_PWGTSPI_M;
+
+	/* Construct the new register value */
+	valread = (valread & ~mask) | val;
+	/* Overwrite the PWGTxEN with the stored version */
+	valread = (valread & ~MC13783_REG_POWERMISC_PWGTSPI_M) |
+						priv->powermisc_pwgt_state;
+
+	return mc13783_reg_write(mc13783, MC13783_REG_POWERMISC, valread);
+}
+
+static int mc13783_gpo_regulator_enable(struct regulator_dev *rdev)
+{
+	struct mc13783_regulator_priv *priv = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+	int ret;
+	u32 en_val = mc13783_regulators[id].enable_bit;
+
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
+
+	/* Power Gate enable value is 0 */
+	if (id == MC13783_REGU_PWGT1SPI ||
+	    id == MC13783_REGU_PWGT2SPI)
+		en_val = 0;
+
+	mc13783_lock(priv->mc13783);
+	ret = mc13783_powermisc_rmw(priv, mc13783_regulators[id].enable_bit,
+					en_val);
+	mc13783_unlock(priv->mc13783);
+
+	return ret;
+}
+
+static int mc13783_gpo_regulator_disable(struct regulator_dev *rdev)
+{
+	struct mc13783_regulator_priv *priv = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+	int ret;
+	u32 dis_val = 0;
+
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
+
+	/* Power Gate disable value is 1 */
+	if (id == MC13783_REGU_PWGT1SPI ||
+	    id == MC13783_REGU_PWGT2SPI)
+		dis_val = mc13783_regulators[id].enable_bit;
+
+	mc13783_lock(priv->mc13783);
+	ret = mc13783_powermisc_rmw(priv, mc13783_regulators[id].enable_bit,
+					dis_val);
+	mc13783_unlock(priv->mc13783);
+
+	return ret;
+}
+
+static int mc13783_gpo_regulator_is_enabled(struct regulator_dev *rdev)
+{
+	struct mc13783_regulator_priv *priv = rdev_get_drvdata(rdev);
+	int ret, id = rdev_get_id(rdev);
+	unsigned int val;
+
+	mc13783_lock(priv->mc13783);
+	ret = mc13783_reg_read(priv->mc13783, mc13783_regulators[id].reg, &val);
+	mc13783_unlock(priv->mc13783);
+
+	if (ret)
+		return ret;
+
+	/* Power Gates state is stored in powermisc_pwgt_state
+	 * where the meaning of bits is negated */
+	val = (val & ~MC13783_REG_POWERMISC_PWGTSPI_M) |
+	      (priv->powermisc_pwgt_state ^ MC13783_REG_POWERMISC_PWGTSPI_M);
+
+	return (val & mc13783_regulators[id].enable_bit) != 0;
+}
+
+static struct regulator_ops mc13783_gpo_regulator_ops = {
+	.enable = mc13783_gpo_regulator_enable,
+	.disable = mc13783_gpo_regulator_disable,
+	.is_enabled = mc13783_gpo_regulator_is_enabled,
+	.list_voltage = mc13783_regulator_list_voltage,
+	.set_voltage = mc13783_fixed_regulator_set_voltage,
+	.get_voltage = mc13783_fixed_regulator_get_voltage,
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



