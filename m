Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbZFLNse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbZFLNse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933254AbZFLNkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:40:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:42309 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933216AbZFLNkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:40:40 -0400
From: Petr Tesarik <ptesarik@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>, Petr Tesarik <ptesarik@suse.cz>
Subject: [PATCH v2 7/8] x86: check the size of GOT in vDSO
Date: Fri, 12 Jun 2009 15:40:39 +0200
Message-Id: <1244814040-5810-8-git-send-email-ptesarik@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1244814040-5810-1-git-send-email-ptesarik@suse.cz>
References: <1244814040-5810-1-git-send-email-ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no real entries in the GOT, because they are basically
pointers to dynamic symbols, and that will not work correctly without
a real dynamic linker for the vDSO.

However, the ABI pre-defines three entries in the GOT which are always
present, so the GOT section is never completely empty. We can check
that there are no extra entries beyond these three.

To make it work:
  - move the GOT into a separate section
  - check the size of that section
  - pass -m32 or -m64 to the pre-processor to get the correct
    definition of __SIZEOF_POINTER__

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 arch/x86/vdso/Makefile          |    5 +++--
 arch/x86/vdso/vdso-layout.lds.S |   20 +++++++++++++++++++-
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 16a9020..8c7f06a 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -23,7 +23,8 @@ $(obj)/vdso.o: $(obj)/vdso.so
 
 targets += vdso.so vdso.so.dbg vdso.lds $(vobjs-y)
 
-export CPPFLAGS_vdso.lds += -P -C
+vdso-cppflags = -P -C
+export CPPFLAGS_vdso.lds += -m64 $(vdso-cppflags)
 
 VDSO_LDFLAGS_vdso.lds = -m elf_x86_64 -Wl,-soname=linux-vdso.so.1 \
 		      	-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
@@ -68,7 +69,7 @@ vdso32.so-$(VDSO32-y)		+= sysenter
 
 vdso32-images			= $(vdso32.so-y:%=vdso32-%.so)
 
-CPPFLAGS_vdso32.lds = $(CPPFLAGS_vdso.lds)
+CPPFLAGS_vdso32.lds = -m32 $(vdso-cppflags)
 VDSO_LDFLAGS_vdso32.lds = -m elf_i386 -Wl,-soname=linux-gate.so.1
 
 # This makes sure the $(obj) subdirectory exists even though vdso32/
diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index ffd17e8..3b56e2f 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -44,13 +44,15 @@ SECTIONS
 	.dynamic : {
 		*(.dynamic)
 	} :text :dynamic
+	.got : {
+		*(.got.plt) *(.got)
+	} :text
 
 	.rodata : {
 		*(.rodata*)
 	} :text
 	.data : {
 		*(.data*)
-		*(.got.plt) *(.got)
 		*(.gnu.linkonce.d.*)
 		*(.bss*)
 		*(.gnu.linkonce.b.*)
@@ -113,6 +115,22 @@ SECTIONS
  */
 ASSERT(!SIZEOF(.broken), "The vdso linker script found a section that is bad. See vdso-layout.lds.S for details.");
 
+/* This assert is triggered if the resulting GOT is larger than the
+ * minimum defined by the ABI, i.e. there is some actual use of the
+ * GOT.
+ *
+ * To find the offending symbols you may:
+ *  1. temporarily disable this check
+ *  2. examine the dynamic relocations of the resulting vDSO with
+ *     objdump -R
+ *
+ * To find the places where the symbols were used, you may:
+ *  1. add -Wl,--emit-relocs to VDSO_LDFLAGS
+ *  2. run objdump -r on the resulting vDSO and look for all
+ *     GOT-type relocations.
+ */
+ASSERT(SIZEOF(.got) == 3*__SIZEOF_POINTER__, "The vdso linker script found a wrong reference to an external object. See vdso-layout.lds.S for details.");
+
 /*
  * Very old versions of ld do not recognize this name token; use the constant.
  */
-- 
1.6.0.2

