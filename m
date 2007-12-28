Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087AbXL1PRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbXL1PRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 10:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbXL1PRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 10:17:48 -0500
Received: from mail0.scram.de ([78.47.204.202]:60208 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798AbXL1PRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 10:17:47 -0500
X-Spam-Score: -4.001
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.4 AWL AWL: From: address is in the auto white-list
Message-ID: <477513CC.3060109@scram.de>
Date: Fri, 28 Dec 2007 16:18:36 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org
CC: linux-kernel@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>
Subject: [PATCH/RFC] Add support for freescale watchdog to CPM serial driver.
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a freescale watchdog device node is present, reset the watchdog
while waiting for serial input.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 arch/powerpc/boot/cpm-serial.c |   33 ++++++++++++++++++++++++++++++++-
 1 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/boot/cpm-serial.c b/arch/powerpc/boot/cpm-serial.c
index 28296fa..d85f038 100644
--- a/arch/powerpc/boot/cpm-serial.c
+++ b/arch/powerpc/boot/cpm-serial.c
@@ -6,6 +6,9 @@
  *
  * It is assumed that the firmware (or the platform file) has already set
  * up the port.
+ *
+ * If a watchdog node exists, periodically reset the watchdog while waiting
+ * for console input.
  */
 
 #include "types.h"
@@ -50,7 +53,16 @@ struct cpm_bd {
 	u8 *addr; /* Buffer address in host memory */
 };
 
+struct pq_wdt {
+	u32 res0;
+	u32 swcrr; /* System watchdog control register */
+	u32 swcnr; /* System watchdog count register */
+	u8  res1[2];
+	u16 swsrr; /* System watchdog service register */
+};
+
 static void *cpcr;
+static struct pq_wdt *wdt;
 static struct cpm_param *param;
 static struct cpm_smc *smc;
 static struct cpm_scc *scc;
@@ -154,6 +166,11 @@ static void cpm_serial_putc(unsigned char c)
 
 static unsigned char cpm_serial_tstc(void)
 {
+	if (wdt) {
+		out_be16(&wdt->swsrr, 0x556c);
+		out_be16(&wdt->swsrr, 0xaa39);
+	}
+
 	barrier();
 	return !(rbdf->sc & 0x8000);
 }
@@ -178,7 +195,7 @@ int cpm_console_init(void *devp, struct serial_console_data *scdp)
 	void *reg_virt[2];
 	int is_smc = 0, is_cpm2 = 0, n;
 	unsigned long reg_phys;
-	void *parent, *muram;
+	void *parent, *muram, *watchdog;
 
 	if (dt_is_compatible(devp, "fsl,cpm1-smc-uart")) {
 		is_smc = 1;
@@ -260,6 +277,20 @@ int cpm_console_init(void *devp, struct serial_console_data *scdp)
 	if (n < 4)
 		return -1;
 
+	watchdog = finddevice("/soc/wdt");
+	if (watchdog && (dt_is_compatible(watchdog, "fsl,pq1-wdt") ||
+			 dt_is_compatible(watchdog, "fsl,pq2-wdt") ||
+			 dt_is_compatible(watchdog, "fsl,pq2pro-wdt"))) {
+		n = getprop(watchdog, "virtual-reg", reg_virt,
+			 sizeof(reg_virt));
+		if (n < (int)sizeof(reg_virt)) {
+			if (!dt_xlate_reg(watchdog, 0, &reg_phys, NULL))
+				return -1;
+			reg_virt[0] = (void *)reg_phys;
+		}
+		wdt = reg_virt[0];
+	}
+
 	scdp->open = cpm_serial_open;
 	scdp->putc = cpm_serial_putc;
 	scdp->getc = cpm_serial_getc;
-- 
1.5.3.7

