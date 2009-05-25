Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbZEYVso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbZEYVso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 17:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbZEYVsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 17:48:12 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:60011 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbZEYVsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 17:48:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=viv9SbL0Iiy/VMmB5IxrDY69KJIyuxyMIa9IxXrsp98jkZnaSy9vrHcu6MHdYiB1+/
         VTJq3Ozr6rfNGOyafCn8t5zRaQ/RwwozYFuXPaq1NXpejhbddlQ4raitQmxUHlTLyRna
         N6R76qu0kdBqU9uQgtE9trYc84x90+TfgtKos=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/3] ide: add warning about possible HPA compatibility issue
Date: Mon, 25 May 2009 23:45:45 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6-next-20090522-05935-g4d19128; KDE/4.2.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905252345.45459.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -302,6 +302,16 @@ static const struct drive_list_entry hpa
 	{ NULL,		NULL }
 };
 
+static inline void ide_disk_hpa_warn(unsigned long long first_sector,
+				     unsigned long long last_sector)
+{
+	printk(KERN_WARNING "\t*** possible compatibility issue:\n"
+		"\t*** sectors %llu-%llu may be inaccessible\n"
+		"\t*** if Host Protected Area is used for filesystem data\n"
+		"\t*** (please refer to \"ignore_hpa\" module parameter)\n",
+		first_sector, last_sector);
+}
+
 static void idedisk_check_hpa(ide_drive_t *drive)
 {
 	unsigned long long capacity, set_max;
@@ -330,8 +340,10 @@ static void idedisk_check_hpa(ide_drive_
 			 capacity, sectors_to_MB(capacity),
 			 set_max, sectors_to_MB(set_max));
 
-	if (ide_ignore_hpa == 0)
+	if (ide_ignore_hpa == 0) {
+		ide_disk_hpa_warn(capacity, set_max - 1);
 		return;
+	}
 
 	set_max = idedisk_set_max_address(drive, set_max, lba48);
 
