Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661AbYIZNwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbYIZNwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 09:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYIZNwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 09:52:09 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:37818 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbYIZNwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 09:52:07 -0400
From: Julien Brunel <brunel@diku.dk>
To: rui.zhang@intel.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/acpi: dereference without an error test
Date: Fri, 26 Sep 2008 15:51:57 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809261551.58262.brunel@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a variable is assigned the result of backlight_device_register, an error
test should be performed before a dereference. 

A simplified version of the semantic match that finds this problem is
as follows: 
(http://www.emn.fr/x-info/coccinelle/)
// <smpl>
@def0@
expression x;
position p0;
@@

x@p0 = backlight_device_register(...)

@protected@
expression def0.x,E;
position def0.p0;
position p;
statement S;
@@
x@p0
... when != x = E
if (!IS_ERR(x) && ...) {<... x@p ...>} else S

@unprotected@
expression def0.x,E;
identifier fld;
position def0.p0;
position p != protected.p;
@@
x@p0
... when != x = E
* x@p->fld
// </smpl>

Signed-off-by: Julien Brunel <brunel@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/acpi/video.c |    2 ++
 1 file changed, 2 insertions(+)

diff -u -p a/drivers/acpi/video.c b/drivers/acpi/video.c
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -752,6 +752,8 @@ static void acpi_video_device_find_cap(s
 		sprintf(name, "acpi_video%d", count++);
 		device->backlight = backlight_device_register(name,
 			NULL, device, &acpi_backlight_ops);
+		if (IS_ERR(device->backlight))
+			return;
 		device->backlight->props.max_brightness = device->brightness->count-3;
 		/*
 		 * If there exists the _BQC object, the _BQC object will be
