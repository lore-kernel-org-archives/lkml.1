Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbZBWVAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbZBWVAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 16:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbZBWVAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 16:00:17 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:32323 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751572AbZBWVAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 16:00:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=OQFWKbdlWpt5oh7UhVg7BxGGWva7XhojwL7exYkf1kRxM88GdHoGY24lWLtIEraFJ5btLQ4TM+zg4S7D9lvAuw+WM8rjFNhnlEArw70GVb/yjChZ5rb2az5Sfh7SfAdmT/gTpmPovo0b5IOsXXnDGMz8e8SiXMfZVlsoCfsxc3I=  ;
X-YMail-OSG: fk6ZM58VM1n_ndPQY7NppDZhpoy49AQd4Ljmo3byJ5fHr4U2_BDxp.8PE2x7D7Q_rSWogn.y6AyenhCMQxCQXYynCu08kdEX_qmJBm1hA8IAYk7s4te4K4ShEiB2IV2W4AaVIxQu76FywgfKsoSZqsvyUqgKddBGu0G.yl.Hfw9ndJrbMN53m2Y6uk0YDqY4CA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [patch/rfc 2.6.29-rc6 1/2] regulator: enumerate voltages
Date: Mon, 23 Feb 2009 12:52:01 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>, OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <20090210224851.GA6408@sirena.org.uk> <200902231245.44360.david-b@pacbell.net>
In-Reply-To: <200902231245.44360.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902231252.01980.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Add a basic mechanism for regulators to report the discrete
voltages they support:  one method to count how many voltages
are available, and another to enumerate them.

Use those methods to force machine-level constraints into bounds.
(Example:  regulator supports 1.8V, 2.4V, 2.6V, 3.3V, and board
constraints for that rail are 2.0V to 3.6V ... so the range of
voltages is then 2.4V to 3.3V on this board.)

Export those voltages to the regulator consumer interface, so for
example regulator hooked up to an MMC/SD/SDIO slot can report the
actual voltage options available to cards connected there.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
I'm not particularly pleased with these names; suggestions?
This could also be done with one fewer method by designating a
special list_voltage() return value, but I like this better.

 drivers/regulator/core.c           |  107 +++++++++++++++++++++++++++++++++++
 include/linux/regulator/consumer.h |    2 
 include/linux/regulator/driver.h   |   10 +++
 3 files changed, 119 insertions(+)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -719,6 +719,44 @@ static int set_machine_constraints(struc
 	else
 		name = "regulator";
 
+	/* maybe force machine-wide voltage constraints to match the
+	 * voltages supported by this regulator.  use the regulator's
+	 * entire range for boards with no particular constraints.
+	 */
+	if (ops->list_voltage) {
+		int	count = ops->count_voltages(rdev);
+		int	i;
+		int	min_uV = INT_MAX;
+		int	max_uV = INT_MIN;
+		int	cmin = constraints->min_uV ? : INT_MIN;
+		int	cmax = constraints->max_uV ? : INT_MAX;
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
+			pr_err("%s: bad '%s' voltage constraints\n",
+				       __func__, name);
+			ret = -EINVAL;
+			goto out;
+		}
+		constraints->min_uV = min_uV;
+		constraints->max_uV = max_uV;
+	}
+
 	rdev->constraints = constraints;
 
 	/* do we need to apply the constraint voltage */
@@ -1245,6 +1283,75 @@ int regulator_is_enabled(struct regulato
 EXPORT_SYMBOL_GPL(regulator_is_enabled);
 
 /**
+ * regulator_count_voltages - count regulator_list_voltage() indices
+ * @regulator: regulator source
+ *
+ * Returns number of indices, or negative errno.
+ */
+int regulator_count_voltages(struct regulator *regulator)
+{
+	struct regulator_dev	*rdev = regulator->rdev;
+	struct regulator_ops	*ops;
+	int			ret = -EINVAL;
+
+	mutex_lock(&rdev->mutex);
+
+	ops = rdev->desc->ops;
+	if (ops->count_voltages)
+		ret = ops->count_voltages(rdev);
+
+	mutex_unlock(&rdev->mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regulator_count_voltages);
+
+/**
+ * regulator_list_voltage - enumerate supported voltages
+ * @regulator: regulator source
+ * @index: identify voltage to list
+ *
+ * Returns a voltage that can be passed to @regulator_set_voltage(),
+ * or negative fault code.
+ *
+ * Faults include passing in invalid index, and using an index
+ * corresponding to a voltage that can't be used on this system.
+ */
+int regulator_list_voltage(struct regulator *regulator, unsigned index)
+{
+	struct regulator_dev	*rdev = regulator->rdev;
+	struct regulator_ops	*ops;
+	int			ret = -EINVAL;
+
+	mutex_lock(&rdev->mutex);
+
+	ops = rdev->desc->ops;
+	if (ops->count_voltages && ops->list_voltage)
+		ret = ops->count_voltages(rdev);
+
+	if (ret == 0)
+		ret = -EIO;
+	else if (ret > 0) {
+		if (index >= ret)
+			ret = -EDOM;
+		else
+			ret = ops->list_voltage(rdev, index);
+	}
+
+	if (ret >= 0) {
+		if (ret < rdev->constraints->min_uV)
+			ret = -ERANGE;
+		else if (ret > rdev->constraints->max_uV)
+			ret = -ERANGE;
+	}
+
+	mutex_unlock(&rdev->mutex);
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
+int regulator_list_voltage(struct regulator *regulator, unsigned index);
 int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV);
 int regulator_get_voltage(struct regulator *regulator);
 int regulator_set_current_limit(struct regulator *regulator,
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -40,6 +40,12 @@ enum regulator_status {
  * @set_voltage: Set the voltage for the regulator within the range specified.
  *               The driver should select the voltage closest to min_uV.
  * @get_voltage: Return the currently configured voltage for the regulator.
+ * @count_voltages: Return the number of supported voltage indices which
+ *	may be passed to @list_voltage().  Some indices may correspond to
+ *	voltages that are not usable on this system.
+ * @list_voltage: Return one of the supported voltages, in microvolts;
+ *	or negative errno.  Indices range from zero to one less than
+ *	@count_voltages().  Voltages may be reported in any order.
  * @set_current_limit: Configure a limit for a current-limited regulator.
  * @get_current_limit: Get the configured limit for a current-limited regulator.
  * @set_mode: Set the operating mode for the regulator.
@@ -62,6 +68,10 @@ enum regulator_status {
  */
 struct regulator_ops {
 
+	/* enumerate supported voltages */
+	int (*count_voltages) (struct regulator_dev *);
+	int (*list_voltage) (struct regulator_dev *, unsigned index);
+
 	/* get/set regulator voltage */
 	int (*set_voltage) (struct regulator_dev *, int min_uV, int max_uV);
 	int (*get_voltage) (struct regulator_dev *);
