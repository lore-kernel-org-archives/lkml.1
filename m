Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbZASUBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbZASUBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 15:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbZASUAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 15:00:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39380 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbZASUAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:00:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 2/6] DMI: Introduce dmi_first_match to make the interface more flexible
Date: Mon, 19 Jan 2009 20:55:50 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Frans Pop <elendil@planet.nl>, tj@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20081104062734.GA4420@havoc.gtf.org> <49739371.5030107@garzik.org> <200901192053.50831.rjw@sisk.pl>
In-Reply-To: <200901192053.50831.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901192055.51108.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Some notebooks from HP have the problem that their BIOSes attempt to
spin down hard drives before entering ACPI system states S4 and S5.
This leads to a yo-yo effect during system power-off shutdown and the
last phase of hibernation when the disk is first spun down by the
kernel and then almost immediately turned on and off by the BIOS.
This, in turn, may result in shortening the disk's life times.

To prevent this from happening we can blacklist the affected systems
using DMI information.  However, only the on-board controlles should
be blacklisted and their PCI slot numbers can be used for this
purpose.  Unfortunately the existing interface for checking DMI
information of the system is not very convenient for this purpose,
because to use it, we would have to define special callback functions
or create a separate struct dmi_system_id table for each blacklisted
system.

To overcome this difficulty introduce a new function
dmi_first_match() returning a pointer to the first entry in an array
of struct dmi_system_id elements that matches the system DMI
information.  Then, we can use this pointer to access the entry's
.driver_data field containing the additional information, such as
the PCI slot number, allowing us to do the desired blacklisting.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/firmware/dmi_scan.c |   72 +++++++++++++++++++++++++++++++++-----------
 include/linux/dmi.h         |    1 
 2 files changed, 55 insertions(+), 18 deletions(-)

Index: linux-2.6/drivers/firmware/dmi_scan.c
===================================================================
--- linux-2.6.orig/drivers/firmware/dmi_scan.c
+++ linux-2.6/drivers/firmware/dmi_scan.c
@@ -415,6 +415,29 @@ void __init dmi_scan_machine(void)
 }
 
 /**
+ *	dmi_matches - check if dmi_system_id structure matches system DMI data
+ *	@dmi: pointer to the dmi_system_id structure to check
+ */
+static bool dmi_matches(const struct dmi_system_id *dmi)
+{
+	int i;
+
+	WARN(!dmi_initialized, KERN_ERR "dmi check: not initialized yet.\n");
+
+	for (i = 0; i < ARRAY_SIZE(dmi->matches); i++) {
+		int s = dmi->matches[i].slot;
+		if (s == DMI_NONE)
+			continue;
+		if (dmi_ident[s]
+		    && strstr(dmi_ident[s], dmi->matches[i].substr))
+			continue;
+		/* No match */
+		return false;
+	}
+	return true;
+}
+
+/**
  *	dmi_check_system - check system DMI data
  *	@list: array of dmi_system_id structures to match against
  *		All non-null elements of the list must match
@@ -429,32 +452,45 @@ void __init dmi_scan_machine(void)
  */
 int dmi_check_system(const struct dmi_system_id *list)
 {
-	int i, count = 0;
-	const struct dmi_system_id *d = list;
+	int count = 0;
+	const struct dmi_system_id *d;
 
-	WARN(!dmi_initialized, KERN_ERR "dmi check: not initialized yet.\n");
-
-	while (d->ident) {
-		for (i = 0; i < ARRAY_SIZE(d->matches); i++) {
-			int s = d->matches[i].slot;
-			if (s == DMI_NONE)
-				continue;
-			if (dmi_ident[s] && strstr(dmi_ident[s], d->matches[i].substr))
-				continue;
-			/* No match */
-			goto fail;
+	for (d = list; d->ident; d++)
+		if (dmi_matches(d)) {
+			count++;
+			if (d->callback && d->callback(d))
+				break;
 		}
-		count++;
-		if (d->callback && d->callback(d))
-			break;
-fail:		d++;
-	}
 
 	return count;
 }
 EXPORT_SYMBOL(dmi_check_system);
 
 /**
+ *	dmi_first_match - find dmi_system_id structure matching system DMI data
+ *	@list: array of dmi_system_id structures to match against
+ *		All non-null elements of the list must match
+ *		their slot's (field index's) data (i.e., each
+ *		list string must be a substring of the specified
+ *		DMI slot's string data) to be considered a
+ *		successful match.
+ *
+ *	Walk the blacklist table until the first match is found.  Return the
+ *	pointer to the matching entry or NULL if there's no match.
+ */
+const struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list)
+{
+	const struct dmi_system_id *d;
+
+	for (d = list; d->ident; d++)
+		if (dmi_matches(d))
+			return d;
+
+	return NULL;
+}
+EXPORT_SYMBOL(dmi_first_match);
+
+/**
  *	dmi_get_system_info - return DMI data value
  *	@field: data index (see enum dmi_field)
  *
Index: linux-2.6/include/linux/dmi.h
===================================================================
--- linux-2.6.orig/include/linux/dmi.h
+++ linux-2.6/include/linux/dmi.h
@@ -38,6 +38,7 @@ struct dmi_device {
 #ifdef CONFIG_DMI
 
 extern int dmi_check_system(const struct dmi_system_id *list);
+const struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list);
 extern const char * dmi_get_system_info(int field);
 extern const struct dmi_device * dmi_find_device(int type, const char *name,
 	const struct dmi_device *from);

