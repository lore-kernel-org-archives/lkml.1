Return-Path: <linux-kernel-owner+w=401wt.eu-S1764617AbYD3XOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764617AbYD3XOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758939AbYD3XOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:14:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:20063 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923AbYD3XOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:14:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=enaOj6BUgV4oOlqI6V9uNyrbp3Cmp+MFyek/b0qK4OPB4OM8gaoS87W9r2G60XisB1ralnSLBIhyNvJnmTJoX/xyQc4kbWcIMtr+a9NpkrROq30NN17zOcXvR4TksU4lst4D03MsaGKiPSgzpLRDG47v7f8dniW3qhkMrft898U=
Date: Thu, 1 May 2008 04:10:02 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Justin Mattock <justinmattock@gmail.com>, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: ACPI vs proc_create_data() mismerge (was Re: proc_dir_entry 'info'
	already registered)
Message-ID: <20080501001002.GA4820@martell.zuzino.mipt.ru>
References: <dd18b0c30804301538o35d0caf0x4a7e1c503cae0d6b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd18b0c30804301538o35d0caf0x4a7e1c503cae0d6b@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 10:38:07PM +0000, Justin Mattock wrote:
> Hello, attached is dmesg of proc_dir_entry 'info' already registered;
> whatever that means. Hopefully this is not that important, just a glitch.
> Also I know I should'nt talk about 3rd party modules, but with the
> latest git, it  breaks fglrx.

ACPI vs proc_create_data() mismerge.

acpi_device_dir() is NULL until all files are createst, so everyting is
created in straight in /proc/ and creation code warns.

Carefully try patch below, I almost sent totally bogus version.



Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1070,7 +1070,7 @@ static int acpi_video_device_add_fs(struct acpi_device *device)
 	device_dir->owner = THIS_MODULE;
 
 	/* 'info' [R] */
-	entry = proc_create_data("info", S_IRUGO, acpi_device_dir(device),
+	entry = proc_create_data("info", S_IRUGO, device_dir,
 			&acpi_video_device_info_fops, acpi_driver_data(device));
 	if (!entry)
 		goto err_remove_dir;
@@ -1078,7 +1078,7 @@ static int acpi_video_device_add_fs(struct acpi_device *device)
 	/* 'state' [R/W] */
 	acpi_video_device_state_fops.write = acpi_video_device_write_state;
 	entry = proc_create_data("state", S_IFREG | S_IRUGO | S_IWUSR,
-				 acpi_device_dir(device),
+				 device_dir,
 				 &acpi_video_device_state_fops,
 				 acpi_driver_data(device));
 	if (!entry)
@@ -1088,19 +1088,21 @@ static int acpi_video_device_add_fs(struct acpi_device *device)
 	acpi_video_device_brightness_fops.write =
 		acpi_video_device_write_brightness;
 	entry = proc_create_data("brightness", S_IFREG | S_IRUGO | S_IWUSR,
-				 acpi_device_dir(device),
+				 device_dir,
 				 &acpi_video_device_brightness_fops,
 				 acpi_driver_data(device));
 	if (!entry)
 		goto err_remove_state;
 
 	/* 'EDID' [R] */
-	entry = proc_create_data("EDID", S_IRUGO, acpi_device_dir(device),
+	entry = proc_create_data("EDID", S_IRUGO, device_dir,
 				 &acpi_video_device_EDID_fops,
 				 acpi_driver_data(device));
 	if (!entry)
 		goto err_remove_brightness;
 
+	acpi_device_dir(device) = device_dir;
+
 	return 0;
 
  err_remove_brightness:
@@ -1346,21 +1348,21 @@ static int acpi_video_bus_add_fs(struct acpi_device *device)
 	device_dir->owner = THIS_MODULE;
 
 	/* 'info' [R] */
-	entry = proc_create_data("info", S_IRUGO, acpi_device_dir(device),
+	entry = proc_create_data("info", S_IRUGO, device_dir,
 				 &acpi_video_bus_info_fops,
 				 acpi_driver_data(device));
 	if (!entry)
 		goto err_remove_dir;
 
 	/* 'ROM' [R] */
-	entry = proc_create_data("ROM", S_IRUGO, acpi_device_dir(device),
+	entry = proc_create_data("ROM", S_IRUGO, device_dir,
 				 &acpi_video_bus_ROM_fops,
 				 acpi_driver_data(device));
 	if (!entry)
 		goto err_remove_info;
 
 	/* 'POST_info' [R] */
-	entry = proc_create_data("POST_info", S_IRUGO, acpi_device_dir(device),
+	entry = proc_create_data("POST_info", S_IRUGO, device_dir,
 				 &acpi_video_bus_POST_info_fops,
 				 acpi_driver_data(device));
 	if (!entry)
@@ -1369,7 +1371,7 @@ static int acpi_video_bus_add_fs(struct acpi_device *device)
 	/* 'POST' [R/W] */
 	acpi_video_bus_POST_fops.write = acpi_video_bus_write_POST;
 	entry = proc_create_data("POST", S_IFREG | S_IRUGO | S_IWUSR,
-				 acpi_device_dir(device),
+				 device_dir,
 				 &acpi_video_bus_POST_fops,
 				 acpi_driver_data(device));
 	if (!entry)
@@ -1378,7 +1380,7 @@ static int acpi_video_bus_add_fs(struct acpi_device *device)
 	/* 'DOS' [R/W] */
 	acpi_video_bus_DOS_fops.write = acpi_video_bus_write_DOS;
 	entry = proc_create_data("DOS", S_IFREG | S_IRUGO | S_IWUSR,
-				 acpi_device_dir(device),
+				 device_dir,
 				 &acpi_video_bus_DOS_fops,
 				 acpi_driver_data(device));
 	if (!entry)

