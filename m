Return-Path: <linux-kernel-owner+w=401wt.eu-S1761942AbZAPEbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761942AbZAPEbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 23:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbZAPEbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 23:31:32 -0500
Received: from rv-out-0506.google.com ([209.85.198.227]:53726 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbZAPEbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 23:31:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=DJvY7jqbeFYkOEupd3qbxheplHKCBh3iIduY7Abci44bkvQ3bau9rBCSjFKqQuhhu+
         B7RJ/Y9lvx0qTYJvgoKc3p+Hmx2p5EkzFJp1b3uor3tbLhQZ5hjLLVIU3akjwHPacWtc
         5mQM1PfiuSeoczapp7L5E92ZuEod195nlHGCM=
MIME-Version: 1.0
Date: Thu, 15 Jan 2009 20:31:30 -0800
X-Google-Sender-Auth: 74bb4b4395fc95ee
Message-ID: <86802c440901152031k55bf8e2eu31c8b9658c2216ac@mail.gmail.com>
Subject: kexec fail with e1000 and e1000e
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[    8.652468] Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
[    8.658896] Copyright (c) 1999-2006 Intel Corporation.
[    8.680008] e1000 0000:05:01.0: enabling device (0000 -> 0003)
[    8.685831] vendor=1022 device=7458
[    8.689314] e1000 0000:05:01.0: PCI INT A -> GSI 48 (level, low) -> IRQ 48
[    8.696184] e1000 0000:05:01.0: enabling bus mastering
[    8.953642] e1000: 0000:05:01.0: e1000_probe: The EEPROM Checksum
Is Not Valid
[    9.863340] /*********************/
[    9.866829] Current EEPROM Checksum : 0xffff
[    9.871092] Calculated              : 0xbaf9
[    9.875354] Offset    Values
[    9.878230] ========  ======
[    9.881107] 00000000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.887622] 00000010: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.894137] 00000020: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.900653] 00000030: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.907168] 00000040: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.913684] 00000050: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.920200] 00000060: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.926715] 00000070: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.933231] Include this output when contacting your support provider.
[    9.939746] This is not a software error! Something bad happened to
your hardware or
[    9.947475] EEPROM image. Ignoring this problem could result in
further problems,
[    9.954945] possibly loss of data, corruption or system hangs!
[    9.960767] The MAC Address will be reset to 00:00:00:00:00:00,
which is invalid
[    9.968149] and requires you to set the proper MAC address manually
before continuing
[    9.975964] to enable this network device.
[    9.980053] Please inspect the EEPROM dump and report the issue to
your hardware vendor
[    9.988041] or Intel Customer Support.
[    9.991770] /*********************/

git bisect said following patch is first bad one.

commit 98e6e286d7b01deb7453b717aa38ebb69d6cefc0
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Wed Jan 7 13:10:35 2009 +0100

    PCI PM: Register power state of devices during initialization

    Use the observation that the power state of a PCI device can be
    loaded into its pci_dev structure as soon as pci_pm_init() is run for
    it and make that happen.

    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@suse.cz>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index e491fde..c12f6c7 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1260,14 +1260,15 @@ void pci_pm_init(struct pci_dev *dev)
        /* find PCI PM capability in list */
        pm = pci_find_capability(dev, PCI_CAP_ID_PM);
        if (!pm)
-               return;
+               goto Exit;
+
        /* Check device's ability to generate PME# */
        pci_read_config_word(dev, pm + PCI_PM_PMC, &pmc);

        if ((pmc & PCI_PM_CAP_VER_MASK) > 3) {
                dev_err(&dev->dev, "unsupported PM cap regs version (%u)\n",
                        pmc & PCI_PM_CAP_VER_MASK);
-               return;
+               goto Exit;
        }

        dev->pm_cap = pm;
@@ -1306,6 +1307,9 @@ void pci_pm_init(struct pci_dev *dev)
        } else {
                dev->pme_support = 0;
        }
+
+ Exit:
+       pci_update_current_state(dev, PCI_D0);
 }

 /**

# cat kexec_fail_bisect.txt
git bisect start
# bad: [817c23df55148e8ba5528ab73b7a62f58680778e] Revert "x86 PAT:
remove CPA WARN_ON for zero pte"
git bisect bad 817c23df55148e8ba5528ab73b7a62f58680778e
# good: [4a6908a3a050aacc9c3a2f36b276b46c0629ad91] Linux 2.6.28
git bisect good 4a6908a3a050aacc9c3a2f36b276b46c0629ad91
# good: [b67ff8ce122f3353bd741db48ce1756c12fb5f2d] kbuild: ignore a
few files in headers_check
git bisect good b67ff8ce122f3353bd741db48ce1756c12fb5f2d
# bad: [ce279e6ec91c49f2c5f59f7492e19d39edbf8bbd] Merge
master.kernel.org:/home/rmk/linux-2.6-arm
git bisect bad ce279e6ec91c49f2c5f59f7492e19d39edbf8bbd
# good: [5fec8bdbf9a1c4df4ad3f20e52aa2d8caed490c8] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse
git bisect good 5fec8bdbf9a1c4df4ad3f20e52aa2d8caed490c8
# good: [5bb47b9ff3d16d40f8d45380b373497a545fa280] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/blackfin-2.6
git bisect good 5bb47b9ff3d16d40f8d45380b373497a545fa280
# bad: [661263b55d56365af911049f8824d3bf1a7aea85] V4L/DVB (10191a):
Update MAINTAINERS entries on media drivers
git bisect bad 661263b55d56365af911049f8824d3bf1a7aea85
# good: [8a70da82edc50aa7a4b54864babf2d72538ba1bb] wimax/i2400m: add
CREDITS and MAINTAINERS entries
git bisect good 8a70da82edc50aa7a4b54864babf2d72538ba1bb
# good: [322162a71bd9fc4edb1b11236e7bc8aa27ccac22] PCI: pciehp:
cleanup register and field definitions
git bisect good 322162a71bd9fc4edb1b11236e7bc8aa27ccac22
# good: [b13d3720ecd29d5044334fdbbae3432f26802bae] topology: Fix sparc64 build.
git bisect good b13d3720ecd29d5044334fdbbae3432f26802bae
# bad: [f6dc1e5e3d4b523e1616b43beddb04e4fb1d376a] PCI PM: Put PM
callbacks in the order of execution
git bisect bad f6dc1e5e3d4b523e1616b43beddb04e4fb1d376a
# good: [987a4c783a8bbf3baf554e6b8ff588b26e06e020] PCI: Use msleep
instead of cpu_relax during ASPM link retraining
git bisect good 987a4c783a8bbf3baf554e6b8ff588b26e06e020
# good: [734104292ff77dc71fe626b4ebd91b314547ca1b] PCI PM: Avoid
touching devices behind bridges in unknown state
git bisect good 734104292ff77dc71fe626b4ebd91b314547ca1b
# good: [ad8cfa1defee14a5181d9b63e666318c51cfaeed] PCI PM: Call
pci_fixup_device from legacy routines
git bisect good ad8cfa1defee14a5181d9b63e666318c51cfaeed
# bad: [d67e37d7933ba3b28a63ff38c957e433aaca5dc4] PCI PM: Run default
PM callbacks for all devices using new framework
git bisect bad d67e37d7933ba3b28a63ff38c957e433aaca5dc4
# bad: [98e6e286d7b01deb7453b717aa38ebb69d6cefc0] PCI PM: Register
power state of devices during initialization
git bisect bad 98e6e286d7b01deb7453b717aa38ebb69d6cefc0
[root@vanquish::/data/shared/pxeboot/kernel.org/data]
