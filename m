Return-Path: <linux-kernel-owner+w=401wt.eu-S1761704AbZDBW7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761704AbZDBW7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 18:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755682AbZDBW7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 18:59:31 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:61106 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbZDBW7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 18:59:30 -0400
Date: Thu, 02 Apr 2009 18:59:11 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>, Hans de Goede <hdegoede@redhat.com>,
       linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
       Thomas Renninger <trenn@suse.de>, linux-acpi@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] ACPI: add "auto" to acpi_enforce_resources
In-reply-to: <20090329220127.GA12822@dreamland.darkstar.lan>
Message-id: <alpine.LFD.2.00.0904021858460.9182@localhost.localdomain>
References: <20090204142015.GB3923@srcf.ucam.org>
 <20090210145716.105ab58b@hyperion.delvare>
 <20090210140829.GA25397@srcf.ucam.org> <49919E08.5050002@redhat.com>
 <20090210172408.400cacee@hyperion.delvare> <20090227132740.GF1482@ucw.cz>
 <68676e00903240539i119b6d26j516ee131d4cd6781@mail.gmail.com>
 <49C8DE51.2010103@redhat.com> <20090329201617.GA10303@dreamland.darkstar.lan>
 <20090329225501.0c1771f1@hyperion.delvare>
 <20090329220127.GA12822@dreamland.darkstar.lan>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7e90560c50f754d65884e251e94c1efa2a4b5784 Mon Sep 17 00:00:00 2001
From: Luca Tettamanti <kronos.it@gmail.com>
Date: Mon, 30 Mar 2009 00:01:27 +0200
Subject: [PATCH] ACPI: acpi_enforce_resource=strict by default
X-Patchwork-Hint: ignore

Enforce strict resource checking - disallowing access by native
drivers to IO ports and memory regions claimed by ACPI firmware.

The patch is mainly aimed to block native hwmon drivers from touching
monitoring chips that ACPI thinks it own.

If this causes a regression, boot with "acpi_enforce_resources=lax"
which was the previous default.

http://bugzilla.kernel.org/show_bug.cgi?id=12376
http://bugzilla.kernel.org/show_bug.cgi?id=12541

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
Acked-by: Pavel Machek <pavel@suse.cz>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Len Brown <len.brown@intel.com>
---

as applied.

thanks,
-Len


 Documentation/kernel-parameters.txt |   16 ++++++++++++++++
 drivers/acpi/osl.c                  |    6 +++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 54f21a5..7068d0b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -258,6 +258,22 @@ and is between 256 and 4096 characters. It is defined in the file
 			to assume that this machine's pmtimer latches its value
 			and always returns good values.
 
+	acpi_enforce_resources=	[ACPI]
+			{ strict | lax | no }
+			Check for resource conflicts between native drivers
+			and ACPI OperationRegions (SystemIO and SystemMemory
+			only). IO ports and memory declared in ACPI might be
+			used by the ACPI subsystem in arbitrary AML code and
+			can interfere with legacy drivers.
+			strict (default): access to resources claimed by ACPI
+			is denied; legacy drivers trying to access reserved
+			resources will fail to bind to device using them.
+			lax: access to resources claimed by ACPI is allowed;
+			legacy drivers trying to access reserved resources
+			will bind successfully but a warning message is logged.
+			no: ACPI OperationRegions are not marked as reserved,
+			no further checks are performed.
+
 	agp=		[AGP]
 			{ off | try_unsupported }
 			off: disable AGP support
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 1e35f34..f50ca1e 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1063,9 +1063,9 @@ __setup("acpi_wake_gpes_always_on", acpi_wake_gpes_always_on_setup);
  * in arbitrary AML code and can interfere with legacy drivers.
  * acpi_enforce_resources= can be set to:
  *
- *   - strict           (2)
+ *   - strict (default) (2)
  *     -> further driver trying to access the resources will not load
- *   - lax (default)    (1)
+ *   - lax              (1)
  *     -> further driver trying to access the resources will load, but you
  *     get a system message that something might go wrong...
  *
@@ -1077,7 +1077,7 @@ __setup("acpi_wake_gpes_always_on", acpi_wake_gpes_always_on_setup);
 #define ENFORCE_RESOURCES_LAX    1
 #define ENFORCE_RESOURCES_NO     0
 
-static unsigned int acpi_enforce_resources = ENFORCE_RESOURCES_LAX;
+static unsigned int acpi_enforce_resources = ENFORCE_RESOURCES_STRICT;
 
 static int __init acpi_enforce_resources_setup(char *str)
 {
-- 
1.6.0.6

