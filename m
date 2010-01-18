Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220Ab0ARA4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab0ARA4k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 19:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435Ab0ARA40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 19:56:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:54482 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391Ab0ARAx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 19:53:56 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       Jeff Garzik <jgarzik@pobox.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>, Neil Brown <neilb@suse.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 33/40] async: convert async users to use the new implementation
Date: Mon, 18 Jan 2010 09:57:45 +0900
Message-Id: <1263776272-382-34-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1263776272-382-1-git-send-email-tj@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 00:52:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there are five users of async - libata, sd, battery, raid5
and dasd.  All except libata simply schedule asynchronous excution and
the conversion is trivial.  libata requires synchronization to make
devices appear in order which can be easily achieved by putting the
SCSI probe part into a separate function and using ordered async
feature.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Neil Brown <neilb@suse.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 drivers/acpi/battery.c    |    4 ++--
 drivers/ata/libata-core.c |   31 +++++++++++++++----------------
 drivers/ata/pata_legacy.c |    2 +-
 drivers/md/raid5.c        |    4 ++--
 drivers/s390/block/dasd.c |    4 ++--
 drivers/scsi/sd.c         |    8 ++++----
 6 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index cada73f..fbdcec4 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -911,7 +911,7 @@ static struct acpi_driver acpi_battery_driver = {
 		},
 };
 
-static void __init acpi_battery_init_async(void *unused, async_cookie_t cookie)
+static void __init acpi_battery_init_async(void *unused)
 {
 	if (acpi_disabled)
 		return;
@@ -931,7 +931,7 @@ static void __init acpi_battery_init_async(void *unused, async_cookie_t cookie)
 
 static int __init acpi_battery_init(void)
 {
-	async_schedule(acpi_battery_init_async, NULL);
+	async_call(acpi_battery_init_async, NULL);
 	return 0;
 }
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index de91814..7d413d4 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6068,21 +6068,11 @@ void ata_host_init(struct ata_host *host, struct device *dev,
 }
 
 
-static void async_port_probe(void *data, async_cookie_t cookie)
+static void async_port_probe(void *data)
 {
 	int rc;
 	struct ata_port *ap = data;
 
-	/*
-	 * If we're not allowed to scan this host in parallel,
-	 * we need to wait until all previous scans have completed
-	 * before going further.
-	 * Jeff Garzik says this is only within a controller, so we
-	 * don't need to wait for port 0, only for later ports.
-	 */
-	if (!(ap->host->flags & ATA_HOST_PARALLEL_SCAN) && ap->port_no != 0)
-		async_synchronize_cookie(cookie);
-
 	/* probe */
 	if (ap->ops->error_handler) {
 		struct ata_eh_info *ehi = &ap->link.eh_info;
@@ -6119,13 +6109,17 @@ static void async_port_probe(void *data, async_cookie_t cookie)
 			 */
 		}
 	}
+}
 
-	/* in order to keep device order, we need to synchronize at this point */
-	async_synchronize_cookie(cookie);
-
-	ata_scsi_scan_host(ap, 1);
+static void async_port_probe_finish(void *data)
+{
+	struct ata_host *host = data;
+	int i;
 
+	for (i = 0; i < host->n_ports; i++)
+		ata_scsi_scan_host(host->ports[i], 1);
 }
+
 /**
  *	ata_host_register - register initialized ATA host
  *	@host: ATA host to register
@@ -6204,8 +6198,13 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 	/* perform each probe asynchronously */
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
-		async_schedule(async_port_probe, ap);
+
+		if (host->flags & ATA_HOST_PARALLEL_SCAN)
+			async_call(async_port_probe, ap);
+		else
+			async_call_ordered(async_port_probe, ap);
 	}
+	async_call_ordered(async_port_probe_finish, host);
 
 	return 0;
 }
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 9df1ff7..ad855b0 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -1037,7 +1037,7 @@ static __init int legacy_init_one(struct legacy_probe *probe)
 				&legacy_sht);
 	if (ret)
 		goto fail;
-	async_synchronize_full();
+	async_barrier();
 	ld->platform_dev = pdev;
 
 	/* Nothing found means we drop the port as its probably not there */
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e84204e..7000e87 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1206,7 +1206,7 @@ static void __raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 }
 
 #ifdef CONFIG_MULTICORE_RAID456
-static void async_run_ops(void *param, async_cookie_t cookie)
+static void async_run_ops(void *param)
 {
 	struct stripe_head *sh = param;
 	unsigned long ops_request = sh->ops.request;
@@ -1229,7 +1229,7 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 	sh->ops.request = ops_request;
 
 	atomic_inc(&sh->count);
-	async_schedule(async_run_ops, sh);
+	async_call(async_run_ops, sh);
 }
 #else
 #define raid_run_ops __raid_run_ops
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index fdb2e7c..4437505 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2276,7 +2276,7 @@ dasd_exit(void)
  * SECTION: common functions for ccw_driver use
  */
 
-static void dasd_generic_auto_online(void *data, async_cookie_t cookie)
+static void dasd_generic_auto_online(void *data)
 {
 	struct ccw_device *cdev = data;
 	int ret;
@@ -2317,7 +2317,7 @@ int dasd_generic_probe(struct ccw_device *cdev,
 	 */
 	if ((dasd_get_feature(cdev, DASD_FEATURE_INITIAL_ONLINE) > 0 ) ||
 	    (dasd_autodetect && dasd_busid_known(dev_name(&cdev->dev)) != 0))
-		async_schedule(dasd_generic_auto_online, cdev);
+		async_call(dasd_generic_auto_online, cdev);
 	return 0;
 }
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 255da53..d2857cd 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2142,7 +2142,7 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
 /*
  * The asynchronous part of sd_probe
  */
-static void sd_probe_async(void *data, async_cookie_t cookie)
+static void sd_probe_async(void *data)
 {
 	struct scsi_disk *sdkp = data;
 	struct scsi_device *sdp;
@@ -2277,8 +2277,8 @@ static int sd_probe(struct device *dev)
 
 	get_device(&sdp->sdev_gendev);
 
-	get_device(&sdkp->dev);	/* prevent release before async_schedule */
-	async_schedule(sd_probe_async, sdkp);
+	get_device(&sdkp->dev);	/* prevent release before async_call */
+	async_call(sd_probe_async, sdkp);
 
 	return 0;
 
@@ -2309,7 +2309,7 @@ static int sd_remove(struct device *dev)
 {
 	struct scsi_disk *sdkp;
 
-	async_synchronize_full();
+	async_barrier();
 	sdkp = dev_get_drvdata(dev);
 	blk_queue_prep_rq(sdkp->device->request_queue, scsi_prep_fn);
 	device_del(&sdkp->dev);
-- 
1.6.4.2

