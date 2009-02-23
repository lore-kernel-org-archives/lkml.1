Return-Path: <linux-kernel-owner+w=401wt.eu-S1754992AbZBWMjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbZBWMjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 07:39:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbZBWMix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 07:38:53 -0500
Received: from adelie.canonical.com ([91.189.90.139]:56617 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbZBWMiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 07:38:52 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Andy Whitcroft <apw@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] mmc: add MODALIAS linkage for MMC/SD devices
Date: Mon, 23 Feb 2009 12:38:41 +0000
Message-Id: <1235392721-22545-2-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.1.2.419.g0d87e
In-Reply-To: <20090218205654.05896ece@mjolnir.ossman.eu>
References: <20090218205654.05896ece@mjolnir.ossman.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Pierre, here is the updated version.  Got lost somewhere after testing
and before sending out.]

Currently we are using an explicit udev rule to trigger loading of the
mmc-block module when an MMC or SD card is detected:

    SUBSYSTEM=="mmc", RUN+="/sbin/modprobe -Qba mmc-block"

It makes much more sense for the mmc bus driver and the mmc-block module to
share MODALIAS information so that they are linked automatically.

There is no real information of use in the MMC system at the current time.
All devices inserted require us to load the mmc-block device.  Until such
time as useful parameters exist simply reflect the module linkage via
the module alias below:

	mmc:block

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/mmc/card/block.c |    2 ++
 drivers/mmc/core/bus.c   |    8 ++++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 513eb09..fe8041e 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -41,6 +41,8 @@
 
 #include "queue.h"
 
+MODULE_ALIAS("mmc:block");
+
 /*
  * max 8 partitions per card
  */
diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index f210a8e..bdb165f 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -84,6 +84,14 @@ mmc_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 	}
 
 	retval = add_uevent_var(env, "MMC_NAME=%s", mmc_card_name(card));
+	if (retval)
+		return retval;
+
+	/*
+	 * Request the mmc_block device.  Note: that this is a direct request
+	 * for the module it carries no information as to what is inserted.
+	 */
+	retval = add_uevent_var(env, "MODALIAS=mmc:block");
 
 	return retval;
 }
-- 
1.6.1.2.419.g0d87e

