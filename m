Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab0BBTKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:10:10 -0500
Received: from www17.your-server.de ([213.133.104.17]:54886 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327Ab0BBTJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:09:59 -0500
Subject: [PATCH] i915: slow acpi_lid_open() causes flickering - V2
From: Thomas Meyer <thomas@m3y3r.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       Joe Perches <joe@perches.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Feb 2010 20:09:04 +0100
Message-ID: <1265137744.2353.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_lid_open() could take up to 10ms on my computer.  Some component is
calling the drm GETCONNECTOR ioctl many times in a row.  This results in
flickering (for example, when starting a video).  Fix it by assuming an
always connected lid status.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---
 drivers/gpu/drm/i915/intel_lvds.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index aa74e59..05a31ae 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -623,6 +623,13 @@ static const struct dmi_system_id bad_lid_status[] = {
 		},
 	},
 	{
+		.ident = "Aspire 1810T",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 1810T"),
+		},
+	},
+	{
 		.ident = "PC-81005",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "MALATA"),
@@ -643,7 +650,7 @@ static enum drm_connector_status intel_lvds_detect(struct drm_connector *connect
 {
 	enum drm_connector_status status = connector_status_connected;
 
-	if (!acpi_lid_open() && !dmi_check_system(bad_lid_status))
+	if (!dmi_check_system(bad_lid_status) && !acpi_lid_open())
 		status = connector_status_disconnected;
 
 	return status;
-- 
1.6.6


