Return-Path: <linux-kernel-owner+w=401wt.eu-S1762243AbYHDXux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762243AbYHDXux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 19:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757295AbYHDXup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 19:50:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47964 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174AbYHDXuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 19:50:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: BUG: scheduling while atomic: ip/23212/0x00000102
Date: Tue, 5 Aug 2008 01:53:22 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: David Miller <davem@davemloft.net>, arekm@maven.pl,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <200808041845.10893.arekm@maven.pl> <200808050010.45615.rjw@sisk.pl> <200808041604.47219.jbarnes@virtuousgeek.org>
In-Reply-To: <200808041604.47219.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808050153.23537.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 5 of August 2008, Jesse Barnes wrote:
> On Monday, August 04, 2008 3:10 pm Rafael J. Wysocki wrote:
> > > -	pci_read_config_word(tp->pdev,
> > > -			     pm + PCI_PM_CTRL,
> > > -			     &power_control);
> > > -	power_control |= PCI_PM_CTRL_PME_STATUS;
> > > -	power_control &= ~(PCI_PM_CTRL_STATE_MASK);
> > >  	switch (state) {
> > >  	case PCI_D0:
> > > -		power_control |= 0;
> > > -		pci_write_config_word(tp->pdev,
> > > -				      pm + PCI_PM_CTRL,
> > > -				      power_control);
> > > -		udelay(100);	/* Delay after power state change */
> > > +		pci_enable_wake(tp->pdev, state, false);
> > > +		pci_set_power_state(tp->pdev, PCI_D0);
> >
> > Still, I don't think drivers should access the standard PCI PM registers
> > directly, so perhaps there should be a version of pci_set_power_state()
> > using udelay() instead of msleep() or we can just replace the msleep()
> > in pci_set_power_state() with udelay()?
> 
> I think we should get rid of the open coded PCI PM state management, since 
> otherwise platform related bugs like the Intel PCIe PM quirk that sets 
> pci_pm_d3_delay to 120ms would have to be duplicated around the tree.
> 
> That said, waiting for 120ms with a busy wait seems a bit absurd if we can 
> avoid it.  Either we need to find a way to make drivers only change states 
> (which can be very slow) in non-atomic context or we'll need to add a busy 
> wait variant of the power state call...

What about this?

It fixes the tg3 issue for me.

---
 drivers/net/tg3.c   |   19 +++++++++++++++++--
 drivers/pci/pci.c   |   24 +++++++++++++++---------
 include/linux/pci.h |    2 ++
 3 files changed, 34 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -421,6 +421,7 @@ static inline int platform_pci_sleep_wak
  *                           given PCI device
  * @dev: PCI device to handle.
  * @state: PCI power state (D0, D1, D2, D3hot) to put the device into.
+ * @delay: if set, time to wait for the device to change the state, in microseconds
  *
  * RETURN VALUE:
  * -EINVAL if the requested state is invalid.
@@ -429,8 +430,8 @@ static inline int platform_pci_sleep_wak
  * 0 if device already is in the requested state.
  * 0 if device's power state has been successfully changed.
  */
-static int
-pci_raw_set_power_state(struct pci_dev *dev, pci_power_t state)
+int pci_raw_set_power_state(struct pci_dev *dev, pci_power_t state,
+                            unsigned int delay)
 {
 	u16 pmcsr;
 	bool need_restore = false;
@@ -486,12 +487,16 @@ pci_raw_set_power_state(struct pci_dev *
 	/* enter specified state */
 	pci_write_config_word(dev, dev->pm_cap + PCI_PM_CTRL, pmcsr);
 
-	/* Mandatory power management transition delays */
-	/* see PCI PM 1.1 5.6.1 table 18 */
-	if (state == PCI_D3hot || dev->current_state == PCI_D3hot)
-		msleep(pci_pm_d3_delay);
-	else if (state == PCI_D2 || dev->current_state == PCI_D2)
-		udelay(200);
+	if (delay) {
+		udelay(delay);
+	} else {
+		/* Mandatory power management transition delays */
+		/* see PCI PM 1.1 5.6.1 table 18 */
+		if (state == PCI_D3hot || dev->current_state == PCI_D3hot)
+			msleep(pci_pm_d3_delay);
+		else if (state == PCI_D2 || dev->current_state == PCI_D2)
+			udelay(200);
+	}
 
 	dev->current_state = state;
 
@@ -577,7 +582,7 @@ int pci_set_power_state(struct pci_dev *
 	if (state == PCI_D3hot && (dev->dev_flags & PCI_DEV_FLAGS_NO_D3))
 		return 0;
 
-	error = pci_raw_set_power_state(dev, state);
+	error = pci_raw_set_power_state(dev, state, 0);
 
 	if (state > PCI_D0 && platform_pci_power_manageable(dev)) {
 		/* Allow the platform to finalize the transition */
@@ -1941,6 +1946,7 @@ EXPORT_SYMBOL(pci_assign_resource);
 EXPORT_SYMBOL(pci_find_parent_resource);
 EXPORT_SYMBOL(pci_select_bars);
 
+EXPORT_SYMBOL(pci_raw_set_power_state);
 EXPORT_SYMBOL(pci_set_power_state);
 EXPORT_SYMBOL(pci_save_state);
 EXPORT_SYMBOL(pci_restore_state);
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -645,6 +645,8 @@ size_t pci_get_rom_size(void __iomem *ro
 /* Power management related routines */
 int pci_save_state(struct pci_dev *dev);
 int pci_restore_state(struct pci_dev *dev);
+int pci_raw_set_power_state(struct pci_dev *dev, pci_power_t state,
+			unsigned int delay);
 int pci_set_power_state(struct pci_dev *dev, pci_power_t state);
 pci_power_t pci_choose_state(struct pci_dev *dev, pm_message_t state);
 bool pci_pme_capable(struct pci_dev *dev, pci_power_t state);
Index: linux-2.6/drivers/net/tg3.c
===================================================================
--- linux-2.6.orig/drivers/net/tg3.c
+++ linux-2.6/drivers/net/tg3.c
@@ -1979,6 +1979,21 @@ static void tg3_power_down_phy(struct tg
 	tg3_writephy(tp, MII_BMCR, BMCR_PDOWN);
 }
 
+static int tg3_force_power_state_d0(struct tg3 *tp)
+{
+	int error;
+
+	error = pci_raw_set_power_state(tp->pdev, PCI_D0, 100);
+	if (error)
+		return error;
+
+	/* Switch out of Vaux if it is a NIC */
+	if (tp->tg3_flags2 & TG3_FLG2_IS_NIC)
+		tw32_wait_f(GRC_LOCAL_CTRL, tp->grc_local_ctrl, 100);
+
+	return 0;
+}
+
 static int tg3_set_power_state(struct tg3 *tp, pci_power_t state)
 {
 	u32 misc_host_ctrl;
@@ -7690,7 +7705,7 @@ static int tg3_init_hw(struct tg3 *tp, i
 	int err;
 
 	/* Force the chip into D0. */
-	err = tg3_set_power_state(tp, PCI_D0);
+	err = tg3_force_power_state_d0(tp);
 	if (err)
 		goto out;
 
@@ -8018,7 +8033,7 @@ static int tg3_open(struct net_device *d
 
 	tg3_full_lock(tp, 0);
 
-	err = tg3_set_power_state(tp, PCI_D0);
+	err = tg3_force_power_state_d0(tp);
 	if (err) {
 		tg3_full_unlock(tp);
 		return err;
