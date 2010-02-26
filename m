Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965082Ab0BZPUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 10:20:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965023Ab0BZPTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 10:19:10 -0500
From: Matthew Garrett <mjg@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Mario Limonciello <superm1@ubuntu.com>,
       Tim Gardner <tim.gardner@canonical.com>
Subject: [PATCH 08/14] dell-laptop: Blacklist machines not supporting dell-laptop
Date: Fri, 26 Feb 2010 10:18:41 -0500
Message-Id: <1267197527-18062-9-git-send-email-mjg@redhat.com>
In-Reply-To: <1267197527-18062-1-git-send-email-mjg@redhat.com>
References: <1267197527-18062-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mario Limonciello <superm1@ubuntu.com>

The Mini family doesn't support smbios 17,11 although it reports it does.

Signed-off-by: Mario Limonciello <superm1@ubuntu.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/platform/x86/dell-laptop.c |   46 ++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 81213e8..d8b1b39 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -83,6 +83,46 @@ static const struct dmi_system_id __initdata dell_device_table[] = {
 	{ }
 };
 
+static struct dmi_system_id __devinitdata dell_blacklist[] = {
+	/* Supported by compal-laptop */
+	{
+		.ident = "Dell Mini 9",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 910"),
+		},
+	},
+	{
+		.ident = "Dell Mini 10",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1010"),
+		},
+	},
+	{
+		.ident = "Dell Mini 10v",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1011"),
+		},
+	},
+	{
+		.ident = "Dell Inspiron 11z",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1110"),
+		},
+	},
+	{
+		.ident = "Dell Mini 12",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1210"),
+		},
+	},
+	{}
+};
+
 static void __init parse_da_table(const struct dmi_header *dm)
 {
 	/* Final token is a terminator, so we don't want to copy it */
@@ -237,6 +277,12 @@ static int __init dell_setup_rfkill(void)
 	int status;
 	int ret;
 
+	if (dmi_check_system(dell_blacklist)) {
+		printk(KERN_INFO "dell-laptop: Blacklisted hardware detected - "
+				"not enabling rfkill\n");
+		return 0;
+	}
+
 	memset(&buffer, 0, sizeof(struct calling_interface_buffer));
 	dell_send_request(&buffer, 17, 11);
 	status = buffer.output[1];
-- 
1.6.6.1

