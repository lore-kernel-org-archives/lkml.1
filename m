Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbYI2WQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbYI2WQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 18:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbYI2WPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 18:15:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48223 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbYI2WPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 18:15:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 2/6] DMI: Introduce dmi_first_match to make the interface more flexible
Date: Tue, 30 Sep 2008 00:13:21 +0200
User-Agent: KMail/1.9.9
Cc: Tejun Heo <htejun@gmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ide@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200808290002.55026.rjw@sisk.pl> <48D17BBE.5020807@garzik.org> <200809300006.24919.rjw@sisk.pl>
In-Reply-To: <200809300006.24919.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809300013.22924.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

DMI: Introduce dmi_first_match to make the interface more flexible

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
 drivers/firmware/dmi_scan.c |   68 +++++++++++++++++++++++++++++++++-----------
 include/linux/dmi.h         |    1 
 2 files changed, 53 insertions(+), 16 deletions(-)

Index: linux-2.6/drivers/firmware/dmi_scan.c
===================================================================
--- linux-2.6.orig/drivers/firmware/dmi_scan.c
+++ linux-2.6/drivers/firmware/dmi_scan.c
@@ -407,6 +407,27 @@ void __init dmi_scan_machine(void)
 }
 
 /**
+ *	dmi_match - check if dmi_system_id structure matches system DMI data
+ *	@dmi: pointer to the dmi_system_id structure to check
+ */
+static bool dmi_match(const struct dmi_system_id *dmi)
+{
+	int i;
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
@@ -421,30 +442,45 @@ void __init dmi_scan_machine(void)
  */
 int dmi_check_system(const struct dmi_system_id *list)
 {
-	int i, count = 0;
-	const struct dmi_system_id *d = list;
+	int count = 0;
+	const struct dmi_system_id *d;
 
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
+		if (dmi_match(d)) {
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
+		if (dmi_match(d))
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
@@ -75,6 +75,7 @@ struct dmi_device {
 #ifdef CONFIG_DMI
 
 extern int dmi_check_system(const struct dmi_system_id *list);
+const struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list);
 extern const char * dmi_get_system_info(int field);
 extern const struct dmi_device * dmi_find_device(int type, const char *name,
 	const struct dmi_device *from);

