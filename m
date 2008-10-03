Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbYJCV4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbYJCV4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 17:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbYJCVzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 17:55:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41523 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbYJCVzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 17:55:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/6] SATA: Blacklisting of systems that spin off disks during ACPI power off (rev. 2)
Date: Fri, 3 Oct 2008 23:57:37 +0200
User-Agent: KMail/1.9.9
Cc: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ide@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <200808290002.55026.rjw@sisk.pl> <200810031703.32114.rjw@sisk.pl> <200810032348.59709.rjw@sisk.pl>
In-Reply-To: <200810032348.59709.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810032357.37943.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

SATA: Blacklisting of systems that spin off disks during ACPI power off (rev. 2)

Introduce new libata flags ATA_FLAG_NO_POWEROFF_SPINDOWN and
ATA_FLAG_NO_HIBERNATE_SPINDOWN that, if set, will prevent disks from
being spun off during system power off and hibernation, respectively
(to handle the hibernation case we need the new system state
SYSTEM_HIBERNATE_ENTER that can be checked against by libata, in
analogy with SYSTEM_POWER_OFF).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Tejun Heo <htejun@gmail.com>
---
 drivers/ata/libata-scsi.c |   20 +++++++++++++++++---
 include/linux/libata.h    |    2 ++
 2 files changed, 19 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/ata/libata-scsi.c
===================================================================
--- linux-2.6.orig/drivers/ata/libata-scsi.c
+++ linux-2.6/drivers/ata/libata-scsi.c
@@ -46,6 +46,7 @@
 #include <linux/libata.h>
 #include <linux/hdreg.h>
 #include <linux/uaccess.h>
+#include <linux/suspend.h>
 
 #include "libata.h"
 
@@ -1181,6 +1182,17 @@ static unsigned int ata_scsi_start_stop_
 
 		tf->command = ATA_CMD_VERIFY;	/* READ VERIFY */
 	} else {
+		/* Some odd clown BIOSen issue spindown on power off (ACPI S4
+		 * or S5) causing some drives to spin up and down again.
+		 */
+		if ((qc->ap->flags & ATA_FLAG_NO_POWEROFF_SPINDOWN) &&
+		    system_state == SYSTEM_POWER_OFF)
+			goto skip;
+
+		if ((qc->ap->flags & ATA_FLAG_NO_HIBERNATE_SPINDOWN) &&
+		     system_entering_hibernation())
+			goto skip;
+
 		/* XXX: This is for backward compatibility, will be
 		 * removed.  Read Documentation/feature-removal-schedule.txt
 		 * for more info.
@@ -1204,8 +1216,7 @@ static unsigned int ata_scsi_start_stop_
 				scmd->scsi_done = qc->scsidone;
 				qc->scsidone = ata_delayed_done;
 			}
-			scmd->result = SAM_STAT_GOOD;
-			return 1;
+			goto skip;
 		}
 
 		/* Issue ATA STANDBY IMMEDIATE command */
@@ -1221,10 +1232,13 @@ static unsigned int ata_scsi_start_stop_
 
 	return 0;
 
-invalid_fld:
+ invalid_fld:
 	ata_scsi_set_sense(scmd, ILLEGAL_REQUEST, 0x24, 0x0);
 	/* "Invalid field in cbd" */
 	return 1;
+ skip:
+	scmd->result = SAM_STAT_GOOD;
+	return 1;
 }
 
 
Index: linux-2.6/include/linux/libata.h
===================================================================
--- linux-2.6.orig/include/linux/libata.h
+++ linux-2.6/include/linux/libata.h
@@ -186,6 +186,8 @@ enum {
 	ATA_FLAG_PIO_POLLING	= (1 << 9), /* use polling PIO if LLD
 					     * doesn't handle PIO interrupts */
 	ATA_FLAG_NCQ		= (1 << 10), /* host supports NCQ */
+	ATA_FLAG_NO_POWEROFF_SPINDOWN = (1 << 11), /* don't spindown before poweroff */
+	ATA_FLAG_NO_HIBERNATE_SPINDOWN = (1 << 12), /* don't spindown before hibernation */
 	ATA_FLAG_DEBUGMSG	= (1 << 13),
 	ATA_FLAG_IGN_SIMPLEX	= (1 << 15), /* ignore SIMPLEX */
 	ATA_FLAG_NO_IORDY	= (1 << 16), /* controller lacks iordy */

