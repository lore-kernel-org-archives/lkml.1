Return-Path: <linux-kernel-owner+w=401wt.eu-S932776AbZKFWXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776AbZKFWXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932735AbZKFWXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:23:47 -0500
Received: from kroah.org ([198.145.64.141]:57221 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932613AbZKFWXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:45 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:52 2009
Message-Id: <20091106221552.169581662@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [95/99] powerpc/pmac: Fix issues with sleep on some powerbooks
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=powerpc-pmac-fix-issues-with-sleep-on-some-powerbooks.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 11a50873ef2b3c1c3fe99a661c22c08f35d93553 upstream.

Since the change of how interrupts are disabled during suspend,
certain PowerBook models started exhibiting various issues during
suspend or resume from sleep.

I finally tracked it down to the code that runs various "platform"
functions (kind of little scripts extracted from the device-tree),
which uses our i2c and PMU drivers expecting interrutps to work,
and at a time where with the new scheme, they have been disabled.

This causes timeouts internally which for some reason results in
the PMU being unable to see the trackpad, among other issues, really
it depends on the machine. Most of the time, we fail to properly adjust
some clocks for suspend/resume so the results are not always
predictable.

This patch fixes it by using IRQF_TIMER for both the PMU and the I2C
interrupts. I prefer doing it this way than moving the call sites since
I really want those platform functions to still be called after all
drivers (and before sysdevs).

We also do a slight cleanup to via-pmu.c driver to make sure the
ADB autopoll mask is handled correctly when doing bus resets

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/powermac/low_i2c.c |    7 +++--
 drivers/macintosh/via-pmu.c               |   40 +++++++++++++++++-------------
 2 files changed, 28 insertions(+), 19 deletions(-)

--- a/arch/powerpc/platforms/powermac/low_i2c.c
+++ b/arch/powerpc/platforms/powermac/low_i2c.c
@@ -540,8 +540,11 @@ static struct pmac_i2c_host_kw *__init k
 	/* Make sure IRQ is disabled */
 	kw_write_reg(reg_ier, 0);
 
-	/* Request chip interrupt */
-	if (request_irq(host->irq, kw_i2c_irq, 0, "keywest i2c", host))
+	/* Request chip interrupt. We set IRQF_TIMER because we don't
+	 * want that interrupt disabled between the 2 passes of driver
+	 * suspend or we'll have issues running the pfuncs
+	 */
+	if (request_irq(host->irq, kw_i2c_irq, IRQF_TIMER, "keywest i2c", host))
 		host->irq = NO_IRQ;
 
 	printk(KERN_INFO "KeyWest i2c @0x%08x irq %d %s\n",
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -405,7 +405,11 @@ static int __init via_pmu_start(void)
 		printk(KERN_ERR "via-pmu: can't map interrupt\n");
 		return -ENODEV;
 	}
-	if (request_irq(irq, via_pmu_interrupt, 0, "VIA-PMU", (void *)0)) {
+	/* We set IRQF_TIMER because we don't want the interrupt to be disabled
+	 * between the 2 passes of driver suspend, we control our own disabling
+	 * for that one
+	 */
+	if (request_irq(irq, via_pmu_interrupt, IRQF_TIMER, "VIA-PMU", (void *)0)) {
 		printk(KERN_ERR "via-pmu: can't request irq %d\n", irq);
 		return -ENODEV;
 	}
@@ -419,7 +423,7 @@ static int __init via_pmu_start(void)
 			gpio_irq = irq_of_parse_and_map(gpio_node, 0);
 
 		if (gpio_irq != NO_IRQ) {
-			if (request_irq(gpio_irq, gpio1_interrupt, 0,
+			if (request_irq(gpio_irq, gpio1_interrupt, IRQF_TIMER,
 					"GPIO1 ADB", (void *)0))
 				printk(KERN_ERR "pmu: can't get irq %d"
 				       " (GPIO1)\n", gpio_irq);
@@ -925,8 +929,7 @@ proc_write_options(struct file *file, co
 
 #ifdef CONFIG_ADB
 /* Send an ADB command */
-static int
-pmu_send_request(struct adb_request *req, int sync)
+static int pmu_send_request(struct adb_request *req, int sync)
 {
 	int i, ret;
 
@@ -1005,16 +1008,11 @@ pmu_send_request(struct adb_request *req
 }
 
 /* Enable/disable autopolling */
-static int
-pmu_adb_autopoll(int devs)
+static int __pmu_adb_autopoll(int devs)
 {
 	struct adb_request req;
 
-	if ((vias == NULL) || (!pmu_fully_inited) || !pmu_has_adb)
-		return -ENXIO;
-
 	if (devs) {
-		adb_dev_map = devs;
 		pmu_request(&req, NULL, 5, PMU_ADB_CMD, 0, 0x86,
 			    adb_dev_map >> 8, adb_dev_map);
 		pmu_adb_flags = 2;
@@ -1027,9 +1025,17 @@ pmu_adb_autopoll(int devs)
 	return 0;
 }
 
+static int pmu_adb_autopoll(int devs)
+{
+	if ((vias == NULL) || (!pmu_fully_inited) || !pmu_has_adb)
+		return -ENXIO;
+
+	adb_dev_map = devs;
+	return __pmu_adb_autopoll(devs);
+}
+
 /* Reset the ADB bus */
-static int
-pmu_adb_reset_bus(void)
+static int pmu_adb_reset_bus(void)
 {
 	struct adb_request req;
 	int save_autopoll = adb_dev_map;
@@ -1038,13 +1044,13 @@ pmu_adb_reset_bus(void)
 		return -ENXIO;
 
 	/* anyone got a better idea?? */
-	pmu_adb_autopoll(0);
+	__pmu_adb_autopoll(0);
 
-	req.nbytes = 5;
+	req.nbytes = 4;
 	req.done = NULL;
 	req.data[0] = PMU_ADB_CMD;
-	req.data[1] = 0;
-	req.data[2] = ADB_BUSRESET;
+	req.data[1] = ADB_BUSRESET;
+	req.data[2] = 0;
 	req.data[3] = 0;
 	req.data[4] = 0;
 	req.reply_len = 0;
@@ -1056,7 +1062,7 @@ pmu_adb_reset_bus(void)
 	pmu_wait_complete(&req);
 
 	if (save_autopoll != 0)
-		pmu_adb_autopoll(save_autopoll);
+		__pmu_adb_autopoll(save_autopoll);
 
 	return 0;
 }


