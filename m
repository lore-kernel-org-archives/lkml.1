Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbZINKvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbZINKvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 06:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbZINKvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 06:51:25 -0400
Received: from iksaif.net ([88.191.73.63]:44084 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbZINKvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 06:51:24 -0400
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Sep 2009 06:51:24 EDT
From: Corentin Chary <corentincj@iksaif.net>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Johannes Berg <johannes@sipsolutions.net>,
       Corentin Chary <corentincj@iksaif.net>,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 3/3] dell-laptop: fix rfkill memory leak on unload
Date: Mon, 14 Sep 2009 12:43:53 +0200
Message-Id: <1252925033-29696-4-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252925033-29696-3-git-send-email-corentincj@iksaif.net>
References: <1252925033-29696-1-git-send-email-corentincj@iksaif.net>
 <1252925033-29696-2-git-send-email-corentincj@iksaif.net>
 <1252925033-29696-3-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rfkill_unregister() should always be followed by rfkill_destroy()

Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/dell-laptop.c |   36 ++++++++++++++++++++++++------------
 1 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 74909c4..c81002c 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -206,6 +206,25 @@ static const struct rfkill_ops dell_rfkill_ops = {
 	.query = dell_rfkill_query,
 };
 
+static void dell_free_rfkill(void)
+{
+	if (wifi_rfkill) {
+		rfkill_unregister(wifi_rfkill);
+		rfkill_destroy(wifi_rfkill);
+		wifi_rfkill = NULL;
+	}
+	if (bluetooth_rfkill) {
+		rfkill_unregister(bluetooth_rfkill);
+		rfkill_destroy(bluetooth_rfkill);
+		bluetooth_rfkill = NULL;
+	}
+	if (wwan_rfkill) {
+		rfkill_unregister(wwan_rfkill);
+		rfkill_destroy(wwan_rfkill);
+		wwan_rfkill = NULL;
+	}
+}
+
 static int dell_setup_rfkill(void)
 {
 	struct calling_interface_buffer buffer;
@@ -256,14 +275,17 @@ static int dell_setup_rfkill(void)
 	return 0;
 err_wwan:
 	rfkill_destroy(wwan_rfkill);
+	wwan_rfkill = NULL;
 	if (bluetooth_rfkill)
 		rfkill_unregister(bluetooth_rfkill);
 err_bluetooth:
 	rfkill_destroy(bluetooth_rfkill);
+	bluetooth_rfkill = NULL;
 	if (wifi_rfkill)
 		rfkill_unregister(wifi_rfkill);
 err_wifi:
 	rfkill_destroy(wifi_rfkill);
+	wifi_rfkill = NULL;
 
 	return ret;
 }
@@ -369,12 +391,7 @@ static int __init dell_init(void)
 
 	return 0;
 out:
-	if (wifi_rfkill)
-		rfkill_unregister(wifi_rfkill);
-	if (bluetooth_rfkill)
-		rfkill_unregister(bluetooth_rfkill);
-	if (wwan_rfkill)
-		rfkill_unregister(wwan_rfkill);
+	dell_free_rfkill();
 	kfree(da_tokens);
 	return ret;
 }
@@ -382,12 +399,7 @@ out:
 static void __exit dell_exit(void)
 {
 	backlight_device_unregister(dell_backlight_device);
-	if (wifi_rfkill)
-		rfkill_unregister(wifi_rfkill);
-	if (bluetooth_rfkill)
-		rfkill_unregister(bluetooth_rfkill);
-	if (wwan_rfkill)
-		rfkill_unregister(wwan_rfkill);
+	dell_free_rfkill();
 }
 
 module_init(dell_init);
-- 
1.6.4.2

