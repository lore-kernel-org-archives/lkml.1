Return-Path: <linux-kernel-owner+w=401wt.eu-S1759946AbXGXT7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759946AbXGXT7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 15:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756925AbXGXT7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 15:59:17 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57030 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822AbXGXT7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 15:59:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46A6598B.5080004@s5r6.in-berlin.de>
Date: Tue, 24 Jul 2007 21:56:59 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Manuel Lauss <mano@roarinelk.homelinux.net>
CC: Andreas Micklei <andreas.micklei@ivistar.de>,
       Andreas Messer <andreas.messer@stud-mail.uni-wuerzburg.de>,
       linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: [BUG] firewire: mass-storage i/o-problems
References: <200707222332.12270.andreas.messer@stud-mail.uni-wuerzburg.de> <46A3E973.6090701@s5r6.in-berlin.de> <20070723063741.GA32240@roarinelk.homelinux.net> <46A45B65.9000704@s5r6.in-berlin.de> <20070723084505.GB349@roarinelk.homelinux.net> <46A49244.9010402@s5r6.in-berlin.de> <20070723183336.GA3736@roarinelk.homelinux.net> <20070723184405.GB3736@roarinelk.homelinux.net>
In-Reply-To: <20070723184405.GB3736@roarinelk.homelinux.net>
X-Enigmail-Version: 0.94.1.0
Content-Type: multipart/mixed;
 boundary="------------070000030407000908080201"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070000030407000908080201
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Manuel Lauss wrote:
> Actually, copying data to the disk while playing/seeking through a moviefile
> which is also located on it is already enough. Forget the NFS thing...
> 
> Afterwards the firewire_sbp2 module has to be rmmod-ed and modprobed again
> or it will continue to throw errors even for single reads.
> 
> I hope this helps tracking it down...

I tried this and similar tests on my main PC (PCIe based) and on an
Athlon/KM266 PC, with 1394b and 1394a hardware.  Nothing happened,
except for a single "status write for unknown orb", followed by command
abort from which the disk immediately recovered.  I did many tests and
it didn't happen again.  I.e. it's probable that the supposed bug
happens here too, but very rarely.

Could you (and everyone else who has repeated I/O errors with the new
drivers, but not with the old drivers) test the attached patches, one
patch at a time?  They apply to 2.6.22.
-- 
Stefan Richter
-=====-=-=== -=== ==---
http://arcgraph.de/sr/

--------------070000030407000908080201
Content-Type: text/plain;
 name="test1-firewire-fw-sbp2-default-to-128k-transfers.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="test1-firewire-fw-sbp2-default-to-128k-transfers.patch"

firewire: fw-sbp2: default to 128k transfers

because that's what the old sbp2 driver does per default, to avoid
trouble with buggy devices.

A test on a 1394b hardware RAID0 shows a drop in bandwidth by 10% by
this patch.
---
This should not be hardwired but set by blk_queue_max_sectors() in
sbp2_scsi_slave_configure().

 drivers/firewire/fw-sbp2.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.22/drivers/firewire/fw-sbp2.c
===================================================================
--- linux-2.6.22.orig/drivers/firewire/fw-sbp2.c
+++ linux-2.6.22/drivers/firewire/fw-sbp2.c
@@ -1171,6 +1171,7 @@ static struct scsi_host_template scsi_dr
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.max_sectors		= 255,
 	.cmd_per_lun		= 1,
 	.can_queue		= 1,
 	.sdev_attrs		= sbp2_scsi_sysfs_attrs,

--------------070000030407000908080201
Content-Type: text/plain;
 name="test2-firewire-fw-sbp2-increase-busy-timeout.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="test2-firewire-fw-sbp2-increase-busy-timeout.patch"

firewire: fw-sbp2: increase BUSY_TIMEOUT

Increase BUSY_TIMEOUT.retry_limit to a maximum, like the old sbp2 driver
does.  This lets targets retry more times in single phase retry if our
host adapter is too busy to accept packets.
---
 drivers/firewire/fw-sbp2.c |   30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

Index: linux-2.6.22/drivers/firewire/fw-sbp2.c
===================================================================
--- linux-2.6.22.orig/drivers/firewire/fw-sbp2.c
+++ linux-2.6.22/drivers/firewire/fw-sbp2.c
@@ -538,6 +538,30 @@ release_sbp2_device(struct kref *kref)
 	scsi_host_put(host);
 }
 
+static void
+complete_set_busy_timeout(struct fw_card *card, int rcode,
+			  void *payload, size_t length, void *data)
+{
+	if (rcode != RCODE_COMPLETE)
+		fw_error("set_busy_timeout: rcode %x\n", rcode);
+	complete((struct completion *)data);
+}
+
+static void sbp2_set_busy_timeout(struct sbp2_device *sd)
+{
+	struct fw_device *device = fw_device(sd->unit->device.parent);
+	struct fw_transaction t;
+	struct completion done;
+	__be32 data = cpu_to_be32(0xf);
+
+	init_completion(&done);
+	fw_send_request(device->card, &t, TCODE_WRITE_QUADLET_REQUEST,
+			sd->node_id, sd->generation, device->node->max_speed,
+			0xfffff0000210ULL, &data, sizeof(data),
+			complete_set_busy_timeout, &done);
+	wait_for_completion(&done);
+}
+
 static void sbp2_login(struct work_struct *work)
 {
 	struct sbp2_device *sd =
@@ -587,10 +611,7 @@ static void sbp2_login(struct work_struc
 	fw_notify(" - status write address:        0x%012llx\n",
 		  (unsigned long long) sd->address_handler.offset);
 
-#if 0
-	/* FIXME: The linux1394 sbp2 does this last step. */
-	sbp2_set_busy_timeout(scsi_id);
-#endif
+	sbp2_set_busy_timeout(sd);
 
 	PREPARE_DELAYED_WORK(&sd->work, sbp2_reconnect);
 	sbp2_agent_reset(unit);
@@ -752,6 +773,7 @@ static void sbp2_reconnect(struct work_s
 
 	fw_notify("reconnected to unit %s (%d retries)\n",
 		  unit->device.bus_id, sd->retries);
+	sbp2_set_busy_timeout(sd);
 	sbp2_agent_reset(unit);
 	sbp2_cancel_orbs(unit);
 	kref_put(&sd->kref, release_sbp2_device);

--------------070000030407000908080201--
