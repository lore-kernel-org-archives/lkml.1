Return-Path: <linux-kernel-owner+w=401wt.eu-S1754457AbZHTUj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbZHTUj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 16:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbZHTUj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 16:39:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:50872 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbZHTUj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 16:39:57 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/11] V3 - x86: EHCI and earlyprintk= improvements
Date: Thu, 20 Aug 2009 15:39:47 -0500
Message-Id: <1250800798-31559-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
X-OriginalArrivalTime: 20 Aug 2009 20:39:55.0444 (UTC) FILETIME=[60375F40:01CA21D6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were some conflicts in the linux-next tree which caused a 3rd spin of this patch set.

Since the v2 patches were posted here are the changes:

1) Patch 1 was fixed to build the drivers/usb/Makefile builds the
   early dir unconditionally because code can live in it which does
   not actually require the usb stack.

2) Patch 5 in the series had the printk & CON_BOOT logic removed
   because it is implemented a different way in forth coming patches
   in the tip branch.

3) Patch 11 was added to allow the dbgp device to survive a suspend / resume

--

This patch series against the 2.6.31-rc6 covers improving the
reliability of earlyprintk when using a usb debug device connected to
an EHCI debug controller.

The only patch that is not directly related to the USB earlyprintk is
the 5th in the series which changes the early console registration
such that you can have more than one earlyprintk device. It is
plausible to drop this patch if folks object to the idea or
implementation.

These patches were heavily test on 12 different systems with a total
of 7 different EHCI controllers on both the x86_64 and i386
architectures.

The series starts by moving the EHCI debug code out of the
arch/x86/kernel/early_printk.c and over to under the
drivers/usb/early/ehci-dbgp.c. It is plausible to use this code on
other architectures beyond x86. This also allows the earlyprintk.c to
stay a bit cleaner, since it is primarily intended to handle the
"earlyprintk=" setup.

The other key changes are:
* Update the documentation to reflect the usage constraints
* The earlyprintk=keep,... works correctly with dbgp
* Make the cr nl handling for dbgp the same as the uart drivers
* Numerous errata and initialization fixes to make the usb
debug device work with a wide range of EHCI controllers

Thanks,
Jason.

The following changes since commit 6c30c53fd5ae6a99a23ad78e90c428d2c8ffb07f:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../ryusuke/nilfs2

are available in the git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_gregkh_2

Jason Wessel (11):
      ehci,dbgp,early_printk: split ehci debug driver from early_printk.c
      dbgp: insert cr prior to nl as needed
      ehci-dbgp: Execute early BIOS hand off
      dbgp: EHCI debug controller initialization delays
      early_printk: Allow more than one early console
      ehci-dbgp: stability improvements and external re-init
      ehci-dbgp,ehci: Allow early or late use of the dbgp device
      ehci-dbgp: errata for EHCI debug controller initialization
      ehci-dbgp: errata for EHCI debug/host controller synchronization
      ehci-dbgp,documentation: Documentation updates for ehci-dbgp
      ehci-dbgp,ehci: Allow dbpg to work with suspend/resume

 Documentation/kernel-parameters.txt |    2 +-
 Documentation/x86/earlyprintk.txt   |   39 ++-
 arch/x86/kernel/early_printk.c      |  780 ++--------------------------
 drivers/usb/Makefile                |    1 +
 drivers/usb/early/Makefile          |    5 +
 drivers/usb/early/ehci-dbgp.c       |  996 +++++++++++++++++++++++++++++++++++
 drivers/usb/host/ehci-hcd.c         |    8 +
 drivers/usb/host/ehci-hub.c         |   17 +
 drivers/usb/host/ehci-pci.c         |   39 +-
 include/linux/usb/ehci_def.h        |   22 +
 10 files changed, 1139 insertions(+), 770 deletions(-)
 create mode 100644 drivers/usb/early/Makefile
 create mode 100644 drivers/usb/early/ehci-dbgp.c
