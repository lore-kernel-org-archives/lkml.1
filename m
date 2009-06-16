Return-Path: <linux-kernel-owner+w=401wt.eu-S1758707AbZFPM5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707AbZFPM5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 08:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbZFPMzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 08:55:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:44900 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896AbZFPMza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 08:55:30 -0400
From: Petr Tesarik <ptesarik@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>, Petr Tesarik <ptesarik@suse.cz>
Subject: [PATCH v3 7/9] x86: mark writable vDSO sections as broken
Date: Tue, 16 Jun 2009 14:55:27 +0200
Message-Id: <1245156929-30395-8-git-send-email-ptesarik@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245156929-30395-1-git-send-email-ptesarik@suse.cz>
References: <1245156929-30395-1-git-send-email-ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vDSO is mapped read-only into the process' address space, so
any write accesses to it are broken and would segfault.

Additionally, if there is any uninitialized data, the vDSO setup
code does not allocate any space for it, so this is doubly broken.

The .dynbss section is a place to put symbols which are defined by
dynamic objects, are referenced by regular objects, and are not
functions. Space for these objects is allocated in the process image,
and the dynamic linker copies the object data (using a copy relocation).
So, there should never ever be a .dynbss section in a shared object
(and GNU binutils can't produce one, for sure), but then we can place
it into .broken, too.

As a side effect, the .data section now only contains the Global Offset
Table. Give it a more appropriate name for that.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 arch/x86/vdso/vdso-layout.lds.S |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index 74fc5ae..53317a6 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -48,13 +48,8 @@ SECTIONS
 	.rodata : {
 		*(.rodata*)
 	} :text
-	.data : {
-		*(.data*)
+	.got : {
 		*(.got.plt) *(.got)
-		*(.gnu.linkonce.d.*)
-		*(.bss*)
-		*(.dynbss*)
-		*(.gnu.linkonce.b.*)
 	}
 
 	/*
@@ -76,6 +71,16 @@ SECTIONS
 	 */
 	.broken : {
 		/*
+		 * The vDSO is mapped read-only, so any writable
+		 * sections are broken (and will segfault at runtime).
+		 * Additionally, space for uninitialized data is not
+		 * even allocated by the vDSO setup code.
+		 */
+		*(.data* .gnu.linkonce.d.*)
+		*(.bss* .gnu.linkonce.b.*)
+		*(.dynbss*)
+
+		/*
 		 * Code in the Procedure Linkage Table will segfault.
 		 */
 		*(.plt)
-- 
1.6.0.2

