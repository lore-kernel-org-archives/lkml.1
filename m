Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYJ3BX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYJ3BX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 21:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbYJ3BXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 21:23:50 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:38472 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbYJ3BXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 21:23:49 -0400
Subject: gpu: struct device - replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 02:23:50 +0100
Message-Id: <1225329830.5970.78.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of a larger patch series which will remove
the "char bus_id[20]" name string from struct device. The device
name is managed in the kobject anyway, and without any size
limitation, and just needlessly copied into "struct device".

To set and read the device name dev_name(dev) and dev_set_name(dev)
must be used. If your code uses static kobjects, which it shouldn't
do, "const char *init_name" can be used to statically provide the
name the registered device should have. At registration time, the
init_name field is cleared, to enforce the use of dev_name(dev) to
access the device name at a later time.

We need to get rid of all occurrences of bus_id in the entire tree
to be able to enable the new interface. Please apply this patch,
and possibly convert any remaining remaining occurrences of bus_id.

We want to submit a patch to -next, which will remove bus_id from
"struct device", to find the remaining pieces to convert, and finally
switch over to the new api, which will remove the 20 bytes array
and does no longer have a size limitation.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: gpu: struct device - replace bus_id with dev_name(), dev_set_name()

CC: Dave Airlie <airlied@redhat.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index 1611b9b..98a575c 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -165,7 +165,7 @@ int drm_sysfs_device_add(struct drm_minor *minor)
 	minor->kdev.devt = minor->device;
 	minor_str = "card%d";
 
-	snprintf(minor->kdev.bus_id, BUS_ID_SIZE, minor_str, minor->index);
+	dev_set_name(&minor->kdev, minor_str, minor->index);
 
 	err = device_register(&minor->kdev);
 	if (err) {


