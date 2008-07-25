Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbYGYWTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbYGYWTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 18:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbYGYWTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 18:19:06 -0400
Received: from outbound-mail-112.bluehost.com ([69.89.24.2]:59397 "HELO
	outbound-mail-112.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751937AbYGYWTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 18:19:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id:X-Identified-User;
	b=stzHv0z4GZI92HtA+70huDh+pl0vvevPa9RY7VZbuYx6Az6+tqE9PtkKnewuNwMyoh3dp70EFZMbxE/jBGst8JJ9NbY+EBIIflxOi87B5ZZi4ujhiU4ULj0PsvC68bU0;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
Date: Fri, 25 Jul 2008 15:18:53 -0700
User-Agent: KMail/1.9.9
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, Alex Chiang <achiang@hp.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       Kristen Accardi <kristen.c.accardi@intel.com>
References: <20080724134737.4b91f30d@mjolnir.drzeus.cx> <20080725012916.06679a6d@mjolnir.drzeus.cx> <48895BA1.1030606@jp.fujitsu.com>
In-Reply-To: <48895BA1.1030606@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_NFliIUGVL7zbd1m"
Message-Id: <200807251518.53462.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_NFliIUGVL7zbd1m
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday, July 24, 2008 9:50 pm Kenji Kaneshige wrote:
> Thank you for debug info, Pierre.
>
> According to the debugging output, five slots are detected (five
> slots on laptop!?) and two of them have the same physical slots
> number '2'. This is the reason why Pierre's machine needs
> 'pciehp_slot_with_bus' option.
>
> Before 2.6.26 (from 2.6.xx), pciehp did the workaround for the
> problem (some platform wrongly assign the same physical slot
> number to multiple slots) by default. But this was not a good
> idea because of the several reasons like follows:
>
>   - Slot name should be a physical identifier of physical slot
>     on the system. Using bus number as a part of slot name is
>     not a idea because bus number is logical number and it can
>     be changed.
>
>   - As Jesse explained, some hotplug slot can be handled through
>     several type of controllers. For example, some hotplug slot
>     can be handled by either acpiphp or pciehp. But those drivers
>     must not handle the same slot at the same time. The pci
>     hotplug core is checking this by checking duplicate names.
>     This check didn't work because pciehp had started using bus
>     number as a part of slot name and slot names became different
>     between acpiphp and pciehp.
>
> About the former, I'm ok with using bus number as a part of slot
> name on the problematic platform. But it should not be used on
> the normal platform.
>
> About the latter, IIRC, thanks to Alex's pci slot framework from
> 2.6.26, pci hotplug core can check if multiple drivers attempts
> to handle the same slot even if those drivers uses the different
> names.
>
> Based on my thought above, I have a following idea to remove
> "pciehp_slot_with_bus".
>
>   - Try to use physical slot number as a slot name, first.
>
>   - If pci_hp_register() success, no problem.
>
>   - If pci_hp_register() returns -EBUSY, that means another
>     hotplug driver already handling the slot. So return as error.
>
>   - If pci_hp_register() returns -EEXIST, that means there is a
>     existing slot with the same name. In this case, retry to
>     register slots with logical name (bus number + physical slot
>     number, or other).
>
> With this idea, slots names will become as follows on Pierre's
> machine.
>
> <Before 2.6.26>
> 0001_0001, 0002_0002, 0003_0003, 0004_0004, 0005_0005, 000d_0002
>
> <Current>
> 1, 2, 3, 4, 5
>
> <With my idea>
> 1, 2, 3, 4, 5, 000d_0002
>
>
> Please give me comments.

I think that's fine (automatically creating duplicate devices with names to 
differentiate them), but I think we should also try harder to avoid adding 
duplicates.

In Pierre's case, and on my T61, there's only one actual hotplug slot 
available, but the firmware creates duplicate physical slot numbers and sets 
the HP_CAP bit on everything, both of which are obviously wrong (well I 
suppose you could pop these chips off the board, but it's not very 
practical).  However, afaict that "other" OS uses the _RMV method to 
determine whether a given slot is actually hot pluggable.  On my T61 at 
least, this seems to be accurate: only one of my EXP* objects has a _RMV 
method.

So maybe the PCIe hotplug driver should be checking for that method when ACPI 
is available?  We already try to use _OSC etc., so checking for _RMV first 
would make sense...

I tried and failed to do this (naive patch attached), I think somehow I've got 
to traverse child devices too... (and of course add the appropriate #ifdef 
ACPI etc stuff).

Kenji-san and Alex, maybe you can take a look and clue me in?

Thanks,
Jesse

--Boundary-00=_NFliIUGVL7zbd1m
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="pciehp-detect-fixes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="pciehp-detect-fixes.patch"

diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index e3a1e7e..6ab29d8 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -136,6 +136,7 @@ struct controller {
 #define ATTN_LED_PRSN	0x00000008
 #define PWR_LED_PRSN	0x00000010
 #define HP_SUPR_RM_SUP	0x00000020
+#define HP_CAP_SUP	0x00000040
 #define EMI_PRSN	0x00020000
 #define NO_CMD_CMPL_SUP	0x00040000
 
@@ -145,6 +146,7 @@ struct controller {
 #define ATTN_LED(ctrl)		((ctrl)->slot_cap & ATTN_LED_PRSN)
 #define PWR_LED(ctrl)		((ctrl)->slot_cap & PWR_LED_PRSN)
 #define HP_SUPR_RM(ctrl)	((ctrl)->slot_cap & HP_SUPR_RM_SUP)
+#define HP_CAP(ctrl)		((ctrl)->slot_cap & HP_CAP_SUP)
 #define EMI(ctrl)		((ctrl)->slot_cap & EMI_PRSN)
 #define NO_CMD_CMPL(ctrl)	((ctrl)->slot_cap & NO_CMD_CMPL_SUP)
 
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 3677495..896ca5f 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -386,6 +386,17 @@ static int get_cur_bus_speed(struct hotplug_slot *hotplug_slot, enum pci_bus_spe
 	return 0;
 }
 
+static bool acpi_rmv_present(struct pci_dev *pdev)
+{
+	struct acpi_device *acpi_dev = to_acpi_device(&pdev->dev);
+
+	if (acpi_dev && acpi_dev->flags.removable)
+		return true;
+
+	dbg("%s: no ACPI device (%p) or not removable\n", pci_name(pdev), acpi_dev);
+	return false;
+}
+
 static int pciehp_probe(struct pcie_device *dev, const struct pcie_port_service_id *id)
 {
 	int rc;
@@ -397,8 +408,15 @@ static int pciehp_probe(struct pcie_device *dev, const struct pcie_port_service_
 	if (pciehp_force)
 		dbg("Bypassing BIOS check for pciehp use on %s\n",
 		    pci_name(pdev));
-	else if (pciehp_get_hp_hw_control_from_firmware(pdev))
-		goto err_out_none;
+	else {
+		if (!acpi_rmv_present(pdev))
+			goto err_out_none;
+		if (pciehp_get_hp_hw_control_from_firmware(pdev)) {
+			dbg("Failed to get control from firmware for %s\n",
+			    pci_name(pdev));
+			goto err_out_none;
+		}
+	}
 
 	ctrl = pcie_init(dev);
 	if (!ctrl) {
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 1323a43..445b0b1 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -149,7 +149,7 @@ static inline int pciehp_writel(struct controller *ctrl, int reg, u32 value)
 #define ATTN_LED_PRSN	0x00000008
 #define PWR_LED_PRSN	0x00000010
 #define HP_SUPR_RM_SUP	0x00000020
-#define HP_CAP		0x00000040
+#define HP_CAP_SUP	0x00000040
 #define SLOT_PWR_VALUE	0x000003F8
 #define SLOT_PWR_LIMIT	0x00000C00
 #define PSN		0xFFF80000	/* PSN: Physical Slot Number */
@@ -1102,6 +1102,7 @@ static inline void dbg_ctrl(struct controller *ctrl)
 	dbg("  Attention Indicator  : %3s\n", ATTN_LED(ctrl)   ? "yes" : "no");
 	dbg("  Power Indicator      : %3s\n", PWR_LED(ctrl)    ? "yes" : "no");
 	dbg("  Hot-Plug Surprise    : %3s\n", HP_SUPR_RM(ctrl) ? "yes" : "no");
+	dbg("  Hot-Plug Capable     : %3s\n", HP_CAP(ctrl)     ? "yes" : "no");
 	dbg("  EMI Present          : %3s\n", EMI(ctrl)        ? "yes" : "no");
 	dbg("  Comamnd Completed    : %3s\n", NO_CMD_CMPL(ctrl)? "no" : "yes");
 	pciehp_readw(ctrl, SLOTSTATUS, &reg16);
@@ -1127,18 +1128,25 @@ struct controller *pcie_init(struct pcie_device *dev)
 	ctrl->cap_base = pci_find_capability(pdev, PCI_CAP_ID_EXP);
 	if (!ctrl->cap_base) {
 		err("%s: Cannot find PCI Express capability\n", __func__);
-		goto abort;
+		goto abort_ctrl;
 	}
 	if (pciehp_readl(ctrl, SLOTCAP, &slot_cap)) {
 		err("%s: Cannot read SLOTCAP register\n", __func__);
-		goto abort;
+		goto abort_ctrl;
 	}
 
+
 	ctrl->slot_cap = slot_cap;
 	ctrl->first_slot = slot_cap >> 19;
 	ctrl->slot_device_offset = 0;
 	ctrl->num_slots = 1;
 	ctrl->hpc_ops = &pciehp_hpc_ops;
+
+	if (!HP_CAP(ctrl)) {
+		dbg("%s: not hotplug capable, skipping\n", pci_name(pdev));
+		goto abort_ctrl;
+	}
+
 	mutex_init(&ctrl->crit_sect);
 	mutex_init(&ctrl->ctrl_lock);
 	init_waitqueue_head(&ctrl->queue);

--Boundary-00=_NFliIUGVL7zbd1m--
