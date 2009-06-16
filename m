Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbZFPM5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbZFPM5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 08:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755047AbZFPMzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 08:55:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47309 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633AbZFPMza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 08:55:30 -0400
From: Petr Tesarik <ptesarik@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>, Petr Tesarik <ptesarik@suse.cz>
Subject: [PATCH v3 8/9] x86: check the size of GOT in vDSO
Date: Tue, 16 Jun 2009 14:55:28 +0200
Message-Id: <1245156929-30395-9-git-send-email-ptesarik@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245156929-30395-1-git-send-email-ptesarik@suse.cz>
References: <1245156929-30395-1-git-send-email-ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no real entries in the GOT, because they are basically
pointers to dynamic symbols, and that will not work correctly without
a real dynamic linker for the vDSO.

However, the ABI pre-defines three entries in the GOT which are always
present, so the GOT section is never completely empty. We can check
that there are no extra entries beyond these three.

To make it work, pass -m32 or -m64 to the pre-processor to get the
correct definition of __SIZEOF_POINTER__.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 arch/x86/vdso/Makefile          |    5 +++--
 arch/x86/vdso/vdso-layout.lds.S |   16 ++++++++++++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

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
index 53317a6..0bef418 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -128,6 +128,22 @@ SECTIONS
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

