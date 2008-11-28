Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbYK1M3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbYK1M3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 07:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbYK1M3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 07:29:00 -0500
Received: from ns2.suse.de ([195.135.220.15]:43590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbYK1M27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 07:28:59 -0500
From: Thomas Renninger <trenn@suse.de>
To: linux-kernel@vger.kernel.org
Subject: PCIe ASPM causes machine (HP Compaq 6735s) to sometimes freeze hard at boot at PCI initialization time
Date: Fri, 28 Nov 2008 13:28:54 +0100
User-Agent: KMail/1.9.10
Cc: jbarnes@virtuousgeek.org, shaohua.li@intel.com,
       Rafael Wysocki <rwysocki@suse.de>, shemminger@linux-foundation.org,
       netdev@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2658
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200811281328.55259.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The hang does not always happen.
On latest vanilla 2.6.28-rc6 it nearly always hangs, on a .27 SUSE kernel 
maybe 1 out for 3 times.

I very much expect (I am pretty sure now) it is PCIE ASPM.

I tried to compile out:
CONFIG_PCIEAER=y
CONFIG_PCIEASPM=y

Both disabled survived a reasonable amount of reboots, but when enabling 
CONFIG_PCIEASPM it did not boot anymore on the second try.

The machine is hanging at the network card's PCI initialization rather early, 
here is a photo of the hang:
ftp.suse.com/pub/people/trenn/HP_pci_aspm_hang.jpg

This is the network card:
Marvell 11ab:4357 (PCI ID) using the sky2 driver.
Once the machine booted (even with aspm enabled, the network device works
properly).

Possibly unrelated, because the machine hangs far before the sky2 driver kicks
in or does PCI subsystem already need to set something similar?:

The sky2 driver has some extra ASPM poking in its power_on routine:
/* set all bits to 0 except bits 15..12 and 8 */
                reg &= P_ASPM_CONTROL_MSK;
                sky2_pci_write32(hw, PCI_DEV_REG4, reg);


It seem to be this Marval/Yukon card:
CHIP_ID_YUKON_UL_2 = 0xba, /* YUKON-2 Ultra 2 */

Oh wait,
The SubDevice PCI ID (via hwinfo --netcard) is 0xba, but the driver thinks it
is a (via dmesg):
CHIP_ID_YUKON_FE_P = 0xb8, /* YUKON-2 FE+ */

Any ideas from people with more knowledge in the PCI(e) area is very much 
appreciated.

Thanks,

      Thomas
