Return-Path: <linux-kernel-owner+w=401wt.eu-S1751194AbZFAOQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194AbZFAOQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 10:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZFAOQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 10:16:08 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:48152 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbZFAOQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 10:16:07 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Mario Limonciello <mario_limonciello@dell.com>,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/3] dell-wmi: Add additional keyboard events
Date: Mon,  1 Jun 2009 15:14:36 +0100
Message-Id: <1243865677-25425-2-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1243865677-25425-1-git-send-email-mjg@redhat.com>
References: <1243865677-25425-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 78.86.230.144
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mario Limonciello <mario_limonciello@dell.com>

From: Mario Limonciello <mario_limonciello@dell.com>

Upcoming Dell hardware will send more keyboard events via WMI. Add support
for them.

Signed-off-by: Mario Limonciello <mario_limonciello@dell.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/platform/x86/dell-wmi.c |   45 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index 8a0d39e..9f345dc 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -46,10 +46,53 @@ struct key_entry {
 	u16 keycode;
 };
 
-enum { KE_KEY, KE_SW, KE_END };
+enum { KE_KEY, KE_SW, KE_IGNORE, KE_END };
+
+/*
+ * Certain keys are flagged as KE_IGNORE. All of these are either
+ * notifications (rather than requests for change) or are also sent
+ * via the keyboard controller so should not be sent again.
+ */
 
 static struct key_entry dell_wmi_keymap[] = {
 	{KE_KEY, 0xe045, KEY_PROG1},
+	{KE_KEY, 0xe009, KEY_EJECTCD},
+
+	/* These also contain the brightness level at offset 6 */
+	{KE_KEY, 0xe006, KEY_BRIGHTNESSUP},
+	{KE_KEY, 0xe005, KEY_BRIGHTNESSDOWN},
+
+	/* Battery health status button */
+	{KE_KEY, 0xe007, KEY_BATTERY},
+
+	/* This is actually for all radios. Although physically a
+	 * switch, the notification does not provide an indication of
+	 * state and so it should be reported as a key */
+	{KE_KEY, 0xe008, KEY_WLAN},
+
+	/* The next device is at offset 6, the active devices are at
+	   offset 8 and the attached devices at offset 10 */
+	{KE_KEY, 0xe00b, KEY_DISPLAYTOGGLE},
+
+	{KE_IGNORE, 0xe00c, KEY_KBDILLUMTOGGLE},
+
+	/* BIOS error detected */
+	{KE_IGNORE, 0xe00d, KEY_RESERVED},
+
+	/* Wifi Catcher */
+	{KE_KEY, 0xe011, KEY_PROG2},
+
+	/* Ambient light sensor toggle */
+	{KE_IGNORE, 0xe013, KEY_RESERVED},
+
+	{KE_IGNORE, 0xe020, KEY_MUTE},
+	{KE_IGNORE, 0xe02e, KEY_VOLUMEDOWN},
+	{KE_IGNORE, 0xe030, KEY_VOLUMEUP},
+	{KE_IGNORE, 0xe033, KEY_KBDILLUMUP},
+	{KE_IGNORE, 0xe034, KEY_KBDILLUMDOWN},
+	{KE_IGNORE, 0xe03a, KEY_CAPSLOCK},
+	{KE_IGNORE, 0xe045, KEY_NUMLOCK},
+	{KE_IGNORE, 0xe046, KEY_SCROLLLOCK},
 	{KE_END, 0}
 };
 
-- 
1.6.2.2

