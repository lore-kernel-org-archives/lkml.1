Return-Path: <linux-kernel-owner+w=401wt.eu-S1757769AbZD2RPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbZD2RPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 13:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbZD2RPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 13:15:13 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46318 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbZD2RPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 13:15:11 -0400
Date: Wed, 29 Apr 2009 18:15:08 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add support for more dell-wmi hotkeys
Message-ID: <20090429171508.GA717@srcf.ucam.org>
References: <49ECBAE2.2080308@dell.com> <49EE09D9.2060209@dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EE09D9.2060209@dell.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the version I'm planning on applying - look ok? I've skipped the 
OSD stuff, since right now we're not going to do anything terribly 
useful with them. I'd prefer some consensus on where we're going with 
these notifications.

commit d0cc3d9de1b8e97a7176ddc7efe48239896100c1
Author: Matthew Garrett <mjg@redhat.com>
Date:   Wed Apr 29 18:07:30 2009 +0100

    From: Mario Limonciello <mario_limonciello@dell.com>
    
    dell-wmi: Add additional keyboard events
    
    Upcoming Dell hardware will send more keyboard events via WMI. Add support
    for them.
    
    Signed-off-by: Mario Limonciello <mario_limonciello@dell.com>

diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index 81d7179..847f486 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -48,8 +48,49 @@ struct key_entry {
 
 enum { KE_KEY, KE_SW, KE_END };
 
+/*
+ * There are some additional events sent as scancodes, but these are
+ * not currently terribly relevant to Linux. They are:
+ * 
+ * 0xe020: Mute
+ * 0xe02e: Volume down
+ * 0xe030: Volume up
+ * 0xe00c: Keyboard illumination toggle
+ * 0xe033: Keyboard illumination up
+ * 0xe034: Keyboard illumination down
+ * 0xe00d: BIOS error detected
+ * 0xe013: Ambient light sensor toggle
+ * 0xe03a: Caps lock
+ * 0xe045: Num lock
+ * 0xe046: Scroll lock
+ *
+ * All of these are either notifications (rather than requests for change) or
+ * are also sent via the keyboard controller
+ */
+
 static struct key_entry dell_wmi_keymap[] = {
 	{KE_KEY, 0xe045, KEY_PROG1},
+        {KE_KEY, 0xe009, KEY_EJECTCD},
+
+	/* These also contain the brightness level at offset 6 */
+	{KE_KEY, 0xe006, KEY_BRIGHTNESSUP},
+	{KE_KEY, 0xe005, KEY_BRIGHTNESSDOWN},
+
+	/* The next device is at offset 6, the active devices are at
+	   offset 8 and the attached devices at offset 10 */
+	{KE_KEY, 0xe00b, KEY_DISPLAYTOGGLE},
+
+	/* This is actually for all radios. Although physically a
+	 * switch, the notification does not provide an indication of
+	 * state and so it should be reported as a key */
+	{KE_KEY, 0xe008, KEY_WLAN},
+
+	/* Wifi Catcher */
+	{KE_KEY, 0xe011, KEY_PROG2},
+
+	/* Battery health status button */
+	{KE_KEY, 0xe007, KEY_BATTERY},
+
 	{KE_END, 0}
 };
 

-- 
Matthew Garrett | mjg59@srcf.ucam.org
