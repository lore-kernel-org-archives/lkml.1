Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbZF0FT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbZF0FT0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 01:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZF0FS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 01:18:56 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:48898 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbZF0FSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 01:18:51 -0400
From: =?utf-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
       jbarnes@virtuousgeek.org,
       =?utf-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH 1/2] ACPI: reintroduce acpi_device_ops .shutdown method
Date: Sat, 27 Jun 2009 07:18:31 +0200
Message-Id: <1246079912-17619-2-git-send-email-david@hardeman.nu>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1246079912-17619-1-git-send-email-david@hardeman.nu>
References: <1246079912-17619-1-git-send-email-david@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reintroduces the .shutdown method which is used by the
winbond-cir driver. A normal revert wasn't possible since there
had been other changes to include/acpi/acpi_bus.h since.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/acpi/scan.c     |   12 ++++++++++++
 include/acpi/acpi_bus.h |    2 ++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 781435d..c94ab13 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -464,10 +464,22 @@ static int acpi_device_remove(struct device * dev)
 	return 0;
 }
 
+static void acpi_device_shutdown(struct device *dev)
+{
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+	struct acpi_driver *acpi_drv = acpi_dev->driver;
+
+	if (acpi_drv && acpi_drv->ops.shutdown)
+		acpi_drv->ops.shutdown(acpi_dev);
+
+	return ;
+}
+
 struct bus_type acpi_bus_type = {
 	.name		= "acpi",
 	.suspend	= acpi_device_suspend,
 	.resume		= acpi_device_resume,
+	.shutdown	= acpi_device_shutdown,
 	.match		= acpi_bus_match,
 	.probe		= acpi_device_probe,
 	.remove		= acpi_device_remove,
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index c65e4ce..52da89a 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -96,6 +96,7 @@ typedef int (*acpi_op_resume) (struct acpi_device * device);
 typedef int (*acpi_op_bind) (struct acpi_device * device);
 typedef int (*acpi_op_unbind) (struct acpi_device * device);
 typedef void (*acpi_op_notify) (struct acpi_device * device, u32 event);
+typedef int (*acpi_op_shutdown) (struct acpi_device * device);
 
 struct acpi_bus_ops {
 	u32 acpi_op_add:1;
@@ -112,6 +113,7 @@ struct acpi_device_ops {
 	acpi_op_bind bind;
 	acpi_op_unbind unbind;
 	acpi_op_notify notify;
+	acpi_op_shutdown shutdown;
 };
 
 #define ACPI_DRIVER_ALL_NOTIFY_EVENTS	0x1	/* system AND device events */
-- 
1.6.3.1

