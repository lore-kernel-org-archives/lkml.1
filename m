Return-Path: <linux-kernel-owner+w=401wt.eu-S1753094AbZLaS4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbZLaS4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 13:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZLaS4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 13:56:20 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58895 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbZLaS4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 13:56:18 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 31 Dec 2009 19:55:49 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire fixes; new firewire stack is recommended to
 distributors and users
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.c98ccacd8716c278@s5r6.in-berlin.de>
Message-ID: <tkrat.c0cd1d998becca89@s5r6.in-berlin.de>
References: <tkrat.71d11155e1b4d897@s5r6.in-berlin.de>
 <tkrat.c98ccacd8716c278@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive a few fixes to the FireWire subsystem and a status update WRT
maintenance of the older vs. the newer FireWire driver stack.  Shortlog,
diffstat and full diffs follow below.

Distributors who still ship the old stack (ieee1394, ohci1394, raw1394,
sbp2, eth1394 and more) should now switch to the new one (firewire-core,
firewire-ohci, firewire-sbp2, firewire-net).  In the first iteration,
those distributors might want to ship the old stack also (but
blacklisted) as a fallback for their users if unforeseen problems with
the newer replacement drivers are encountered.

The older FireWire stack contains several known problems which are not
going to be fixed; instead, those issues are addressed by the new stack.
An incomplete list of these issues is kept in bugzilla:
http://bugzilla.kernel.org/show_bug.cgi?id=10046
We have a guide on migration from the older to the newer stack:
http://ieee1394.wiki.kernel.org/index.php/Juju_Migration

Thanks.


Clemens Ladisch (1):
      firewire: fix use of multiple AV/C devices, allow multiple FCP listeners

Stefan Richter (4):
      firewire: cdev: fix another memory leak in an error path
      firewire: ohci: always use packet-per-buffer mode for isochronous reception
      firewire, ieee1394: update MAINTAINERS entries
      firewire, ieee1394: update Kconfig help

 MAINTAINERS                             |   15 +---
 drivers/Kconfig                         |    2 +-
 drivers/firewire/Kconfig                |   44 +++------
 drivers/firewire/core-cdev.c            |   27 +++--
 drivers/firewire/core-transaction.c     |  118 +++++++++++++++++++----
 drivers/firewire/ohci.c                 |    4 +-
 drivers/ieee1394/Kconfig                |   59 ++++++++----
 drivers/media/dvb/firewire/firedtv-fw.c |   12 +--
 include/linux/firewire-cdev.h           |    3 +
 include/linux/firewire.h                |    4 +-
 10 files changed, 182 insertions(+), 106 deletions(-)


commit 5d7db0499e5bb13381a7fbfdd0d913b966545e75
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Dec 26 01:36:53 2009 +0100

    firewire, ieee1394: update Kconfig help
    
    Update the Kconfig help texts of both stacks to encourage a general move
    from the older to the newer drivers.  However, do not label ieee1394 as
    "Obsolete" yet, as the newer drivers have not been deployed as default
    stack in the majority of Linux distributions yet, and those who start
    doing so now may still want to install the old drivers as fallback for
    unforeseen issues.
    
    Since Linux 2.6.32, FireWire audio devices can be driven by the newer
    firewire driver stack too, hence remove an outdated comment about audio
    devices.  Also remove comments about library versions since the 2nd
    generation of libraw1394 and libdc1394 is now in common use; details on
    library versions can be read at the wiki link from the help texts.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 8a07363..368ae6d 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -28,7 +28,7 @@ source "drivers/md/Kconfig"
 
 source "drivers/message/fusion/Kconfig"
 
-source "drivers/ieee1394/Kconfig"
+source "drivers/firewire/Kconfig"
 
 source "drivers/message/i2o/Kconfig"
 
diff --git a/drivers/firewire/Kconfig b/drivers/firewire/Kconfig
index 13efcd3..a9371b3 100644
--- a/drivers/firewire/Kconfig
+++ b/drivers/firewire/Kconfig
@@ -1,5 +1,10 @@
+menu "IEEE 1394 (FireWire) support"
+	depends on PCI || BROKEN
+	# firewire-core does not depend on PCI but is
+	# not useful without PCI controller driver
+
 comment "You can enable one or both FireWire driver stacks."
-comment "See the help texts for more information."
+comment "The newer stack is recommended."
 
 config FIREWIRE
 	tristate "FireWire driver stack"
@@ -15,16 +20,6 @@ config FIREWIRE
 	  To compile this driver as a module, say M here: the module will be
 	  called firewire-core.
 
-	  This module functionally replaces ieee1394, raw1394, and video1394.
-	  To access it from application programs, you generally need at least
-	  libraw1394 v2.  IIDC/DCAM applications need libdc1394 v2.
-	  No libraries are required to access storage devices through the
-	  firewire-sbp2 driver.
-
-	  NOTE:
-	  FireWire audio devices currently require the old drivers (ieee1394,
-	  ohci1394, raw1394).
-
 config FIREWIRE_OHCI
 	tristate "OHCI-1394 controllers"
 	depends on PCI && FIREWIRE
@@ -34,22 +29,7 @@ config FIREWIRE_OHCI
 	  is the only chipset in use, so say Y here.
 
 	  To compile this driver as a module, say M here:  The module will be
-	  called firewire-ohci.  It replaces ohci1394 of the classic IEEE 1394
-	  stack.
-
-	  NOTE:
-	  If you want to install firewire-ohci and ohci1394 together, you
-	  should configure them only as modules and blacklist the driver(s)
-	  which you don't want to have auto-loaded.  Add either
-
-	      blacklist firewire-ohci
-	  or
-	      blacklist ohci1394
-	      blacklist video1394
-	      blacklist dv1394
-
-	  to /etc/modprobe.conf or /etc/modprobe.d/* and update modprobe.conf
-	  depending on your distribution.
+	  called firewire-ohci.
 
 config FIREWIRE_OHCI_DEBUG
 	bool
@@ -66,8 +46,7 @@ config FIREWIRE_SBP2
 	  like scanners.
 
 	  To compile this driver as a module, say M here:  The module will be
-	  called firewire-sbp2.  It replaces sbp2 of the classic IEEE 1394
-	  stack.
+	  called firewire-sbp2.
 
 	  You should also enable support for disks, CD-ROMs, etc. in the SCSI
 	  configuration section.
@@ -83,5 +62,8 @@ config FIREWIRE_NET
 	  NOTE, this driver is not stable yet!
 
 	  To compile this driver as a module, say M here:  The module will be
-	  called firewire-net.  It replaces eth1394 of the classic IEEE 1394
-	  stack.
+	  called firewire-net.
+
+source "drivers/ieee1394/Kconfig"
+
+endmenu
diff --git a/drivers/ieee1394/Kconfig b/drivers/ieee1394/Kconfig
index f102fcc..e02096c 100644
--- a/drivers/ieee1394/Kconfig
+++ b/drivers/ieee1394/Kconfig
@@ -1,8 +1,3 @@
-menu "IEEE 1394 (FireWire) support"
-	depends on PCI || BROKEN
-
-source "drivers/firewire/Kconfig"
-
 config IEEE1394
 	tristate "Legacy alternative FireWire driver stack"
 	depends on PCI || BROKEN
@@ -16,8 +11,13 @@ config IEEE1394
 	  is the core support only, you will also need to select a driver for
 	  your IEEE 1394 adapter.
 
-	  To compile this driver as a module, say M here: the
-	  module will be called ieee1394.
+	  To compile this driver as a module, say M here: the module will be
+	  called ieee1394.
+
+	  NOTE:
+	  ieee1394 is superseded by the newer firewire-core driver.  See
+	  http://ieee1394.wiki.kernel.org/index.php/Juju_Migration for
+	  further information on how to switch to the new FireWire drivers.
 
 config IEEE1394_OHCI1394
 	tristate "OHCI-1394 controllers"
@@ -29,19 +29,23 @@ config IEEE1394_OHCI1394
 	  use one of these chipsets.  It should work with any OHCI-1394
 	  compliant card, however.
 
-	  To compile this driver as a module, say M here: the
-	  module will be called ohci1394.
+	  To compile this driver as a module, say M here: the module will be
+	  called ohci1394.
 
 	  NOTE:
+	  ohci1394 is superseded by the newer firewire-ohci driver.  See
+	  http://ieee1394.wiki.kernel.org/index.php/Juju_Migration for
+	  further information on how to switch to the new FireWire drivers.
+
 	  If you want to install firewire-ohci and ohci1394 together, you
 	  should configure them only as modules and blacklist the driver(s)
 	  which you don't want to have auto-loaded.  Add either
 
-	      blacklist firewire-ohci
-	  or
 	      blacklist ohci1394
 	      blacklist video1394
 	      blacklist dv1394
+	  or
+	      blacklist firewire-ohci
 
 	  to /etc/modprobe.conf or /etc/modprobe.d/* and update modprobe.conf
 	  depending on your distribution.
@@ -58,8 +62,8 @@ config IEEE1394_PCILYNX
 	  Instruments PCILynx chip.  Note: this driver is written for revision
 	  2 of this chip and may not work with revision 0.
 
-	  To compile this driver as a module, say M here: the
-	  module will be called pcilynx.
+	  To compile this driver as a module, say M here: the module will be
+	  called pcilynx.
 
 	  Only some old and now very rare PCI and CardBus cards and
 	  PowerMacs G3 B&W contain the PCILynx controller.  Therefore
@@ -79,6 +83,14 @@ config IEEE1394_SBP2
 	  You should also enable support for disks, CD-ROMs, etc. in the SCSI
 	  configuration section.
 
+	  To compile this driver as a module, say M here: the module will be
+	  called sbp2.
+
+	  NOTE:
+	  sbp2 is superseded by the newer firewire-sbp2 driver. See
+	  http://ieee1394.wiki.kernel.org/index.php/Juju_Migration for
+	  further information on how to switch to the new FireWire drivers.
+
 config IEEE1394_SBP2_PHYS_DMA
 	bool "Enable replacement for physical DMA in SBP2"
 	depends on IEEE1394_SBP2 && VIRT_TO_BUS && EXPERIMENTAL
@@ -111,6 +123,11 @@ config IEEE1394_ETH1394
 
 	  The module is called eth1394 although it does not emulate Ethernet.
 
+	  NOTE:
+	  eth1394 is superseded by the newer firewire-net driver. See
+	  http://ieee1394.wiki.kernel.org/index.php/Juju_Migration for
+	  further information on how to switch to the new FireWire drivers.
+
 config IEEE1394_RAWIO
 	tristate "raw1394 userspace interface"
 	depends on IEEE1394
@@ -123,6 +140,11 @@ config IEEE1394_RAWIO
 	  To compile this driver as a module, say M here: the module will be
 	  called raw1394.
 
+	  NOTE:
+	  raw1394 is superseded by the newer firewire-core driver. See
+	  http://ieee1394.wiki.kernel.org/index.php/Juju_Migration for
+	  further information on how to switch to the new FireWire drivers.
+
 config IEEE1394_VIDEO1394
 	tristate "video1394 userspace interface"
 	depends on IEEE1394 && IEEE1394_OHCI1394
@@ -136,13 +158,18 @@ config IEEE1394_VIDEO1394
 	  To compile this driver as a module, say M here: the module will be
 	  called video1394.
 
+	  NOTE:
+	  video1394 is superseded by the newer firewire-core driver. See
+	  http://ieee1394.wiki.kernel.org/index.php/Juju_Migration for
+	  further information on how to switch to the new FireWire drivers.
+
 config IEEE1394_DV1394
 	tristate "dv1394 userspace interface (deprecated)"
 	depends on IEEE1394 && IEEE1394_OHCI1394
 	help
 	  The dv1394 driver is unsupported and may be removed from Linux in a
-	  future release.  Its functionality is now provided by raw1394 together
-	  with libraries such as libiec61883.
+	  future release.  Its functionality is now provided by either
+	  raw1394 or firewire-core together with libraries such as libiec61883.
 
 config IEEE1394_VERBOSEDEBUG
 	bool "Excessive debugging output"
@@ -153,5 +180,3 @@ config IEEE1394_VERBOSEDEBUG
 	  will quickly result in large amounts of data sent to the system log.
 
 	  Say Y if you really need the debugging output.  Everyone else says N.
-
-endmenu

commit 958a29cb1c9161d61dcd4ced51f260578e19823c
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Dec 26 01:36:12 2009 +0100

    firewire, ieee1394: update MAINTAINERS entries
    
    Ben and Kristian have not been involved in maintenance of the IEEE 1394
    drivers for quite some time; submitters are not required to Cc them on
    patches.
    
    The linux1394.org domain has been dead for a while and is no longer
    under control of a Linux developer.  The current web site of the
    Linux 1394 project is http://ieee1394.wiki.kernel.org/.
    
    The classic drivers/ieee1394/ stack is now obsolete from the development
    point of view, though still a useful alternative in productive use.  But
    nobody should attempt to submit style cleanup patches for it or to
    develop new drivers on top of this stack, hence mark its MAINTAINERS
    entry as Obsolete.
    
    drivers/ieee1394/raw1394*, like the rest of the old stack, does not
    receive bigger code changes anymore, hence shrink the MAINTAINERS
    database a bit by dropping raw1394's special entry.  If something
    important and urgent is going to come up for raw1394, I will make sure
    that Dan will be notified of it besides via linux1394-devel.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Dan Dennedy <dan@dennedy.org>
    Cc: Ben Collins <ben.collins@ubuntu.com>
    Cc: Kristian Hoegsberg <krh@bitplanet.net>

diff --git a/MAINTAINERS b/MAINTAINERS
index 66f5f7d..c22d597 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2169,10 +2169,9 @@ F:	drivers/hwmon/f75375s.c
 F:	include/linux/f75375s.h
 
 FIREWIRE SUBSYSTEM
-M:	Kristian Hoegsberg <krh@redhat.com>
 M:	Stefan Richter <stefanr@s5r6.in-berlin.de>
 L:	linux1394-devel@lists.sourceforge.net
-W:	http://www.linux1394.org/
+W:	http://ieee1394.wiki.kernel.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
 F:	drivers/firewire/
@@ -2705,22 +2704,14 @@ S:	Supported
 F:	drivers/idle/i7300_idle.c
 
 IEEE 1394 SUBSYSTEM
-M:	Ben Collins <ben.collins@ubuntu.com>
 M:	Stefan Richter <stefanr@s5r6.in-berlin.de>
 L:	linux1394-devel@lists.sourceforge.net
-W:	http://www.linux1394.org/
+W:	http://ieee1394.wiki.kernel.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
-S:	Maintained
+S:	Obsolete
 F:	Documentation/debugging-via-ohci1394.txt
 F:	drivers/ieee1394/
 
-IEEE 1394 RAW I/O DRIVER
-M:	Dan Dennedy <dan@dennedy.org>
-M:	Stefan Richter <stefanr@s5r6.in-berlin.de>
-L:	linux1394-devel@lists.sourceforge.net
-S:	Maintained
-F:	drivers/ieee1394/raw1394*
-
 IEEE 802.15.4 SUBSYSTEM
 M:	Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
 M:	Sergey Lapin <slapin@ossfans.org>

commit 090699c0530ae5380a9b8511d76f656cc437bb6e
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Dec 26 01:35:14 2009 +0100

    firewire: ohci: always use packet-per-buffer mode for isochronous reception
    
    This is a minimal change meant for the short term:  Never set the
    ohci->use_dualbuffer flag to true.
    
    There are two reasons to do so:
    
      - Packet-per-buffer mode and dual-buffer mode do not behave the same
        under certain circumstances, notably if several packets are covered
        by a single fw_cdev_iso_packet descriptor.
        http://marc.info/?l=linux1394-devel&m=124965653718313
        Therefore the driver stack should not silently choose one or the
        other mode but should leave the choice to the high-level driver
        (regardless if kernel driver or userspace driver).  Or simply always
        only offer packet-per-buffer mode, since a considerable number of
        controllers, even current ones, does not offer dual-buffer support.
    
      - Even under circumstances where packet-per-buffer mode and
        dual-buffer mode behave exactly the same --- notably when used
        through libraw1394, libdc1394, as well as the current two kernel
        drivers which use isochronous reception (firewire-net and firedtv)
        --- we are still faced with the problem that several OHCI 1.1
        controllers have bugs in dual-buffer mode.  Although it looks like
        we have identified most of those buggy controllers by now, we
        cannot be quite sure about that.
    
    So, use packet-per-buffer by default from now on.  This change should
    be followed up by a more complete solution:  Either extend the
    in-kernel API and the userspace ABI by a choice between the two IR modes
    or remove all dual-buffer related code from firewire-ohci.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 96768e1..a61571c 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2226,7 +2226,6 @@ static int ohci_queue_iso_receive_dualbuffer(struct fw_iso_context *base,
 	if (rest == 0)
 		return -EINVAL;
 
-	/* FIXME: make packet-per-buffer/dual-buffer a context option */
 	while (rest > 0) {
 		d = context_get_descriptors(&ctx->context,
 					    z + header_z, &d_bus);
@@ -2470,7 +2469,10 @@ static int __devinit pci_probe(struct pci_dev *dev,
 	}
 
 	version = reg_read(ohci, OHCI1394_Version) & 0x00ff00ff;
+#if 0
+	/* FIXME: make it a context option or remove dual-buffer mode */
 	ohci->use_dualbuffer = version >= OHCI_VERSION_1_1;
+#endif
 
 	/* dual-buffer mode is broken if more than one IR context is active */
 	if (dev->vendor == PCI_VENDOR_ID_AGERE &&

commit cf0e575dcc4cab9fd955e9bec49df7e8ee30a7cf
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Dec 26 01:34:29 2009 +0100

    firewire: cdev: fix another memory leak in an error path
    
    If copy_from_user in an FW_CDEV_IOC_SEND_RESPONSE ioctl failed, the
    fw_request pointed to by the inbound_transaction_resource is no
    longer referenced and needs to be freed.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index 2cb22d1..e6d6384 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -723,6 +723,7 @@ static int ioctl_send_response(struct client *client, void *buffer)
 		if (copy_from_user(r->data, u64_to_uptr(request->data),
 				   r->length)) {
 			ret = -EFAULT;
+			kfree(r->request);
 			goto out;
 		}
 		fw_send_response(client->device->card, r->request,

commit db5d247ae811f49185a71e703b65acad845e4b18
Author: Clemens Ladisch <cladisch@fastmail.net>
Date:   Thu Dec 24 12:05:58 2009 +0100

    firewire: fix use of multiple AV/C devices, allow multiple FCP listeners
    
    Control of more than one AV/C device at once --- e.g. camcorders, tape
    decks, audio devices, TV tuners --- failed or worked only unreliably,
    depending on driver implementation.  This affected kernelspace and
    userspace drivers alike and was caused by firewire-core's inability to
    accept multiple registrations of FCP listeners.
    
    The fix allows multiple address handlers to be registered for the FCP
    command and response registers.  When a request for these registers is
    received, all handlers are invoked, and the Firewire response is
    generated by the core and not by any handler.
    
    The cdev API does not change, i.e., userspace is still expected to send
    a response for FCP requests; this response is silently ignored.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (changelog, rebased, whitespace)

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index 231e6ee..2cb22d1 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -601,8 +601,9 @@ static void release_request(struct client *client,
 	struct inbound_transaction_resource *r = container_of(resource,
 			struct inbound_transaction_resource, resource);
 
-	fw_send_response(client->device->card, r->request,
-			 RCODE_CONFLICT_ERROR);
+	if (r->request)
+		fw_send_response(client->device->card, r->request,
+				 RCODE_CONFLICT_ERROR);
 	kfree(r);
 }
 
@@ -645,7 +646,8 @@ static void handle_request(struct fw_card *card, struct fw_request *request,
  failed:
 	kfree(r);
 	kfree(e);
-	fw_send_response(card, request, RCODE_CONFLICT_ERROR);
+	if (request)
+		fw_send_response(card, request, RCODE_CONFLICT_ERROR);
 }
 
 static void release_address_handler(struct client *client,
@@ -715,15 +717,17 @@ static int ioctl_send_response(struct client *client, void *buffer)
 
 	r = container_of(resource, struct inbound_transaction_resource,
 			 resource);
-	if (request->length < r->length)
-		r->length = request->length;
-
-	if (copy_from_user(r->data, u64_to_uptr(request->data), r->length)) {
-		ret = -EFAULT;
-		goto out;
+	if (r->request) {
+		if (request->length < r->length)
+			r->length = request->length;
+		if (copy_from_user(r->data, u64_to_uptr(request->data),
+				   r->length)) {
+			ret = -EFAULT;
+			goto out;
+		}
+		fw_send_response(client->device->card, r->request,
+				 request->rcode);
 	}
-
-	fw_send_response(client->device->card, r->request, request->rcode);
  out:
 	kfree(r);
 
diff --git a/drivers/firewire/core-transaction.c b/drivers/firewire/core-transaction.c
index 842739d..495849e 100644
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -432,14 +432,20 @@ static struct fw_address_handler *lookup_overlapping_address_handler(
 	return NULL;
 }
 
+static bool is_enclosing_handler(struct fw_address_handler *handler,
+				 unsigned long long offset, size_t length)
+{
+	return handler->offset <= offset &&
+		offset + length <= handler->offset + handler->length;
+}
+
 static struct fw_address_handler *lookup_enclosing_address_handler(
 	struct list_head *list, unsigned long long offset, size_t length)
 {
 	struct fw_address_handler *handler;
 
 	list_for_each_entry(handler, list, link) {
-		if (handler->offset <= offset &&
-		    offset + length <= handler->offset + handler->length)
+		if (is_enclosing_handler(handler, offset, length))
 			return handler;
 	}
 
@@ -465,6 +471,12 @@ const struct fw_address_region fw_unit_space_region =
 	{ .start = 0xfffff0000900ULL, .end = 0x1000000000000ULL, };
 #endif  /*  0  */
 
+static bool is_in_fcp_region(u64 offset, size_t length)
+{
+	return offset >= (CSR_REGISTER_BASE | CSR_FCP_COMMAND) &&
+		offset + length <= (CSR_REGISTER_BASE | CSR_FCP_END);
+}
+
 /**
  * fw_core_add_address_handler - register for incoming requests
  * @handler: callback
@@ -477,8 +489,11 @@ const struct fw_address_region fw_unit_space_region =
  * give the details of the particular request.
  *
  * Return value:  0 on success, non-zero otherwise.
+ *
  * The start offset of the handler's address region is determined by
  * fw_core_add_address_handler() and is returned in handler->offset.
+ *
+ * Address allocations are exclusive, except for the FCP registers.
  */
 int fw_core_add_address_handler(struct fw_address_handler *handler,
 				const struct fw_address_region *region)
@@ -498,10 +513,12 @@ int fw_core_add_address_handler(struct fw_address_handler *handler,
 
 	handler->offset = region->start;
 	while (handler->offset + handler->length <= region->end) {
-		other =
-		    lookup_overlapping_address_handler(&address_handler_list,
-						       handler->offset,
-						       handler->length);
+		if (is_in_fcp_region(handler->offset, handler->length))
+			other = NULL;
+		else
+			other = lookup_overlapping_address_handler
+					(&address_handler_list,
+					 handler->offset, handler->length);
 		if (other != NULL) {
 			handler->offset += other->length;
 		} else {
@@ -668,6 +685,9 @@ static struct fw_request *allocate_request(struct fw_packet *p)
 void fw_send_response(struct fw_card *card,
 		      struct fw_request *request, int rcode)
 {
+	if (WARN_ONCE(!request, "invalid for FCP address handlers"))
+		return;
+
 	/* unified transaction or broadcast transaction: don't respond */
 	if (request->ack != ACK_PENDING ||
 	    HEADER_DESTINATION_IS_BROADCAST(request->request_header[0])) {
@@ -686,26 +706,15 @@ void fw_send_response(struct fw_card *card,
 }
 EXPORT_SYMBOL(fw_send_response);
 
-void fw_core_handle_request(struct fw_card *card, struct fw_packet *p)
+static void handle_exclusive_region_request(struct fw_card *card,
+					    struct fw_packet *p,
+					    struct fw_request *request,
+					    unsigned long long offset)
 {
 	struct fw_address_handler *handler;
-	struct fw_request *request;
-	unsigned long long offset;
 	unsigned long flags;
 	int tcode, destination, source;
 
-	if (p->ack != ACK_PENDING && p->ack != ACK_COMPLETE)
-		return;
-
-	request = allocate_request(p);
-	if (request == NULL) {
-		/* FIXME: send statically allocated busy packet. */
-		return;
-	}
-
-	offset      =
-		((unsigned long long)
-		 HEADER_GET_OFFSET_HIGH(p->header[1]) << 32) | p->header[2];
 	tcode       = HEADER_GET_TCODE(p->header[0]);
 	destination = HEADER_GET_DESTINATION(p->header[0]);
 	source      = HEADER_GET_SOURCE(p->header[1]);
@@ -732,6 +741,73 @@ void fw_core_handle_request(struct fw_card *card, struct fw_packet *p)
 					  request->data, request->length,
 					  handler->callback_data);
 }
+
+static void handle_fcp_region_request(struct fw_card *card,
+				      struct fw_packet *p,
+				      struct fw_request *request,
+				      unsigned long long offset)
+{
+	struct fw_address_handler *handler;
+	unsigned long flags;
+	int tcode, destination, source;
+
+	if ((offset != (CSR_REGISTER_BASE | CSR_FCP_COMMAND) &&
+	     offset != (CSR_REGISTER_BASE | CSR_FCP_RESPONSE)) ||
+	    request->length > 0x200) {
+		fw_send_response(card, request, RCODE_ADDRESS_ERROR);
+
+		return;
+	}
+
+	tcode       = HEADER_GET_TCODE(p->header[0]);
+	destination = HEADER_GET_DESTINATION(p->header[0]);
+	source      = HEADER_GET_SOURCE(p->header[1]);
+
+	if (tcode != TCODE_WRITE_QUADLET_REQUEST &&
+	    tcode != TCODE_WRITE_BLOCK_REQUEST) {
+		fw_send_response(card, request, RCODE_TYPE_ERROR);
+
+		return;
+	}
+
+	spin_lock_irqsave(&address_handler_lock, flags);
+	list_for_each_entry(handler, &address_handler_list, link) {
+		if (is_enclosing_handler(handler, offset, request->length))
+			handler->address_callback(card, NULL, tcode,
+						  destination, source,
+						  p->generation, p->speed,
+						  offset, request->data,
+						  request->length,
+						  handler->callback_data);
+	}
+	spin_unlock_irqrestore(&address_handler_lock, flags);
+
+	fw_send_response(card, request, RCODE_COMPLETE);
+}
+
+void fw_core_handle_request(struct fw_card *card, struct fw_packet *p)
+{
+	struct fw_request *request;
+	unsigned long long offset;
+
+	if (p->ack != ACK_PENDING && p->ack != ACK_COMPLETE)
+		return;
+
+	request = allocate_request(p);
+	if (request == NULL) {
+		/* FIXME: send statically allocated busy packet. */
+		return;
+	}
+
+	offset = ((u64)HEADER_GET_OFFSET_HIGH(p->header[1]) << 32) |
+		p->header[2];
+
+	if (!is_in_fcp_region(offset, request->length))
+		handle_exclusive_region_request(card, p, request, offset);
+	else
+		handle_fcp_region_request(card, p, request, offset);
+
+}
 EXPORT_SYMBOL(fw_core_handle_request);
 
 void fw_core_handle_response(struct fw_card *card, struct fw_packet *p)
diff --git a/drivers/media/dvb/firewire/firedtv-fw.c b/drivers/media/dvb/firewire/firedtv-fw.c
index fe44789..6223bf0 100644
--- a/drivers/media/dvb/firewire/firedtv-fw.c
+++ b/drivers/media/dvb/firewire/firedtv-fw.c
@@ -202,14 +202,8 @@ static void handle_fcp(struct fw_card *card, struct fw_request *request,
 	unsigned long flags;
 	int su;
 
-	if ((tcode != TCODE_WRITE_QUADLET_REQUEST &&
-	     tcode != TCODE_WRITE_BLOCK_REQUEST) ||
-	    offset != CSR_REGISTER_BASE + CSR_FCP_RESPONSE ||
-	    length == 0 ||
-	    (((u8 *)payload)[0] & 0xf0) != 0) {
-		fw_send_response(card, request, RCODE_TYPE_ERROR);
+	if (length < 2 || (((u8 *)payload)[0] & 0xf0) != 0)
 		return;
-	}
 
 	su = ((u8 *)payload)[1] & 0x7;
 
@@ -230,10 +224,8 @@ static void handle_fcp(struct fw_card *card, struct fw_request *request,
 	}
 	spin_unlock_irqrestore(&node_list_lock, flags);
 
-	if (fdtv) {
+	if (fdtv)
 		avc_recv(fdtv, payload, length);
-		fw_send_response(card, request, RCODE_COMPLETE);
-	}
 }
 
 static struct fw_address_handler fcp_handler = {
diff --git a/include/linux/firewire-cdev.h b/include/linux/firewire-cdev.h
index c6b3ca3..1f716d9 100644
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -340,6 +340,9 @@ struct fw_cdev_send_response {
  * The @closure field is passed back to userspace in the response event.
  * The @handle field is an out parameter, returning a handle to the allocated
  * range to be used for later deallocation of the range.
+ *
+ * The address range is allocated on all local nodes.  The address allocation
+ * is exclusive except for the FCP command and response registers.
  */
 struct fw_cdev_allocate {
 	__u64 offset;
diff --git a/include/linux/firewire.h b/include/linux/firewire.h
index 9416a46..a0e6715 100644
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -248,8 +248,8 @@ typedef void (*fw_transaction_callback_t)(struct fw_card *card, int rcode,
 					  void *data, size_t length,
 					  void *callback_data);
 /*
- * Important note:  The callback must guarantee that either fw_send_response()
- * or kfree() is called on the @request.
+ * Important note:  Except for the FCP registers, the callback must guarantee
+ * that either fw_send_response() or kfree() is called on the @request.
  */
 typedef void (*fw_address_callback_t)(struct fw_card *card,
 				      struct fw_request *request,


-- 
Stefan Richter
-=====-==--= ==-- =====
http://arcgraph.de/sr/

