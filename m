Return-Path: <linux-kernel-owner+w=401wt.eu-S965625AbXIGRE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965625AbXIGRE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 13:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965315AbXIGREt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 13:04:49 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34105 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965313AbXIGREs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 13:04:48 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 7 Sep 2007 19:04:02 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] FireWire fix
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
Message-ID: <tkrat.9f3ebd038aa685a2@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive a fix of the laptop-refuses-to-suspend kind. Or simply apply
the patch from this mail.


There is still an old underlying oddness though which I ask the PPC
folks to investigate and possibly fix post 2.6.23:  On iBook G3 and
older PowerBooks, the onboard FireWire controller's pci_dev
current_state remains PCI_UNKNOWN long after initialization. Sounds like
a bug in platform code to me.


Stat, log, diff:

 drivers/firewire/fw-ohci.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

commit 5511142870046a7bed947d51ec9b320856ee120a
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Thu Sep 6 09:50:30 2007 +0200

    firewire: fw-ohci: ignore failure of pci_set_power_state (fix suspend regression)
    
    Fixes (papers over) "Sleep problems with kernels >= 2.6.21 on powerpc",
    http://lkml.org/lkml/2007/8/25/155.  The issue is that the FireWire
    controller's pci_dev.current_state of iBook G3 and presumably older
    PowerBooks is still in PCI_UNKNOWN instead of PCI_D0 when the firewire
    driver's .suspend method is called.
    
    Like it was suggested earlier in http://lkml.org/lkml/2006/10/24/13, we
    do not fail .suspend anymore if pci_set_power_state failed.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 7e427b4..e14c1ca 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -1945,10 +1945,8 @@ static int pci_suspend(struct pci_dev *pdev, pm_message_t state)
 		return err;
 	}
 	err = pci_set_power_state(pdev, pci_choose_state(pdev, state));
-	if (err) {
-		fw_error("pci_set_power_state failed\n");
-		return err;
-	}
+	if (err)
+		fw_error("pci_set_power_state failed with %d\n", err);
 
 	return 0;
 }

-- 
Stefan Richter
-=====-=-=== =--= --===
http://arcgraph.de/sr/

