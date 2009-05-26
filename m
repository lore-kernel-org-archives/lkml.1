Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbZEZS7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbZEZS7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 14:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbZEZS7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 14:59:18 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:57296 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbZEZS7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 14:59:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=k4xwPfDhp0HT3KL7iUlSzEfn9fQrq9tU99X+6mCK/Wwo3OShRgZzY9RaBbegYOtfcG
         plIVwzhNHBN/CVupk3pecCq1CpuWfJv1QjPykuCfdqup/sJ/2eYgwRuK4XqGv+YD3CXi
         WnERhSF4uMTjclnussyKJ64kljGW5sk7D0K00=
MIME-Version: 1.0
In-Reply-To: <430c80e90905260402q6943d04dqae38d8692c7e7ad9@mail.gmail.com>
References: <430c80e90905260141y313830c3oc98b03583daf626e@mail.gmail.com>
	 <430c80e90905260402q6943d04dqae38d8692c7e7ad9@mail.gmail.com>
Date: Wed, 27 May 2009 00:29:18 +0530
Message-ID: <f24d23310905261159t5f2ba6d4n244e160123dae069@mail.gmail.com>
Subject: [TRIVIAL][PATCH 1/1] Fix various section mismatches in 2.6.30-rc7
From: debian developer <debiandev@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This seems to have missed LKML




---------- Forwarded message ----------
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Tue, May 26, 2009 at 2:11 PM
Subject: [TRIVIAL][PATCH 1/1] Fix various section mismatches in 2.6.30-rc7
To: airlied <airlied@linux.ie>, torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>


Hello,

Fix the following section mismatches reported by $make
CONFIG_DEBUG_SECTION_MISMATCH=y

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

For the first warning, intel_lvds_init might get called after module
has been loaded,
intel_no_lvds shouldn't be marked __initdata.

For the others the explanation is in the above warnings.

Thanks,
Pranith.

Signed-off-by: D Pranith Kumar <bobby.prani@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>
---
diff -uprN -X linux-2.6.30-rc7-vanilla/Documentation/dontdiff
linux-2.6.30-rc7-vanilla/drivers/acpi/video.c
linux-2.6.30-rc7/drivers/acpi/video.c
--- linux-2.6.30-rc7-vanilla/drivers/acpi/video.c 2009-05-26
13:40:14.000000000 +0530
+++ linux-2.6.30-rc7/drivers/acpi/video.c 2009-05-26 13:27:59.000000000 +0530
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
--- linux-2.6.30-rc7-vanilla/drivers/gpu/drm/i915/intel_lvds.c
2009-05-26 13:40:14.000000000 +0530
+++ linux-2.6.30-rc7/drivers/gpu/drm/i915/intel_lvds.c 2009-05-26
13:25:50.000000000 +0530
@@ -391,7 +391,7 @@ static int __init intel_no_lvds_dmi_call
}

/* These systems claim to have LVDS, but really don't */
-static const struct dmi_system_id __initdata intel_no_lvds[] = {
+static const struct dmi_system_id intel_no_lvds[] = {
{
.callback = intel_no_lvds_dmi_callback,
.ident = "Apple Mac Mini (Core series)",


--
Pranith.
