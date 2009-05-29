Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbZE2HY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbZE2HY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 03:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbZE2HYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 03:24:51 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:44526 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbZE2HYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 03:24:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=v06lNifHwe1cFMa+etjPT19TZ05VYAyxGGzn15z46g8Sxes5/RwHMcA42EzThVvEDn
         KYKmL9J0jeIFG6WZQTu6d79EbllYpzB71t0tzEQlGSYn2EmGSracpbQJLuB4gSzAaap0
         IjgBIQ/1WJyFRfRUSmIMXFNQiQ16Oe/e6ngNs=
MIME-Version: 1.0
In-Reply-To: <430c80e90905260118t16a51f20x48c39fd03c1331a7@mail.gmail.com>
References: <430c80e90905260118t16a51f20x48c39fd03c1331a7@mail.gmail.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Fri, 29 May 2009 12:54:32 +0530
Message-ID: <430c80e90905290024n702a5210pecf9424331030a13@mail.gmail.com>
Subject: [REPOST][TRIVIAL][PATCH 1/1] Fix various section mismatches in 
	2.6.30-rc7
To: airlied@linux.ie, torvalds@linux-foundation.org
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Fix the following section mismatches reported by

$make CONFIG_DEBUG_SECTION_MISMATCH=y

For the first warning, intel_lvds_init might get called after module
has been loaded,
intel_no_lvds shouldn't be marked __initdata.

For the others the explanation is in the below warnings.

WARNING: vmlinux.o(.text+0x25ad83): Section mismatch in reference from
the function intel_lvds_init() to the variable
.init.data:intel_no_lvds
The function intel_lvds_init() references
the variable __initdata intel_no_lvds.
This is often because intel_lvds_init lacks a __initdata
annotation or the annotation of intel_no_lvds is wrong.

WARNING: vmlinux.o(.text+0x26308b): Section mismatch in reference from
the function intel_opregion_free() to the function
.exit.text:acpi_video_exit()
The function intel_opregion_free() references a function in an exit section.
Often the function acpi_video_exit() has valid usage outside the exit section
and the fix is to remove the __exit annotation of acpi_video_exit.

WARNING: vmlinux.o(__ksymtab+0x75f0): Section mismatch in reference
from the variable __ksymtab_acpi_video_exit to the function
.exit.text:acpi_video_exit()
The symbol acpi_video_exit is exported and annotated __exit
Fix this by removing the __exit annotation of acpi_video_exit or drop
the export.



Thanks,
Pranith.

Signed-off-by: D Pranith Kumar <bobby.prani@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>

diff -uprN -X linux-2.6.30-rc7-vanilla/Documentation/dontdiff
linux-2.6.30-rc7-vanilla/drivers/acpi/video.c
linux-2.6.30-rc7/drivers/acpi/video.c
--- linux-2.6.30-rc7-vanilla/drivers/acpi/video.c	2009-05-26
13:40:14.000000000 +0530
+++ linux-2.6.30-rc7/drivers/acpi/video.c	2009-05-26 13:27:59.000000000 +0530
@@ -2334,7 +2334,7 @@ static int __init acpi_video_init(void)
 	return acpi_video_register();
 }

-void __exit acpi_video_exit(void)
+void acpi_video_exit(void)
 {

 	acpi_bus_unregister_driver(&acpi_video_bus);
diff -uprN -X linux-2.6.30-rc7-vanilla/Documentation/dontdiff
linux-2.6.30-rc7-vanilla/drivers/gpu/drm/i915/intel_lvds.c
linux-2.6.30-rc7/drivers/gpu/drm/i915/intel_lvds.c
--- linux-2.6.30-rc7-vanilla/drivers/gpu/drm/i915/intel_lvds.c	2009-05-26
13:40:14.000000000 +0530
+++ linux-2.6.30-rc7/drivers/gpu/drm/i915/intel_lvds.c	2009-05-26
13:25:50.000000000 +0530
@@ -391,7 +391,7 @@ static int __init intel_no_lvds_dmi_call
 }

 /* These systems claim to have LVDS, but really don't */
-static const struct dmi_system_id __initdata intel_no_lvds[] = {
+static const struct dmi_system_id intel_no_lvds[] = {
 	{
 		.callback = intel_no_lvds_dmi_callback,
 		.ident = "Apple Mac Mini (Core series)",
