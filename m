Return-Path: <linux-kernel-owner+w=401wt.eu-S933315AbYAaWNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315AbYAaWNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934478AbYAaWKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:10:45 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:40289 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934323AbYAaWKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:10:37 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] x86: fix section mismatch warning in acpi/boot.c
Date: Thu, 31 Jan 2008 23:10:37 +0100
Message-Id: <1201817440-5081-8-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <20080131220430.GA4874@uranus.ravnborg.org>
References: <20080131220430.GA4874@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: o-x86_64/arch/x86/kernel/built-in.o(.text+0x13d15): Section mismatch in reference from the function acpi_map_lsapic() to the function .cpuinit.text:mp_register_lapic()

The function acpi_map_lsapic() is exported and thus not annotated.
But the sole user is acpi/processor_core.c in a __cpuinit path.
So create a small wrapper and put back the annotation thus
avoiding the warning.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/kernel/acpi/boot.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 0ca27c7..d2a5843 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -496,7 +496,8 @@ EXPORT_SYMBOL(acpi_register_gsi);
  *  ACPI based hotplug support for CPU
  */
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
-int acpi_map_lsapic(acpi_handle handle, int *pcpu)
+
+static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int *pcpu)
 {
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *obj;
@@ -551,6 +552,11 @@ int acpi_map_lsapic(acpi_handle handle, int *pcpu)
 	return 0;
 }
 
+/* wrapper to silence section mismatch warning */
+int __ref acpi_map_lsapic(acpi_handle handle, int *pcpu)
+{
+	return _acpi_map_lsapic(handle, pcpu);
+}
 EXPORT_SYMBOL(acpi_map_lsapic);
 
 int acpi_unmap_lsapic(int cpu)
-- 
1.5.4.rc3.14.g44397

