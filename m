Return-Path: <linux-kernel-owner+w=401wt.eu-S934994AbZDCSEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934994AbZDCSEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 14:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936091AbZDCSEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 14:04:20 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:38128 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936087AbZDCSET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 14:04:19 -0400
Date: Fri, 03 Apr 2009 18:57:50 +0100
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: linux-kernel@vger.kernel.org, acpi4asus-user@lists.sourceforge.net
Cc: corentincj@iksaif.net
Subject: [PATCH 2.6.29] eeepc-laptop: report brightness control events via the input layer
Message-ID: <504BBE2828%linux@youmustbejoking.demon.co.uk>
Mail-Followup-To: linux-kernel@vger.kernel.org, 
 acpi4asus-user@lists.sourceforge.net, corentincj@iksaif.net, Darren Salt 
 <linux@youmustbejoking.demon.co.uk>
Mail-Followup-To: linux-kernel@vger.kernel.org,
 acpi4asus-user@lists.sourceforge.net, corentincj@iksaif.net,
 linux@youmustbejoking.demon.co.uk
User-Agent: Gemini/2.29m (Qt/3.3.8b) (Linux-x86_64)
X-NuLabour-Date: Fri, 8890 Dec 1984 18:57:50 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
X-SA-Exim-Scanned: No (on pentagram.youmustbejoking.demon.co.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This maps the brightness control events to one of two keys, either
KEY_BRIGHTNESSDOWN or KEY_BRIGHTNESSUP, as needed.

Some mapping has to be done due to the fact that the BIOS reports them as
<base value> + <current brightness index>; the selection is done according to
the sign of the change in brightness (if this is 0, no keypress is reported).

(Ref. http://lists.alioth.debian.org/pipermail/debian-eeepc-devel/2009-April/002001.html)

Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>

diff -u a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
--- a/drivers/platform/x86/eeepc-laptop.c	2009-03-24 17:32:56.000000000 +0000
+++ b/drivers/platform/x86/eeepc-laptop.c	2009-04-03 13:24:59.000000000 +0100
@@ -166,6 +166,8 @@
 	{KE_KEY, 0x1b, KEY_ZOOM },
 	{KE_KEY, 0x1c, KEY_PROG2 },
 	{KE_KEY, 0x1d, KEY_PROG3 },
+	{KE_KEY, NOTIFY_BRN_MIN,     KEY_BRIGHTNESSDOWN },
+	{KE_KEY, NOTIFY_BRN_MIN + 2, KEY_BRIGHTNESSUP },
 	{KE_KEY, 0x30, KEY_SWITCHVIDEOMODE },
 	{KE_KEY, 0x31, KEY_SWITCHVIDEOMODE },
 	{KE_KEY, 0x32, KEY_SWITCHVIDEOMODE },
@@ -512,11 +514,17 @@
 	return 0;
 }
 
-static void notify_brn(void)
+static int notify_brn(void)
 {
+	/* returns the *previous* brightness, or -1 */
 	struct backlight_device *bd = eeepc_backlight_device;
 	if (bd)
+	{
+		int old = bd->props.brightness;
 		bd->props.brightness = read_brightness(bd);
+		return old;
+	}
+	return -1;
 }
 
 static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
@@ -558,17 +566,34 @@
 {
 	static struct key_entry *key;
 	u16 count;
+	int brn = -2;
 
 	if (!ehotk)
 		return;
 	if (event >= NOTIFY_BRN_MIN && event <= NOTIFY_BRN_MAX)
-		notify_brn();
+		brn = notify_brn();
 	count = ehotk->event_count[event % 128]++;
 	acpi_bus_generate_proc_event(ehotk->device, event, count);
 	acpi_bus_generate_netlink_event(ehotk->device->pnp.device_class,
 					dev_name(&ehotk->device->dev), event,
 					count);
 	if (ehotk->inputdev) {
+		if (brn != -2)
+		{
+			/* brightness-change events need special
+			 * handling for conversion to key events
+			 */
+			if (brn == -1)
+				brn = event;
+			else
+				brn += NOTIFY_BRN_MIN;
+			if (event < brn)
+				event = NOTIFY_BRN_MIN; /* brightness down */
+			else if (event > brn)
+				event = NOTIFY_BRN_MIN + 2; /* ... up */
+			else
+				event = NOTIFY_BRN_MIN + 1; /* ... unchanged */
+		}
 		key = eepc_get_entry_by_scancode(event);
 		if (key) {
 			switch (key->type) {


-- 
| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
| + Output *more* particulate pollutants.      BUFFER AGAINST GLOBAL WARMING.

I cut down trees, I eat my lunch, I go to the lavatory.
