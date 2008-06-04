Return-Path: <linux-kernel-owner+w=401wt.eu-S1752107AbYFDAdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbYFDAdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 20:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756962AbYFDAcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 20:32:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:25336 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756891AbYFDAcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 20:32:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,586,1204531200"; 
   d="scan'208";a="572066262"
Date: Tue, 3 Jun 2008 17:23:07 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC] expand link_power_management_policy definition
Message-ID: <20080603172307.1b963aac@appleyard>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think I mentioned on the list a couple weeks ago that I favor just 
expanding the definition of link power management to include
the notion of simply powering the entire port off rather
than adding new knobs to sysfs.  I wrote this completely untested and
very incomplete patch to give you a better idea of what I am proposing.
This patch adds a new valid value of "power_off" for the existing
link_power_management_policy sysfs entry:

power_off:  phy is not on at all.
min_power:  driver uses minimum possible power. hotplug
            may or may not be available.
medium_power: best power/performance tradeoff.  hotplug
            may or may not be available
max_performance: max performance without regard to power
            hot plug is available.

the default value for link_power_management_policy
can be determined by the core and overriden by the
driver, or just solely determined by the driver.

min_power and medium_power are only valid values for
occupied ports.  right now, using min_power or medium_power
mode means that hotplug is not available, although that's
not necessarily got to be true in the future, since we
could add polling or low power presence detect or even
use mechanical interlock switch events.

We could further add a "power_on" value to indicate that
there's no device attached but we can detect one if it
becomes available if you think that using max_performance 
to indicate this state is too confusing.

---
 drivers/ata/libata-core.c |   10 ++++++++++
 drivers/ata/libata-scsi.c |    1 +
 include/linux/libata.h    |    1 +
 3 files changed, 12 insertions(+)

Index: linux-ahci-phy/drivers/ata/libata-core.c
===================================================================
--- linux-ahci-phy.orig/drivers/ata/libata-core.c	2008-06-03 16:52:05.000000000 -0700
+++ linux-ahci-phy/drivers/ata/libata-core.c	2008-06-03 17:02:34.000000000 -0700
@@ -993,6 +993,16 @@ void ata_dev_enable_pm(struct ata_device
 	int rc = 0;
 	struct ata_port *ap = dev->link->ap;
 
+	/*
+	 * if we don't have a device attached, all we can
+	 * do is power off
+	 */
+	if (!ata_dev_enabled(dev) && policy == POWER_OFF) {
+		ap->flags |= ATA_FLAG_NO_HOTPLUG;
+		ata_phy_offline(ap);
+		return;
+	}
+
 	/* set HIPM first, then DIPM */
 	if (ap->ops->enable_pm)
 		rc = ap->ops->enable_pm(ap, policy);
Index: linux-ahci-phy/drivers/ata/libata-scsi.c
===================================================================
--- linux-ahci-phy.orig/drivers/ata/libata-scsi.c	2008-06-03 16:53:17.000000000 -0700
+++ linux-ahci-phy/drivers/ata/libata-scsi.c	2008-06-03 16:53:34.000000000 -0700
@@ -122,6 +122,7 @@ static const struct {
 	{ MIN_POWER, "min_power" },
 	{ MAX_PERFORMANCE, "max_performance" },
 	{ MEDIUM_POWER, "medium_power" },
+	{ POWER_OFF, "power_off" },
 };
 
 static const char *ata_scsi_lpm_get(enum link_pm policy)
Index: linux-ahci-phy/include/linux/libata.h
===================================================================
--- linux-ahci-phy.orig/include/linux/libata.h	2008-06-03 16:52:32.000000000 -0700
+++ linux-ahci-phy/include/linux/libata.h	2008-06-03 16:52:54.000000000 -0700
@@ -443,6 +443,7 @@ enum link_pm {
 	MIN_POWER,
 	MAX_PERFORMANCE,
 	MEDIUM_POWER,
+	POWER_OFF,
 };
 extern struct device_attribute dev_attr_link_power_management_policy;
 
