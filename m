Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbYE1VrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbYE1VrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbYE1Vo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:44:58 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:51223 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898AbYE1Vo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:44:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=gq1+IcFwPFOinTGQtwmIBcn4WZ76/LQ85K26zhla3W/OZcBpdcM0TqcUudclEV8uhKliHGhsYRA5/ul9cDGwJdDKsZ0D9aNLDWR33JKUK0UsVAhiggnO/Q98KJeiAxRw59IHqSgqjm4rpUPZlAl7eD/ulcUoXhokoAb317oskT8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 28 May 2008 23:42:30 +0200
Message-Id: <20080528214230.16327.71001.sendpatchset@localhost.localdomain>
In-Reply-To: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
References: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
Subject: [PATCH 12/21] cmd640: convert to use ide_timing_find_mode()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig      |    1 +
 drivers/ide/pci/cmd640.c |    8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -329,6 +329,7 @@ config BLK_DEV_PLATFORM
 config BLK_DEV_CMD640
 	tristate "CMD640 chipset bugfix/support"
 	depends on X86
+	select IDE_TIMINGS
 	---help---
 	  The CMD-Technologies CMD640 IDE chip is used on many common 486 and
 	  Pentium motherboards, usually in combination with a "Neptune" or
Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -521,6 +521,7 @@ static void program_drive_counts(ide_dri
 static void cmd640_set_mode(ide_drive_t *drive, unsigned int index,
 			    u8 pio_mode, unsigned int cycle_time)
 {
+	struct ide_timing *t;
 	int setup_time, active_time, recovery_time, clock_time;
 	u8 setup_count, active_count, recovery_count, recovery_count2, cycle_count;
 	int bus_speed;
@@ -532,8 +533,11 @@ static void cmd640_set_mode(ide_drive_t 
 
 	if (pio_mode > 5)
 		pio_mode = 5;
-	setup_time  = ide_pio_timings[pio_mode].setup_time;
-	active_time = ide_pio_timings[pio_mode].active_time;
+
+	t = ide_timing_find_mode(XFER_PIO_0 + pio_mode);
+	setup_time  = t->setup;
+	active_time = t->active;
+
 	recovery_time = cycle_time - (setup_time + active_time);
 	clock_time = 1000 / bus_speed;
 	cycle_count = DIV_ROUND_UP(cycle_time, clock_time);
