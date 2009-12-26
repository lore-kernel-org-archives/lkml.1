Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbZLZTPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbZLZTPK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 14:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZLZTPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 14:15:06 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:9897 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbZLZTPE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 14:15:04 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] ACPI: WMI: Handle duplicate GUIDs
Date: Sat, 26 Dec 2009 19:14:59 +0000
User-Agent: KMail/1.12.4 (Linux/2.6.31.5; KDE/4.3.4; x86_64; ; )
Cc: Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>, lenb@kernel.org
References: <4B352513.90302@lwfinger.net> <200912261836.41882.carlos@strangeworlds.co.uk> <4B365E56.9030302@lwfinger.net>
In-Reply-To: <4B365E56.9030302@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912261914.59515.carlos@strangeworlds.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would appear that in BIOS's with nVidia hooks, the GUID
05901221-D566-11D1-B2F0-00A0C9062910 is duplicated. For now, the simplest
solution is to just ignore any duplicate GUIDs. These particular hooks are not
currently supported/ used in the kernel, so whoever does that can figure out
what the 'right' solution should be (if there's a better one).

Fixes kernel bugzilla #14846

Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: Oldřich Jedlička <oldium.pro@seznam.cz>
---
Len,

Can you get this out ASAP, as it fixes a regression with the WMI autoloading code.

 drivers/platform/x86/wmi.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 9f93d6c..845aaf6 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -716,6 +716,22 @@ static int wmi_class_init(void)
 	return ret;
 }
 
+static bool guid_already_parsed(const char *guid_string) {
+	struct guid_block *gblock;
+	struct wmi_block *wblock;
+	struct list_head *p;
+
+	list_for_each(p, &wmi_blocks.list) {
+		wblock = list_entry(p, struct wmi_block, list);
+		gblock = &wblock->gblock;
+
+		if (strncmp(gblock->guid, guid_string, 16) == 0) {
+			return true;
+		}
+	}
+	return false;
+}
+
 /*
  * Parse the _WDG method for the GUID data blocks
  */
@@ -725,6 +741,7 @@ static __init acpi_status parse_wdg(acpi_handle handle)
 	union acpi_object *obj;
 	struct guid_block *gblock;
 	struct wmi_block *wblock;
+	char guid_string[37];
 	acpi_status status;
 	u32 i, total;
 
@@ -747,6 +764,19 @@ static __init acpi_status parse_wdg(acpi_handle handle)
 	memcpy(gblock, obj->buffer.pointer, obj->buffer.length);
 
 	for (i = 0; i < total; i++) {
+		/*
+		  Some WMI devices, like those for nVidia hooks, have a
+		  duplicate GUID. It's not clear what we should do in this
+		  case yet, so for now, we'll just ignore the duplicate.
+		  Anyone who wants to add support for that device can come
+		  up with a better workaround for the mess then.
+		*/
+		if (guid_already_parsed(gblock[i].guid) == true) {
+			wmi_gtoa(gblock[i].guid, guid_string);
+			printk(KERN_INFO PREFIX "Skipping duplicate GUID %s\n",
+				guid_string);
+			continue;
+		}
 		wblock = kzalloc(sizeof(struct wmi_block), GFP_KERNEL);
 		if (!wblock)
 			return AE_NO_MEMORY;
