Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbZA0MMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbZA0MMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 07:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbZA0MMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 07:12:10 -0500
Received: from adelie.canonical.com ([91.189.90.139]:42807 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbZA0MMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 07:12:09 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Kay Sievers <kay.sievers@vrfy.org>, Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/1] mmc: add MODALIAS linkage for MMC/SD devices
Date: Tue, 27 Jan 2009 12:12:05 +0000
Message-Id: <1233058325-12719-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.1.258.g7ff14.dirty
In-Reply-To: <20090126093549.GC17399@shadowen.org>
References: <20090126093549.GC17399@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Here is an updated patch which only uses information already exported in
the ABI.]

Currently we are using an explicit udev rule to trigger loading of the
mmc-block module when an MMC or SD card is detected:

    SUBSYSTEM=="mmc", RUN+="/sbin/modprobe -Qba mmc-block"

It makes much more sense for the mmc bus driver and the mmc-block module to
share MODALIAS information so that they are linked automatically.

Add MODALIAS attributes to the uevents as generated, and add the
corresponding MODULE_ALIAS marks to the mmc-block module so that it is
automatically loaded by udev.  Following discussion it was decided to
expose the textual types, and so I have followed the example set by
the dmi: aliases for handling text.  The aliases are of the following
form:

    mmc:t<type>:

For example:

    mmc:tMMC:

The entry ends with a separator (:) in order to allow simple differentiation
between common prefixes such as SD and SDIO in MODULE_ALIAS declarations.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/mmc/card/block.c |    3 +++
 drivers/mmc/core/bus.c   |    5 +++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 3d067c3..9799273 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -41,6 +41,9 @@
 
 #include "queue.h"
 
+MODULE_ALIAS("mmc:tMMC:*");
+MODULE_ALIAS("mmc:tSD:*");
+
 /*
  * max 8 partitions per card
  */
diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index f210a8e..7b34c00 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -84,6 +84,11 @@ mmc_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 	}
 
 	retval = add_uevent_var(env, "MMC_NAME=%s", mmc_card_name(card));
+	if (retval)
+		return retval;
+
+	retval = add_uevent_var(env, "MODALIAS=mmc:t%s:",
+						(type) ? type : "UNKNOWN");
 
 	return retval;
 }
-- 
1.6.1.258.g7ff14.dirty

