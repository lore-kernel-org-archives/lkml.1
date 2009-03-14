Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbZCNL7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbZCNL7V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 07:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbZCNL7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 07:59:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40423 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978AbZCNL7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 07:59:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [RFC][PATCH][0/8] PM: Rework suspend-resume ordering to avoid problems with shared interrupts
Date: Sat, 14 Mar 2009 12:59:01 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       linux-pm@lists.linux-foundation.org
References: <200902221837.49396.rjw@sisk.pl> <200903082150.55377.rjw@sisk.pl> <200903140944.37081.elendil@planet.nl>
In-Reply-To: <200903140944.37081.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903141259.02164.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 March 2009, Frans Pop wrote:
> On Sunday 08 March 2009, Rafael J. Wysocki wrote:
> > > # These don't need restoring anymore?
> >
> > I think they generally do, but the restored values may (and often are)
> > identical to the current ones.
> >
> > >    -pci 0000:00:02.1: restoring config space at offset 0x4 (was 0x4, writing 0xe0500004)
> > >    -pci 0000:00:02.1: restoring config space at offset 0x1 (was 0x900000, writing 0x900007)
> > >    -pci 0000:00:03.0: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
> > >    -pci 0000:00:03.0: restoring config space at offset 0x4 (was 0xfed12004, writing 0xe0600004)
> > >    -pci 0000:00:03.2: restoring config space at offset 0xf (was 0x300, writing 0x30b)
> > >    -pci 0000:00:03.2: restoring config space at offset 0x8 (was 0x1, writing 0x2031)
> > >    -pci 0000:00:03.2: restoring config space at offset 0x7 (was 0x1, writing 0x2021)
> > >    -pci 0000:00:03.2: restoring config space at offset 0x6 (was 0x1, writing 0x2019)
> > >    -pci 0000:00:03.2: restoring config space at offset 0x5 (was 0x1, writing 0x2011)
> > >    -pci 0000:00:03.2: restoring config space at offset 0x4 (was 0x1, writing 0x2009)
> > >    -pci 0000:00:03.2: restoring config space at offset 0x1 (was 0xb00000, writing 0xb00001)
> [...]
> > > # These have moved down to late resume.
> >
> > That's a bit strange.  It looks like the registers changed after we had
> > restored them during "early" resume.  So either we hadn't actually
> > restored them (it would be interesting to find out why), or they really
> > changed (again, it would be interesting to see why).
> >
> > >    -uhci_hcd 0000:00:1a.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
> > >    -uhci_hcd 0000:00:1a.0: restoring config space at offset 0x8 (was 0x1, writing 0x2081)
> > >    -uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800001)
> > >    -uhci_hcd 0000:00:1a.1: restoring config space at offset 0xf (was 0x200, writing 0x20a)
> > >    -uhci_hcd 0000:00:1a.1: restoring config space at offset 0x8 (was 0x1, writing 0x20a1)
> > >    -uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800001)
> 
> These changes look to have been reverted somehow with rc8 + your latest
> patch set. Not sure if it's due to changes in the patches, or just an
> effect of local circumstances (such as (un)suspending while the system
> is docked). Or sun spots of course.
> 
> The "restoring config space" messages now look virtually the same
> as for rc5, only some messages for the ricoh-mmc module are still
> "missing", but I'm not worried about that.

Thanks for testing!

Could you please also test the last iteration of the $subject patch series
(just sent) with the appended patch applied on top and post dmesg output?

Rafael

---
 drivers/pci/pci-driver.c |   23 +++++++++++++++++++++--
 drivers/pci/pci.c        |    5 +++++
 2 files changed, 26 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -732,6 +732,9 @@ int
 pci_save_state(struct pci_dev *dev)
 {
 	int i;
+
+	dev_info(&dev->dev, "saving PCI config space\n");
+
 	/* XXX: 100% dword access ok here? */
 	for (i = 0; i < 16; i++)
 		pci_read_config_dword(dev, i * 4,&dev->saved_config_space[i]);
@@ -753,6 +756,8 @@ pci_restore_state(struct pci_dev *dev)
 	int i;
 	u32 val;
 
+	dev_info(&dev->dev, "restoring PCI config space\n");
+
 	/* PCI Express register must be restored first */
 	pci_restore_pcie_state(dev);
 
Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -438,10 +438,24 @@ static int pci_restore_standard_config(s
 {
 	pci_update_current_state(pci_dev, PCI_UNKNOWN);
 
+	switch (pci_dev->current_state) {
+	case PCI_UNKNOWN:
+	case PCI_POWER_ERROR:
+		dev_info(&pci_dev->dev, "%s: unknown power state\n",
+				__FUNCTION__);
+		break;
+	default:
+		dev_info(&pci_dev->dev, "%s: power state D%d\n",
+				__FUNCTION__, pci_dev->current_state);
+	}
+
 	if (pci_dev->current_state != PCI_D0) {
 		int error = pci_set_power_state(pci_dev, PCI_D0);
-		if (error)
+		if (error) {
+			dev_err(&pci_dev->dev,
+				"error %d while changing power state\n", error);
 			return error;
+		}
 	}
 
 	return pci_dev->state_saved ? pci_restore_state(pci_dev) : 0;
@@ -449,6 +463,8 @@ static int pci_restore_standard_config(s
 
 static void pci_pm_default_resume_noirq(struct pci_dev *pci_dev)
 {
+	dev_info(&pci_dev->dev, "%s: calling pci_restore_standard_config()\n",
+			__FUNCTION__);
 	pci_restore_standard_config(pci_dev);
 	pci_dev->state_saved = false;
 	pci_fixup_device(pci_fixup_resume_early, pci_dev);
@@ -615,8 +631,11 @@ static int pci_pm_resume(struct device *
 	 * This is necessary for the suspend error path in which resume is
 	 * called without restoring the standard config registers of the device.
 	 */
-	if (pci_dev->state_saved)
+	if (pci_dev->state_saved) {
+		dev_info(dev, "%s: restoring standard PCI config registers\n",
+				__FUNCTION__);
 		pci_restore_standard_config(pci_dev);
+	}
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_resume(dev);
