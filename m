Return-Path: <linux-kernel-owner+w=401wt.eu-S933551AbXF2PmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551AbXF2PmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 11:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763529AbXF2PmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 11:42:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47806 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762436AbXF2PmH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 11:42:07 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 29 Jun 2007 17:41:48 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] ieee1394 fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.feae9f37e6769ed7@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following updates.

Stefan Richter (2):
      firewire: fix async reception on big endian machines
      firewire: add Kconfig help on building both stacks


 drivers/firewire/Kconfig   |   65 +++++++++++++++++++++++------------
 drivers/firewire/fw-ohci.c |    6 ++--
 2 files changed, 46 insertions(+), 25 deletions(-)


commit 0a9972baa7454c747fd5f67ce864420dff99d383
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Jun 23 20:28:17 2007 +0200

    firewire: fix async reception on big endian machines
    
    descriptor.data_address is little endian
    
    Tested-by: Olaf Hering <olh@suse.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Kristian Høgsberg <krh@redhat.com>
---

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index b72a5c1..96c8ac5 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -373,8 +373,8 @@ static void ar_context_tasklet(unsigned long data)
 
 		offset = offsetof(struct ar_buffer, data);
 		dma_unmap_single(ohci->card.device,
-				 ab->descriptor.data_address - offset,
-				 PAGE_SIZE, DMA_BIDIRECTIONAL);
+			le32_to_cpu(ab->descriptor.data_address) - offset,
+			PAGE_SIZE, DMA_BIDIRECTIONAL);
 
 		buffer = ab;
 		ab = ab->next;
@@ -427,7 +427,7 @@ static void ar_context_run(struct ar_context *ctx)
 	size_t offset;
 
 	offset = offsetof(struct ar_buffer, data);
-	ab_bus = ab->descriptor.data_address - offset;
+	ab_bus = le32_to_cpu(ab->descriptor.data_address) - offset;
 
 	reg_write(ctx->ohci, COMMAND_PTR(ctx->regs), ab_bus | 1);
 	reg_write(ctx->ohci, CONTROL_SET(ctx->regs), CONTEXT_RUN);


commit fe77d4f283e840879f0e23b86a5d6a486823fdef
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Mon Jun 25 22:18:40 2007 +0200

    firewire: add Kconfig help on building both stacks
    
    Alas that won't work so good, because nobody reads help texts.
    
    I thought about adding some crude multiple choice selection (build the
    old stack, build the new stack, build both stacks).  It's possible, but
    it would introduce awkward dummy config variables.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

diff --git a/drivers/firewire/Kconfig b/drivers/firewire/Kconfig
index 396dade..d011a76 100644
--- a/drivers/firewire/Kconfig
+++ b/drivers/firewire/Kconfig
@@ -4,27 +4,44 @@ comment "An alternative FireWire stack is available with EXPERIMENTAL=y"
 	depends on EXPERIMENTAL=n
 
 config FIREWIRE
-	tristate "IEEE 1394 (FireWire) support (JUJU alternative stack, experimental)"
+	tristate "IEEE 1394 (FireWire) support - alternative stack, EXPERIMENTAL"
 	depends on EXPERIMENTAL
 	select CRC_ITU_T
 	help
-	  IEEE 1394 describes a high performance serial bus, which is also
-	  known as FireWire(tm) or i.Link(tm) and is used for connecting all
-	  sorts of devices (most notably digital video cameras) to your
-	  computer.
-
-	  If you have FireWire hardware and want to use it, say Y here.  This
-	  is the core support only, you will also need to select a driver for
-	  your IEEE 1394 adapter.
-
-	  To compile this driver as a module, say M here: the module will be
-	  called firewire-core.
-
-	  This is the "JUJU" FireWire stack, an alternative implementation
+	  This is the "Juju" FireWire stack, a new alternative implementation
 	  designed for robustness and simplicity.  You can build either this
 	  stack, or the classic stack (the ieee1394 driver, ohci1394 etc.)
 	  or both.
 
+	  To compile this driver as a module, say M here: the module will be
+	  called firewire-core.  It functionally replaces ieee1394, raw1394,
+	  and video1394.
+
+          NOTE:
+
+	  You should only build ONE of the stacks, unless you REALLY know what
+	  you are doing.  If you install both, you should configure them only as
+	  modules rather than link them statically, and you should blacklist one
+	  of the concurrent low-level drivers in /etc/modprobe.conf.  Add either
+
+	      blacklist firewire-ohci
+	  or
+	      blacklist ohci1394
+
+	  there depending on which driver you DON'T want to have auto-loaded.
+	  You can optionally do the same with the other IEEE 1394/ FireWire
+	  drivers.
+
+	  If you have an old modprobe which doesn't implement the blacklist
+	  directive, use either
+
+	       install firewire-ohci /bin/true
+	  or
+	       install ohci1394 /bin/true
+
+	  and so on, depending on which modules you DON't want to have
+	  auto-loaded.
+
 config FIREWIRE_OHCI
 	tristate "Support for OHCI FireWire host controllers"
 	depends on PCI && FIREWIRE
@@ -34,11 +51,13 @@ config FIREWIRE_OHCI
 	  is the only chipset in use, so say Y here.
 
 	  To compile this driver as a module, say M here:  The module will be
-	  called firewire-ohci.
+	  called firewire-ohci.  It replaces ohci1394 of the classic IEEE 1394
+	  stack.
+
+          NOTE:
 
-	  If you also build ohci1394 of the classic IEEE 1394 driver stack,
-	  blacklist either ohci1394 or firewire-ohci to let hotplug load the
-	  desired driver.
+	  If you also build ohci1394 of the classic stack, blacklist either
+	  ohci1394 or firewire-ohci to let hotplug load only the desired driver.
 
 config FIREWIRE_SBP2
 	tristate "Support for storage devices (SBP-2 protocol driver)"
@@ -50,12 +69,14 @@ config FIREWIRE_SBP2
 	  like scanners.
 
 	  To compile this driver as a module, say M here:  The module will be
-	  called firewire-sbp2.
+	  called firewire-sbp2.  It replaces sbp2 of the classic IEEE 1394
+	  stack.
 
 	  You should also enable support for disks, CD-ROMs, etc. in the SCSI
 	  configuration section.
 
-	  If you also build sbp2 of the classic IEEE 1394 driver stack,
-	  blacklist either sbp2 or firewire-sbp2 to let hotplug load the
-	  desired driver.
+          NOTE:
+
+	  If you also build sbp2 of the classic stack, blacklist either sbp2
+	  or firewire-sbp2 to let hotplug load only the desired driver.
 

-- 
Stefan Richter
-=====-=-=== -==- ===-=
http://arcgraph.de/sr/

