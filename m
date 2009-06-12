Return-Path: <linux-kernel-owner+w=401wt.eu-S1765013AbZFLN1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765013AbZFLN1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762129AbZFLNZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:25:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:41672 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760175AbZFLNZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:25:41 -0400
From: Petr Tesarik <ptesarik@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>, Petr Tesarik <ptesarik@suse.cz>
Subject: [PATCH 6/8] x86: mark some standard sections as broken in a vDSO
Date: Fri, 12 Jun 2009 15:25:40 +0200
Message-Id: <18f4ec0df8d4aa8d1b7ae80f14939d46d297808e.1244812577.git.ptesarik@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <cover.1244812577.git.ptesarik@suse.cz>
References: <cover.1244812577.git.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some standard sections can't work in a vDSO. Although most of them
are not very likely to ever appear there, it doesn't hurt to list
them as a precaution.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 arch/x86/vdso/vdso-layout.lds.S |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index 2f0830f..0da3db0 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -71,6 +71,25 @@ SECTIONS
 	 * if they get used by accident.
 	 */
 	.broken : {
+		/* Code in the Procedure Linkage Table will segfault */
+		*(.plt)
+
+		/* Relocation will not be done, so any pointers will
+		 * still point to the prelinked address, which is wrong
+		 */
+		*(.data.rel.ro*)
+		*(.gnu.linkonce.d.rel.ro.*)
+
+		/* Initialization/termination won't work this way */
+		*(.init) *(.fini)
+		*(.preinit_array) *(.init_array*)
+		*(.fini_array*)
+
+		/* Thread-local storage cannot be defined like this */
+		*(.tdata .tdata.* .gnu.linkonce.td.*)
+		*(.tbss .tbss.* .gnu.linkonce.tb.*)
+		*(.tcommon)
+
 		/* The vDSO setup code does not handle alternative
 		 * instructions.
 		 */ 
-- 
1.6.0.2

