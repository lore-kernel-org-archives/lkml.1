Return-Path: <linux-kernel-owner+w=401wt.eu-S1754354AbZIIVVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbZIIVVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 17:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbZIIVVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 17:21:08 -0400
Received: from mailout02.t-online.de ([194.25.134.17]:47600 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347AbZIIVVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 17:21:04 -0400
Message-ID: <4AA81B50.9060300@t-online.de>
Date: Wed, 09 Sep 2009 23:17:04 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Thunderbird 1.5.0.14 (X11/20060911)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@osdl.org>
CC: lenb@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix Aopen i915GMm-hfs hwmon support
Content-Type: multipart/mixed;
 boundary="------------020102030607000709090809"
X-ID: rAQjVEZegheLVxn6D0aF2omcIksAk+A6bpRkm5gfkApqlXBFaYF2FMGOL-rWKFHwE6
X-TOI-MSGID: f68cf19e-1f70-449d-b6d8-ce68abc76338
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020102030607000709090809
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi Linus!

Hwmon support is broken for the Aopen i915GMm-hfs. The
reason is the default value ENFORCE_RESOURCES_STRICT
for acpi_enforce_resources in drivers/acpi/osl.c.

The use of ENFORCE_RESOURCES_LAX is proven to be ok
by more than 30000 hours of uptime on my i915GMm-hfs.

Of course, it would be possible to tell all users of that board
to add a cmdline parameter to restore hwmon support, but
I believe that it is a good idea to do things automatically that
can be done that way. And we should only break things if
it is really necessary.

The attached trivial patch looks for the i915GMm-hfs board
during init and changes the default to lax ACPI resource
checking only for that board. I think this is reasonable, and
probably a number of other boards could also be handled
that way.

There is a high probability that for lots of people 2.6.31 will
be their first kernel using strict resource enforcement, as
2.6.31 will be used by a number of distributions.

Because of that I believe this patch should be included in
kernel 2.6.31.

cu,
 Knut

--------------020102030607000709090809
Content-Type: text/x-patch;
 name="acpiosl.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="acpiosl.patch"

--- linux-2.6.31-rc9-git3/drivers/acpi/osl.c	2009-09-06 01:38:12.000000000 +0200
+++ linux-2.6.31-rc9-git3-kp/drivers/acpi/osl.c	2009-09-09 18:41:51.000000000 +0200
@@ -1113,6 +1113,8 @@
  *   - no               (0)
  *     -> ACPI Operation Region resources will not be registered
  *
+ *     We do detect some special boards and switch to lax checking
+ *     as we do not want to break support of sensors.
  */
 #define ENFORCE_RESOURCES_STRICT 2
 #define ENFORCE_RESOURCES_LAX    1
@@ -1120,8 +1122,30 @@
 
 static unsigned int acpi_enforce_resources = ENFORCE_RESOURCES_STRICT;
 
+static int enforce_resources_lax(const struct dmi_system_id *d)
+{
+
+	printk(KERN_NOTICE "ACPI: %s detected: "
+		"using lax resource checking\n", d->ident);
+	acpi_enforce_resources = ENFORCE_RESOURCES_LAX;
+	return 0;
+}
+
+static struct dmi_system_id osl_dmi_table[] __initdata = {
+	{
+		.callback = enforce_resources_lax,
+		.ident = "AOpen i915GMm-HFS",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "AOpen"),
+			DMI_MATCH(DMI_BOARD_NAME, "i915GMm-HFS"),
+		},
+	},
+	{}
+};
+
 static int __init acpi_enforce_resources_setup(char *str)
 {
+
 	if (str == NULL || *str == '\0')
 		return 0;
 
@@ -1421,3 +1445,11 @@
 }
 
 #endif
+
+static int __init acpi_osl_init(void)
+{
+	dmi_check_system(osl_dmi_table);
+	return 0;
+}
+
+module_init(acpi_osl_init);

--------------020102030607000709090809--
