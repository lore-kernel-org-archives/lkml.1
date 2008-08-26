Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbYHZNZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbYHZNZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 09:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbYHZNZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 09:25:31 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53506 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbYHZNZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 09:25:30 -0400
Date: Tue, 26 Aug 2008 14:25:25 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hp-wmi: Add proper hotkey support
Message-ID: <20080826132525.GA29293@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out that event 0x4 merely indcates that a hotkey has been 
pressed, not which one. A further query is required in order to 
determine the actual keypress. The following patch adds support for that 
along with the known keycodes.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

diff --git a/drivers/misc/hp-wmi.c b/drivers/misc/hp-wmi.c
index bc6ccfb..0968304 100644
--- a/drivers/misc/hp-wmi.c
+++ b/drivers/misc/hp-wmi.c
@@ -49,6 +49,7 @@ MODULE_ALIAS("wmi:5FB7F034-2C63-45e9-BE91-3D44E2C707E4");
 #define HPWMI_ALS_QUERY 0x3
 #define HPWMI_DOCK_QUERY 0x4
 #define HPWMI_WIRELESS_QUERY 0x5
+#define HPWMI_HOTKEY_QUERY 0xc
 
 static int __init hp_wmi_bios_setup(struct platform_device *device);
 static int __exit hp_wmi_bios_remove(struct platform_device *device);
@@ -69,7 +70,7 @@ struct bios_return {
 
 struct key_entry {
 	char type;		/* See KE_* below */
-	u8 code;
+	u16 code;
 	u16 keycode;
 };
 
@@ -79,7 +80,9 @@ static struct key_entry hp_wmi_keymap[] = {
 	{KE_SW, 0x01, SW_DOCK},
 	{KE_KEY, 0x02, KEY_BRIGHTNESSUP},
 	{KE_KEY, 0x03, KEY_BRIGHTNESSDOWN},
-	{KE_KEY, 0x04, KEY_HELP},
+	{KE_KEY, 0x20e6, KEY_PROG1},
+	{KE_KEY, 0x2142, KEY_MEDIA},
+	{KE_KEY, 0x231b, KEY_HELP},
 	{KE_END, 0}
 };
 
@@ -318,6 +321,9 @@ void hp_wmi_notify(u32 value, void *context)
 
 	if (obj && obj->type == ACPI_TYPE_BUFFER && obj->buffer.length == 8) {
 		int eventcode = *((u8 *) obj->buffer.pointer);
+		if (eventcode == 0x4)
+			eventcode = hp_wmi_perform_query(HPWMI_HOTKEY_QUERY, 0,
+							 0);
 		key = hp_wmi_get_entry_by_scancode(eventcode);
 		if (key) {
 			switch (key->type) {

-- 
Matthew Garrett | mjg59@srcf.ucam.org
