Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab0CBXbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:31:35 -0500
Received: from kroah.org ([198.145.64.141]:38746 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539Ab0CBX3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:52 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Lee, Chun-Yi" <jlee@novell.com>,
       Lennart Poettering <mzxreary@0pointer.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 59/62] msi-laptop: Add resume method for set the SCM load again
Date: Tue,  2 Mar 2010 15:28:58 -0800
Message-Id: <1267572541-410-59-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee, Chun-Yi <jlee@novell.com>

Implement the resume method for set the load SCM flag after system reusme.
Without this patch, the wifi function key on SCM model will back to BIOS
control mode then confuse with the userland software control.
e.g. MSI N034

Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/platform/x86/msi-laptop.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index ff21d1a..af1b62f 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -77,6 +77,8 @@
 #define MSI_STANDARD_EC_SCM_LOAD_ADDRESS	0x2d
 #define MSI_STANDARD_EC_SCM_LOAD_MASK		(1 << 0)
 
+static int msi_laptop_resume(struct platform_device *device);
+
 static int force;
 module_param(force, bool, 0);
 MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
@@ -395,7 +397,8 @@ static struct platform_driver msipf_driver = {
 	.driver = {
 		.name = "msi-laptop-pf",
 		.owner = THIS_MODULE,
-	}
+	},
+	.resume = msi_laptop_resume,
 };
 
 static struct platform_device *msipf_device;
@@ -584,6 +587,27 @@ err_bluetooth:
 	return retval;
 }
 
+static int msi_laptop_resume(struct platform_device *device)
+{
+	u8 data;
+	int result;
+
+	if (!load_scm_model)
+		return 0;
+
+	/* set load SCM to disable hardware control by fn key */
+	result = ec_read(MSI_STANDARD_EC_SCM_LOAD_ADDRESS, &data);
+	if (result < 0)
+		return result;
+
+	result = ec_write(MSI_STANDARD_EC_SCM_LOAD_ADDRESS,
+		data | MSI_STANDARD_EC_SCM_LOAD_MASK);
+	if (result < 0)
+		return result;
+
+	return 0;
+}
+
 static int load_scm_model_init(struct platform_device *sdev)
 {
 	u8 data;
-- 
1.7.0.1

