Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965097Ab0BZPXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 10:23:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965030Ab0BZPXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 10:23:06 -0500
From: Matthew Garrett <mjg@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 10/14] dell-laptop: Pay attention to which devices the hardware switch controls
Date: Fri, 26 Feb 2010 10:18:43 -0500
Message-Id: <1267197527-18062-11-git-send-email-mjg@redhat.com>
In-Reply-To: <1267197527-18062-1-git-send-email-mjg@redhat.com>
References: <1267197527-18062-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now, we assume that the hardware rfkill switch on Dells toggles all
radio devices. In fact, this can be configured in the BIOS and so right
now we may mark a device as hardware killed even when it isn't. Add code
to query the devices controlled by the switch, and use this when
determining the hardware kill state of a radio.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/platform/x86/dell-laptop.c |   31 +++++++++++++++++++++++++++++--
 1 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 1a0bfd4..04b2ddb 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -128,6 +128,8 @@ static struct calling_interface_buffer *buffer;
 struct page *bufferpage;
 DEFINE_MUTEX(buffer_mutex);
 
+static int hwswitch_state;
+
 static void get_buffer(void)
 {
 	mutex_lock(&buffer_mutex);
@@ -217,6 +219,8 @@ dell_send_request(struct calling_interface_buffer *buffer, int class,
 /* Derived from information in DellWirelessCtl.cpp:
    Class 17, select 11 is radio control. It returns an array of 32-bit values.
 
+   Input byte 0 = 0: Wireless information
+
    result[0]: return code
    result[1]:
      Bit 0:      Hardware switch supported
@@ -237,18 +241,35 @@ dell_send_request(struct calling_interface_buffer *buffer, int class,
      Bits 20-31: Reserved
    result[2]: NVRAM size in bytes
    result[3]: NVRAM format version number
+
+   Input byte 0 = 2: Wireless switch configuration
+   result[0]: return code
+   result[1]:
+     Bit 0:      Wifi controlled by switch
+     Bit 1:      Bluetooth controlled by switch
+     Bit 2:      WWAN controlled by switch
+     Bits 3-6:   Reserved
+     Bit 7:      Wireless switch config locked
+     Bit 8:      Wifi locator enabled
+     Bits 9-14:  Reserved
+     Bit 15:     Wifi locator setting locked
+     Bits 16-31: Reserved
 */
 
 static int dell_rfkill_set(void *data, bool blocked)
 {
 	int disable = blocked ? 1 : 0;
 	unsigned long radio = (unsigned long)data;
+	int hwswitch_bit = (unsigned long)data - 1;
 	int ret = 0;
 
 	get_buffer();
 	dell_send_request(buffer, 17, 11);
 
-	if (!(buffer->output[1] & BIT(16))) {
+	/* If the hardware switch controls this radio, and the hardware
+	   switch is disabled, don't allow changing the software state */
+	if ((hwswitch_state & BIT(hwswitch_bit)) &&
+	    !(buffer->output[1] & BIT(16))) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -265,6 +286,7 @@ static void dell_rfkill_query(struct rfkill *rfkill, void *data)
 {
 	int status;
 	int bit = (unsigned long)data + 16;
+	int hwswitch_bit = (unsigned long)data - 1;
 
 	get_buffer();
 	dell_send_request(buffer, 17, 11);
@@ -272,7 +294,9 @@ static void dell_rfkill_query(struct rfkill *rfkill, void *data)
 	release_buffer();
 
 	rfkill_set_sw_state(rfkill, !!(status & BIT(bit)));
-	rfkill_set_hw_state(rfkill, !(status & BIT(16)));
+
+	if (hwswitch_state & (BIT(hwswitch_bit)))
+		rfkill_set_hw_state(rfkill, !(status & BIT(16)));
 }
 
 static const struct rfkill_ops dell_rfkill_ops = {
@@ -306,6 +330,9 @@ static int __init dell_setup_rfkill(void)
 	get_buffer();
 	dell_send_request(buffer, 17, 11);
 	status = buffer->output[1];
+	buffer->input[0] = 0x2;
+	dell_send_request(buffer, 17, 11);
+	hwswitch_state = buffer->output[1];
 	release_buffer();
 
 	if ((status & (1<<2|1<<8)) == (1<<2|1<<8)) {
-- 
1.6.6.1

