Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbYFTPOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbYFTPOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbYFTPNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:13:54 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39331 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834AbYFTPNw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:13:52 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 20 Jun 2008 17:13:19 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] firewire updates
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.0cd973a7161526ac@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following FireWire subsystem updates.
They fix a post 2.6.25 regression and an older panicking bug.

They also reword and reorder Kconfig menu prompts and help texts.
It's generally better to keep old prompt texts which people are used to
and may be mentioned in external documentation.  But there have been
incidents where not only endusers but even maintainers of one
distribution evidently did not understand the relationship between the
two 1394 stacks.

Shortlog, diffstat, combined diff:

Stefan Richter (9):
      firewire: don't panic on invalid AR request buffer
      firewire: fw-ohci: use of uninitialized data in AR handler
      firewire: fw-ohci: disable PHY packet reception into AR context
      firewire: fw-ohci: write selfIDBufferPtr before LinkControl.rcvSelfID
      firewire: fill_bus_reset_event needs lock protection
      firewire: fw-ohci: unify printk prefixes
      firewire: deadline for PHY config transmission
      firewire: Kconfig menu touch-up
      ieee1394: Kconfig menu touch-up

 drivers/firewire/Kconfig          |   32 ++++----
 drivers/firewire/fw-cdev.c        |    9 ++-
 drivers/firewire/fw-ohci.c        |  110 ++++++++++++++-------------
 drivers/firewire/fw-transaction.c |   52 +++++++++----
 drivers/ieee1394/Kconfig          |  118 ++++++++++++++++-------------
 5 files changed, 180 insertions(+), 141 deletions(-)


commit 9499fe2b340d19ef55c349de794db9d917e7403f
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Mon Jun 16 01:39:28 2008 +0200

    ieee1394: Kconfig menu touch-up
    
    Rename and reorder some prompts and modify some help texts.
    The result:
    
      -------------------- IEEE 1394 (FireWire) support --------------------
      *** Enable only one of the two stacks, unless you know what you are doing ***
      New FireWire stack, EXPERIMENTAL
        OHCI-1394 controllers
        Storage devices (SBP-2 protocol)
      Stable FireWire stack
        OHCI-1394 controllers
        PCILynx controller
        Storage devices (SBP-2 protocol)
          Enable replacement for physical DMA in SBP2
        IP over 1394
        raw1394 userspace interface
        video1394 userspace interface
        dv1394 userspace interface (deprecated)
        Excessive debugging output
    
    The old prompts for reference:
    
      -------------------- IEEE 1394 (FireWire) support --------------------
      IEEE 1394 (FireWire) support - alternative stack, EXPERIMENTAL
        Support for OHCI FireWire host controllers
        Support for storage devices (SBP-2 protocol driver)
      IEEE 1394 (FireWire) support
        *** Subsystem Options ***
        Excessive debugging output
        *** Controllers ***
        Texas Instruments PCILynx support
        OHCI-1394 support
        *** Protocols ***
        OHCI-1394 Video support
        SBP-2 support (Harddisks etc.)
          Enable replacement for physical DMA in SBP2
        IP over 1394
        OHCI-DV I/O support (deprecated)
        Raw IEEE1394 I/O support
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/Kconfig b/drivers/ieee1394/Kconfig
index 545663e..95f45f9 100644
--- a/drivers/ieee1394/Kconfig
+++ b/drivers/ieee1394/Kconfig
@@ -4,7 +4,7 @@ menu "IEEE 1394 (FireWire) support"
 source "drivers/firewire/Kconfig"
 
 config IEEE1394
-	tristate "IEEE 1394 (FireWire) support"
+	tristate "Stable FireWire stack"
 	depends on PCI || BROKEN
 	help
 	  IEEE 1394 describes a high performance serial bus, which is also
@@ -19,30 +19,45 @@ config IEEE1394
 	  To compile this driver as a module, say M here: the
 	  module will be called ieee1394.
 
-comment "Subsystem Options"
-	depends on IEEE1394
-
-config IEEE1394_VERBOSEDEBUG
-	bool "Excessive debugging output"
-	depends on IEEE1394
+config IEEE1394_OHCI1394
+	tristate "OHCI-1394 controllers"
+	depends on PCI && IEEE1394
 	help
-	  If you say Y here, you will get very verbose debugging logs from
-	  the subsystem which includes a dump of the header of every sent
-	  and received packet.  This can amount to a high amount of data
-	  collected in a very short time which is usually also saved to
-	  disk by the system logging daemons.
+	  Enable this driver if you have an IEEE 1394 controller based on the
+	  OHCI-1394 specification. The current driver is only tested with OHCI
+	  chipsets made by Texas Instruments and NEC. Most third-party vendors
+	  use one of these chipsets.  It should work with any OHCI-1394
+	  compliant card, however.
 
-	  Say Y if you really want or need the debugging output, everyone
-	  else says N.
+	  To compile this driver as a module, say M here: the
+	  module will be called ohci1394.
 
-comment "Controllers"
-	depends on IEEE1394
+	  NOTE:
 
-comment "Texas Instruments PCILynx requires I2C"
+	  You should only build either ohci1394 or the new firewire-ohci driver,
+	  but not both.  If you nevertheless want to install both, you should
+	  configure them only as modules and blacklist the driver(s) which you
+	  don't want to have auto-loaded.  Add either
+
+	      blacklist firewire-ohci
+	  or
+	      blacklist ohci1394
+	      blacklist video1394
+	      blacklist dv1394
+
+	  to /etc/modprobe.conf or /etc/modprobe.d/* and update modprobe.conf
+	  depending on your distribution.  The latter two modules should be
+	  blacklisted together with ohci1394 because they depend on ohci1394.
+
+	  If you have an old modprobe which doesn't implement the blacklist
+	  directive, use "install modulename /bin/true" for the modules to be
+	  blacklisted.
+
+comment "PCILynx controller requires I2C"
 	depends on IEEE1394 && I2C=n
 
 config IEEE1394_PCILYNX
-	tristate "Texas Instruments PCILynx support"
+	tristate "PCILynx controller"
 	depends on PCI && IEEE1394 && I2C
 	select I2C_ALGOBIT
 	help
@@ -57,35 +72,11 @@ config IEEE1394_PCILYNX
 	  PowerMacs G3 B&W contain the PCILynx controller.  Therefore
 	  almost everybody can say N here.
 
-config IEEE1394_OHCI1394
-	tristate "OHCI-1394 support"
-	depends on PCI && IEEE1394
-	help
-	  Enable this driver if you have an IEEE 1394 controller based on the
-	  OHCI-1394 specification. The current driver is only tested with OHCI
-	  chipsets made by Texas Instruments and NEC. Most third-party vendors
-	  use one of these chipsets.  It should work with any OHCI-1394
-	  compliant card, however.
-
-	  To compile this driver as a module, say M here: the
-	  module will be called ohci1394.
-
-comment "Protocols"
-	depends on IEEE1394
-
-config IEEE1394_VIDEO1394
-	tristate "OHCI-1394 Video support"
-	depends on IEEE1394 && IEEE1394_OHCI1394
-	help
-	  This option enables video device usage for OHCI-1394 cards.  Enable
-	  this option only if you have an IEEE 1394 video device connected to
-	  an OHCI-1394 card.
-
 comment "SBP-2 support (for storage devices) requires SCSI"
 	depends on IEEE1394 && SCSI=n
 
 config IEEE1394_SBP2
-	tristate "SBP-2 support (Harddisks etc.)"
+	tristate "Storage devices (SBP-2 protocol)"
 	depends on IEEE1394 && SCSI
 	help
 	  This option enables you to use SBP-2 devices connected to an IEEE
@@ -127,24 +118,47 @@ config IEEE1394_ETH1394
 
 	  The module is called eth1394 although it does not emulate Ethernet.
 
+config IEEE1394_RAWIO
+	tristate "raw1394 userspace interface"
+	depends on IEEE1394
+	help
+	  This option adds support for the raw1394 device file which enables
+	  direct communication of user programs with IEEE 1394 devices
+	  (isochronous and asynchronous).  Almost all application programs
+	  which access FireWire require this option.
+
+	  To compile this driver as a module, say M here: the module will be
+	  called raw1394.
+
+config IEEE1394_VIDEO1394
+	tristate "video1394 userspace interface"
+	depends on IEEE1394 && IEEE1394_OHCI1394
+	help
+	  This option adds support for the video1394 device files which enable
+	  isochronous communication of user programs with IEEE 1394 devices,
+	  especially video capture or export.  This interface is used by all
+	  libdc1394 based programs and by several other programs, in addition to
+	  the raw1394 interface.  It is generally not required for DV capture.
+
+	  To compile this driver as a module, say M here: the module will be
+	  called video1394.
+
 config IEEE1394_DV1394
-	tristate "OHCI-DV I/O support (deprecated)"
+	tristate "dv1394 userspace interface (deprecated)"
 	depends on IEEE1394 && IEEE1394_OHCI1394
 	help
 	  The dv1394 driver is unsupported and may be removed from Linux in a
 	  future release.  Its functionality is now provided by raw1394 together
 	  with libraries such as libiec61883.
 
-config IEEE1394_RAWIO
-	tristate "Raw IEEE1394 I/O support"
+config IEEE1394_VERBOSEDEBUG
+	bool "Excessive debugging output"
 	depends on IEEE1394
 	help
-	  This option adds support for the raw1394 device file which enables
-	  direct communication of user programs with the IEEE 1394 bus and thus
-	  with the attached peripherals.  Almost all application programs which
-	  access FireWire require this option.
+	  If you say Y here, you will get very verbose debugging logs from the
+	  ieee1394 drivers, including sent and received packet headers.  This
+	  will quickly result in large amounts of data sent to the system log.
 
-	  To compile this driver as a module, say M here: the module will be
-	  called raw1394.
+	  Say Y if you really need the debugging output.  Everyone else says N.
 
 endmenu

commit a7b64b8704b03c9972b114932fdf517e06153f11
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Jun 14 14:24:53 2008 +0200

    firewire: Kconfig menu touch-up
    
    Emphasize the recommendation to build only one stack.
    Trim the prompts to better fit into short attention spans.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/Kconfig b/drivers/firewire/Kconfig
index fb4d391..76f2671 100644
--- a/drivers/firewire/Kconfig
+++ b/drivers/firewire/Kconfig
@@ -1,28 +1,26 @@
-comment "An alternative FireWire stack is available with EXPERIMENTAL=y"
+comment "A new alternative FireWire stack is available with EXPERIMENTAL=y"
 	depends on EXPERIMENTAL=n
 
+comment "Enable only one of the two stacks, unless you know what you are doing"
+	depends on EXPERIMENTAL
+
 config FIREWIRE
-	tristate "IEEE 1394 (FireWire) support - alternative stack, EXPERIMENTAL"
+	tristate "New FireWire stack, EXPERIMENTAL"
 	depends on EXPERIMENTAL
 	select CRC_ITU_T
 	help
 	  This is the "Juju" FireWire stack, a new alternative implementation
 	  designed for robustness and simplicity.  You can build either this
-	  stack, or the classic stack (the ieee1394 driver, ohci1394 etc.)
-	  or both.  Please read http://wiki.linux1394.org/JujuMigration before
-	  you enable the new stack.
+	  stack, or the old stack (the ieee1394 driver, ohci1394 etc.) or both.
+	  Please read http://wiki.linux1394.org/JujuMigration before you
+	  enable the new stack.
 
 	  To compile this driver as a module, say M here: the module will be
 	  called firewire-core.  It functionally replaces ieee1394, raw1394,
 	  and video1394.
 
-          NOTE:
-
-	  You should only build ONE of the stacks, unless you REALLY know what
-	  you are doing.
-
 config FIREWIRE_OHCI
-	tristate "Support for OHCI FireWire host controllers"
+	tristate "OHCI-1394 controllers"
 	depends on PCI && FIREWIRE
 	help
 	  Enable this driver if you have a FireWire controller based
@@ -33,12 +31,12 @@ config FIREWIRE_OHCI
 	  called firewire-ohci.  It replaces ohci1394 of the classic IEEE 1394
 	  stack.
 
-          NOTE:
+	  NOTE:
 
-	  You should only build ohci1394 or firewire-ohci, but not both.
-	  If you nevertheless want to install both, you should configure them
-	  only as modules and blacklist the driver(s) which you don't want to
-	  have auto-loaded.  Add either
+	  You should only build either firewire-ohci or the old ohci1394 driver,
+	  but not both.  If you nevertheless want to install both, you should
+	  configure them only as modules and blacklist the driver(s) which you
+	  don't want to have auto-loaded.  Add either
 
 	      blacklist firewire-ohci
 	  or
@@ -60,7 +58,7 @@ config FIREWIRE_OHCI_DEBUG
 	default y
 
 config FIREWIRE_SBP2
-	tristate "Support for storage devices (SBP-2 protocol driver)"
+	tristate "Storage devices (SBP-2 protocol)"
 	depends on FIREWIRE && SCSI
 	help
 	  This option enables you to use SBP-2 devices connected to a

commit ae1e53557911d7e60a637b2400173add958aae94
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Wed Jun 18 18:20:45 2008 +0200

    firewire: deadline for PHY config transmission
    
    If the low-level driver failed to initialize a card properly without
    noticing it, fw-core was blocked indefinitely when trying to send a
    PHY config packet.  This hung up the events kernel thread, e.g. locked
    up keyboard input.
    https://bugzilla.redhat.com/show_bug.cgi?id=444694
    https://bugzilla.redhat.com/show_bug.cgi?id=446763
    
    This problem was introduced between 2.6.25 and 2.6.26-rc1 by commit
    2a0a2590498be7b92e3e76409c9b8ee722e23c8f "firewire: wait until PHY
    configuration packet was transmitted (fix bus reset loop)".
    
    The solution is to wait with timeout.  I tested it with 7 different
    working controllers and 1 non-working controller.  On the working ones,
    the packet callback complete()s usually --- but not always --- before a
    timeout of 10ms.  Hence I chose a safer timeout of 100ms.
    
    On the few tests with the non-working controller ALi M5271, PHY config
    packet transmission always timed out so far.  (Fw-ohci needs to be fixed
    for this controller independently of this deadline fix.  Often the core
    doesn't even attempt to send a phy config because not even self ID
    reception works.)
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-transaction.c b/drivers/firewire/fw-transaction.c
index 7f92c45..03ae8a7 100644
--- a/drivers/firewire/fw-transaction.c
+++ b/drivers/firewire/fw-transaction.c
@@ -20,6 +20,7 @@
 
 #include <linux/completion.h>
 #include <linux/kernel.h>
+#include <linux/kref.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -297,37 +298,55 @@ EXPORT_SYMBOL(fw_send_request);
 struct fw_phy_packet {
 	struct fw_packet packet;
 	struct completion done;
+	struct kref kref;
 };
 
-static void
-transmit_phy_packet_callback(struct fw_packet *packet,
-			     struct fw_card *card, int status)
+static void phy_packet_release(struct kref *kref)
+{
+	struct fw_phy_packet *p =
+			container_of(kref, struct fw_phy_packet, kref);
+	kfree(p);
+}
+
+static void transmit_phy_packet_callback(struct fw_packet *packet,
+					 struct fw_card *card, int status)
 {
 	struct fw_phy_packet *p =
 			container_of(packet, struct fw_phy_packet, packet);
 
 	complete(&p->done);
+	kref_put(&p->kref, phy_packet_release);
 }
 
 void fw_send_phy_config(struct fw_card *card,
 			int node_id, int generation, int gap_count)
 {
-	struct fw_phy_packet p;
+	struct fw_phy_packet *p;
+	long timeout = DIV_ROUND_UP(HZ, 10);
 	u32 data = PHY_IDENTIFIER(PHY_PACKET_CONFIG) |
 		   PHY_CONFIG_ROOT_ID(node_id) |
 		   PHY_CONFIG_GAP_COUNT(gap_count);
 
-	p.packet.header[0] = data;
-	p.packet.header[1] = ~data;
-	p.packet.header_length = 8;
-	p.packet.payload_length = 0;
-	p.packet.speed = SCODE_100;
-	p.packet.generation = generation;
-	p.packet.callback = transmit_phy_packet_callback;
-	init_completion(&p.done);
-
-	card->driver->send_request(card, &p.packet);
-	wait_for_completion(&p.done);
+	p = kmalloc(sizeof(*p), GFP_KERNEL);
+	if (p == NULL)
+		return;
+
+	p->packet.header[0] = data;
+	p->packet.header[1] = ~data;
+	p->packet.header_length = 8;
+	p->packet.payload_length = 0;
+	p->packet.speed = SCODE_100;
+	p->packet.generation = generation;
+	p->packet.callback = transmit_phy_packet_callback;
+	init_completion(&p->done);
+	kref_set(&p->kref, 2);
+
+	card->driver->send_request(card, &p->packet);
+	timeout = wait_for_completion_timeout(&p->done, timeout);
+	kref_put(&p->kref, phy_packet_release);
+
+	/* will leak p if the callback is never executed */
+	WARN_ON(timeout == 0);
 }
 
 void fw_flush_transactions(struct fw_card *card)

commit 161b96e782ec995c55843101976d9c35b57aa109
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Jun 14 14:23:43 2008 +0200

    firewire: fw-ohci: unify printk prefixes
    
    The messages which can be enabled by fw-ohci's debug module parameter
    are changed from KERN_DEBUG to KERN_NOTICE level and uniformly prefixed
    with "firewire_ohci: ".  This further simplifies communication with
    users when we ask them to capture debug messages.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 96e3cce..0b66306 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -265,27 +265,25 @@ static void log_irqs(u32 evt)
 	    !(evt & OHCI1394_busReset))
 		return;
 
-	printk(KERN_DEBUG KBUILD_MODNAME ": IRQ "
-	       "%08x%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
-	       evt,
-	       evt & OHCI1394_selfIDComplete	? " selfID"		: "",
-	       evt & OHCI1394_RQPkt		? " AR_req"		: "",
-	       evt & OHCI1394_RSPkt		? " AR_resp"		: "",
-	       evt & OHCI1394_reqTxComplete	? " AT_req"		: "",
-	       evt & OHCI1394_respTxComplete	? " AT_resp"		: "",
-	       evt & OHCI1394_isochRx		? " IR"			: "",
-	       evt & OHCI1394_isochTx		? " IT"			: "",
-	       evt & OHCI1394_postedWriteErr	? " postedWriteErr"	: "",
-	       evt & OHCI1394_cycleTooLong	? " cycleTooLong"	: "",
-	       evt & OHCI1394_cycle64Seconds	? " cycle64Seconds"	: "",
-	       evt & OHCI1394_regAccessFail	? " regAccessFail"	: "",
-	       evt & OHCI1394_busReset		? " busReset"		: "",
-	       evt & ~(OHCI1394_selfIDComplete | OHCI1394_RQPkt |
-		       OHCI1394_RSPkt | OHCI1394_reqTxComplete |
-		       OHCI1394_respTxComplete | OHCI1394_isochRx |
-		       OHCI1394_isochTx | OHCI1394_postedWriteErr |
-		       OHCI1394_cycleTooLong | OHCI1394_cycle64Seconds |
-		       OHCI1394_regAccessFail | OHCI1394_busReset)
+	fw_notify("IRQ %08x%s%s%s%s%s%s%s%s%s%s%s%s%s\n", evt,
+	    evt & OHCI1394_selfIDComplete	? " selfID"		: "",
+	    evt & OHCI1394_RQPkt		? " AR_req"		: "",
+	    evt & OHCI1394_RSPkt		? " AR_resp"		: "",
+	    evt & OHCI1394_reqTxComplete	? " AT_req"		: "",
+	    evt & OHCI1394_respTxComplete	? " AT_resp"		: "",
+	    evt & OHCI1394_isochRx		? " IR"			: "",
+	    evt & OHCI1394_isochTx		? " IT"			: "",
+	    evt & OHCI1394_postedWriteErr	? " postedWriteErr"	: "",
+	    evt & OHCI1394_cycleTooLong		? " cycleTooLong"	: "",
+	    evt & OHCI1394_cycle64Seconds	? " cycle64Seconds"	: "",
+	    evt & OHCI1394_regAccessFail	? " regAccessFail"	: "",
+	    evt & OHCI1394_busReset		? " busReset"		: "",
+	    evt & ~(OHCI1394_selfIDComplete | OHCI1394_RQPkt |
+		    OHCI1394_RSPkt | OHCI1394_reqTxComplete |
+		    OHCI1394_respTxComplete | OHCI1394_isochRx |
+		    OHCI1394_isochTx | OHCI1394_postedWriteErr |
+		    OHCI1394_cycleTooLong | OHCI1394_cycle64Seconds |
+		    OHCI1394_regAccessFail | OHCI1394_busReset)
 						? " ?"			: "");
 }
 
@@ -308,23 +306,22 @@ static void log_selfids(int node_id, int generation, int self_id_count, u32 *s)
 	if (likely(!(param_debug & OHCI_PARAM_DEBUG_SELFIDS)))
 		return;
 
-	printk(KERN_DEBUG KBUILD_MODNAME ": %d selfIDs, generation %d, "
-	       "local node ID %04x\n", self_id_count, generation, node_id);
+	fw_notify("%d selfIDs, generation %d, local node ID %04x\n",
+		  self_id_count, generation, node_id);
 
 	for (; self_id_count--; ++s)
 		if ((*s & 1 << 23) == 0)
-			printk(KERN_DEBUG "selfID 0: %08x, phy %d [%c%c%c] "
-			       "%s gc=%d %s %s%s%s\n",
-			       *s, *s >> 24 & 63, _p(s, 6), _p(s, 4), _p(s, 2),
-			       speed[*s >> 14 & 3], *s >> 16 & 63,
-			       power[*s >> 8 & 7], *s >> 22 & 1 ? "L" : "",
-			       *s >> 11 & 1 ? "c" : "", *s & 2 ? "i" : "");
+			fw_notify("selfID 0: %08x, phy %d [%c%c%c] "
+			    "%s gc=%d %s %s%s%s\n",
+			    *s, *s >> 24 & 63, _p(s, 6), _p(s, 4), _p(s, 2),
+			    speed[*s >> 14 & 3], *s >> 16 & 63,
+			    power[*s >> 8 & 7], *s >> 22 & 1 ? "L" : "",
+			    *s >> 11 & 1 ? "c" : "", *s & 2 ? "i" : "");
 		else
-			printk(KERN_DEBUG "selfID n: %08x, phy %d "
-			       "[%c%c%c%c%c%c%c%c]\n",
-			       *s, *s >> 24 & 63,
-			       _p(s, 16), _p(s, 14), _p(s, 12), _p(s, 10),
-			       _p(s,  8), _p(s,  6), _p(s,  4), _p(s,  2));
+			fw_notify("selfID n: %08x, phy %d [%c%c%c%c%c%c%c%c]\n",
+			    *s, *s >> 24 & 63,
+			    _p(s, 16), _p(s, 14), _p(s, 12), _p(s, 10),
+			    _p(s,  8), _p(s,  6), _p(s,  4), _p(s,  2));
 }
 
 static const char *evts[] = {
@@ -373,15 +370,14 @@ static void log_ar_at_event(char dir, int speed, u32 *header, int evt)
 			evt = 0x1f;
 
 	if (evt == OHCI1394_evt_bus_reset) {
-		printk(KERN_DEBUG "A%c evt_bus_reset, generation %d\n",
-		       dir, (header[2] >> 16) & 0xff);
+		fw_notify("A%c evt_bus_reset, generation %d\n",
+		    dir, (header[2] >> 16) & 0xff);
 		return;
 	}
 
 	if (header[0] == ~header[1]) {
-		printk(KERN_DEBUG "A%c %s, %s, %08x\n",
-		       dir, evts[evt], phys[header[0] >> 30 & 0x3],
-		       header[0]);
+		fw_notify("A%c %s, %s, %08x\n",
+		    dir, evts[evt], phys[header[0] >> 30 & 0x3], header[0]);
 		return;
 	}
 
@@ -400,24 +396,23 @@ static void log_ar_at_event(char dir, int speed, u32 *header, int evt)
 
 	switch (tcode) {
 	case 0xe: case 0xa:
-		printk(KERN_DEBUG "A%c %s, %s\n",
-		       dir, evts[evt], tcodes[tcode]);
+		fw_notify("A%c %s, %s\n", dir, evts[evt], tcodes[tcode]);
 		break;
 	case 0x0: case 0x1: case 0x4: case 0x5: case 0x9:
-		printk(KERN_DEBUG "A%c spd %x tl %02x, "
-		       "%04x -> %04x, %s, "
-		       "%s, %04x%08x%s\n",
-		       dir, speed, header[0] >> 10 & 0x3f,
-		       header[1] >> 16, header[0] >> 16, evts[evt],
-		       tcodes[tcode], header[1] & 0xffff, header[2], specific);
+		fw_notify("A%c spd %x tl %02x, "
+		    "%04x -> %04x, %s, "
+		    "%s, %04x%08x%s\n",
+		    dir, speed, header[0] >> 10 & 0x3f,
+		    header[1] >> 16, header[0] >> 16, evts[evt],
+		    tcodes[tcode], header[1] & 0xffff, header[2], specific);
 		break;
 	default:
-		printk(KERN_DEBUG "A%c spd %x tl %02x, "
-		       "%04x -> %04x, %s, "
-		       "%s%s\n",
-		       dir, speed, header[0] >> 10 & 0x3f,
-		       header[1] >> 16, header[0] >> 16, evts[evt],
-		       tcodes[tcode], specific);
+		fw_notify("A%c spd %x tl %02x, "
+		    "%04x -> %04x, %s, "
+		    "%s%s\n",
+		    dir, speed, header[0] >> 10 & 0x3f,
+		    header[1] >> 16, header[0] >> 16, evts[evt],
+		    tcodes[tcode], specific);
 	}
 }
 

commit 5cb84067d646fa3889463129dad8b218806b4698
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Fri Jun 6 22:11:30 2008 +0200

    firewire: fill_bus_reset_event needs lock protection
    
    Callers of fill_bus_reset_event() have to take card->lock.  Otherwise
    access to node data may oops if node removal is in progress.
    
    A lockless alternative would be
    
    -	event->local_node_id = card->local_node->node_id;
    +	tmp = fw_node_get(card->local_node);
    +	event->local_node_id = tmp->node_id;
    +	fw_node_put(tmp);
    
    and ditto with the other node pointers which fill_bus_reset_event()
    accesses.  But I went the locked route because one of the two callers
    already holds the lock.  As a bonus, we don't need the memory barrier
    anymore because device->generation and device->node_id are written in
    a card->lock protected section.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Kristian Høgsberg <krh@redhat.com>

diff --git a/drivers/firewire/fw-cdev.c b/drivers/firewire/fw-cdev.c
index dda1401..c639915 100644
--- a/drivers/firewire/fw-cdev.c
+++ b/drivers/firewire/fw-cdev.c
@@ -205,6 +205,7 @@ fw_device_op_read(struct file *file,
 	return dequeue_event(client, buffer, count);
 }
 
+/* caller must hold card->lock so that node pointers can be dereferenced here */
 static void
 fill_bus_reset_event(struct fw_cdev_event_bus_reset *event,
 		     struct client *client)
@@ -214,7 +215,6 @@ fill_bus_reset_event(struct fw_cdev_event_bus_reset *event,
 	event->closure	     = client->bus_reset_closure;
 	event->type          = FW_CDEV_EVENT_BUS_RESET;
 	event->generation    = client->device->generation;
-	smp_rmb();           /* node_id must not be older than generation */
 	event->node_id       = client->device->node_id;
 	event->local_node_id = card->local_node->node_id;
 	event->bm_node_id    = 0; /* FIXME: We don't track the BM. */
@@ -274,6 +274,7 @@ static int ioctl_get_info(struct client *client, void *buffer)
 {
 	struct fw_cdev_get_info *get_info = buffer;
 	struct fw_cdev_event_bus_reset bus_reset;
+	struct fw_card *card = client->device->card;
 	unsigned long ret = 0;
 
 	client->version = get_info->version;
@@ -299,13 +300,17 @@ static int ioctl_get_info(struct client *client, void *buffer)
 	client->bus_reset_closure = get_info->bus_reset_closure;
 	if (get_info->bus_reset != 0) {
 		void __user *uptr = u64_to_uptr(get_info->bus_reset);
+		unsigned long flags;
 
+		spin_lock_irqsave(&card->lock, flags);
 		fill_bus_reset_event(&bus_reset, client);
+		spin_unlock_irqrestore(&card->lock, flags);
+
 		if (copy_to_user(uptr, &bus_reset, sizeof(bus_reset)))
 			return -EFAULT;
 	}
 
-	get_info->card = client->device->card->index;
+	get_info->card = card->index;
 
 	return 0;
 }

commit affc9c24ade666f9903163c12686da567dbfe06f
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Thu Jun 5 20:50:53 2008 +0200

    firewire: fw-ohci: write selfIDBufferPtr before LinkControl.rcvSelfID
    
    OHCI 1.1 clause 5.10 requires that selfIDBufferPtr is valid when a 1 is
    written into LinkControl.rcvSelfID.
    
    This driver bug has so far not been known to cause harm because most
    chips obviously accept a later selfIDBufferPtr write, at least before
    HCControl.linkEnable is written.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>
    Signed-off-by: Kristian Høgsberg <krh@redhat.com>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 481d3f3..96e3cce 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -1473,6 +1473,7 @@ static int ohci_enable(struct fw_card *card, u32 *config_rom, size_t length)
 	reg_write(ohci, OHCI1394_HCControlClear,
 		  OHCI1394_HCControl_noByteSwapData);
 
+	reg_write(ohci, OHCI1394_SelfIDBuffer, ohci->self_id_bus);
 	reg_write(ohci, OHCI1394_LinkControlClear,
 		  OHCI1394_LinkControl_rcvPhyPkt);
 	reg_write(ohci, OHCI1394_LinkControlSet,
@@ -1488,7 +1489,6 @@ static int ohci_enable(struct fw_card *card, u32 *config_rom, size_t length)
 	ar_context_run(&ohci->ar_request_ctx);
 	ar_context_run(&ohci->ar_response_ctx);
 
-	reg_write(ohci, OHCI1394_SelfIDBuffer, ohci->self_id_bus);
 	reg_write(ohci, OHCI1394_PhyUpperBound, 0x00010000);
 	reg_write(ohci, OHCI1394_IntEventClear, ~0);
 	reg_write(ohci, OHCI1394_IntMaskClear, ~0);

commit e896ec4302f45fdaf2fc78aec0093eca5478fe28
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Thu Jun 5 20:49:38 2008 +0200

    firewire: fw-ohci: disable PHY packet reception into AR context
    
    We want the rcvPhyPkt bit in LinkControl off before we start using the
    chip.  However, the spec says that the reset value of it is undefined.
    Hence switch it explicitly off.
    
    https://bugzilla.redhat.com/show_bug.cgi?id=244576#c48 shows that for
    example the nForce2 integrated FireWire controller seems to have it on
    by default.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index b062e73..481d3f3 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -1473,6 +1473,8 @@ static int ohci_enable(struct fw_card *card, u32 *config_rom, size_t length)
 	reg_write(ohci, OHCI1394_HCControlClear,
 		  OHCI1394_HCControl_noByteSwapData);
 
+	reg_write(ohci, OHCI1394_LinkControlClear,
+		  OHCI1394_LinkControl_rcvPhyPkt);
 	reg_write(ohci, OHCI1394_LinkControlSet,
 		  OHCI1394_LinkControl_rcvSelfID |
 		  OHCI1394_LinkControl_cycleTimerEnable |

commit ccff962943df539c5860aa120eecc189d70a308b
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat May 31 19:36:06 2008 +0200

    firewire: fw-ohci: use of uninitialized data in AR handler
    
    header_length and payload_length are filled with random data if an
    unknown tcode was read from the AR buffer (i.e. if the AR buffer
    contained invalid data).
    
    We still need a better strategy to recover from this, but at least
    handle_ar_packet now doesn't return out of bound buffer addresses
    anymore.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 4f02c55..b062e73 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -548,6 +548,11 @@ static __le32 *handle_ar_packet(struct ar_context *ctx, __le32 *buffer)
 		p.header_length = 12;
 		p.payload_length = 0;
 		break;
+
+	default:
+		/* FIXME: Stop context, discard everything, and restart? */
+		p.header_length = 0;
+		p.payload_length = 0;
 	}
 
 	p.payload = (void *) buffer + p.header_length;

commit 0bf607c5b4edd13362e4add6ca1e81f8a9fbd47c
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat May 31 19:01:26 2008 +0200

    firewire: don't panic on invalid AR request buffer
    
    BUG() at this place is wrong.  (Unless if the low level driver would
    already do higher-level input validation of incoming request headers.)
    
    Invalid incoming requests or bugs in the controller which corrupt the
    AR-req buffer needlessly crashed the box because this is run in tasklet
    context.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-transaction.c b/drivers/firewire/fw-transaction.c
index ccf0e4c..7f92c45 100644
--- a/drivers/firewire/fw-transaction.c
+++ b/drivers/firewire/fw-transaction.c
@@ -572,7 +572,8 @@ allocate_request(struct fw_packet *p)
 		break;
 
 	default:
-		BUG();
+		fw_error("ERROR - corrupt request received - %08x %08x %08x\n",
+			 p->header[0], p->header[1], p->header[2]);
 		return NULL;
 	}
 

-- 
Stefan Richter
-=====-==--- -==- =-=--
http://arcgraph.de/sr/



