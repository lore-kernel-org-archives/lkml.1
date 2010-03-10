Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab0CJVQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 16:16:59 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:37655 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab0CJVQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 16:16:56 -0500
Date: Wed, 10 Mar 2010 22:16:51 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 4/6] drivers/acpi: Use kasprintf
Message-ID: <Pine.LNX.4.64.1003102216290.1672@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

kasprintf combines kmalloc and sprintf, and takes care of the size
calculation itself.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression a,flag;
expression list args;
statement S;
@@

  a =
-  \(kmalloc\|kzalloc\)(...,flag)
+  kasprintf(flag,args)
  <... when != a
  if (a == NULL || ...) S
  ...>
- sprintf(a,args);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/acpi/video.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -u -p a/drivers/acpi/video.c b/drivers/acpi/video.c
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1005,11 +1005,10 @@ static void acpi_video_device_find_cap(s
 		result = acpi_video_init_brightness(device);
 		if (result)
 			return;
-		name = kzalloc(MAX_NAME_LEN, GFP_KERNEL);
+		name = kasprintf(GFP_KERNEL, "acpi_video%d", count++);
 		if (!name)
 			return;
 
-		sprintf(name, "acpi_video%d", count++);
 		device->backlight = backlight_device_register(name,
 			NULL, device, &acpi_backlight_ops);
 		kfree(name);
@@ -1056,10 +1055,9 @@ static void acpi_video_device_find_cap(s
 		if (device->cap._DCS && device->cap._DSS) {
 			static int count;
 			char *name;
-			name = kzalloc(MAX_NAME_LEN, GFP_KERNEL);
+			name = kasprintf(GFP_KERNEL, "acpi_video%d", count++);
 			if (!name)
 				return;
-			sprintf(name, "acpi_video%d", count++);
 			device->output_dev = video_output_register(name,
 					NULL, device, &acpi_output_properties);
 			kfree(name);
