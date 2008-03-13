Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbYCMW34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbYCMW34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757997AbYCMW3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:29:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:14483 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757965AbYCMW3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:29:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=aY5BKCJeH1WKSHsMxWVPCojzAD+mYIU+oL6KlnsjiroBe5Pf4i2hTknNTi6pYgYT7tUWw0OiOaFd6Qtwor8Fmf8++AVnDhckrDhTjZnXs0KZzqSOWHvJHw4TnJPGB0lnbtaCEJ+hyarQsOj8gglK8pf6NYGuyGF1kqUobglw5+I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 13 Mar 2008 23:44:05 +0100
Message-Id: <20080313224405.7051.35540.sendpatchset@localhost.localdomain>
In-Reply-To: <20080313224352.7051.44005.sendpatchset@localhost.localdomain>
References: <20080313224352.7051.44005.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/12] qd65xx: add "vlb_clock=" parameter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "vlb_clock=" parameter for specifying VLB clock frequency (in MHz).

Also rename {active,recovery}_cycle variables to {act,rec}_cyc while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/legacy/qd65xx.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

Index: b/drivers/ide/legacy/qd65xx.c
===================================================================
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -41,6 +41,8 @@
 
 #include "qd65xx.h"
 
+static int vlb_clock;
+
 /*
  * I/O ports are 0x30-0x31 (and 0x32-0x33 for qd6580)
  *            or 0xb0-0xb1 (and 0xb2-0xb3 for qd6580)
@@ -114,17 +116,18 @@ static void qd65xx_select(ide_drive_t *d
 
 static u8 qd6500_compute_timing (ide_hwif_t *hwif, int active_time, int recovery_time)
 {
-	u8 active_cycle,recovery_cycle;
+	int clk = vlb_clock ? vlb_clock : system_bus_clock();
+	u8 act_cyc, rec_cyc;
 
-	if (system_bus_clock()<=33) {
-		active_cycle =   9  - IDE_IN(active_time   * system_bus_clock() / 1000 + 1, 2, 9);
-		recovery_cycle = 15 - IDE_IN(recovery_time * system_bus_clock() / 1000 + 1, 0, 15);
+	if (clk <= 33) {
+		act_cyc =  9 - IDE_IN(active_time   * clk / 1000 + 1, 2,  9);
+		rec_cyc = 15 - IDE_IN(recovery_time * clk / 1000 + 1, 0, 15);
 	} else {
-		active_cycle =   8  - IDE_IN(active_time   * system_bus_clock() / 1000 + 1, 1, 8);
-		recovery_cycle = 18 - IDE_IN(recovery_time * system_bus_clock() / 1000 + 1, 3, 18);
+		act_cyc =  8 - IDE_IN(active_time   * clk / 1000 + 1, 1,  8);
+		rec_cyc = 18 - IDE_IN(recovery_time * clk / 1000 + 1, 3, 18);
 	}
 
-	return((recovery_cycle<<4) | 0x08 | active_cycle);
+	return (rec_cyc << 4) | 0x08 | act_cyc;
 }
 
 /*
@@ -135,10 +138,13 @@ static u8 qd6500_compute_timing (ide_hwi
 
 static u8 qd6580_compute_timing (int active_time, int recovery_time)
 {
-	u8 active_cycle   = 17 - IDE_IN(active_time   * system_bus_clock() / 1000 + 1, 2, 17);
-	u8 recovery_cycle = 15 - IDE_IN(recovery_time * system_bus_clock() / 1000 + 1, 2, 15);
+	int clk = vlb_clock ? vlb_clock : system_bus_clock();
+	u8 act_cyc, rec_cyc;
+
+	act_cyc = 17 - IDE_IN(active_time   * clk / 1000 + 1, 2, 17);
+	rec_cyc = 15 - IDE_IN(recovery_time * clk / 1000 + 1, 2, 15);
 
-	return((recovery_cycle<<4) | active_cycle);
+	return (rec_cyc << 4) | act_cyc;
 }
 
 /*
@@ -404,6 +410,9 @@ static int probe_qd65xx;
 module_param_named(probe, probe_qd65xx, bool, 0);
 MODULE_PARM_DESC(probe, "probe for QD65xx chipsets");
 
+module_param(vlb_clock, int, 0);
+MODULE_PARM_DESC(vlb_clock, "VLB clock frequency (in MHz)");
+
 static int __init qd65xx_init(void)
 {
 	int rc1, rc2 = -ENODEV;
