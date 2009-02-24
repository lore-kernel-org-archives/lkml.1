Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbZBXFl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbZBXFl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 00:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbZBXFlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 00:41:21 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:48895 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751339AbZBXFlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 00:41:20 -0500
From: Michael Spang <mspang@csclub.uwaterloo.ca>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
       Len Brown <len.brown@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] acer-wmi: Fix regression in backlight detection
Date: Tue, 24 Feb 2009 00:41:18 -0500
Message-Id: <1235454078-3069-1-git-send-email-mspang@csclub.uwaterloo.ca>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we disable the Acer WMI backlight device if there is no ACPI
backlight device. As a result, we end up with no backlight device at
all. We should instead disable it if there is an ACPI device, as the
other laptop drivers do. This regression was introduced in febf2d9.

Signed-off-by: Michael Spang <mspang@csclub.uwaterloo.ca>
---
 drivers/platform/x86/acer-wmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Each laptop driver with backlight support got a similar change around
febf2d9. The changes to the other drivers look correct; see e.g. a598c82f
for a similar but correct change. The regression is also in 2.6.28.

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 94c9f91..6bcca61 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -1297,7 +1297,7 @@ static int __init acer_wmi_init(void)
 
 	set_quirks();
 
-	if (!acpi_video_backlight_support() && has_cap(ACER_CAP_BRIGHTNESS)) {
+	if (acpi_video_backlight_support() && has_cap(ACER_CAP_BRIGHTNESS)) {
 		interface->capability &= ~ACER_CAP_BRIGHTNESS;
 		printk(ACER_INFO "Brightness must be controlled by "
 		       "generic video driver\n");
-- 
1.6.0.6

