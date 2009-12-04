Return-Path: <linux-kernel-owner+w=401wt.eu-S932201AbZLDQYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbZLDQYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 11:24:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932171AbZLDQYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 11:24:07 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:47352 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158AbZLDQYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 11:24:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=EB3gwpgyEn2buOx80TbBN5Mfpr8oaDhKhV/9nXyJ9dkXcDXV64c781eeFSnsqHelhC
         p20XAIIXISnxTj03gyiS7Ap09bzDy7Wo0ydCFL84b+tHL49ZUpUylN3Y2VXsuhCRE+TB
         rtZglVU4WpnxpRm1U/XeNQJyPgbTzYMMeCcyQ=
MIME-Version: 1.0
Date: Fri, 4 Dec 2009 22:24:11 +0600
Message-ID: <b9df5fa10912040824r4c496b54x6165523935293001@mail.gmail.com>
Subject: [PATCH] x86: Put trampoline_data into readonly section.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 x86, trampoline_32: Put trampoline_data into readonly section.

 Put trampoline_data into readonly section when cpu
hotplug is supported. We cannot free up trampoline_data
because its been referenced from tboot_setup_sleep() which
is in non-cpuinit section.

 We were warned by the following warning:

WARNING: arch/x86/kernel/built-in.o(.text+0x13c77): Section mismatch
in reference from the function tboot_setup_sleep() to the variable
.cpuinit.rodata:trampoline_end
The function tboot_setup_sleep() references
the variable __cpuinitconst trampoline_end.
This is often because tboot_setup_sleep lacks a __cpuinitconst
annotation or the annotation of trampoline_end is wrong.

WARNING: arch/x86/kernel/built-in.o(.text+0x13c84): Section mismatch
in reference from the function tboot_setup_sleep() to the variable
.cpuinit.rodata:trampoline_data
The function tboot_setup_sleep() references
the variable __cpuinitconst trampoline_data.
This is often because tboot_setup_sleep lacks a __cpuinitconst
annotation or the annotation of trampoline_data is wrong.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

--- linus/arch/x86/kernel/trampoline_32.S	2009-12-04 17:17:51.000000000 +0600
+++ rakib/arch/x86/kernel/trampoline_32.S	2009-12-04 17:24:44.000000000 +0600
@@ -32,8 +32,13 @@
 #include <asm/segment.h>
 #include <asm/page_types.h>

+#ifdef CONFIG_ACPI_SLEEP
+.section .rodata, "a", @progbits
+#else
 /* We can free up trampoline after bootup if cpu hotplug is not supported. */
 __CPUINITRODATA
+#endif
+
 .code16

 ENTRY(trampoline_data)
