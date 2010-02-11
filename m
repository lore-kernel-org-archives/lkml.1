Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab0BKJ4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 04:56:53 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:63529 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab0BKJ4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 04:56:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=iiT147KwBPj3L/rgz7vKXtxOD5kaTy5vEiI6a1OPM/4Cw/Od8j/WSdBLvav7y2Czvp
         5/uCqd99Ctz8uBhUDXTMcqNGoho1PAu9dYDzHI0hTIckBmzecAtjgerHwjflitb/os1R
         0POO4WlTvIosY7C8bGTQJg6NdPvTY00Wy5sWc=
Subject: [PATCH] drivers: acpi: fan.c move a dereference below the NULL test
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>, Thomas Renninger <trenn@suse.de>,
       Alexey Dobriyan <adobriyan@gmail.com>, Matthew Garrett <mjg@redhat.com>,
       linux ACPI <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Feb 2010 20:56:42 +1100
Message-ID: <1265882202.27789.0.camel@ICE-BOX>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In acpi_fan_remove() device is being dereferenced before the NULL test.
This reorders the code to ensure it is checked for NULL first.

Coverity CID: 2758

Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
---
 drivers/acpi/fan.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index acf2ab2..dc39640 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -298,9 +298,14 @@ static int acpi_fan_add(struct acpi_device *device)
 
 static int acpi_fan_remove(struct acpi_device *device, int type)
 {
-	struct thermal_cooling_device *cdev = acpi_driver_data(device);
+	struct thermal_cooling_device *cdev;
+
+	if (!device)
+		return -EINVAL;
+
+	cdev = acpi_driver_data(device);
 
-	if (!device || !cdev)
+	if (!cdev)
 		return -EINVAL;
 
 	acpi_fan_remove_fs(device);
-- 
1.6.3.3




