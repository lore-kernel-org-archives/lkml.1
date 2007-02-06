Return-Path: <linux-kernel-owner+w=401wt.eu-S932968AbXBFADa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968AbXBFADa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 19:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933105AbXBFADa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 19:03:30 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:49303 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932968AbXBFAD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 19:03:29 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 6 Feb 2007 01:03:21 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: ohci1394 broke 2.6.19 -> 2.6.20-rc1
To: Robert Crocombe <rcrocomb@gmail.com>
cc: linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <e6babb600702051521l4a08eb2dw2a7f423fd0d7edd7@mail.gmail.com>
Message-ID: <tkrat.c39467d7194502c4@s5r6.in-berlin.de>
References: <e6babb600702051521l4a08eb2dw2a7f423fd0d7edd7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Crocombe wrote:
> Prior to testing a patch for bugzilla bug 7569 (hosts lost on bus
> reset),

(Well, I think a lot more has to be done for that bug than in the patch
I posted so far.)

> I wanted to reproduce the behavior.  I can under the noted
> 2.6.16-blah kernels, but moving to anything more recent than 2.6.19
> means ohci1394 is non-functional (no 1394 hosts are detected) and the
> module cannot be removed.
> 
> I have narrowed it down to 2.6.19 works, 2.6.20-rc1 doesn't.  Lots of detail at:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=7942

I get a spinlock lockup on 2.6.20-rc6 + some 1394 updates with a similar
trace to what Robert posted at bugzilla --- *if* I use ieee1394's option
disable_nodemgr=1. (Never used it before.) The key appears to be how
hpsb_alloc_host interacts with the driver core. I don't know if hosts.c
is at fault or some change in the driver core.

There is one notable change in hpsb_alloc_host after 2.6.19: I moved the
device registering out of a mutex. But I don't think that's relevant.
The lockup which I got was with only one FireWire controller.

$ git diff v2.6.19..v2.6.20-rc1 drivers/ieee1394/hosts.c
diff --git a/drivers/ieee1394/hosts.c b/drivers/ieee1394/hosts.c
index d90a3a1..ee82a53 100644
--- a/drivers/ieee1394/hosts.c
+++ b/drivers/ieee1394/hosts.c
@@ -31,9 +31,10 @@
 #include "config_roms.h"
 
 
-static void delayed_reset_bus(void * __reset_info)
+static void delayed_reset_bus(struct work_struct *work)
 {
-	struct hpsb_host *host = (struct hpsb_host*)__reset_info;
+	struct hpsb_host *host =
+		container_of(work, struct hpsb_host, delayed_reset.work);
 	int generation = host->csr.generation + 1;
 
 	/* The generation field rolls over to 2 rather than 0 per IEEE
@@ -43,9 +44,10 @@ static void delayed_reset_bus(void * __reset_info)
 
 	CSR_SET_BUS_INFO_GENERATION(host->csr.rom, generation);
 	if (csr1212_generate_csr_image(host->csr.rom) != CSR1212_SUCCESS) {
-		/* CSR image creation failed, reset generation field and do not
-		 * issue a bus reset. */
-		CSR_SET_BUS_INFO_GENERATION(host->csr.rom, host->csr.generation);
+		/* CSR image creation failed.
+		 * Reset generation field and do not issue a bus reset. */
+		CSR_SET_BUS_INFO_GENERATION(host->csr.rom,
+					    host->csr.generation);
 		return;
 	}
 
@@ -53,7 +55,8 @@ static void delayed_reset_bus(void * __reset_info)
 
 	host->update_config_rom = 0;
 	if (host->driver->set_hw_config_rom)
-		host->driver->set_hw_config_rom(host, host->csr.rom->bus_info_data);
+		host->driver->set_hw_config_rom(host,
+						host->csr.rom->bus_info_data);
 
 	host->csr.gen_timestamp[host->csr.generation] = jiffies;
 	hpsb_reset_bus(host, SHORT_RESET);
@@ -69,7 +72,8 @@ static int dummy_devctl(struct hpsb_host *h, enum devctl_cmd c, int arg)
 	return -1;
 }
 
-static int dummy_isoctl(struct hpsb_iso *iso, enum isoctl_cmd command, unsigned long arg)
+static int dummy_isoctl(struct hpsb_iso *iso, enum isoctl_cmd command,
+			unsigned long arg)
 {
 	return -1;
 }
@@ -122,15 +126,13 @@ struct hpsb_host *hpsb_alloc_host(struct hpsb_host_driver *drv, size_t extra,
 	int i;
 	int hostnum = 0;
 
-	h = kzalloc(sizeof(*h) + extra, SLAB_KERNEL);
+	h = kzalloc(sizeof(*h) + extra, GFP_KERNEL);
 	if (!h)
 		return NULL;
 
 	h->csr.rom = csr1212_create_csr(&csr_bus_ops, CSR_BUS_INFO_SIZE, h);
-	if (!h->csr.rom) {
-		kfree(h);
-		return NULL;
-	}
+	if (!h->csr.rom)
+		goto fail;
 
 	h->hostdata = h + 1;
 	h->driver = drv;
@@ -145,21 +147,20 @@ struct hpsb_host *hpsb_alloc_host(struct hpsb_host_driver *drv, size_t extra,
 
 	atomic_set(&h->generation, 0);
 
-	INIT_WORK(&h->delayed_reset, delayed_reset_bus, h);
+	INIT_DELAYED_WORK(&h->delayed_reset, delayed_reset_bus);
 	
 	init_timer(&h->timeout);
 	h->timeout.data = (unsigned long) h;
 	h->timeout.function = abort_timedouts;
-	h->timeout_interval = HZ / 20; // 50ms by default
+	h->timeout_interval = HZ / 20; /* 50ms, half of minimum SPLIT_TIMEOUT */
 
 	h->topology_map = h->csr.topology_map + 3;
 	h->speed_map = (u8 *)(h->csr.speed_map + 2);
 
 	mutex_lock(&host_num_alloc);
-
 	while (nodemgr_for_each_host(&hostnum, alloc_hostnum_cb))
 		hostnum++;
-
+	mutex_unlock(&host_num_alloc);
 	h->id = hostnum;
 
 	memcpy(&h->device, &nodemgr_dev_template_host, sizeof(h->device));
@@ -170,13 +171,19 @@ struct hpsb_host *hpsb_alloc_host(struct hpsb_host_driver *drv, size_t extra,
 	h->class_dev.class = &hpsb_host_class;
 	snprintf(h->class_dev.class_id, BUS_ID_SIZE, "fw-host%d", h->id);
 
-	device_register(&h->device);
-	class_device_register(&h->class_dev);
+	if (device_register(&h->device))
+		goto fail;
+	if (class_device_register(&h->class_dev)) {
+		device_unregister(&h->device);
+		goto fail;
+	}
 	get_device(&h->device);
 
-	mutex_unlock(&host_num_alloc);
-
 	return h;
+
+fail:
+	kfree(h);
+	return NULL;
 }
 
 int hpsb_add_host(struct hpsb_host *host)
@@ -228,13 +235,14 @@ int hpsb_update_config_rom_image(struct hpsb_host *host)
 	if (time_before(jiffies, host->csr.gen_timestamp[next_gen] + 60 * HZ))
 		/* Wait 60 seconds from the last time this generation number was
 		 * used. */
-		reset_delay = (60 * HZ) + host->csr.gen_timestamp[next_gen] - jiffies;
+		reset_delay =
+			(60 * HZ) + host->csr.gen_timestamp[next_gen] - jiffies;
 	else
 		/* Wait 1 second in case some other code wants to change the
 		 * Config ROM in the near future. */
 		reset_delay = HZ;
 
-	PREPARE_WORK(&host->delayed_reset, delayed_reset_bus, host);
+	PREPARE_DELAYED_WORK(&host->delayed_reset, delayed_reset_bus);
 	schedule_delayed_work(&host->delayed_reset, reset_delay);
 
 	return 0;



-- 
Stefan Richter
-=====-=-=== --=- --==-
http://arcgraph.de/sr/

