Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004Ab0ATSXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab0ATSXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 13:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192Ab0ATSXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 13:23:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab0ATSXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 13:23:23 -0500
Subject: [PATCH] Disable i8042 checks on Intel Apple Macs
From: Bastien Nocera <hadess@hadess.net>
To: linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 20 Jan 2010 18:23:13 +0000
Message-ID: <1264011793.1735.3683.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As those computers never had any i8042 controllers, and the
current lookup code could potentially lock up/hang/wait for
timeout for long periods of time.

Fixes intermittent hangs on boot on a MacbookAir1,1

Signed-off-by: Bastien Nocera <hadess@hadess.net>
---
 drivers/input/serio/i8042.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index d84a36e..2be7207 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -1438,12 +1438,30 @@ static struct platform_driver i8042_driver = {
 	.shutdown	= i8042_shutdown,
 };
 
+static struct dmi_system_id __initdata dmi_system_table[] = {
+	{
+		.matches = {
+			DMI_MATCH(DMI_BIOS_VENDOR, "Apple Computer, Inc.")
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BIOS_VENDOR, "Apple Inc.")
+		},
+	},
+	{}
+};
+
 static int __init i8042_init(void)
 {
 	int err;
 
 	dbg_init();
 
+	/* Intel Apple Macs never have an i8042 controller */
+	if (dmi_check_system(dmi_system_table) > 0)
+		return -ENODEV;
+
 	err = i8042_platform_init();
 	if (err)
 		return err;
-- 
1.6.6


