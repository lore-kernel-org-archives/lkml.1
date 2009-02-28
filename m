Return-Path: <linux-kernel-owner+w=401wt.eu-S932424AbZB1Bys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbZB1Bys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761968AbZB1Bv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:51:29 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:45523
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762940AbZB1Bv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:51:27 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH] x86: use brk allocation for DMI
Date: Fri, 27 Feb 2009 17:51:21 -0800
Message-Id: <1235785882-17580-5-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235785882-17580-1-git-send-email-jeremy@goop.org>
References: <1235785882-17580-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Use extend_brk() to allocate memory for DMI rather than having an
ad-hoc allocator.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/dmi.h |   14 ++------------
 arch/x86/kernel/setup.c    |    6 ------
 2 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/dmi.h b/arch/x86/include/asm/dmi.h
index bc68212..aa32f7e 100644
--- a/arch/x86/include/asm/dmi.h
+++ b/arch/x86/include/asm/dmi.h
@@ -2,21 +2,11 @@
 #define _ASM_X86_DMI_H
 
 #include <asm/io.h>
+#include <asm/setup.h>
 
-#define DMI_MAX_DATA 2048
-
-extern int dmi_alloc_index;
-extern char dmi_alloc_data[DMI_MAX_DATA];
-
-/* This is so early that there is no good way to allocate dynamic memory.
-   Allocate data in an BSS array. */
 static inline void *dmi_alloc(unsigned len)
 {
-	int idx = dmi_alloc_index;
-	if ((dmi_alloc_index + len) > DMI_MAX_DATA)
-		return NULL;
-	dmi_alloc_index += len;
-	return dmi_alloc_data + idx;
+	return extend_brk(len, sizeof(int));
 }
 
 /* Use early IO mappings for DMI because it's initialized early */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ed02176..1d4fe19 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -215,12 +215,6 @@ unsigned long mmu_cr4_features = X86_CR4_PAE;
 int bootloader_type;
 
 /*
- * Early DMI memory
- */
-int dmi_alloc_index;
-char dmi_alloc_data[DMI_MAX_DATA];
-
-/*
  * Setup options
  */
 struct screen_info screen_info;
-- 
1.6.0.6

