Return-Path: <linux-kernel-owner+w=401wt.eu-S1759187AbXLSAdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187AbXLSAdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbXLSAdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:33:15 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:16720 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbXLSAdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:33:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:reply-to:to:cc:subject:message-id:mime-version:content-type;
        b=tJblQphk33cd59cMHH2rNiq77QG+FTIlVSythHhoydc6R4U0JfVN99YMAbLZfJx0OYp/MDsYsFRJIHxAhvQeZV+RtwslQpMyzLR4EqJISSye0rLsE1RFT1CU/iXtrpZgtr1OzfjNbEZbPxR3eLWf+lDnRt80MAwS5dqHNLfYxeQ=
Date: Tue, 18 Dec 2007 19:33:00 -0500 (EST)
From: Parag Warudkar <parag.warudkar@gmail.com>
X-X-Sender: parag@mini.warudkars.net
Reply-To: parag.warudkar@gmail.com
To: linux-kernel@vger.kernel.org
cc: mingo@elte.hu, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       ak@suse.de
Subject: [PATCH] x86: Fix DMI out of memory problems
Message-ID: <Pine.LNX.4.64.0712181848430.3663@mini.warudkars.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


People with HP Desktops (including me) encounter couple of DMI errors 
during boot - dmi_save_oem_strings_devices: out of memory and dmi_string: out of 
memory.

On some HP desktops the DMI data include OEM strings (type 11) out of 
which only few are meaningful and most other are empty. DMI code 
religiously creates copies of these 27 strings (65 bytes each in my 
case) and goes OOM in dmi_string().

If DMI_MAX_DATA is bumped up a little then it goes and fails in 
dmi_save_oem_strings while allocating dmi_devices of sizeof(struct 
dmi_device) corresponding to these strings.

On x86_64 since we cannot use alloc_bootmem this early, the code uses a 
static array of 2048 bytes (DMI_MAX_DATA) for allocating the memory DMI 
needs. It does not survive the creation of empty strings and devices.

Fix this by detecting and not newly allocating empty strings and instead 
using a one statically defined dmi_empty_string.

Also do not create a new struct dmi_device for each empty string - use one 
statically define dmi_device with .name=dmi_empty_string and add that to 
the dmi_devices list.

On x64 this should stop the OOM with same current size of DMI_MAX_DATA and 
on x86 this should save a good amount of (27*65 bytes + 27*sizeof(struct 
dmi_device) bootmem.

Compile and boot tested on both x86 and x86_64.

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>

--- linux-2.6/drivers/firmware/dmi_scan.c	2007-12-07 10:04:38.000000000 -0500
+++ linux-2.6-work/drivers/firmware/dmi_scan.c	2007-12-18 19:21:52.000000000 -0500
@@ -8,6 +8,8 @@
  #include <linux/slab.h>
  #include <asm/dmi.h>

+static char dmi_empty_string[] = "        ";
+
  static char * __init dmi_string(const struct dmi_header *dm, u8 s)
  {
  	const u8 *bp = ((u8 *) dm) + dm->length;
@@ -21,11 +23,15 @@
  		}

  		if (*bp != 0) {
-			str = dmi_alloc(strlen(bp) + 1);
+			size_t len = strlen(bp)+1;
+			size_t cmp_len = len > 8 ? 8 : len;
+			if (!memcmp(bp, dmi_empty_string, cmp_len))
+				return dmi_empty_string;
+			str = dmi_alloc(len);
  			if (str != NULL)
  				strcpy(str, bp);
  			else
-				printk(KERN_ERR "dmi_string: out of memory.\n");
+				printk(KERN_ERR "dmi_string: cannot allocate %Zu bytes.\n", len);
  		}
  	}

@@ -175,12 +181,24 @@
  	}
  }

+static struct dmi_device empty_oem_string_dev =
+			{.name = dmi_empty_string,
+			 .device_data = NULL
+			};
+
  static void __init dmi_save_oem_strings_devices(const struct dmi_header *dm)
  {
  	int i, count = *(u8 *)(dm + 1);
  	struct dmi_device *dev;

  	for (i = 1; i <= count; i++) {
+		char* devname = dmi_string(dm, i);
+
+		if (!strcmp(devname, dmi_empty_string)) {
+			list_add(&empty_oem_string_dev.list, &dmi_devices);
+			continue;
+		}
+
  		dev = dmi_alloc(sizeof(*dev));
  		if (!dev) {
  			printk(KERN_ERR
@@ -189,7 +207,7 @@
  		}

  		dev->type = DMI_DEV_TYPE_OEM_STRING;
-		dev->name = dmi_string(dm, i);
+		dev->name = devname;
  		dev->device_data = NULL;

  		list_add(&dev->list, &dmi_devices);

