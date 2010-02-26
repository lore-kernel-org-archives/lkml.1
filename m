Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965078Ab0BZPUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 10:20:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965015Ab0BZPTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 10:19:12 -0500
From: Matthew Garrett <mjg@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Stuart Hayes <stuart_hayes@dell.com>
Subject: [PATCH 09/14] dell-laptop: Use buffer with 32-bit physical address
Date: Fri, 26 Feb 2010 10:18:42 -0500
Message-Id: <1267197527-18062-10-git-send-email-mjg@redhat.com>
In-Reply-To: <1267197527-18062-1-git-send-email-mjg@redhat.com>
References: <1267197527-18062-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stuart Hayes <stuart_hayes@dell.com>

Calls to communicate with system firmware via a SMI (using dcdbas)
need to use a buffer that has a physical address of 4GB or less.
Currently the dell-laptop driver does not guarantee this, and when the
buffer address is higher than 4GB, the address is truncated to 32 bits
and the SMI handler writes to the wrong memory address.

Signed-off-by: Stuart Hayes <stuart_hayes@dell.com>
Acked-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/platform/x86/dell-laptop.c |  122 ++++++++++++++++++++++++-----------
 1 files changed, 83 insertions(+), 39 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index d8b1b39..1a0bfd4 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -22,6 +22,7 @@
 #include <linux/rfkill.h>
 #include <linux/power_supply.h>
 #include <linux/acpi.h>
+#include <linux/mm.h>
 #include <linux/i8042.h>
 #include "../../firmware/dcdbas.h"
 
@@ -123,6 +124,21 @@ static struct dmi_system_id __devinitdata dell_blacklist[] = {
 	{}
 };
 
+static struct calling_interface_buffer *buffer;
+struct page *bufferpage;
+DEFINE_MUTEX(buffer_mutex);
+
+static void get_buffer(void)
+{
+	mutex_lock(&buffer_mutex);
+	memset(buffer, 0, sizeof(struct calling_interface_buffer));
+}
+
+static void release_buffer(void)
+{
+	mutex_unlock(&buffer_mutex);
+}
+
 static void __init parse_da_table(const struct dmi_header *dm)
 {
 	/* Final token is a terminator, so we don't want to copy it */
@@ -225,30 +241,35 @@ dell_send_request(struct calling_interface_buffer *buffer, int class,
 
 static int dell_rfkill_set(void *data, bool blocked)
 {
-	struct calling_interface_buffer buffer;
 	int disable = blocked ? 1 : 0;
 	unsigned long radio = (unsigned long)data;
+	int ret = 0;
 
-	memset(&buffer, 0, sizeof(struct calling_interface_buffer));
-	dell_send_request(&buffer, 17, 11);
-	if (!(buffer.output[1] & BIT(16)))
-		return -EINVAL;
+	get_buffer();
+	dell_send_request(buffer, 17, 11);
 
-	buffer.input[0] = (1 | (radio<<8) | (disable << 16));
-	dell_send_request(&buffer, 17, 11);
+	if (!(buffer->output[1] & BIT(16))) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	return 0;
+	buffer->input[0] = (1 | (radio<<8) | (disable << 16));
+	dell_send_request(buffer, 17, 11);
+
+out:
+	release_buffer();
+	return ret;
 }
 
 static void dell_rfkill_query(struct rfkill *rfkill, void *data)
 {
-	struct calling_interface_buffer buffer;
 	int status;
 	int bit = (unsigned long)data + 16;
 
-	memset(&buffer, 0, sizeof(struct calling_interface_buffer));
-	dell_send_request(&buffer, 17, 11);
-	status = buffer.output[1];
+	get_buffer();
+	dell_send_request(buffer, 17, 11);
+	status = buffer->output[1];
+	release_buffer();
 
 	rfkill_set_sw_state(rfkill, !!(status & BIT(bit)));
 	rfkill_set_hw_state(rfkill, !(status & BIT(16)));
@@ -273,7 +294,6 @@ static DECLARE_DELAYED_WORK(dell_rfkill_work, dell_update_rfkill);
 
 static int __init dell_setup_rfkill(void)
 {
-	struct calling_interface_buffer buffer;
 	int status;
 	int ret;
 
@@ -283,9 +303,10 @@ static int __init dell_setup_rfkill(void)
 		return 0;
 	}
 
-	memset(&buffer, 0, sizeof(struct calling_interface_buffer));
-	dell_send_request(&buffer, 17, 11);
-	status = buffer.output[1];
+	get_buffer();
+	dell_send_request(buffer, 17, 11);
+	status = buffer->output[1];
+	release_buffer();
 
 	if ((status & (1<<2|1<<8)) == (1<<2|1<<8)) {
 		wifi_rfkill = rfkill_alloc("dell-wifi", &platform_device->dev,
@@ -361,39 +382,49 @@ static void dell_cleanup_rfkill(void)
 
 static int dell_send_intensity(struct backlight_device *bd)
 {
-	struct calling_interface_buffer buffer;
+	int ret = 0;
 
-	memset(&buffer, 0, sizeof(struct calling_interface_buffer));
-	buffer.input[0] = find_token_location(BRIGHTNESS_TOKEN);
-	buffer.input[1] = bd->props.brightness;
+	get_buffer();
+	buffer->input[0] = find_token_location(BRIGHTNESS_TOKEN);
+	buffer->input[1] = bd->props.brightness;
 
-	if (buffer.input[0] == -1)
-		return -ENODEV;
+	if (buffer->input[0] == -1) {
+		ret = -ENODEV;
+		goto out;
+	}
 
 	if (power_supply_is_system_supplied() > 0)
-		dell_send_request(&buffer, 1, 2);
+		dell_send_request(buffer, 1, 2);
 	else
-		dell_send_request(&buffer, 1, 1);
+		dell_send_request(buffer, 1, 1);
 
+out:
+	release_buffer();
 	return 0;
 }
 
 static int dell_get_intensity(struct backlight_device *bd)
 {
-	struct calling_interface_buffer buffer;
+	int ret = 0;
 
-	memset(&buffer, 0, sizeof(struct calling_interface_buffer));
-	buffer.input[0] = find_token_location(BRIGHTNESS_TOKEN);
+	get_buffer();
+	buffer->input[0] = find_token_location(BRIGHTNESS_TOKEN);
 
-	if (buffer.input[0] == -1)
-		return -ENODEV;
+	if (buffer->input[0] == -1) {
+		ret = -ENODEV;
+		goto out;
+	}
 
 	if (power_supply_is_system_supplied() > 0)
-		dell_send_request(&buffer, 0, 2);
+		dell_send_request(buffer, 0, 2);
 	else
-		dell_send_request(&buffer, 0, 1);
+		dell_send_request(buffer, 0, 1);
 
-	return buffer.output[1];
+out:
+	release_buffer();
+	if (ret)
+		return ret;
+	return buffer->output[1];
 }
 
 static struct backlight_ops dell_ops = {
@@ -427,7 +458,6 @@ bool dell_laptop_i8042_filter(unsigned char data, unsigned char str,
 
 static int __init dell_init(void)
 {
-	struct calling_interface_buffer buffer;
 	int max_intensity = 0;
 	int ret;
 
@@ -453,6 +483,17 @@ static int __init dell_init(void)
 	if (ret)
 		goto fail_platform_device2;
 
+	/*
+	 * Allocate buffer below 4GB for SMI data--only 32-bit physical addr
+	 * is passed to SMI handler.
+	 */
+	bufferpage = alloc_page(GFP_KERNEL | GFP_DMA32);
+
+	if (!bufferpage)
+		goto fail_buffer;
+	buffer = page_address(bufferpage);
+	mutex_init(&buffer_mutex);
+
 	ret = dell_setup_rfkill();
 
 	if (ret) {
@@ -475,13 +516,13 @@ static int __init dell_init(void)
 		return 0;
 #endif
 
-	memset(&buffer, 0, sizeof(struct calling_interface_buffer));
-	buffer.input[0] = find_token_location(BRIGHTNESS_TOKEN);
-
-	if (buffer.input[0] != -1) {
-		dell_send_request(&buffer, 0, 2);
-		max_intensity = buffer.output[3];
+	get_buffer();
+	buffer->input[0] = find_token_location(BRIGHTNESS_TOKEN);
+	if (buffer->input[0] != -1) {
+		dell_send_request(buffer, 0, 2);
+		max_intensity = buffer->output[3];
 	}
+	release_buffer();
 
 	if (max_intensity) {
 		dell_backlight_device = backlight_device_register(
@@ -508,6 +549,8 @@ fail_backlight:
 fail_filter:
 	dell_cleanup_rfkill();
 fail_rfkill:
+	free_page((unsigned long)bufferpage);
+fail_buffer:
 	platform_device_del(platform_device);
 fail_platform_device2:
 	platform_device_put(platform_device);
@@ -529,6 +572,7 @@ static void __exit dell_exit(void)
 		platform_driver_unregister(&platform_driver);
 	}
 	kfree(da_tokens);
+	free_page((unsigned long)buffer);
 }
 
 module_init(dell_init);
-- 
1.6.6.1

