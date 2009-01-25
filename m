Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbZAYVFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbZAYVFy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 16:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbZAYVFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 16:05:44 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:24218 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbZAYVFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 16:05:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=gflsmzqr36CO2igKo+fMxK2jnIf2VSsfMhXziFIhk03vRa3B5od80AV5vM1gzN/Qpw
         5SZun0UnMPSHwlAGJby4k8eqiJK4+LQqcrqLth01r3SahQIsscO8rLB0Nao96bOk58wP
         EPR/e0q2rF4DheVMLJqkbWRa+6DSy35zMh/n0=
Date: Sun, 25 Jan 2009 22:05:20 +0100
From: Luca Tettamanti <kronos.it@gmail.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
       Len Brown <lenb@kernel.org>
Subject: [PATCH] ACPI: add "auto" to acpi_enforce_resources
Message-ID: <20090125210520.GA12963@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This is an improved version of my earlier patch, I've reworked deviced
detection to simply check for the desired HID)

The following patch adds "auto" option to "acpi_enforce_resource"; this value
is also the new default.
"auto" enforces strict resource checking - disallowing access by native drivers
to IO ports and memory regions claimed by ACPI firmware - when a device with a
known ACPI driver is found (currently only ASUS ATK0110 is checked), and
reverts to lax checking otherwise.

The patch is mainly aimed to block native hwmon drivers from touching
monitoring chips that ACPI thinks it own.

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
---
New revision, now it simply checks the HID.

 Documentation/kernel-parameters.txt |   19 ++++++++++++++++
 drivers/acpi/osl.c                  |   41 +++++++++++++++++++++++++++++++++---
 2 files changed, 57 insertions(+), 3 deletions(-)

Index: b/Documentation/kernel-parameters.txt
===================================================================
--- a/Documentation/kernel-parameters.txt	2009-01-17 21:22:49.218882286 +0100
+++ b/Documentation/kernel-parameters.txt	2009-01-21 23:25:41.262478018 +0100
@@ -258,6 +258,25 @@
 			to assume that this machine's pmtimer latches its value
 			and always returns good values.
 
+	acpi_enforce_resources=	[ACPI]
+			{ strict, auto, lax, no }
+			Check for resource conflicts between native drivers
+			and ACPI OperationRegions (SystemIO and System Memory
+			only). IO ports and memory declared in ACPI might be
+			used by the ACPI subsystem in arbitrary AML code and
+			can interfere with legacy drivers.
+			strict: access to resources claimed by ACPI is denied;
+			legacy drivers trying to access reserved resources
+			will fail to load.
+			auto (default): try and detect ACPI devices with known
+			ACPI drivers; escalates the setting to "strict" if such
+			a device is found, otherwise behaves like "lax".
+			lax: access to resources claimed by ACPI is allowed;
+			legacy drivers trying to access reserved resources
+			will load and a warning message is logged.
+			no: ACPI OperationRegions are not marked as reserved,
+			no further checks are performed.
+
 	agp=		[AGP]
 			{ off | try_unsupported }
 			off: disable AGP support
Index: b/drivers/acpi/osl.c
===================================================================
--- a/drivers/acpi/osl.c	2009-01-17 21:22:49.190882303 +0100
+++ b/drivers/acpi/osl.c	2009-01-25 22:04:30.759209000 +0100
@@ -1063,7 +1063,10 @@
  * in arbitrary AML code and can interfere with legacy drivers.
  * acpi_enforce_resources= can be set to:
  *
- *   - strict           (2)
+ *   - auto             (2)
+ *     -> detect possible conflicts with ACPI drivers and switch to
+ *     strict if needed, otherwise act like lax
+ *   - strict           (3)
  *     -> further driver trying to access the resources will not load
  *   - lax (default)    (1)
  *     -> further driver trying to access the resources will load, but you
@@ -1073,11 +1076,12 @@
  *     -> ACPI Operation Region resources will not be registered
  *
  */
-#define ENFORCE_RESOURCES_STRICT 2
+#define ENFORCE_RESOURCES_STRICT 3
+#define ENFORCE_RESOURCES_AUTO   2
 #define ENFORCE_RESOURCES_LAX    1
 #define ENFORCE_RESOURCES_NO     0
 
-static unsigned int acpi_enforce_resources = ENFORCE_RESOURCES_LAX;
+static unsigned int acpi_enforce_resources = ENFORCE_RESOURCES_AUTO;
 
 static int __init acpi_enforce_resources_setup(char *str)
 {
@@ -1086,6 +1090,8 @@
 
 	if (!strcmp("strict", str))
 		acpi_enforce_resources = ENFORCE_RESOURCES_STRICT;
+	else if (!strcmp("auto", str))
+		acpi_enforce_resources = ENFORCE_RESOURCES_AUTO;
 	else if (!strcmp("lax", str))
 		acpi_enforce_resources = ENFORCE_RESOURCES_LAX;
 	else if (!strcmp("no", str))
@@ -1096,6 +1102,35 @@
 
 __setup("acpi_enforce_resources=", acpi_enforce_resources_setup);
 
+static acpi_status acpi_detect_asus_atk_cb(acpi_handle obj_handle,
+		u32 nesting_level, void *context, void **return_value)
+{
+	*((bool *)return_value) = true;
+	return AE_CTRL_TERMINATE;
+}
+
+static int __init acpi_detect_asus_atk(void)
+{
+	acpi_status ret;
+	bool found = false;
+
+	if (acpi_enforce_resources != ENFORCE_RESOURCES_AUTO)
+		return 0;
+
+	ret = acpi_get_devices("ATK0110", acpi_detect_asus_atk_cb,
+			NULL, (void **)&found);
+
+	if (ret == AE_OK && found) {
+		printk(KERN_DEBUG "Asus ATK0110 interface detected: "
+				"enforcing resource checking.\n");
+		acpi_enforce_resources = ENFORCE_RESOURCES_STRICT;
+	} else
+		acpi_enforce_resources =  ENFORCE_RESOURCES_LAX;
+
+	return 0;
+}
+fs_initcall(acpi_detect_asus_atk);
+
 /* Check for resource conflicts between ACPI OperationRegions and native
  * drivers */
 int acpi_check_resource_conflict(struct resource *res)


Luca
-- 
La vasca da bagno fu inventata nel 1850, il telefono nel 1875.
Se fossi vissuto nel 1850, avrei potuto restare in vasca per 25 anni
senza sentir squillare il telefono
