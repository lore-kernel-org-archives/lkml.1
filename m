Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbZDDW4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbZDDW4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 18:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbZDDW4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 18:56:34 -0400
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:40828 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751500AbZDDW4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 18:56:33 -0400
Date: Sat, 04 Apr 2009 23:10:46 +0100
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       acpi4asus-user@lists.sourceforge.net
Subject: Re: [PATCH 2.6.29] eeepc-laptop: report brightness control events via  the input layer
Message-ID: <504C592648%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <71cd59b00904040535t51f0e8bew34b487e0a3703f7e@mail.gmail.com>
References: <504BBE2828%linux@youmustbejoking.demon.co.uk> 
 <20090404041813.GA30746@srcf.ucam.org> 
 <71cd59b00904040133p1f130673r4e93d2c48f8f4616@mail.gmail.com> 
 <504C2315A8%linux@youmustbejoking.demon.co.uk> 
 <71cd59b00904040535t51f0e8bew34b487e0a3703f7e@mail.gmail.com>
Mail-Followup-To: Corentin Chary <corentin.chary@gmail.com>, Matthew Garrett 
 <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org, 
 acpi4asus-user@lists.sourceforge.net, Darren Salt 
 <linux@youmustbejoking.demon.co.uk>
User-Agent: Gemini/2.29m (Qt/3.3.8b) (Linux-x86_64)
X-NuLabour-Date: Sat, 8891 Dec 1984 23:10:46 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
X-SA-Exim-Scanned: No (on pentagram.youmustbejoking.demon.co.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I demand that Corentin Chary may or may not have written...

>>> How can brn be -2?
>> If notify_brn() wasn't called, it will be.

> Oh, yeah, I miss the if() before notify_brn()

Easily missed. ;-)

>>> And why -2?
>> Because notify_brn() won't return it (and if it ever does, it needs to be
>> fixed). (Yes, I know, "magic numbers" and all that...)

> Maybe a negative known error code could be used here

I see the following:

* read_acpi_int() returns 0 and writes the brightness setting to *val, or
  returns -1 and writes -1 to *val if the ACPI call failed.

* get_acpi() returns whatever was written to value by read_acpi_int(), or
  -ENODEV if there's no ACPI method which can be called.

* read_brightness is a trivial wrapper for get_acpi().

* notify_brn() stores the result of read_brightness and returns the
  previously-stored value, so it can store then later return -ENODEV, -1 or
  the brightness setting.

This makes -ENODEV a suitable value. Replacing that -1 with something other
than -ENODEV might be good, but I don't think that that really matters right
now (though I've replaced the "!= -1" in the original version of the patch
with "< 0").

Revised patch follows...

---
eeepc-laptop: report brightness control events via the input layer

This maps the brightness control events to one of two keys, either
KEY_BRIGHTNESSDOWN or KEY_BRIGHTNESSUP, as needed.

Some mapping has to be done due to the fact that the BIOS reports them as
<base value> + <current brightness index>; the selection is done according to
the sign of the change in brightness (if this is 0, no keypress is reported).

(Ref. http://lists.alioth.debian.org/pipermail/debian-eeepc-devel/2009-April/002001.html)

Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>

--- a/drivers/platform/x86/eeepc-laptop.c	2009-03-24 17:32:56.000000000 +0000
+++ b/drivers/platform/x86/eeepc-laptop.c	2009-04-03 23:37:34.000000000 +0100
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
@@ -558,17 +566,33 @@
 {
 	static struct key_entry *key;
 	u16 count;
+	int brn = -ENODEV;
 
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
+		if (brn != -ENODEV) {
+			/* brightness-change events need special
+			 * handling for conversion to key events
+			 */
+			if (brn < 0)
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
| + Burn less waste. Use less packaging. Waste less.     USE FEWER RESOURCES.

Worse things happen in C.
