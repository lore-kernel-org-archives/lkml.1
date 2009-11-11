Return-Path: <linux-kernel-owner+w=401wt.eu-S1758473AbZKKSyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473AbZKKSyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 13:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758168AbZKKSyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 13:54:36 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:43131 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758096AbZKKSyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 13:54:35 -0500
Message-ID: <4AFB086B.1020201@natemccallum.com>
Date: Wed, 11 Nov 2009 13:54:35 -0500
From: Nathaniel McCallum <nathaniel@natemccallum.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Devices that ignore USB spec generate invalid modaliases
References: <4AFA73C7.4070002@natemccallum.com> <4AFA784D.1060001@natemccallum.com>
In-Reply-To: <4AFA784D.1060001@natemccallum.com>
Content-Type: multipart/mixed;
 boundary="------------030700000608050503040702"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030700000608050503040702
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 11/11/2009 03:39 AM, Nathaniel McCallum wrote:
> On 11/11/2009 03:20 AM, Nathaniel McCallum wrote:
>> Drivers for devices which have bcdDevice conforming to BCD will have no
>> change in modalias output.
>
> One small clarification. Existing drivers which specify a non-zero lower
> bound and an upper bound past the next character will have their upper
> bound changed from 0x9 to 0xf (i.e.: d123[4-9] -> d123[4-9a-f]). I
> believe this is the only case where an existing (working) modalias will
> change.

I've solved the above problem in the latest patch 
(file2alias_hex_or_bcd.patch) which automatically detects if a driver 
entry is supporting a hex bcdDevice rather than a bcd one and adjusts 
accordingly.  Thus, for all normal devices, there is now no change at all.

In the process I discovered another bug.  'devlo++' and 'devhi--' are 
used.  However this number is most often in BCD format, so ++/-- won't 
work.  A second patch (file2alias_bcd_increment.patch) resolves this issue.

Again, questions/comments welcome.

Nathaniel McCallum

--------------030700000608050503040702
Content-Type: text/plain;
 name="file2alias_bcd_increment.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="file2alias_bcd_increment.patch"

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 85ad782..f25c09b 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -160,6 +160,45 @@ static void do_usb_entry(struct usb_device_id *id,
 		   "MODULE_ALIAS(\"%s\");\n", alias);
 }
 
+/* Handles increment/decrement of BCD formatted integers */
+/* Returns the previous value, so it works like i++ or i-- */
+static unsigned int incbcd(unsigned int *bcd,
+			   int inc,
+			   unsigned char max,
+			   size_t chars)
+{
+	unsigned int init = *bcd, i, j;
+	unsigned long long c, dec = 0;
+
+	/* If bcd is not in BCD format, just increment */
+	if (max > 0x9) {
+		*bcd += inc;
+		return init;
+	}
+
+	/* Convert BCD to Decimal */
+	for (i=0 ; i < chars ; i++) {
+		c = (*bcd >> (i << 2)) & 0xf;
+		c = c > 9 ? 9 : c; /* force to bcd just in case */
+		for (j=0 ; j < i ; j++)
+			c = c * 10;
+		dec += c;
+	}
+
+	/* Do our increment/decrement */
+	dec += inc;
+	*bcd  = 0;
+
+	/* Convert back to BCD */
+	for (i=0 ; i < chars ; i++) {
+		for (c=1,j=0 ; j < i ; j++)
+			c = c * 10;
+		c = (dec / c) % 10;
+		*bcd += c << (i << 2);
+	}
+	return init;
+}
+
 static void do_usb_entry_multi(struct usb_device_id *id, struct module *mod)
 {
 	unsigned int devlo, devhi;
@@ -208,10 +247,16 @@ static void do_usb_entry_multi(struct usb_device_id *id, struct module *mod)
 		}
 
 		if (clo > 0x0)
-			do_usb_entry(id, devlo++, ndigits, clo, max, max, mod);
+			do_usb_entry(id,
+				     incbcd(&devlo, 1, max,
+					    sizeof(id->bcdDevice_lo) * 2),
+				     ndigits, clo, max, max, mod);
 
 		if (chi < max)
-			do_usb_entry(id, devhi--, ndigits, 0x0, chi, max, mod);
+			do_usb_entry(id,
+				     incbcd(&devhi, -1, max,
+					    sizeof(id->bcdDevice_lo) * 2),
+				     ndigits, 0x0, chi, max, mod);
 	}
 }
 

--------------030700000608050503040702
Content-Type: text/plain;
 name="file2alias_hex_or_bcd.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="file2alias_hex_or_bcd.patch"

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 62a9025..85ad782 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -104,7 +104,7 @@ static void device_id_check(const char *modname, const char *device_id,
 static void do_usb_entry(struct usb_device_id *id,
 			 unsigned int bcdDevice_initial, int bcdDevice_initial_digits,
 			 unsigned char range_lo, unsigned char range_hi,
-			 struct module *mod)
+			 unsigned char max, struct module *mod)
 {
 	char alias[500];
 	strcpy(alias, "usb:");
@@ -118,9 +118,22 @@ static void do_usb_entry(struct usb_device_id *id,
 		sprintf(alias + strlen(alias), "%0*X",
 			bcdDevice_initial_digits, bcdDevice_initial);
 	if (range_lo == range_hi)
-		sprintf(alias + strlen(alias), "%u", range_lo);
-	else if (range_lo > 0 || range_hi < 9)
-		sprintf(alias + strlen(alias), "[%u-%u]", range_lo, range_hi);
+		sprintf(alias + strlen(alias), "%X", range_lo);
+	else if (range_lo > 0 || range_hi < max) {
+		if (range_lo > 0x9 || range_hi < 0xA)
+			sprintf(alias + strlen(alias), 
+				"[%X-%X]",
+				range_lo,
+				range_hi);
+		else {
+			sprintf(alias + strlen(alias),
+				range_lo < 0x9 ? "[%X-9" : "[%X",
+				range_lo);
+			sprintf(alias + strlen(alias),
+				range_hi > 0xA ? "a-%X]" : "%X]",
+				range_lo);
+		}
+	}
 	if (bcdDevice_initial_digits < (sizeof(id->bcdDevice_lo) * 2 - 1))
 		strcat(alias, "*");
 
@@ -150,7 +163,7 @@ static void do_usb_entry(struct usb_device_id *id,
 static void do_usb_entry_multi(struct usb_device_id *id, struct module *mod)
 {
 	unsigned int devlo, devhi;
-	unsigned char chi, clo;
+	unsigned char chi, clo, max;
 	int ndigits;
 
 	id->match_flags = TO_NATIVE(id->match_flags);
@@ -162,6 +175,17 @@ static void do_usb_entry_multi(struct usb_device_id *id, struct module *mod)
 	devhi = id->match_flags & USB_DEVICE_ID_MATCH_DEV_HI ?
 		TO_NATIVE(id->bcdDevice_hi) : ~0x0U;
 
+	/* Figure out if this entry is in bcd or hex format */
+	max = 0x9; /* Default to decimal format */
+	for (ndigits = 0 ; ndigits < sizeof(id->bcdDevice_lo) * 2 ; ndigits++) {
+		clo = (devlo >> (ndigits << 2)) & 0xf;
+		chi = ((devhi > 0x9999 ? 0x9999 : devhi) >> (ndigits << 2)) & 0xf;
+		if (clo > max || chi > max) {
+			max = 0xf;
+			break;
+		}
+	}
+
 	/*
 	 * Some modules (visor) have empty slots as placeholder for
 	 * run-time specification that results in catch-all alias
@@ -173,21 +197,21 @@ static void do_usb_entry_multi(struct usb_device_id *id, struct module *mod)
 	for (ndigits = sizeof(id->bcdDevice_lo) * 2 - 1; devlo <= devhi; ndigits--) {
 		clo = devlo & 0xf;
 		chi = devhi & 0xf;
-		if (chi > 9)	/* it's bcd not hex */
-			chi = 9;
+		if (chi > max)	/* If we are in bcd mode, truncate if necessary */
+			chi = max;
 		devlo >>= 4;
 		devhi >>= 4;
 
 		if (devlo == devhi || !ndigits) {
-			do_usb_entry(id, devlo, ndigits, clo, chi, mod);
+			do_usb_entry(id, devlo, ndigits, clo, chi, max, mod);
 			break;
 		}
 
-		if (clo > 0)
-			do_usb_entry(id, devlo++, ndigits, clo, 9, mod);
+		if (clo > 0x0)
+			do_usb_entry(id, devlo++, ndigits, clo, max, max, mod);
 
-		if (chi < 9)
-			do_usb_entry(id, devhi--, ndigits, 0, chi, mod);
+		if (chi < max)
+			do_usb_entry(id, devhi--, ndigits, 0x0, chi, max, mod);
 	}
 }
 

--------------030700000608050503040702--
