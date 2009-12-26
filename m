Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbZLZBSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbZLZBSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 20:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756630AbZLZBSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 20:18:35 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:64250 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019AbZLZBSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 20:18:33 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Regression in module wmi since 2.6.32 (bisected to commit 1caab3c)
Date: Sat, 26 Dec 2009 01:18:26 +0000
User-Agent: KMail/1.12.4 (Linux/2.6.31.5; KDE/4.3.4; x86_64; ; )
Cc: Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>
References: <4B352513.90302@lwfinger.net> <200912252158.31127.carlos@strangeworlds.co.uk> <4B353818.1020308@lwfinger.net>
In-Reply-To: <4B353818.1020308@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912260118.26391.carlos@strangeworlds.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 December 2009 22:09:28 Larry Finger wrote:
> On 12/25/2009 03:58 PM, Carlos Corbacho wrote:
> > On Friday 25 December 2009 21:35:49 Larry Finger wrote:
> >> Should I attach the files DSDT.dat, acpidump.out, or DSDT?
> >
> > DSDT from /proc/acpi/dsdt will do fine for my purposes.
> 
> Attached.

This is the same as bugzilla #14846 - in both cases, the GUID 05901221-D566-11D1-B2F0-00A0C9062910 (a data block query) is duplicated in two different devices, although both look like they are nVidia related hooks.

Since we don't currently have any in kernel drivers that use that stuff, and the query in question just returns a binary MOF, the simplest solution (for now) seems to be to just ignore these duplicates - if and when someone wants to support these hooks, they can clean the mess up properly when they figure out how WMI is supposed to cope with conflicting GUID's. 

Matthew, you looked at NVIF for your sins, can you see a better solution? We could just blacklist the offending GUID, rather than trying to catch all duplicates? Although just ignoring all duplicates strikes me as a better solution to catch the next time that J Random BIOS Developer decides to duplicate GUIDs in WMI.

Initial patch below which takes the "ignore all duplicate GUIDs" approach.

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
---
ACPI: WMI: Handle duplicate GUIDs

From: Carlos Corbacho <carlos@strangeworlds.co.uk>

It would appear that in BIOS's with nVidia hooks, the GUID
05901221-D566-11D1-B2F0-00A0C9062910 is duplicated. For now, the simplest
solution is to just ignore any duplicate GUIDs. These particular hooks are not
currently supported/ used in the kernel, so whoever does that can figure out
what the 'right' solution should be (if there's a better one).
---
 drivers/platform/x86/wmi.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 9f93d6c..483827f 100644
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
+		if (strncmp(gblock->guid, guid_string, 16) != 0) {
+			return true;
+		}
+	}
+	return false;
+}
+
 /*
  * Parse the _WDG method for the GUID data blocks
  */
@@ -747,6 +763,16 @@ static __init acpi_status parse_wdg(acpi_handle handle)
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
+			continue;
+		}
 		wblock = kzalloc(sizeof(struct wmi_block), GFP_KERNEL);
 		if (!wblock)
 			return AE_NO_MEMORY;
