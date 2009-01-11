Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbZAKTMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbZAKTMb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZAKTLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:11:04 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:63160 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbZAKTLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:11:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=cmxakEzHZLkGZ5BGLk99NzTgjL74sr37WFPgeGp5oHO6NUpVNu4JutvXk59x9egmA4
         iXeqKRQe8UGIS4WGuA3QmP2KYR2Fk29YlPBoSy/JZZmQjWLTzJ4MpcokvFSIT0c7ZHJ5
         LJlycZV1xqDL5IsZkKsfw0s9jgFhyPEQuI6IE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 11 Jan 2009 20:11:53 +0100
Message-Id: <20090111191153.17361.73267.sendpatchset@localhost.localdomain>
In-Reply-To: <20090111191120.17361.69981.sendpatchset@localhost.localdomain>
References: <20090111191120.17361.69981.sendpatchset@localhost.localdomain>
Subject: [PATCH 6/8] ide-acpi: cleanup do_drive_get_GTF()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-acpi: cleanup do_drive_get_GTF()

* ide_noacpi is already checked by ide_acpi_exec_tfs()
  which is the only user of do_drive_get_GTF().

* ide_acpi_exec_tfs() prints sufficient debug info about the
  device so no need to have excessive data about port/host.

* It is sufficient to check for drive->acpidata->obj_handle
  as it will be NULL if dev == NULL or hwif->acpidata == NULL
  or device is not present.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-acpi.c |   27 ---------------------------
 1 file changed, 27 deletions(-)

Index: b/drivers/ide/ide-acpi.c
===================================================================
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -225,39 +225,12 @@ static int do_drive_get_GTF(ide_drive_t 
 	acpi_status			status;
 	struct acpi_buffer		output;
 	union acpi_object 		*out_obj;
-	ide_hwif_t			*hwif = drive->hwif;
-	struct device			*dev = hwif->gendev.parent;
 	int				err = -ENODEV;
-	int				port;
 
 	*gtf_length = 0;
 	*gtf_address = 0UL;
 	*obj_loc = 0UL;
 
-	if (ide_noacpi)
-		return 0;
-
-	if (!dev) {
-		DEBPRINT("no PCI device for %s\n", hwif->name);
-		goto out;
-	}
-
-	if (!hwif->acpidata) {
-		DEBPRINT("no ACPI data for %s\n", hwif->name);
-		goto out;
-	}
-
-	port = hwif->channel ? drive->dn - 2: drive->dn;
-
-	DEBPRINT("ENTER: %s at %s, port#: %d, hard_port#: %d\n",
-		 hwif->name, dev->bus_id, port, hwif->channel);
-
-	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0) {
-		DEBPRINT("%s drive %d:%d not present\n",
-			 hwif->name, hwif->channel, port);
-		goto out;
-	}
-
 	if (!drive->acpidata->obj_handle) {
 		DEBPRINT("No ACPI object found for %s\n", drive->name);
 		goto out;
