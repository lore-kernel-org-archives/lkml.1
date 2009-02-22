Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbZBVUrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbZBVUrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 15:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbZBVUrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 15:47:11 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:50421 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbZBVUrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 15:47:10 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] ACPI: bus.c, remove doubled status checking
Date: Sun, 22 Feb 2009 21:46:55 +0100
Message-Id: <1235335615-910-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a misplaced status test (two consequent tests without
a statement in between) in acpi_bus_init for ages. Remove it,
since the function which should be checked (acpi_os_initialize1)
has BUG_ONs on failure paths.

On platforms with BUG_ON not being "noreturn", we panics elsewhere
since the function ever returns 0 anyway.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/acpi/bus.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 765fd1c..bee64b7 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -758,8 +758,7 @@ static int __init acpi_bus_init(void)
 	acpi_status status = AE_OK;
 	extern acpi_status acpi_os_initialize1(void);
 
-
-	status = acpi_os_initialize1();
+	acpi_os_initialize1();
 
 	status =
 	    acpi_enable_subsystem(ACPI_NO_HARDWARE_INIT | ACPI_NO_ACPI_ENABLE);
@@ -769,12 +768,6 @@ static int __init acpi_bus_init(void)
 		goto error1;
 	}
 
-	if (ACPI_FAILURE(status)) {
-		printk(KERN_ERR PREFIX
-		       "Unable to initialize ACPI OS objects\n");
-		goto error1;
-	}
-
 	/*
 	 * ACPI 2.0 requires the EC driver to be loaded and work before
 	 * the EC device is found in the namespace (i.e. before acpi_initialize_objects()
-- 
1.6.1.3

