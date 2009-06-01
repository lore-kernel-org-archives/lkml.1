Return-Path: <linux-kernel-owner+w=401wt.eu-S1759800AbZFAV6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759800AbZFAV6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759105AbZFAVz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:55:59 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:51303 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759104AbZFAVz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:55:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=WZZ2qZ7pynVpeZqzdGjEnhEQKpZ6kPdPpiZfACNUa2JNAmLd/3gybo6j0YMpoJWTNS
         8q2OHn0q9/fcdCkuKqDdjxyhNmEHhZJttx7/BgMI4Q6Ix9Lu7uVho6eijbAdqCY8R37K
         gOXSox472tYR7ulp50mPTgNbnpAo/MnNevb9g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: Re: [PATCH 3/4] ide-gd: implement block device ->set_capacity method
Date: Mon, 1 Jun 2009 23:32:20 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc7-next-20090601-06903-gd651475-dirty; KDE/4.2.3; i686; ; )
Cc: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Frans Pop <elendil@planet.nl>
References: <20090531143911.7164.26834.sendpatchset@localhost.localdomain> <20090531143931.7164.96956.sendpatchset@localhost.localdomain>
In-Reply-To: <20090531143931.7164.96956.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906012332.31628.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 May 2009 16:39:31 Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide-gd: implement block device ->set_capacity method
> 
> * Use ->probed_capacity to store native device capacity for ATA disks.
> 
> * Add ->set_capacity method to struct ide_disk_ops.
> 
> * Implement disk device ->set_capacity method for ATA disks.
> 
> * Implement block device ->set_capacity method.
> 
> Together with the previous patch adding ->set_capacity block device
> method this allows automatic disabling of Host Protected Area (HPA)
> if any partitions overlapping HPA are detected.
> 
> Cc: Robert Hancock <hancockrwd@gmail.com>
> Cc: Frans Pop <elendil@planet.nl>
> Cc: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

v2 interdiff

v2:
* Check if LBA and HPA are supported in ide_disk_set_capacity().

* According to the spec the SET MAX ADDRESS command shall be
  immediately preceded by a READ NATIVE MAX ADDRESS command.

* Add ide_disk_hpa_{get_native,set}_capacity() helpers.
---
 ide-disk.c |   58 +++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 15 deletions(-)

diff -u b/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
--- b/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -302,14 +302,12 @@
 	{ NULL,		NULL }
 };
 
-static void idedisk_check_hpa(ide_drive_t *drive)
+static u64 ide_disk_hpa_get_native_capacity(ide_drive_t *drive, int lba48)
 {
-	unsigned long long capacity, set_max;
-	int lba48 = ata_id_lba48_enabled(drive->id);
+	u64 capacity, set_max;
 
 	capacity = drive->capacity64;
-
-	set_max = idedisk_read_native_max_address(drive, lba48);
+	set_max  = idedisk_read_native_max_address(drive, lba48);
 
 	if (ide_in_drive_list(drive->id, hpa_list)) {
 		/*
@@ -320,6 +318,26 @@
 			set_max--;
 	}
 
+	return set_max;
+}
+
+static u64 ide_disk_hpa_set_capacity(ide_drive_t *drive, u64 set_max, int lba48)
+{
+	set_max = idedisk_set_max_address(drive, set_max, lba48);
+	if (set_max)
+		drive->capacity64 = set_max;
+
+	return set_max;
+}
+
+static void idedisk_check_hpa(ide_drive_t *drive)
+{
+	u64 capacity, set_max;
+	int lba48 = ata_id_lba48_enabled(drive->id);
+
+	capacity = drive->capacity64;
+	set_max  = ide_disk_hpa_get_native_capacity(drive, lba48);
+
 	if (set_max <= capacity)
 		return;
 
@@ -332,13 +350,10 @@
 			 capacity, sectors_to_MB(capacity),
 			 set_max, sectors_to_MB(set_max));
 
-	set_max = idedisk_set_max_address(drive, set_max, lba48);
-
-	if (set_max) {
-		drive->capacity64 = set_max;
+	set_max = ide_disk_hpa_set_capacity(drive, set_max, lba48);
+	if (set_max)
 		printk(KERN_INFO "%s: Host Protected Area disabled.\n",
 				 drive->name);
-	}
 }
 
 static int ide_disk_get_capacity(ide_drive_t *drive)
@@ -399,12 +414,25 @@
 static u64 ide_disk_set_capacity(ide_drive_t *drive, u64 capacity)
 {
 	u64 set = min(capacity, drive->probed_capacity);
-	int lba48 = ata_id_lba48_enabled(drive->id);
-
-	capacity = idedisk_set_max_address(drive, set, lba48);
-	if (capacity)
-		drive->capacity64 = capacity;
+	u16 *id = drive->id;
+	int lba48 = ata_id_lba48_enabled(id);
 
+	if ((drive->dev_flags & IDE_DFLAG_LBA) == 0 ||
+	    ata_id_hpa_enabled(id) == 0)
+		goto out;
+
+	/*
+	 * according to the spec the SET MAX ADDRESS command shall be
+	 * immediately preceded by a READ NATIVE MAX ADDRESS command
+	 */
+	capacity = ide_disk_hpa_get_native_capacity(drive, lba48);
+	if (capacity == 0)
+		goto out;
+
+	set = ide_disk_hpa_set_capacity(drive, set, lba48);
+	if (set)
+		return set;
+out:
 	return drive->capacity64;
 }
 
