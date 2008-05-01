Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbYEAIo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbYEAIo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 04:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbYEAIoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 04:44:19 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40469 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbYEAIoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 04:44:18 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 1 May 2008 10:43:04 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 2.6.25-git16 -- BUG: unable to handle kernel NULL pointer
 dereference at 00000000 -- IP: [<c02dd5d5>] fw_show_drv_device_ids+0xd9/0xee
To: Miles Lane <miles.lane@gmail.com>
cc: linux-kernel@vger.kernel.org, Kristian Hoegsberg <krh@redhat.com>,
       linux1394-devel@lists.sourceforge.net
In-Reply-To: <a44ae5cd0804301729q77530ecerdbb65b4ed40eeba@mail.gmail.com>
Message-ID: <tkrat.39b6a8e0dced1929@s5r6.in-berlin.de>
References: <a44ae5cd0804301729q77530ecerdbb65b4ed40eeba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 Apr, Miles Lane wrote:
> BUG: unable to handle kernel NULL pointer dereference at 00000000
> IP: [<c02dd5d5>] fw_show_drv_device_ids+0xd9/0xee
[...]

Is everything alright again with this patch?

From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: ieee1394: fix NULL pointer dereference in sysfs access

Regression since "ieee1394: prevent device binding of raw1394,
video1394, dv1394", commit d2ace29fa44589da51fedc06a67b3f05301f3bfd:
$ cat /sys/bus/ieee1394/drivers/raw1394/device_ids
triggers a NULL pointer dereference in fw_show_drv_device_ids.

Reported-by: Miles Lane <miles.lane@gmail.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/nodemgr.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux/drivers/ieee1394/nodemgr.c
===================================================================
--- linux.orig/drivers/ieee1394/nodemgr.c
+++ linux/drivers/ieee1394/nodemgr.c
@@ -520,8 +520,11 @@ static ssize_t fw_show_drv_device_ids(st
 	char *scratch = buf;
 
 	driver = container_of(drv, struct hpsb_protocol_driver, driver);
+	id = driver->id_table;
+	if (!id)
+		return 0;
 
-	for (id = driver->id_table; id->match_flags != 0; id++) {
+	for (; id->match_flags != 0; id++) {
 		int need_coma = 0;
 
 		if (id->match_flags & IEEE1394_MATCH_VENDOR_ID) {

-- 
Stefan Richter
-=====-==--- -=-= ----=
http://arcgraph.de/sr/

