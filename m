Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbZLXHel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbZLXHel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 02:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbZLXHek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 02:34:40 -0500
Received: from mga10.intel.com ([192.55.52.92]:62410 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754219AbZLXHej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 02:34:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,445,1257148800"; 
   d="scan'208";a="525980004"
Date: Thu, 24 Dec 2009 15:31:02 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Rudolf Marek <r.marek@assembler.cz>, Huaxu Wan <huaxu.wan@intel.com>,
       Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hwmon: (coretemp) Fix TjMax for Atom N450/D410/D510 CPUs
Message-ID: <20091224073102.GA23058@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The max junction temperature of Atom N450/D410/D510 CPUs is 100 degrees Celsius.
Since these CPUs are always coupled with Intel NM10 chipset in one package, the
best way to verify whether an Atom CPU is N450/D410/D510 is to check the host
bridge device.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
Acked-by: Huaxu Wan <huaxu.wan@intel.com>
---
 drivers/hwmon/coretemp.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index caef39c..65a33ec 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -33,6 +33,7 @@
 #include <linux/list.h>
 #include <linux/platform_device.h>
 #include <linux/cpu.h>
+#include <linux/pci.h>
 #include <asm/msr.h>
 #include <asm/processor.h>
 
@@ -161,6 +162,7 @@ static int __devinit adjust_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *
 	int usemsr_ee = 1;
 	int err;
 	u32 eax, edx;
+	struct pci_dev *host_bridge;
 
 	/* Early chips have no MSR for TjMax */
 
@@ -168,11 +170,21 @@ static int __devinit adjust_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *
 		usemsr_ee = 0;
 	}
 
-	/* Atoms seems to have TjMax at 90C */
+	/* Atoms CPUs */
 
 	if (c->x86_model == 0x1c) {
 		usemsr_ee = 0;
-		tjmax = 90000;
+
+		host_bridge = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
+
+		if (host_bridge && host_bridge->vendor == PCI_VENDOR_ID_INTEL
+		    && (host_bridge->device == 0xa000	/* NM10 based nettop */
+		    || host_bridge->device == 0xa010))	/* NM10 based netbook */
+			tjmax = 100000;
+		else
+			tjmax = 90000;
+
+		pci_dev_put(host_bridge);
 	}
 
 	if ((c->x86_model > 0xe) && (usemsr_ee)) {
