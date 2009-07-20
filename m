Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbZGTUJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbZGTUJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbZGTUJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:09:53 -0400
Received: from mail.windriver.com ([147.11.1.11]:36170 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbZGTUJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:09:44 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       dbrownell@users.sourceforge.net, Alan Stern <stern@rowland.harvard.edu>,
       Sarah Sharp <sarah.a.sharp@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 0/10] x86: EHCI and earlyprintk= improvements
Date: Mon, 20 Jul 2009 15:06:22 -0500
Message-Id: <1248120392-8372-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.0.3.523.g304d0
X-OriginalArrivalTime: 20 Jul 2009 20:06:36.0425 (UTC) FILETIME=[95E70790:01CA0975]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch series against the 2.6.31-rc3 covers improving the
reliability of earlyprintk when using a usb debug device connected to
an EHCI debug controller.

The only patch that is not directly related to the USB earlyprintk is
the 5th in the series which changes the console registration such that
you can have more than one earlyprintk device.  It is plausible to
drop this patch if folks object to the idea or implementation.

These patches were heavily test on 12 different systems with a total
of 7 different EHCI controllers on both the x86_64 and i386
architectures.

The series starts by moving the EHCI debug code out of the
arch/x86/kernel/early_printk.c and over to under the
drivers/usb/early/ehci-dbgp.c.  It is plausible to use this code on
other architectures beyond x86.  This also allows the earlyprintk.c to
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

The following changes since commit 78af08d90b8f745044b1274430bc4bc6b2b27aca:
  Linus Torvalds (1):
        Merge branch 'drm-fixes' of git://git.kernel.org/.../airlied/drm-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_gregkh_2

Jason Wessel (10):
      ehci early_printk: split ehci debug driver from early_printk.c
      usb,early_printk: insert cr prior to nl as needed
      ehci-dbgp: Execute early BIOS hand off
      usb,early_printk: EHCI debug controller initialization delays
      printk,early_printk,console: Allow more than one early console
      ehci-dbgp: stability improvements and external re-init
      ehci-dbgp,ehci: Allow early or late use of the dbgp device
      ehci-dbgp: errata for EHCI debug controller initialization
      ehci-dbgp: errata for EHCI debug/host controller synchronization
      ehci-dbgp,documentation: Documentation updates for ehci-dbgp


 Documentation/kernel-parameters.txt |    2 +-
 Documentation/x86/earlyprintk.txt   |   39 ++-
 arch/x86/kernel/early_printk.c      |  780 ++--------------------------
 drivers/usb/Makefile                |    1 +
 drivers/usb/early/Makefile          |    5 +
 drivers/usb/early/ehci-dbgp.c       |  996 +++++++++++++++++++++++++++++++++++
 drivers/usb/host/ehci-hcd.c         |   33 ++-
 drivers/usb/host/ehci-hub.c         |   10 +
 drivers/usb/host/ehci-pci.c         |   20 -
 include/linux/usb/ehci_def.h        |   13 +
 kernel/printk.c                     |   41 +-
 11 files changed, 1154 insertions(+), 786 deletions(-)
 create mode 100644 drivers/usb/early/Makefile
 create mode 100644 drivers/usb/early/ehci-dbgp.c
