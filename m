Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbZCXLBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbZCXLBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 07:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759321AbZCXLAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 07:00:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36192 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759301AbZCXLAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 07:00:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [RFC][PATCH 0/2] Export platform_pci_set_power_state() and make radeonfb use it
Date: Tue, 24 Mar 2009 12:00:37 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alex Deucher <alexdeucher@gmail.com>
References: <200903210003.55161.rjw@sisk.pl> <1237856239.25062.696.camel@pasglop> <20090323181420.30125d59@hobbes.virtuouswap>
In-Reply-To: <20090323181420.30125d59@hobbes.virtuouswap>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903241200.37982.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 March 2009, Jesse Barnes wrote:
> On Tue, 24 Mar 2009 11:57:19 +1100
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > On Mon, 2009-03-23 at 15:23 -0700, Jesse Barnes wrote:
> > > The thing I didn't like was that it made the radeon driver use an
> > > internal interface; I'd really prefer a proper return value from
> > > pci_set_power_state, which in turn means auditing all its current
> > > callers. But that doesn't seem worth it unless we see other drivers
> > > needing something similar...
> > > 
> > > And if we did go with something like your first patch, I'd still
> > > rather see the timeout done in the driver, rather than having the
> > > attempts & delay included in the function...
> > 
> > So what ? The driver would call pci_set_power_state() until it stops
> > failing ?
> 
> Yeah, that's what I had in mind.
> 
> > I'm not too fan of that, because it will change the access pattern
> > to the chip:
> > 
> >  - write PM to 2
> >  - short delay
> >  - read PM, see 0, return error
> >  - driver does big delay
> >  - write PM to 2
> >  - short delay
> >  - read PM ....
> > 
> > vs. the current sequence which is
> > 
> >  - write PM to 2
> >  - long delay
> >  - read PM, be happy
> > 
> > Which -seems- to be pretty much what happens in practice, though on
> > that chip, I don't know for sure about others.
> > 
> > I'm worried of the possible side effects of the first sequence that
> > you propose since it would do 2 things potentially confusing to the
> > HW:
> > 
> >  - read PM after a short delay... it -should- be harmless but you know
> > HW as well as I do ...
> > 
> >  - write PM to 2 a second time after the long delay. Again, it
> > -should- be harmless since the chip at this stage should already be
> > in D2 state but god knows how the HW will react.
> > 
> > I'm especially worried about the later in fact. Maybe we can minimize
> > it by having pci_set_power_state() dbl check the content of the PM
> > reg before writing to it...
> 
> Honestly I'm not too happy about any of the approaches, but yeah I see
> your point.  The main thing is to prevent any config space access for
> a specified time after the first D-state transition, which I think we
> do correctly in the core.  Beyond that, we just have to make sure the
> core state is updated correctly; Rafael's first patch does that
> correctly I think.

In fact I have yet another idea.  If we use the "retransmission with exponential
backoff" algorithm in pci_raw_set_power_state(), we won't have to add any
extra parameters to pci_set_power_state() and the radeon case will be covered
automatically.  That should also cover any other devices having similar
problems IMO.

A patch to implement that is appended, please tell me what you think.

Thanks,
Rafael

---
 drivers/pci/pci.c   |   50 ++++++++++++++++++++++++++++++++++++++++----------
 include/linux/pci.h |    1 +
 2 files changed, 41 insertions(+), 10 deletions(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -436,8 +436,10 @@ static inline int platform_pci_sleep_wak
  */
 static int pci_raw_set_power_state(struct pci_dev *dev, pci_power_t state)
 {
-	u16 pmcsr;
+	u16 pmcsr, pmcsr_r;
+	unsigned int delay;
 	bool need_restore = false;
+	int error = 0;
 
 	/* Check if we're already there */
 	if (dev->current_state == state)
@@ -488,17 +490,45 @@ static int pci_raw_set_power_state(struc
 		break;
 	}
 
-	/* enter specified state */
-	pci_write_config_word(dev, dev->pm_cap + PCI_PM_CTRL, pmcsr);
-
-	/* Mandatory power management transition delays */
-	/* see PCI PM 1.1 5.6.1 table 18 */
+	/*
+	 * Mandatory power management transition delays, in microseconds
+	 * (see PCI PM 1.1 5.6.1 table 18).
+	 */
 	if (state == PCI_D3hot || dev->current_state == PCI_D3hot)
-		msleep(pci_pm_d3_delay);
+		delay = pci_pm_d3_delay * 1000;
 	else if (state == PCI_D2 || dev->current_state == PCI_D2)
-		udelay(PCI_PM_D2_DELAY);
+		delay = PCI_PM_D2_DELAY;
+	else
+		delay = 0;
+
+	/*
+	 * Write the new value to the control register, wait as long as needed
+	 * and check if the value read back from the register is the same as
+	 * the written one.  If not, repeat with exponential backoff.
+	 */
+	do {
+		pci_write_config_word(dev, dev->pm_cap + PCI_PM_CTRL, pmcsr);
+		if (delay) {
+			if (delay < 1000)
+				udelay(delay);
+			else
+				msleep(DIV_ROUND_UP(delay, 1000));
+			delay <<= 1;
+		}
+		pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr_r);
+		if (pmcsr == pmcsr_r) {
+			dev->current_state = state;
+			break;
+		}
+	} while (delay && delay <= PCI_PM_MAX_DELAY);
 
-	dev->current_state = state;
+	if (pmcsr != pmcsr_r) {
+		dev->current_state = (pmcsr_r & PCI_PM_CTRL_STATE_MASK);
+		dev_warn(&dev->dev,
+			"failed to set power state to D%d, currently in D%d\n",
+			state, dev->current_state);
+		error = -ENODEV;
+	}
 
 	/* According to section 5.4.1 of the "PCI BUS POWER MANAGEMENT
 	 * INTERFACE SPECIFICATION, REV. 1.2", a device transitioning
@@ -518,7 +548,7 @@ static int pci_raw_set_power_state(struc
 	if (dev->bus->self)
 		pcie_aspm_pm_state_change(dev->bus->self);
 
-	return 0;
+	return error;
 }
 
 /**
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -117,6 +117,7 @@ typedef int __bitwise pci_power_t;
 #define PCI_UNKNOWN	((pci_power_t __force) 5)
 #define PCI_POWER_ERROR	((pci_power_t __force) -1)
 
+#define PCI_PM_MAX_DELAY 2000000
 #define PCI_PM_D2_DELAY	200
 #define PCI_PM_D3_WAIT	10
 #define PCI_PM_BUS_WAIT	50
