Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbYISRjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbYISRjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 13:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYISRjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 13:39:23 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:45759 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbYISRjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 13:39:21 -0400
Subject: [PATCH 1/6] regulator: core - Rework machine API to remove string
	based functions.
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       eric miao <eric.y.miao@gmail.com>, David Brownell <david-b@pacbell.net>
Content-Type: text/plain
Date: Fri, 19 Sep 2008 18:39:16 +0100
Message-Id: <1221845956.6892.134.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves the machine level API in order to configure
regulator constraints and consumers as platform data. It removes the
old string based API that required several calls to set up each regulator.

The intention is to create a struct regulator_init_data, populate
it's fields with constraints, consumers devices, etc and then register
the regulator device from board.c in the standard Linux way.

e.g. regulator LDO2 (supplying codec and sim) platform data.

/* regulator LDO2 consumer devices */
static struct regulator_consumer_supply ldo2_consumers[] = {
{
	.dev	= &platform_audio_device.dev,
	.supply	= "codec_avdd",
},
{
	.dev	= &platform_sim_device.dev,
	.supply	= "sim_vcc",
}
};

/* regulator LDO2 constraints  */
static struct regulator_init_data ldo2_data = {
	.constraints = {
		.min_uV = 3300000,
		.max_uV = 3300000,
		.valid_modes_mask = REGULATOR_MODE_NORMAL,
		.apply_uV = 1,
	},
	.num_consumer_supplies = ARRAY_SIZE(ldo2_consumers),
	.consumer_supplies = ldo2_consumers,
};

/* machine regulator devices with thier consumers and constraints */
static struct platform_device wm8350_regulator_devices[] = {
{
	.name = "wm8350-regulator",
	.id = WM8350_LDO_2,
	.dev = {
		.platform_data = &ldo2_data,
	},
},
};

Changes in detail:-

  o Removed all const char* regulator config functions in machine API.
  o Created new struct regulator_init_data to contain regulator
    machine configuration constraints and consmuers.
  o Changed set_supply(), set_machine_constraints(),
    set_consumer_device_supply() to remove their string identifier
    parameters. Also made them static and moved functions nearer top of
    core.c.
  o Removed no longer used inline func to_rdev()
  o Added regulator_get_init_drvdata() to retrieve init data.
  o Added struct device* as parameter to regulator_register().
  o Changed my email address.

Signed-off-by: Eric Miao <eric.miao@marvell.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>
---
 Documentation/power/regulator/machine.txt   |  140 ++++-----
 Documentation/power/regulator/regulator.txt |    8 +-
 drivers/regulator/core.c                    |  453 +++++++++++++--------------
 include/linux/regulator/driver.h            |    9 +-
 include/linux/regulator/machine.h           |   30 ++-
 5 files changed, 320 insertions(+), 320 deletions(-)

diff --git a/Documentation/power/regulator/machine.txt b/Documentation/power/regulator/machine.txt
index c9a3566..ce3487d 100644
--- a/Documentation/power/regulator/machine.txt
+++ b/Documentation/power/regulator/machine.txt
@@ -2,17 +2,8 @@ Regulator Machine Driver Interface
 ===================================
 
 The regulator machine driver interface is intended for board/machine specific
-initialisation code to configure the regulator subsystem. Typical things that
-machine drivers would do are :-
+initialisation code to configure the regulator subsystem.
 
- 1. Regulator -> Device mapping.
- 2. Regulator supply configuration.
- 3. Power Domain constraint setting.
-
-
-
-1. Regulator -> device mapping
-==============================
 Consider the following machine :-
 
   Regulator-1 -+-> Regulator-2 --> [Consumer A @ 1.8 - 2.0V]
@@ -21,81 +12,82 @@ Consider the following machine :-
 
 The drivers for consumers A & B must be mapped to the correct regulator in
 order to control their power supply. This mapping can be achieved in machine
-initialisation code by calling :-
+initialisation code by creating a struct regulator_consumer_supply for
+each regulator.
+
+struct regulator_consumer_supply {
+	struct device *dev;	/* consumer */
+	const char *supply;	/* consumer supply - e.g. "vcc" */
+};
 
-int regulator_set_device_supply(const char *regulator, struct device *dev,
-				const char *supply);
+e.g. for the machine above
 
-and is shown with the following code :-
+static struct regulator_consumer_supply regulator1_consumers[] = {
+{
+	.dev	= &platform_consumerB_device.dev,
+	.supply	= "Vcc",
+},};
 
-regulator_set_device_supply("Regulator-1", devB, "Vcc");
-regulator_set_device_supply("Regulator-2", devA, "Vcc");
+static struct regulator_consumer_supply regulator2_consumers[] = {
+{
+	.dev	= &platform_consumerA_device.dev,
+	.supply	= "Vcc",
+},};
 
 This maps Regulator-1 to the 'Vcc' supply for Consumer B and maps Regulator-2
 to the 'Vcc' supply for Consumer A.
 
-
-2. Regulator supply configuration.
-==================================
-Consider the following machine (again) :-
-
-  Regulator-1 -+-> Regulator-2 --> [Consumer A @ 1.8 - 2.0V]
-               |
-               +-> [Consumer B @ 3.3V]
+Constraints can now be registered by defining a struct regulator_init_data
+for each regulator power domain. This structure also maps the consumers
+to their supply regulator :-
+
+static struct regulator_init_data regulator1_data = {
+	.constraints = {
+		.min_uV = 3300000,
+		.max_uV = 3300000,
+		.valid_modes_mask = REGULATOR_MODE_NORMAL,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(regulator1_consumers),
+	.consumer_supplies = regulator1_consumers,
+};
 
 Regulator-1 supplies power to Regulator-2. This relationship must be registered
 with the core so that Regulator-1 is also enabled when Consumer A enables it's
-supply (Regulator-2).
-
-This relationship can be register with the core via :-
-
-int regulator_set_supply(const char *regulator, const char *regulator_supply);
-
-In this example we would use the following code :-
-
-regulator_set_supply("Regulator-2", "Regulator-1");
-
-Relationships can be queried by calling :-
-
-const char *regulator_get_supply(const char *regulator);
-
-
-3. Power Domain constraint setting.
-===================================
-Each power domain within a system has physical constraints on voltage and
-current. This must be defined in software so that the power domain is always
-operated within specifications.
-
-Consider the following machine (again) :-
-
-  Regulator-1 -+-> Regulator-2 --> [Consumer A @ 1.8 - 2.0V]
-               |
-               +-> [Consumer B @ 3.3V]
-
-This gives us two regulators and two power domains:
-
-                   Domain 1: Regulator-2, Consumer B.
-                   Domain 2: Consumer A.
-
-Constraints can be registered by calling :-
-
-int regulator_set_platform_constraints(const char *regulator,
-	struct regulation_constraints *constraints);
-
-The example is defined as follows :-
-
-struct regulation_constraints domain_1 = {
-	.min_uV = 3300000,
-	.max_uV = 3300000,
-	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+supply (Regulator-2). The supply regulator is set by the supply_regulator_dev
+field below:-
+
+static struct regulator_init_data regulator2_data = {
+	.supply_regulator_dev = &platform_regulator1_device.dev,
+	.constraints = {
+		.min_uV = 1800000,
+		.max_uV = 2000000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
+		.valid_modes_mask = REGULATOR_MODE_NORMAL,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(regulator2_consumers),
+	.consumer_supplies = regulator2_consumers,
 };
 
-struct regulation_constraints domain_2 = {
-	.min_uV = 1800000,
-	.max_uV = 2000000,
-	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
-	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+Finally the regulator devices must be registered in the usual manner.
+
+static struct platform_device regulator_devices[] = {
+{
+	.name = "regulator",
+	.id = DCDC_1,
+	.dev = {
+		.platform_data = &regulator1_data,
+	},
+},
+{
+	.name = "regulator",
+	.id = DCDC_2,
+	.dev = {
+		.platform_data = &regulator2_data,
+	},
+},
 };
+/* register regulator 1 device */
+platform_device_register(&wm8350_regulator_devices[0]);
 
-regulator_set_platform_constraints("Regulator-1", &domain_1);
-regulator_set_platform_constraints("Regulator-2", &domain_2);
+/* register regulator 2 device */
+platform_device_register(&wm8350_regulator_devices[1]);
diff --git a/Documentation/power/regulator/regulator.txt b/Documentation/power/regulator/regulator.txt
index a690501..4200acc 100644
--- a/Documentation/power/regulator/regulator.txt
+++ b/Documentation/power/regulator/regulator.txt
@@ -10,11 +10,11 @@ Registration
 
 Drivers can register a regulator by calling :-
 
-struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
-					  void *reg_data);
+struct regulator_dev *regulator_register(struct device *dev,
+	struct regulator_desc *regulator_desc);
 
-This will register the regulators capabilities and operations the regulator
-core. The core does not touch reg_data (private to regulator driver).
+This will register the regulators capabilities and operations to the regulator
+core.
 
 Regulators can be unregistered by calling :-
 
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 9c79862..cec9c73 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2,8 +2,9 @@
  * core.c  --  Voltage/Current Regulator framework.
  *
  * Copyright 2007, 2008 Wolfson Microelectronics PLC.
+ * Copyright 2008 SlimLogic Ltd.
  *
- * Author: Liam Girdwood <liam.girdwood@wolfsonmicro.com>
+ * Author: Liam Girdwood <lrg@slimlogic.co.uk>
  *
  *  This program is free software; you can redistribute  it and/or modify it
  *  under  the terms of  the GNU General  Public License as published by the
@@ -64,14 +65,9 @@ struct regulator_map {
 	struct list_head list;
 	struct device *dev;
 	const char *supply;
-	const char *regulator;
+	struct regulator_dev *regulator;
 };
 
-static inline struct regulator_dev *to_rdev(struct device *d)
-{
-	return container_of(d, struct regulator_dev, dev);
-}
-
 /*
  * struct regulator
  *
@@ -227,7 +223,7 @@ static ssize_t device_requested_uA_show(struct device *dev,
 static ssize_t regulator_uV_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	struct regulator_dev *rdev = to_rdev(dev);
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
 	ssize_t ret;
 
 	mutex_lock(&rdev->mutex);
@@ -240,7 +236,7 @@ static ssize_t regulator_uV_show(struct device *dev,
 static ssize_t regulator_uA_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	struct regulator_dev *rdev = to_rdev(dev);
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%d\n", _regulator_get_current_limit(rdev));
 }
@@ -248,7 +244,7 @@ static ssize_t regulator_uA_show(struct device *dev,
 static ssize_t regulator_opmode_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
-	struct regulator_dev *rdev = to_rdev(dev);
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
 	int mode = _regulator_get_mode(rdev);
 
 	switch (mode) {
@@ -267,7 +263,7 @@ static ssize_t regulator_opmode_show(struct device *dev,
 static ssize_t regulator_state_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
-	struct regulator_dev *rdev = to_rdev(dev);
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
 	int state = _regulator_is_enabled(rdev);
 
 	if (state > 0)
@@ -281,7 +277,7 @@ static ssize_t regulator_state_show(struct device *dev,
 static ssize_t regulator_min_uA_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
-	struct regulator_dev *rdev = to_rdev(dev);
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
 	if (!rdev->constraints)
 		return sprintf(buf, "constraint not defined\n");
@@ -292,7 +288,7 @@ static ssize_t regulator_min_uA_show(struct device *dev,
 static ssize_t regulator_max_uA_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
-	struct regulator_dev *rdev = to_rdev(dev);
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
 	if (!rdev->constraints)
 		return sprintf(buf, "constraint not defined\n");
@@ -303,7 +299,7 @@ static ssize_t regulator_max_uA_show(struct device *dev,
 static ssize_t regulator_min_uV_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
-	struct regulator_dev *rdev = to_rdev(dev);
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
 	if (!rdev->constraints)
 		return sprintf(buf, "constraint not defined\n");
@@ -314,7 +310,7 @@ static ssize_t regulator_min_uV_show(struct device *dev,
 static ssize_t regulator_max_uV_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
-	struct regulator_dev *rdev = to_rdev(dev);
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
 	if (!rdev->constraints)
 		return sprintf(buf, "constraint not defined\n");
@@ -325,7 +321,7 @@ static ssize_t regulator_max_uV_show(struct device *dev,
 static ssize_t regulator_total_uA_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
-	struct regulator_dev *rdev = to_rdev(dev);
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
 	struct regulator *regulator;
 	int uA = 0;
 
@@ -339,14 +335,14 @@ static ssize_t regulator_total_uA_show(struct device *dev,
 static ssize_t regulator_num_users_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
-	struct regulator_dev *rdev = to_rdev(dev);
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
 	return sprintf(buf, "%d\n", rdev->use_count);
 }
 
 static ssize_t regulator_type_show(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
-	struct regulator_dev *rdev = to_rdev(dev);
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
 	switch (rdev->desc->type) {
 	case REGULATOR_VOLTAGE:
@@ -360,7 +356,7 @@ static ssize_t regulator_type_show(struct device *dev,
 static ssize_t regulator_suspend_mem_uV_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	struct regulator_dev *rdev = to_rdev(dev);
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
 	if (!rdev->constraints)
 		return sprintf(buf, "not defined\n");
@@ -370,7 +366,7 @@ static ssize_t regulator_suspend_mem_uV_show(struct device *dev,
 static ssize_t regulator_suspend_disk_uV_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	struct regulator_dev *rdev = to_rdev(dev);
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
 	if (!rdev->constraints)
 		return sprintf(buf, "not defined\n");
@@ -380,7 +376,7 @@ static ssize_t regulator_suspend_disk_uV_show(struct device *dev,
 static ssize_t regulator_suspend_standby_uV_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	struct regulator_dev *rdev = to_rdev(dev);
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
 	if (!rdev->constraints)
 		return sprintf(buf, "not defined\n");
@@ -406,7 +402,7 @@ static ssize_t suspend_opmode_show(struct regulator_dev *rdev,
 static ssize_t regulator_suspend_mem_mode_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	struct regulator_dev *rdev = to_rdev(dev);
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
 	if (!rdev->constraints)
 		return sprintf(buf, "not defined\n");
@@ -417,7 +413,7 @@ static ssize_t regulator_suspend_mem_mode_show(struct device *dev,
 static ssize_t regulator_suspend_disk_mode_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	struct regulator_dev *rdev = to_rdev(dev);
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
 	if (!rdev->constraints)
 		return sprintf(buf, "not defined\n");
@@ -428,7 +424,7 @@ static ssize_t regulator_suspend_disk_mode_show(struct device *dev,
 static ssize_t regulator_suspend_standby_mode_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	struct regulator_dev *rdev = to_rdev(dev);
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
 	if (!rdev->constraints)
 		return sprintf(buf, "not defined\n");
@@ -439,7 +435,7 @@ static ssize_t regulator_suspend_standby_mode_show(struct device *dev,
 static ssize_t regulator_suspend_mem_state_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
-	struct regulator_dev *rdev = to_rdev(dev);
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
 	if (!rdev->constraints)
 		return sprintf(buf, "not defined\n");
@@ -453,7 +449,7 @@ static ssize_t regulator_suspend_mem_state_show(struct device *dev,
 static ssize_t regulator_suspend_disk_state_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
-	struct regulator_dev *rdev = to_rdev(dev);
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
 	if (!rdev->constraints)
 		return sprintf(buf, "not defined\n");
@@ -467,7 +463,7 @@ static ssize_t regulator_suspend_disk_state_show(struct device *dev,
 static ssize_t regulator_suspend_standby_state_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
-	struct regulator_dev *rdev = to_rdev(dev);
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
 	if (!rdev->constraints)
 		return sprintf(buf, "not defined\n");
@@ -512,7 +508,7 @@ static struct device_attribute regulator_dev_attrs[] = {
 
 static void regulator_dev_release(struct device *dev)
 {
-	struct regulator_dev *rdev = to_rdev(dev);
+	struct regulator_dev *rdev = dev_get_drvdata(dev);
 	kfree(rdev);
 }
 
@@ -569,8 +565,11 @@ static int suspend_set_state(struct regulator_dev *rdev,
 
 	/* enable & disable are mandatory for suspend control */
 	if (!rdev->desc->ops->set_suspend_enable ||
-		!rdev->desc->ops->set_suspend_disable)
+		!rdev->desc->ops->set_suspend_disable) {
+		printk(KERN_ERR "%s: no way to set suspend state\n",
+			__func__);
 		return -EINVAL;
+	}
 
 	if (rstate->enabled)
 		ret = rdev->desc->ops->set_suspend_enable(rdev);
@@ -656,6 +655,125 @@ static void print_constraints(struct regulator_dev *rdev)
 	printk(KERN_INFO "regulator: %s: %s\n", rdev->desc->name, buf);
 }
 
+/**
+ * set_machine_constraints - sets regulator constraints
+ * @regulator: regulator source
+ *
+ * Allows platform initialisation code to define and constrain
+ * regulator circuits e.g. valid voltage/current ranges, etc.  NOTE:
+ * Constraints *must* be set by platform code in order for some
+ * regulator operations to proceed i.e. set_voltage, set_current_limit,
+ * set_mode.
+ */
+static int set_machine_constraints(struct regulator_dev *rdev,
+	struct regulation_constraints *constraints)
+{
+	int ret = 0;
+
+	rdev->constraints = constraints;
+
+	/* do we need to apply the constraint voltage */
+	if (rdev->constraints->apply_uV &&
+		rdev->constraints->min_uV == rdev->constraints->max_uV &&
+		rdev->desc->ops->set_voltage) {
+		ret = rdev->desc->ops->set_voltage(rdev,
+			rdev->constraints->min_uV, rdev->constraints->max_uV);
+			if (ret < 0) {
+				printk(KERN_ERR "%s: failed to apply %duV"
+					" constraint\n", __func__,
+					rdev->constraints->min_uV);
+				rdev->constraints = NULL;
+				goto out;
+			}
+	}
+
+	/* are we enabled at boot time by firmware / bootloader */
+	if (rdev->constraints->boot_on)
+		rdev->use_count = 1;
+
+	/* do we need to setup our suspend state */
+	if (constraints->initial_state)
+		ret = suspend_prepare(rdev, constraints->initial_state);
+
+	print_constraints(rdev);
+out:
+	return ret;
+}
+
+/**
+ * set_supply - set regulator supply regulator
+ * @regulator: regulator name
+ * @supply: supply regulator name
+ *
+ * Called by platform initialisation code to set the supply regulator for this
+ * regulator. This ensures that a regulators supply will also be enabled by the
+ * core if it's child is enabled.
+ */
+static int set_supply(struct regulator_dev *rdev,
+	struct regulator_dev *supply_rdev)
+{
+	int err;
+
+	err = sysfs_create_link(&rdev->dev.kobj, &supply_rdev->dev.kobj,
+				"supply");
+	if (err) {
+		printk(KERN_ERR
+		       "%s: could not add device link %s err %d\n",
+		       __func__, supply_rdev->dev.kobj.name, err);
+		       goto out;
+	}
+	rdev->supply = supply_rdev;
+	list_add(&rdev->slist, &supply_rdev->supply_list);
+out:
+	return err;
+}
+
+/**
+ * set_consumer_device_supply: Bind a regulator to a symbolic supply
+ * @regulator: regulator source
+ * @dev:       device the supply applies to
+ * @supply:    symbolic name for supply
+ *
+ * Allows platform initialisation code to map physical regulator
+ * sources to symbolic names for supplies for use by devices.  Devices
+ * should use these symbolic names to request regulators, avoiding the
+ * need to provide board-specific regulator names as platform data.
+ */
+static int set_consumer_device_supply(struct regulator_dev *rdev,
+	struct device *consumer_dev, const char *supply)
+{
+	struct regulator_map *node;
+
+	if (supply == NULL)
+		return -EINVAL;
+
+	node = kmalloc(sizeof(struct regulator_map), GFP_KERNEL);
+	if (node == NULL)
+		return -ENOMEM;
+
+	node->regulator = rdev;
+	node->dev = consumer_dev;
+	node->supply = supply;
+
+	list_add(&node->list, &regulator_map_list);
+	return 0;
+}
+
+static void unset_consumer_device_supply(struct regulator_dev *rdev,
+	struct device *consumer_dev)
+{
+	struct regulator_map *node, *n;
+
+	list_for_each_entry_safe(node, n, &regulator_map_list, list) {
+		if (rdev == node->regulator &&
+			consumer_dev == node->dev) {
+			list_del(&node->list);
+			kfree(node);
+			return;
+		}
+	}
+}
+
 #define REG_STR_SIZE	32
 
 static struct regulator *create_regulator(struct regulator_dev *rdev,
@@ -746,7 +864,6 @@ struct regulator *regulator_get(struct device *dev, const char *id)
 	struct regulator_dev *rdev;
 	struct regulator_map *map;
 	struct regulator *regulator = ERR_PTR(-ENODEV);
-	const char *supply = id;
 
 	if (id == NULL) {
 		printk(KERN_ERR "regulator: get() with no identifier\n");
@@ -758,15 +875,9 @@ struct regulator *regulator_get(struct device *dev, const char *id)
 	list_for_each_entry(map, &regulator_map_list, list) {
 		if (dev == map->dev &&
 		    strcmp(map->supply, id) == 0) {
-			supply = map->regulator;
-			break;
-		}
-	}
-
-	list_for_each_entry(rdev, &regulator_list, list) {
-		if (strcmp(supply, rdev->desc->name) == 0 &&
-		    try_module_get(rdev->owner))
+			rdev = map->regulator;
 			goto found;
+		}
 	}
 	printk(KERN_ERR "regulator: Unable to get requested regulator: %s\n",
 	       id);
@@ -774,12 +885,16 @@ struct regulator *regulator_get(struct device *dev, const char *id)
 	return regulator;
 
 found:
+	if (!try_module_get(rdev->owner))
+		goto out;
+
 	regulator = create_regulator(rdev, dev, id);
 	if (regulator == NULL) {
 		regulator = ERR_PTR(-ENOMEM);
 		module_put(rdev->owner);
 	}
 
+out:
 	mutex_unlock(&regulator_list_mutex);
 	return regulator;
 }
@@ -1558,12 +1673,13 @@ EXPORT_SYMBOL_GPL(regulator_notifier_call_chain);
  * Called by regulator drivers to register a regulator.
  * Returns 0 on success.
  */
-struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
-					  void *reg_data)
+struct regulator_dev *regulator_register(struct device *dev,
+	struct regulator_desc *regulator_desc)
 {
 	static atomic_t regulator_no = ATOMIC_INIT(0);
 	struct regulator_dev *rdev;
-	int ret;
+	struct regulator_init_data *init_data = dev->platform_data;
+	int ret, i;
 
 	if (regulator_desc == NULL)
 		return ERR_PTR(-EINVAL);
@@ -1582,7 +1698,7 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 	mutex_lock(&regulator_list_mutex);
 
 	mutex_init(&rdev->mutex);
-	rdev->reg_data = reg_data;
+	rdev->reg_data = dev_get_drvdata(dev);
 	rdev->owner = regulator_desc->owner;
 	rdev->desc = regulator_desc;
 	INIT_LIST_HEAD(&rdev->consumer_list);
@@ -1591,20 +1707,68 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 	INIT_LIST_HEAD(&rdev->slist);
 	BLOCKING_INIT_NOTIFIER_HEAD(&rdev->notifier);
 
+	/* preform any regulator specific init */
+	if (init_data->regulator_init) {
+		ret = init_data->regulator_init(rdev->reg_data);
+		if (ret < 0) {
+			kfree(rdev);
+			rdev = ERR_PTR(ret);
+			goto out;
+		}
+	}
+
+	/* set regulator constraints */
+	ret = set_machine_constraints(rdev, &init_data->constraints);
+	if (ret < 0) {
+		kfree(rdev);
+		rdev = ERR_PTR(ret);
+		goto out;
+	}
+
+	/* register with sysfs */
 	rdev->dev.class = &regulator_class;
-	device_initialize(&rdev->dev);
+	rdev->dev.parent = dev;
 	snprintf(rdev->dev.bus_id, sizeof(rdev->dev.bus_id),
-		 "regulator_%ld_%s",
-		 (unsigned long)atomic_inc_return(&regulator_no) - 1,
-		 regulator_desc->name);
-
-	ret = device_add(&rdev->dev);
-	if (ret == 0)
-		list_add(&rdev->list, &regulator_list);
-	else {
+		 "regulator.%d", atomic_inc_return(&regulator_no) - 1);
+	ret = device_register(&rdev->dev);
+	if (ret != 0) {
 		kfree(rdev);
 		rdev = ERR_PTR(ret);
+		goto out;
+	}
+
+	dev_set_drvdata(&rdev->dev, rdev);
+
+	/* set supply regulator if it exists */
+	if (init_data->supply_regulator_dev) {
+		ret = set_supply(rdev,
+			dev_get_drvdata(init_data->supply_regulator_dev));
+		if (ret < 0) {
+			device_unregister(&rdev->dev);
+			kfree(rdev);
+			rdev = ERR_PTR(ret);
+			goto out;
+		}
+	}
+
+	/* add consumers devices */
+	for (i = 0; i < init_data->num_consumer_supplies; i++) {
+		ret = set_consumer_device_supply(rdev,
+			init_data->consumer_supplies[i].dev,
+			init_data->consumer_supplies[i].supply);
+		if (ret < 0) {
+			for (--i; i >= 0; i--)
+				unset_consumer_device_supply(rdev,
+					init_data->consumer_supplies[i].dev);
+			device_unregister(&rdev->dev);
+			kfree(rdev);
+			rdev = ERR_PTR(ret);
+			goto out;
+		}
 	}
+
+	list_add(&rdev->list, &regulator_list);
+out:
 	mutex_unlock(&regulator_list_mutex);
 	return rdev;
 }
@@ -1631,187 +1795,6 @@ void regulator_unregister(struct regulator_dev *rdev)
 EXPORT_SYMBOL_GPL(regulator_unregister);
 
 /**
- * regulator_set_supply - set regulator supply regulator
- * @regulator: regulator name
- * @supply: supply regulator name
- *
- * Called by platform initialisation code to set the supply regulator for this
- * regulator. This ensures that a regulators supply will also be enabled by the
- * core if it's child is enabled.
- */
-int regulator_set_supply(const char *regulator, const char *supply)
-{
-	struct regulator_dev *rdev, *supply_rdev;
-	int err;
-
-	if (regulator == NULL || supply == NULL)
-		return -EINVAL;
-
-	mutex_lock(&regulator_list_mutex);
-
-	list_for_each_entry(rdev, &regulator_list, list) {
-		if (!strcmp(rdev->desc->name, regulator))
-			goto found_regulator;
-	}
-	mutex_unlock(&regulator_list_mutex);
-	return -ENODEV;
-
-found_regulator:
-	list_for_each_entry(supply_rdev, &regulator_list, list) {
-		if (!strcmp(supply_rdev->desc->name, supply))
-			goto found_supply;
-	}
-	mutex_unlock(&regulator_list_mutex);
-	return -ENODEV;
-
-found_supply:
-	err = sysfs_create_link(&rdev->dev.kobj, &supply_rdev->dev.kobj,
-				"supply");
-	if (err) {
-		printk(KERN_ERR
-		       "%s: could not add device link %s err %d\n",
-		       __func__, supply_rdev->dev.kobj.name, err);
-		       goto out;
-	}
-	rdev->supply = supply_rdev;
-	list_add(&rdev->slist, &supply_rdev->supply_list);
-out:
-	mutex_unlock(&regulator_list_mutex);
-	return err;
-}
-EXPORT_SYMBOL_GPL(regulator_set_supply);
-
-/**
- * regulator_get_supply - get regulator supply regulator
- * @regulator: regulator name
- *
- * Returns the supply supply regulator name or NULL if no supply regulator
- * exists (i.e the regulator is supplied directly from USB, Line, Battery, etc)
- */
-const char *regulator_get_supply(const char *regulator)
-{
-	struct regulator_dev *rdev;
-
-	if (regulator == NULL)
-		return NULL;
-
-	mutex_lock(&regulator_list_mutex);
-	list_for_each_entry(rdev, &regulator_list, list) {
-		if (!strcmp(rdev->desc->name, regulator))
-			goto found;
-	}
-	mutex_unlock(&regulator_list_mutex);
-	return NULL;
-
-found:
-	mutex_unlock(&regulator_list_mutex);
-	if (rdev->supply)
-		return rdev->supply->desc->name;
-	else
-		return NULL;
-}
-EXPORT_SYMBOL_GPL(regulator_get_supply);
-
-/**
- * regulator_set_machine_constraints - sets regulator constraints
- * @regulator: regulator source
- *
- * Allows platform initialisation code to define and constrain
- * regulator circuits e.g. valid voltage/current ranges, etc.  NOTE:
- * Constraints *must* be set by platform code in order for some
- * regulator operations to proceed i.e. set_voltage, set_current_limit,
- * set_mode.
- */
-int regulator_set_machine_constraints(const char *regulator_name,
-	struct regulation_constraints *constraints)
-{
-	struct regulator_dev *rdev;
-	int ret = 0;
-
-	if (regulator_name == NULL)
-		return -EINVAL;
-
-	mutex_lock(&regulator_list_mutex);
-
-	list_for_each_entry(rdev, &regulator_list, list) {
-		if (!strcmp(regulator_name, rdev->desc->name))
-			goto found;
-	}
-	ret = -ENODEV;
-	goto out;
-
-found:
-	mutex_lock(&rdev->mutex);
-	rdev->constraints = constraints;
-
-	/* do we need to apply the constraint voltage */
-	if (rdev->constraints->apply_uV &&
-		rdev->constraints->min_uV == rdev->constraints->max_uV &&
-		rdev->desc->ops->set_voltage) {
-		ret = rdev->desc->ops->set_voltage(rdev,
-			rdev->constraints->min_uV, rdev->constraints->max_uV);
-			if (ret < 0) {
-				printk(KERN_ERR "%s: failed to apply %duV"
-					" constraint\n", __func__,
-					rdev->constraints->min_uV);
-				rdev->constraints = NULL;
-				goto out;
-			}
-	}
-
-	/* are we enabled at boot time by firmware / bootloader */
-	if (rdev->constraints->boot_on)
-		rdev->use_count = 1;
-
-	/* do we need to setup our suspend state */
-	if (constraints->initial_state)
-		ret = suspend_prepare(rdev, constraints->initial_state);
-
-	print_constraints(rdev);
-	mutex_unlock(&rdev->mutex);
-
-out:
-	mutex_unlock(&regulator_list_mutex);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(regulator_set_machine_constraints);
-
-
-/**
- * regulator_set_device_supply: Bind a regulator to a symbolic supply
- * @regulator: regulator source
- * @dev:       device the supply applies to
- * @supply:    symbolic name for supply
- *
- * Allows platform initialisation code to map physical regulator
- * sources to symbolic names for supplies for use by devices.  Devices
- * should use these symbolic names to request regulators, avoiding the
- * need to provide board-specific regulator names as platform data.
- */
-int regulator_set_device_supply(const char *regulator, struct device *dev,
-				const char *supply)
-{
-	struct regulator_map *node;
-
-	if (regulator == NULL || supply == NULL)
-		return -EINVAL;
-
-	node = kmalloc(sizeof(struct regulator_map), GFP_KERNEL);
-	if (node == NULL)
-		return -ENOMEM;
-
-	node->regulator = regulator;
-	node->dev = dev;
-	node->supply = supply;
-
-	mutex_lock(&regulator_list_mutex);
-	list_add(&node->list, &regulator_map_list);
-	mutex_unlock(&regulator_list_mutex);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(regulator_set_device_supply);
-
-/**
  * regulator_suspend_prepare: prepare regulators for system wide suspend
  * @state: system suspend state
  *
@@ -1893,6 +1876,12 @@ int rdev_get_id(struct regulator_dev *rdev)
 }
 EXPORT_SYMBOL_GPL(rdev_get_id);
 
+void *regulator_get_init_drvdata(struct regulator_init_data *reg_init_data)
+{
+	return reg_init_data->driver_data;
+}
+EXPORT_SYMBOL_GPL(regulator_get_init_drvdata);
+
 static int __init regulator_init(void)
 {
 	printk(KERN_INFO "regulator: core version %s\n", REGULATOR_VERSION);
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 1d712c7..e7cbeda 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -18,8 +18,8 @@
 #include <linux/device.h>
 #include <linux/regulator/consumer.h>
 
-struct regulator_constraints;
 struct regulator_dev;
+struct regulator_init_data;
 
 /**
  * struct regulator_ops - regulator operations.
@@ -85,9 +85,8 @@ struct regulator_desc {
 	struct module *owner;
 };
 
-
-struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
-					  void *reg_data);
+struct regulator_dev *regulator_register(struct device *dev,
+	struct regulator_desc *regulator_desc);
 void regulator_unregister(struct regulator_dev *rdev);
 
 int regulator_notifier_call_chain(struct regulator_dev *rdev,
@@ -96,4 +95,6 @@ int regulator_notifier_call_chain(struct regulator_dev *rdev,
 void *rdev_get_drvdata(struct regulator_dev *rdev);
 int rdev_get_id(struct regulator_dev *rdev);
 
+void *regulator_get_init_drvdata(struct regulator_init_data *reg_init_data);
+
 #endif
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index 11e737d..c6d6933 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -89,15 +89,33 @@ struct regulation_constraints {
 	unsigned apply_uV:1;	/* apply uV constraint iff min == max */
 };
 
-int regulator_set_supply(const char *regulator, const char *regulator_supply);
+/**
+ * struct regulator_consumer_supply - supply -> device mapping
+ *
+ * This maps a supply name to a device.
+ */
+struct regulator_consumer_supply {
+	struct device *dev;	/* consumer */
+	const char *supply;	/* consumer supply - e.g. "vcc" */
+};
 
-const char *regulator_get_supply(const char *regulator);
+/**
+ * struct regulator_init_data - regulator platform initialisation data.
+ *
+ * Initialisation constraints, our supply and consumers supplies.
+ */
+struct regulator_init_data {
+	struct device *supply_regulator_dev; /* or NULL for LINE */
 
-int regulator_set_machine_constraints(const char *regulator,
-	struct regulation_constraints *constraints);
+	struct regulation_constraints constraints;
 
-int regulator_set_device_supply(const char *regulator, struct device *dev,
-				const char *supply);
+	int num_consumer_supplies;
+	struct regulator_consumer_supply *consumer_supplies;
+
+	/* optional regulator machine specific init */
+	int (*regulator_init)(void *driver_data);
+	void *driver_data;	/* core does not touch this */
+};
 
 int regulator_suspend_prepare(suspend_state_t state);
 
-- 
1.5.4.3


