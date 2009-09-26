Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbZIZSyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbZIZSyY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 14:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbZIZSyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 14:54:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:36394 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbZIZSyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 14:54:19 -0400
Date: Sat, 26 Sep 2009 20:52:23 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       lenb@kernel.org
Subject: [PATCH 5/9] Add bound checks in acpi/video for copy_from_user
Message-ID: <20090926205223.61dd0844@infradead.org>
In-Reply-To: <20090926204951.424e567e@infradead.org>
References: <20090926204951.424e567e@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 5/9] Add bound checks in acpi/video for copy_from_user
CC: Len Brown <lenb@kernel.org>

The ACPI video driver has a few boundary checks for copy_from_user
that unfortunately confuse the GCC optimizer.

This patch simplifies these boundary checks to the point that
gcc knows they copy_from_user() is always within bounds.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>


diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 94b1a4c..0dd2cc8 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1218,7 +1218,9 @@ acpi_video_device_write_state(struct file *file,
 	u32 state = 0;
 
 
-	if (!dev || count + 1 > sizeof str)
+	if (!dev)
+		return -EINVAL;
+	if (count >= sizeof(str))
 		return -EINVAL;
 
 	if (copy_from_user(str, buffer, count))
@@ -1275,7 +1277,10 @@ acpi_video_device_write_brightness(struct file *file,
 	int i;
 
 
-	if (!dev || !dev->brightness || count + 1 > sizeof str)
+	if (!dev || !dev->brightness)
+		return -EINVAL;
+
+	if (count >= sizeof(str))
 		return -EINVAL;
 
 	if (copy_from_user(str, buffer, count))
@@ -1557,7 +1562,10 @@ acpi_video_bus_write_POST(struct file *file,
 	unsigned long long opt, options;
 
 
-	if (!video || count + 1 > sizeof str)
+	if (!video)
+		return -EINVAL;
+
+	if (count >= sizeof(str))
 		return -EINVAL;
 
 	status = acpi_video_bus_POST_options(video, &options);
@@ -1597,7 +1605,9 @@ acpi_video_bus_write_DOS(struct file *file,
 	unsigned long opt;
 
 
-	if (!video || count + 1 > sizeof str)
+	if (!video)
+		return -EINVAL;
+	if (count >= sizeof(str))
 		return -EINVAL;
 
 	if (copy_from_user(str, buffer, count))



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
