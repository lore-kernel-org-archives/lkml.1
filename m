Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbYLEAIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbYLEAIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 19:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYLEAIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 19:08:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53573 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbYLEAIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 19:08:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH -regression fix] ACPI: Fix ACPI battery regression introduced by commit 558073
Date: Fri, 5 Dec 2008 01:07:51 +0100
User-Agent: KMail/1.9.9
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812050107.51343.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: ACPI: Fix ACPI battery regression introduced by commit 558073

Commit 558073dd56707864f09d563b64e7c37c021e89d2
"ACPI: battery: Convert discharge energy rate to current properly"
caused the battery subsystem to report wrong values of the remaining
time on battery power and the time until fully charged on Toshiba
Portege R500 (and presumably on other boxes too).

Fix the issue by correcting the conversion from mW to mA.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/battery.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/acpi/battery.c
===================================================================
--- linux-2.6.orig/drivers/acpi/battery.c
+++ linux-2.6/drivers/acpi/battery.c
@@ -173,14 +173,17 @@ static int acpi_battery_get_property(str
 		val->intval = battery->voltage_now * 1000;
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
-		val->intval = battery->current_now * 1000;
-		/* if power units are mW, convert to mA by
-		   dividing by current voltage (mV/1000) */
-		if (!battery->power_unit) {
-			if (battery->voltage_now) {
+		val->intval = battery->current_now;
+		if (battery->power_unit) {
+			val->intval *= 1000;
+		} else {
+			/*
+			 * If power units are mW, convert to mA by dividing by
+			 * current voltage.
+			 */
+			if (battery->voltage_now)
 				val->intval /= battery->voltage_now;
-				val->intval *= 1000;
-			} else
+			else
 				val->intval = -1;
 		}
 		break;
