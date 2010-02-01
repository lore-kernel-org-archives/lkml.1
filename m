Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab0BASVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 13:21:52 -0500
Received: from www17.your-server.de ([213.133.104.17]:54441 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab0BASVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 13:21:51 -0500
Subject: [PATCH] i915: slow acpi_lid_open() causes flickering
From: Thomas Meyer <thomas@m3y3r.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 19:20:53 +0100
Message-ID: <1265048453.2619.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_lid_open() could take up to 10ms on my computer.
Some component is calling the drm GETCONNECTOR ioctl many times in a row.
This results in flickering (for example, when starting a video).
Fix it by assuming an always connected lid status.

This fixes bug http://bugzilla.kernel.org/show_bug.cgi?id=14670

---
 drivers/gpu/drm/i915/intel_lvds.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index aa74e59..0f0779c 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -632,6 +632,18 @@ static const struct dmi_system_id bad_lid_status[] = {
 	{ }
 };
 
+/* Some lid devices take a long time to report the lid status, assume they're connected*/
+static const struct dmi_system_id slow_lid_status[] = {
+	{
+		.ident = "Aspire 1810T",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 1810T"),
+		},
+	},
+	{ }
+};
+
 /**
  * Detect the LVDS connection.
  *
@@ -643,7 +655,8 @@ static enum drm_connector_status intel_lvds_detect(struct drm_connector *connect
 {
 	enum drm_connector_status status = connector_status_connected;
 
-	if (!acpi_lid_open() && !dmi_check_system(bad_lid_status))
+	if (!dmi_check_system(slow_lid_status) && !dmi_check_system(bad_lid_status))
+	    if (!acpi_lid_open())
 		status = connector_status_disconnected;
 
 	return status;
-- 
1.6.6


