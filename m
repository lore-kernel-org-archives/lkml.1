Return-Path: <linux-kernel-owner+w=401wt.eu-S1751767AbZIWDmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbZIWDmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 23:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbZIWDmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 23:42:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:36771 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbZIWDmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 23:42:52 -0400
Subject: Re: [regression, bisected] adb trackpad disappears after suspend
 to ram
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jan Scholz <scholz@fias.uni-frankfurt.de>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <200906032200.55563.rjw@sisk.pl>
References: <878wkl6vce.fsf@scholz.fias.uni-frankfurt.de>
	 <200906031202.28916.rjw@sisk.pl>
	 <877hzty0hm.fsf@scholz.fias.uni-frankfurt.de>
	 <200906032200.55563.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 23 Sep 2009 13:32:25 +1000
Message-Id: <1253676745.7103.268.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allright, I think I nailed it (finally !)

Can everybody try this patch:

[PATCH] powerpc/pmac: Fix issues with sleep on some powerbooks

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

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
---

diff --git a/arch/powerpc/platforms/powermac/low_i2c.c b/arch/powerpc/platforms/powermac/low_i2c.c
index 21226b7..414ca98 100644
--- a/arch/powerpc/platforms/powermac/low_i2c.c
+++ b/arch/powerpc/platforms/powermac/low_i2c.c
@@ -540,8 +540,11 @@ static struct pmac_i2c_host_kw *__init kw_i2c_host_init(struct device_node *np)
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
diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
index b40fb9b..6f308a4 100644
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
@@ -925,8 +929,7 @@ proc_write_options(struct file *file, const char __user *buffer,
 
 #ifdef CONFIG_ADB
 /* Send an ADB command */
-static int
-pmu_send_request(struct adb_request *req, int sync)
+static int pmu_send_request(struct adb_request *req, int sync)
 {
 	int i, ret;
 
@@ -1005,16 +1008,11 @@ pmu_send_request(struct adb_request *req, int sync)
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


On Wed, 2009-06-03 at 22:00 +0200, Rafael J. Wysocki wrote:
> On Wednesday 03 June 2009, Jan Scholz wrote:
> > "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> > 
> > > On Tuesday 02 June 2009, Jan Scholz wrote: 
> > >> "Rafael J. Wysocki" <rjw@sisk.pl> writes: 
> > >> 
> > >> > On Monday 01 June 2009, Jan Scholz wrote: 
> > >> >> "Rafael J. Wysocki" <rjw@sisk.pl> writes: 
> > >> >> 
> > >> >> > On Friday 29 May 2009, Jan Scholz wrote: 
> > >> >> >> Benjamin Herrenschmidt <benh@kernel.crashing.org> writes: 
> > >> >> >> 
> > >> >> >> >> We are too late in the cycle to revert this commit and
> it 
> > > really is needed to 
> > >> >> >> >> fix a more serious issue. Nevertheless knowing that it
> caused 
> > > the problem to 
> > >> >> >> >> appear on your system is also important. 
> > >> >> >> >> 
> > >> >> >> >> Ben, do you have an idea what may be going on here?
> Does 
> > > __disable_irq() mask 
> > >> >> >> >> the interrupt on this platform? 
> > >> >> >> > 
> > >> >> >> > I suppose so :-) I'll have to check what's going on, it's
> not 
> > >> >> >> > immediately clear to me. 
> > >> >> >> > 
> > >> >> >> > Cheers, 
> > >> >> >> > Ben. 
> > >> >> >> > 
> > >> >> >> >> 
> > >> >> >> >> I'd like to see a boot log, preferably containing a 
> > > suspend-resume in which 
> > >> >> >> >> the problem was reproduced. 
> > >> >> >> 
> > >> >> >> Here is a log from booting, through several suspend cycles,
> until 
> > > the 
> > >> >> >> trackpad disappeared. The first few suspends were done
> while X was 
> > >> >> >> running but from the console. As you can tell from lines
> like 
> > >> >> >> May 28 23:51:26 [kernel] adb devices: [2]: 2 c4 [3]: 3 1
> [7]: 7 1f 
> > >> >> >> the trackpad was still present. The last suspend was done
> from 
> > > within X, 
> > >> >> >> here the trackpad did not make it. 
> > >> >> >> May 28 23:58:09 [kernel] adb devices: [2]: 2 c4 [7]: 7 1f 
> > >> >> >> However, there have been cases, although not in this log,
> were the 
> > >> >> >> trackpad has been alive even when suspending from within
> X. 
> > >> >> > 
> > >> >> > This means the problem is probably timing-related. 
> > >> >> > 
> > >> >> > Can you please try to comment out suspend_device_irqs() and 
> > >> >> > resume_device_irqs() in drivers/base/power/main.c and see if
> that 
> > > changes 
> > >> >> > anything? It's not entirely safe (well, that's why the calls
> are 
> > > there after 
> > >> >> > all), but hopefully the box won't hang during this test. 
> > >> >> > 
> > >> >> 
> > >> >> Tried that against v2.6.30-rc7 and it seems to fix the issue.
> I did 
> > > ~10 
> > >> >> suspend-resume cycles from the console (which worked just
> like 
> > > before) 
> > >> >> and ~20 cycles from within X and the trackpad is still alive. 
> > >> > 
> > >> > So, it seems we lose and interrupt during resume and that
> confuses the 
> > >> > ADB controller driver or something like this. Do you use the
> keyboard 
> > > or 
> > >> > the trackpad as a wake-up device? 
> > >> 
> > >> I do the wakeup by pressing keys on the keyboard. I'd try wakeup
> via the 
> > >> trackpad's button, but I have no idea how to activate that. 
> > >> 
> > >> > Please additionally try to go back to the original code, put 
> > >> > 'sleepy_trackpad = 1' at the beginning of do_adb_reset_bus()
> in 
> > >> > drivers/macintosh/adb.c and see if the problem is reproducible
> with 
> > > that. 
> > >> 
> > >> Tried this, but it does not help. 
> > >> 
> > >> What I haven't noticed before is, that even if the trackpad
> already 
> > >> disappeared, an additional suspend-resume cycle from the console
> brought 
> > >> it back to life every time. Sometimes this worked from within X
> as well, 
> > >> just not with such a high probability as from the console. 
> > >> However, this is independent from 'sleepy_trackpad = 1'. 
> > >
> > > OK, the patch is below, but I haven't had the opportunity to test
> it yet. 
> > >
> > > Can you please check if it helps, on top of 2.6.30-rc8? 
> > >
> > > Best, 
> > > Rafael 
> > >
> > > --- 
> > > kernel/irq/manage.c | 12 ++++++++---- 
> > > 1 file changed, 8 insertions(+), 4 deletions(-) 
> > >
> > > Index: linux-2.6/kernel/irq/manage.c 
> > >
> =================================================================== 
> > > --- linux-2.6.orig/kernel/irq/manage.c 
> > > +++ linux-2.6/kernel/irq/manage.c 
> > > @@ -187,9 +187,9 @@ static inline int setup_affinity(unsigne 
> > > void __disable_irq(struct irq_desc *desc, unsigned int irq, bool
> suspend) 
> > > { 
> > > if (suspend) { 
> > > - if (!desc->action || (desc->action->flags & IRQF_TIMER)) 
> > > - return; 
> > > - desc->status |= IRQ_SUSPENDED; 
> > > + if (desc->action && !(desc->action->flags & IRQF_TIMER)) 
> > > + desc->status |= IRQ_SUSPENDED | IRQ_DISABLED; 
> > > + return; 
> > > } 
> > >
> > > if (!desc->depth++) { 
> > > @@ -250,8 +250,12 @@ EXPORT_SYMBOL(disable_irq); 
> > >
> > > void __enable_irq(struct irq_desc *desc, unsigned int irq, bool
> resume) 
> > > { 
> > > - if (resume) 
> > > + if (resume) { 
> > > desc->status &= ~IRQ_SUSPENDED; 
> > > + if (!desc->depth) 
> > > + desc->status &= ~IRQ_DISABLED; 
> > > + return; 
> > > + } 
> > >
> > > switch (desc->depth) { 
> > > case 0: 
> > 
> > Hi Rafael,
> > 
> > I tried your patch, but it makes my box crash on wakeup. It even
> reset
> > the hwclock which normally only happens with completely empty
> battery
> > and without AC.
> 
> 
> 
> Ouch, sorry.
> 
> 
> 
> In that case I have no idea why it breaks.
> 
> 
> 
> Johannes also reported a problem with MacBook that was most probably
> introduced
> by the suspend reordering changes, but that one related to
> hibernation.
> 
> 
> 
> Best,
> Rafael
> 
> 
> 

