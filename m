Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbZBZTup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbZBZTup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 14:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbZBZTuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 14:50:22 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:45855 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756273AbZBZTuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 14:50:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=AmkRw5QLUS8gEl/tA8377/h7S1yl5imgkYc42kzdKEhBb/MQfi+8I8I5eqZG+UeQfZL/4Cks4xNhjkFvDXyR54776983aR/D7xXtLe01wkQatMS+KHli+fEeadwFWBJvSpSaW7qaN5fjqGRKjq/3y0L4hi3Z/4O2DKTi8gTJNls=  ;
X-YMail-OSG: 0qle_a4VM1lnzPNmzTESGBgGU9ni2CjjzylxxP3ILTtErNQDGja39DQsS_yoq3Xi69DmM8Sib._5PEi8vMCF4c4_G5AKpt5J7aeyd37lSdtOHFXVAkEnYOwQIAWIhS7nfAwoeF2D9WErpCN4Bu.TvepG3BszUixFcfzn9U7zKSzIWlmIduz9thMAVbUWT4iamI6hUBewUXM9cM6wfrD_2P0W.Ct5RSCHbNk2ZA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: [patch 2.6.29-rc6 1/2] regulator: enumerate voltages (v2)
Date: Thu, 26 Feb 2009 11:48:36 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <200902231245.44360.david-b@pacbell.net> <200902231252.01980.david-b@pacbell.net>
In-Reply-To: <200902231252.01980.david-b@pacbell.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902261148.36892.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Add a basic mechanism for regulators to report the discrete
voltages they support:  list_voltage() enumerates them using
selectors numbered from 0 to an upper bound.

Use those methods to force machine-level constraints into bounds.
(Example:  regulator supports 1.8V, 2.4V, 2.6V, 3.3V, and board
constraints for that rail are 2.0V to 3.6V ... so the range of
voltages is then 2.4V to 3.3V on this board.)

Export those voltages to the regulator consumer interface, so for
example regulator hooked up to an MMC/SD/SDIO slot can report the
actual voltage options available to cards connected there.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Updates since previous version:  address feedback, simplify.

 drivers/regulator/core.c           |  113 +++++++++++++++++++++++++++++++++++
 include/linux/regulator/consumer.h |    2 
 include/linux/regulator/driver.h   |    9 ++
 3 files changed, 124 insertions(+)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -719,6 +719,69 @@ static int set_machine_constraints(struc
 	else
 		name = "regulator";
 
+	/* constrain machine-level voltage specs to fit
+	 * the actual range supported by this regulator.
+	 */
+	if (ops->list_voltage && rdev->desc->n_voltages) {
+		int	count = rdev->desc->n_voltages;
+		int	i;
+		int	min_uV = INT_MAX;
+		int	max_uV = INT_MIN;
+		int	cmin = constraints->min_uV;
+		int	cmax = constraints->max_uV;
+
+		/* it's safe to autoconfigure fixed-voltage supplies */
+		if (count == 1 && !cmin) {
+			cmin = INT_MIN;
+			cmax = INT_MAX;
+		}
+
+		/* else require explicit machine-level constraints */
+		else if (cmin <= 0 || cmax <= 0 || cmax < cmin) {
+			pr_err("%s: %s '%s' voltage constraints\n",
+				       __func__, "invalid", name);
+			ret = -EINVAL;
+			goto out;
+		}
+
+		/* initial: [cmin..cmax] valid, [min_uV..max_uV] not */
+		for (i = 0; i < count; i++) {
+			int	value;
+
+			value = ops->list_voltage(rdev, i);
+			if (value <= 0)
+				continue;
+
+			/* maybe adjust [min_uV..max_uV] */
+			if (value >= cmin && value < min_uV)
+				min_uV = value;
+			if (value <= cmax && value > max_uV)
+				max_uV = value;
+		}
+
+		/* final: [min_uV..max_uV] valid iff constraints valid */
+		if (max_uV < min_uV) {
+			pr_err("%s: %s '%s' voltage constraints\n",
+				       __func__, "unsupportable", name);
+			ret = -EINVAL;
+			goto out;
+		}
+
+		/* use regulator's subset of machine constraints */
+		if (constraints->min_uV < min_uV) {
+			pr_debug("%s: override '%s' %s, %d -> %d\n",
+				       __func__, name, "min_uV",
+					constraints->min_uV, min_uV);
+			constraints->min_uV = min_uV;
+		}
+		if (constraints->max_uV > max_uV) {
+			pr_debug("%s: override '%s' %s, %d -> %d\n",
+				       __func__, name, "max_uV",
+					constraints->max_uV, max_uV);
+			constraints->max_uV = max_uV;
+		}
+	}
+
 	rdev->constraints = constraints;
 
 	/* do we need to apply the constraint voltage */
@@ -1245,6 +1308,56 @@ int regulator_is_enabled(struct regulato
 EXPORT_SYMBOL_GPL(regulator_is_enabled);
 
 /**
+ * regulator_count_voltages - count regulator_list_voltage() selectors
+ * @regulator: regulator source
+ *
+ * Returns number of selectors, or negative errno.  Selectors are
+ * numbered starting at zero, and typically correspond to bitfields
+ * in hardware registers.
+ */
+int regulator_count_voltages(struct regulator *regulator)
+{
+	struct regulator_dev	*rdev = regulator->rdev;
+
+	return rdev->desc->n_voltages ? : -EINVAL;
+}
+EXPORT_SYMBOL_GPL(regulator_count_voltages);
+
+/**
+ * regulator_list_voltage - enumerate supported voltages
+ * @regulator: regulator source
+ * @selector: identify voltage to list
+ * Context: can sleep
+ *
+ * Returns a voltage that can be passed to @regulator_set_voltage(),
+ * zero if this selector code can't be used on this sytem, or a
+ * negative errno.
+ */
+int regulator_list_voltage(struct regulator *regulator, unsigned selector)
+{
+	struct regulator_dev	*rdev = regulator->rdev;
+	struct regulator_ops	*ops = rdev->desc->ops;
+	int			ret;
+
+	if (!ops->list_voltage || selector >= rdev->desc->n_voltages)
+		return -EINVAL;
+
+	mutex_lock(&rdev->mutex);
+	ret = ops->list_voltage(rdev, selector);
+	mutex_unlock(&rdev->mutex);
+
+	if (ret > 0) {
+		if (ret < rdev->constraints->min_uV)
+			ret = 0;
+		else if (ret > rdev->constraints->max_uV)
+			ret = 0;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regulator_list_voltage);
+
+/**
  * regulator_set_voltage - set regulator output voltage
  * @regulator: regulator source
  * @min_uV: Minimum required voltage in uV
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -140,6 +140,8 @@ int regulator_bulk_disable(int num_consu
 void regulator_bulk_free(int num_consumers,
 			 struct regulator_bulk_data *consumers);
 
+int regulator_count_voltages(struct regulator *regulator);
+int regulator_list_voltage(struct regulator *regulator, unsigned selector);
 int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV);
 int regulator_get_voltage(struct regulator *regulator);
 int regulator_set_current_limit(struct regulator *regulator,
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -40,6 +40,10 @@ enum regulator_status {
  * @set_voltage: Set the voltage for the regulator within the range specified.
  *               The driver should select the voltage closest to min_uV.
  * @get_voltage: Return the currently configured voltage for the regulator.
+ * @list_voltage: Return one of the supported voltages, in microvolts; zero
+ *	if the selector indicates a voltage that is unusable on this system;
+ *	or negative errno.  Selectors range from zero to one less than
+ *	regulator_desc.n_voltages.  Voltages may be reported in any order.
  * @set_current_limit: Configure a limit for a current-limited regulator.
  * @get_current_limit: Get the configured limit for a current-limited regulator.
  * @set_mode: Set the operating mode for the regulator.
@@ -62,6 +66,9 @@ enum regulator_status {
  */
 struct regulator_ops {
 
+	/* enumerate supported voltages */
+	int (*list_voltage) (struct regulator_dev *, unsigned selector);
+
 	/* get/set regulator voltage */
 	int (*set_voltage) (struct regulator_dev *, int min_uV, int max_uV);
 	int (*get_voltage) (struct regulator_dev *);
@@ -121,6 +128,7 @@ enum regulator_type {
  *
  * @name: Identifying name for the regulator.
  * @id: Numerical identifier for the regulator.
+ * @n_voltages: Number of selectors available for ops.list_voltage().
  * @ops: Regulator operations table.
  * @irq: Interrupt number for the regulator.
  * @type: Indicates if the regulator is a voltage or current regulator.
@@ -129,6 +137,7 @@ enum regulator_type {
 struct regulator_desc {
 	const char *name;
 	int id;
+	unsigned n_voltages;
 	struct regulator_ops *ops;
 	int irq;
 	enum regulator_type type;
