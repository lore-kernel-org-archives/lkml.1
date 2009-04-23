Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbZDWHku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbZDWHku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756404AbZDWHaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:30:14 -0400
Received: from sous-sol.org ([216.99.217.87]:50366 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756356AbZDWHaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:30:11 -0400
Message-Id: <20090423072548.873251740@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:07 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Len Brown <len.brown@intel.com>
Subject: [patch 047/100] acer-wmi: Blacklist Acer Aspire One
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=acer-wmi-blacklist-acer-aspire-one.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Carlos Corbacho <carlos@strangeworlds.co.uk>

upstream commit: a74dd5fdabcd34c93e17e9c7024eeb503c92b048

The Aspire One's ACPI-WMI interface is a placeholder that does nothing,
and the invalid results that we get from it are now causing userspace
problems as acer-wmi always returns that the rfkill is enabled (i.e. the
radio is off, when it isn't). As it's hardware controlled, acer-wmi
isn't needed on the Aspire One either.

Thanks to Andy Whitcroft at Canonical for tracking down Ubuntu's userspace
issues to this.

Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
Reported-by: Andy Whitcroft <apw@canonical.com>
Cc: stable@kernel.org
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/platform/x86/acer-wmi.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -225,6 +225,25 @@ static struct quirk_entry quirk_fujitsu_
 	.wireless = 2,
 };
 
+/* The Aspire One has a dummy ACPI-WMI interface - disable it */
+static struct dmi_system_id __devinitdata acer_blacklist[] = {
+	{
+		.ident = "Acer Aspire One (SSD)",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AOA110"),
+		},
+	},
+	{
+		.ident = "Acer Aspire One (HDD)",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AOA150"),
+		},
+	},
+	{}
+};
+
 static struct dmi_system_id acer_quirks[] = {
 	{
 		.callback = dmi_matched,
@@ -1254,6 +1273,12 @@ static int __init acer_wmi_init(void)
 
 	printk(ACER_INFO "Acer Laptop ACPI-WMI Extras\n");
 
+	if (dmi_check_system(acer_blacklist)) {
+		printk(ACER_INFO "Blacklisted hardware detected - "
+				"not loading\n");
+		return -ENODEV;
+	}
+
 	find_quirks();
 
 	/*

