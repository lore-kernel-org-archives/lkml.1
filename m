Return-Path: <linux-kernel-owner+w=401wt.eu-S965034AbYCSWdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965034AbYCSWdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763942AbYCSVFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:05:15 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:25581 "EHLO
	phenom.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S936064AbYCSVFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:05:10 -0400
Date: Wed, 19 Mar 2008 14:55:59 -0600
From: dougthompson@xmission.com
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 3/3] EDAC Add e752x parameter for sysbus_parity selection
Message-ID: <47e17ddf.xF+lLzMkHllCZjZq%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Peter Tyser <ptyser@xes-inc.com>

This patch adds a module parameter "sysbus_parity" to allow forcing system bus parity error
 checking on or off.  It also adds support to automatically disable system bus parity errors for
 processors which do not support it.

If the sysbus_parity parameter is specified, sysbus parity detection will be forced on or off.  If
 it is not specified, the driver will attempt to look at the CPU identifier string and determine
 if the CPU supports system bus parity.  A blacklist was used instead of a whitelist so that system
 bus parity would be enabled by default and to minimize the chances of breaking things for those
 people already using the driver which for some reason have a processor that does not have a valid
 CPU identifier string.

CC:		Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by:	Peter Tyser <ptyser@xes-inc.com>
Signed-off-by:	Doug Thompson <dougthompson@xmission.com>
---
 e752x_edac.c |   40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

Index: linux-2.6.25-rc5/drivers/edac/e752x_edac.c
===================================================================
--- linux-2.6.25-rc5.orig/drivers/edac/e752x_edac.c
+++ linux-2.6.25-rc5/drivers/edac/e752x_edac.c
@@ -29,6 +29,7 @@
 #define EDAC_MOD_STR	"e752x_edac"
 
 static int force_function_unhide;
+static int sysbus_parity = -1;
 
 static struct edac_pci_ctl_info *e752x_pci;
 
@@ -1049,6 +1050,37 @@ fail:
 	return 1;
 }
 
+/* Setup system bus parity mask register.
+ * Sysbus parity supported on:
+ *   e7320/e7520/e7525 + Xeon
+ *   i3100 + Xeon/Celeron
+ * Sysbus parity not supported on:
+ *   i3100 + Pentium M/Celeron M/Core Duo/Core2 Duo
+ */
+static void e752x_init_sysbus_parity_mask(struct e752x_pvt *pvt)
+{
+	char *cpu_id = cpu_data(0).x86_model_id;
+	struct pci_dev *dev = pvt->dev_d0f1;
+	int enable = 1;
+
+	/* Allow module paramter override, else see if CPU supports parity */
+	if (sysbus_parity != -1) {
+		enable = sysbus_parity;
+	} else if (cpu_id[0] &&
+		   ((strstr(cpu_id, "Pentium") && strstr(cpu_id, " M ")) ||
+		    (strstr(cpu_id, "Celeron") && strstr(cpu_id, " M ")) ||
+		    (strstr(cpu_id, "Core") && strstr(cpu_id, "Duo")))) {
+		e752x_printk(KERN_INFO, "System Bus Parity not "
+			     "supported by CPU, disabling\n");
+		enable = 0;
+	}
+
+	if (enable)
+		pci_write_config_word(dev, E752X_SYSBUS_ERRMASK, 0x0000);
+	else
+		pci_write_config_word(dev, E752X_SYSBUS_ERRMASK, 0x0309);
+}
+
 static void e752x_init_error_reporting_regs(struct e752x_pvt *pvt)
 {
 	struct pci_dev *dev;
@@ -1062,7 +1094,9 @@ static void e752x_init_error_reporting_r
 		pci_write_config_byte(dev, E752X_HI_ERRMASK, 0x00);
 		pci_write_config_byte(dev, E752X_HI_SMICMD, 0x00);
 	}
-	pci_write_config_word(dev, E752X_SYSBUS_ERRMASK, 0x00);
+
+	e752x_init_sysbus_parity_mask(pvt);
+
 	pci_write_config_word(dev, E752X_SYSBUS_SMICMD, 0x00);
 	pci_write_config_byte(dev, E752X_BUF_ERRMASK, 0x00);
 	pci_write_config_byte(dev, E752X_BUF_SMICMD, 0x00);
@@ -1286,3 +1320,7 @@ MODULE_PARM_DESC(force_function_unhide, 
 
 module_param(edac_op_state, int, 0444);
 MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
+
+module_param(sysbus_parity, int, 0444);
+MODULE_PARM_DESC(sysbus_parity, "0=disable system bus parity checking,"
+                " 1=enable system bus parity checking, default=auto-detect");
