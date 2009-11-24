Return-Path: <linux-kernel-owner+w=401wt.eu-S933654AbZKXRfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933654AbZKXRfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 12:35:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933596AbZKXRfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 12:35:08 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:55936 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933594AbZKXRfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 12:35:07 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 24 Nov 2009 18:34:56 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: What's in linux1394-2.6.git?
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.bf76c8414f032885@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a summary of what is currently queued up in

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git

and also visible in linux-next.  Gitweb:

    http://git.kernel.org/?p=linux/kernel/git/ieee1394/linux1394-2.6.git


fixes branch
============

These are two fixes which make the new firewire driver stack
interoperable with FFADO, the userspace drivers for FireWire audio
interfaces.  I will ask Linus to pull this branch later this week, in
hope to get these fixes released in 2.6.32.

In addition to these two kernel fixes, there are also some updates to
the firewire-core backend of libraw1394 necessary to make it work with
FFADO.  At the moment these proposed updates are queued up at the
"testing" branch of

    git://git.kernel.org/pub/scm/libs/ieee1394/libraw1394.git testing

Here is the shortlog and diffstat of the fixes branch; full log and diff
follow at the end of this message:

Jay Fenlason (2):
      firewire: ohci: Make cycleMatch ISO transmission work
      firewire: ohci: pass correct iso xmit timestamps to core

 drivers/firewire/ohci.c |   41 +++++++++++++++++++++++++++++++++-----
 1 files changed, 35 insertions(+), 6 deletions(-)

Many thanks to Jay for debugging and fixing these issues.

Some more kernel work will be neessary for fully satisfactory support of
FireWire audio interfaces:  Multiplex FCP requests as necessary for
multiple device support; implement variable split transaction time-out;
longer-term: implement a kernelspace streaming component for FFADO (some
groundwork has been done in a GSoC project).


master branch
=============

This is for the post 2.6.32 merge window.  We have got minor fixes and
tweaks, among them reduced stack usage in ioctls and and a considerable
reduction of stack usage in the bus reset handler tasklet.

Akinobu Mita (1):
      ieee1394: Use hweight32

Stefan Richter (9):
      firewire: cdev: fix memory leak in an error path
      firewire: normalize style of queue_work wrappers
      firewire: cdev: normalize variable names
      firewire: optimize config ROM creation
      firewire: core: clarify generate_config_rom usage
      firewire: core: optimize Topology Map creation
      firewire: core: WARN on wrong usage of core transaction functions
      firewire: ohci: 0 may be a valid DMA address
      firewire: cdev: reduce stack usage by ioctl_dispatch

 drivers/firewire/core-card.c        |   75 ++++++++----------
 drivers/firewire/core-cdev.c        |  113 ++++++++++++++++-----------
 drivers/firewire/core-topology.c    |   17 +++--
 drivers/firewire/core-transaction.c |   19 ++---
 drivers/firewire/core.h             |    9 +-
 drivers/firewire/ohci.c             |   39 ++++++----
 drivers/firewire/sbp2.c             |    9 ++-
 drivers/ieee1394/ohci1394.c         |    8 +--
 include/linux/firewire.h            |   17 +----
 9 files changed, 159 insertions(+), 147 deletions(-)


firedtv branch
==============

This is only a temporary branch with updates of the FireDTV DVB driver.
These updates are currently picked up by Mauro and will go into the
mainline via the V4L-DVB tree.  Most notably, the firedtv driver is now
finally ported from the old ieee1394 stack to the new firewire stack.
Depending on which one or two of the stacks are chosen in Kconfig, the
firedtv driver is built with an interface to one or both of the stacks.

Stefan Richter (11):
      firedtv: move remote control workqueue handling into rc source file
      firedtv: reform lock transaction backend call
      firedtv: add missing include, rename a constant
      firedtv: port to new firewire core
      firedtv: shrink buffer pointer table
      firedtv: packet requeuing is likely to succeed
      firedtv: remove an unnecessary function argument
      Merge tag 'v2.6.32-rc8' into firedtv
      firedtv: do not DMA-map stack addresses
      firedtv: remove check for interrupting signal
      firedtv: reduce memset()s

 drivers/media/dvb/firewire/Kconfig        |    7 +-
 drivers/media/dvb/firewire/Makefile       |    1 +
 drivers/media/dvb/firewire/firedtv-1394.c |   42 +-
 drivers/media/dvb/firewire/firedtv-avc.c  |  566 +++++++++++----------
 drivers/media/dvb/firewire/firedtv-dvb.c  |   16 +-
 drivers/media/dvb/firewire/firedtv-fw.c   |  376 ++++++++++++++
 drivers/media/dvb/firewire/firedtv-rc.c   |    2 +
 drivers/media/dvb/firewire/firedtv.h      |   23 +-
 8 files changed, 746 insertions(+), 287 deletions(-)
 create mode 100644 drivers/media/dvb/firewire/firedtv-fw.c


And here are the two patches from the "fixes" branch because they
weren't posted to LKML yet:

commit 31769cef2e973544164aa7d0db2e2024660d5e21
Author: Jay Fenlason <fenlason@redhat.com>
Date:   Sat Nov 21 00:05:56 2009 +0100

    firewire: ohci: pass correct iso xmit timestamps to core
    
    Here is the final set of patches I used to get ffado to work with the
    new firewire stack.  With these patches, I was able to start ardour
    and record from and playback to my PreSonus Inspire1394 from a
    (mostly) Fedora 12 system.
    
    Signed-off-by: Jay Fenlason <fenlason@redhat.com>
    
    Until now, firewire-ohci exposed only the transmit cycle of the last
    transmitted packet at each isochronous transmit complete event.  This
    made it impossible for FFADO (FireWire audio drivers in userspace) to
    synchronize audio-out streams.  The fix is to store the timestamp of
    each packet in the iso xmit event.  As a bonus, the transfer status is
    stored too.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index c07cfad..94260aa 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -1904,15 +1904,30 @@ static int handle_it_packet(struct context *context,
 {
 	struct iso_context *ctx =
 		container_of(context, struct iso_context, context);
+	int i;
+	struct descriptor *pd;
 
-	if (last->transfer_status == 0)
-		/* This descriptor isn't done yet, stop iteration. */
+	for (pd = d; pd <= last; pd++)
+		if (pd->transfer_status)
+			break;
+	if (pd > last)
+		/* Descriptor(s) not done yet, stop iteration */
 		return 0;
 
-	if (le16_to_cpu(last->control) & DESCRIPTOR_IRQ_ALWAYS)
+	i = ctx->header_length;
+	if (i + 4 < PAGE_SIZE) {
+		/* Present this value as big-endian to match the receive code */
+		*(__be32 *)(ctx->header + i) = cpu_to_be32(
+				((u32)le16_to_cpu(pd->transfer_status) << 16) |
+				le16_to_cpu(pd->res_count));
+		ctx->header_length += 4;
+	}
+	if (le16_to_cpu(last->control) & DESCRIPTOR_IRQ_ALWAYS) {
 		ctx->base.callback(&ctx->base, le16_to_cpu(last->res_count),
-				   0, NULL, ctx->base.callback_data);
-
+				   ctx->header_length, ctx->header,
+				   ctx->base.callback_data);
+		ctx->header_length = 0;
+	}
 	return 1;
 }
 

commit 5ed1f321a71b8549cc2eea26c94fe7943ed01d31
Author: Jay Fenlason <fenlason@redhat.com>
Date:   Tue Nov 17 12:29:17 2009 -0500

    firewire: ohci: Make cycleMatch ISO transmission work
    
    Calling the START_ISO ioctl with a nonnegative cycle paramater has
    never worked.  Last night I got around to figuring out why.  Most of
    this patch is a big comment explaining why we enable an interrupt
    source then don't actually do anything when we get one.  As the
    comment says, we should do more, but we don't have a way to tell
    userspace what happened. . .
    
    Signed-off-by: Jay Fenlason <fenlason@redhat.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (edited comment)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 5d52425..c07cfad 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -275,7 +275,7 @@ static void log_irqs(u32 evt)
 	    !(evt & OHCI1394_busReset))
 		return;
 
-	fw_notify("IRQ %08x%s%s%s%s%s%s%s%s%s%s%s%s%s\n", evt,
+	fw_notify("IRQ %08x%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n", evt,
 	    evt & OHCI1394_selfIDComplete	? " selfID"		: "",
 	    evt & OHCI1394_RQPkt		? " AR_req"		: "",
 	    evt & OHCI1394_RSPkt		? " AR_resp"		: "",
@@ -286,6 +286,7 @@ static void log_irqs(u32 evt)
 	    evt & OHCI1394_postedWriteErr	? " postedWriteErr"	: "",
 	    evt & OHCI1394_cycleTooLong		? " cycleTooLong"	: "",
 	    evt & OHCI1394_cycle64Seconds	? " cycle64Seconds"	: "",
+	    evt & OHCI1394_cycleInconsistent	? " cycleInconsistent"	: "",
 	    evt & OHCI1394_regAccessFail	? " regAccessFail"	: "",
 	    evt & OHCI1394_busReset		? " busReset"		: "",
 	    evt & ~(OHCI1394_selfIDComplete | OHCI1394_RQPkt |
@@ -293,6 +294,7 @@ static void log_irqs(u32 evt)
 		    OHCI1394_respTxComplete | OHCI1394_isochRx |
 		    OHCI1394_isochTx | OHCI1394_postedWriteErr |
 		    OHCI1394_cycleTooLong | OHCI1394_cycle64Seconds |
+		    OHCI1394_cycleInconsistent |
 		    OHCI1394_regAccessFail | OHCI1394_busReset)
 						? " ?"			: "");
 }
@@ -1439,6 +1441,17 @@ static irqreturn_t irq_handler(int irq, void *data)
 			  OHCI1394_LinkControl_cycleMaster);
 	}
 
+	if (unlikely(event & OHCI1394_cycleInconsistent)) {
+		/*
+		 * We need to clear this event bit in order to make
+		 * cycleMatch isochronous I/O work.  In theory we should
+		 * stop active cycleMatch iso contexts now and restart
+		 * them at least two cycles later.  (FIXME?)
+		 */
+		if (printk_ratelimit())
+			fw_notify("isochronous cycle inconsistent\n");
+	}
+
 	if (event & OHCI1394_cycle64Seconds) {
 		cycle_time = reg_read(ohci, OHCI1394_IsochronousCycleTimer);
 		if ((cycle_time & 0x80000000) == 0)
@@ -1528,6 +1541,7 @@ static int ohci_enable(struct fw_card *card, u32 *config_rom, size_t length)
 		  OHCI1394_reqTxComplete | OHCI1394_respTxComplete |
 		  OHCI1394_isochRx | OHCI1394_isochTx |
 		  OHCI1394_postedWriteErr | OHCI1394_cycleTooLong |
+		  OHCI1394_cycleInconsistent |
 		  OHCI1394_cycle64Seconds | OHCI1394_regAccessFail |
 		  OHCI1394_masterIntEnable);
 	if (param_debug & OHCI_PARAM_DEBUG_BUSRESETS)
-- 
Stefan Richter
-=====-==--= =-== ==---
http://arcgraph.de/sr/

