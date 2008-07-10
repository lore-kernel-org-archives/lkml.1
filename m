Return-Path: <linux-kernel-owner+w=401wt.eu-S1759867AbYGJP2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759867AbYGJP2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759218AbYGJP1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:27:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45156 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759213AbYGJP1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:27:16 -0400
Subject: [PATCH 12/15] regulator: documentation - machine
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       arm kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 16:27:14 +0100
Message-Id: <1215703634.13431.68.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds documenation describing the regulator machine interface.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
---
 Documentation/power/regulator/machine.txt |  101 +++++++++++++++++++++++++++++
 1 files changed, 101 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/power/regulator/machine.txt

diff --git a/Documentation/power/regulator/machine.txt b/Documentation/power/regulator/machine.txt
new file mode 100644
index 0000000..c9a3566
--- /dev/null
+++ b/Documentation/power/regulator/machine.txt
@@ -0,0 +1,101 @@
+Regulator Machine Driver Interface
+===================================
+
+The regulator machine driver interface is intended for board/machine specific
+initialisation code to configure the regulator subsystem. Typical things that
+machine drivers would do are :-
+
+ 1. Regulator -> Device mapping.
+ 2. Regulator supply configuration.
+ 3. Power Domain constraint setting.
+
+
+
+1. Regulator -> device mapping
+==============================
+Consider the following machine :-
+
+  Regulator-1 -+-> Regulator-2 --> [Consumer A @ 1.8 - 2.0V]
+               |
+               +-> [Consumer B @ 3.3V]
+
+The drivers for consumers A & B must be mapped to the correct regulator in
+order to control their power supply. This mapping can be achieved in machine
+initialisation code by calling :-
+
+int regulator_set_device_supply(const char *regulator, struct device *dev,
+				const char *supply);
+
+and is shown with the following code :-
+
+regulator_set_device_supply("Regulator-1", devB, "Vcc");
+regulator_set_device_supply("Regulator-2", devA, "Vcc");
+
+This maps Regulator-1 to the 'Vcc' supply for Consumer B and maps Regulator-2
+to the 'Vcc' supply for Consumer A.
+
+
+2. Regulator supply configuration.
+==================================
+Consider the following machine (again) :-
+
+  Regulator-1 -+-> Regulator-2 --> [Consumer A @ 1.8 - 2.0V]
+               |
+               +-> [Consumer B @ 3.3V]
+
+Regulator-1 supplies power to Regulator-2. This relationship must be registered
+with the core so that Regulator-1 is also enabled when Consumer A enables it's
+supply (Regulator-2).
+
+This relationship can be register with the core via :-
+
+int regulator_set_supply(const char *regulator, const char *regulator_supply);
+
+In this example we would use the following code :-
+
+regulator_set_supply("Regulator-2", "Regulator-1");
+
+Relationships can be queried by calling :-
+
+const char *regulator_get_supply(const char *regulator);
+
+
+3. Power Domain constraint setting.
+===================================
+Each power domain within a system has physical constraints on voltage and
+current. This must be defined in software so that the power domain is always
+operated within specifications.
+
+Consider the following machine (again) :-
+
+  Regulator-1 -+-> Regulator-2 --> [Consumer A @ 1.8 - 2.0V]
+               |
+               +-> [Consumer B @ 3.3V]
+
+This gives us two regulators and two power domains:
+
+                   Domain 1: Regulator-2, Consumer B.
+                   Domain 2: Consumer A.
+
+Constraints can be registered by calling :-
+
+int regulator_set_platform_constraints(const char *regulator,
+	struct regulation_constraints *constraints);
+
+The example is defined as follows :-
+
+struct regulation_constraints domain_1 = {
+	.min_uV = 3300000,
+	.max_uV = 3300000,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+};
+
+struct regulation_constraints domain_2 = {
+	.min_uV = 1800000,
+	.max_uV = 2000000,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+};
+
+regulator_set_platform_constraints("Regulator-1", &domain_1);
+regulator_set_platform_constraints("Regulator-2", &domain_2);
-- 
1.5.4.3



