Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbZFPM4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbZFPM4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 08:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbZFPMzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 08:55:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47318 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814AbZFPMza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 08:55:30 -0400
From: Petr Tesarik <ptesarik@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>, Petr Tesarik <ptesarik@suse.cz>
Subject: [PATCH v3 5/9] x86: mark some standard sections as broken in a vDSO
Date: Tue, 16 Jun 2009 14:55:25 +0200
Message-Id: <1245156929-30395-6-git-send-email-ptesarik@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245156929-30395-1-git-send-email-ptesarik@suse.cz>
References: <1245156929-30395-1-git-send-email-ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some standard sections can't work in a vDSO. Although most of them
are not very likely to ever appear there, it doesn't hurt to list
them as a precaution.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 arch/x86/vdso/vdso-layout.lds.S |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index 3d34d66..74fc5ae 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -76,6 +76,31 @@ SECTIONS
 	 */
 	.broken : {
 		/*
+		 * Code in the Procedure Linkage Table will segfault.
+		 */
+		*(.plt)
+
+		/*
+		 * Nobody does the final relocation to fixup prelinked
+		 * addresses for the actual vDSO base address.
+		 */
+		*(.rel*)
+
+		/*
+		 * Initialization/termination won't work this way.
+		 */
+		*(.init) *(.fini)
+		*(.preinit_array) *(.init_array*)
+		*(.fini_array*)
+
+		/*
+		 * Thread-local storage cannot be defined like this.
+		 */
+		*(.tdata .tdata.* .gnu.linkonce.td.*)
+		*(.tbss .tbss.* .gnu.linkonce.tb.*)
+		*(.tcommon)
+
+		/*
 		 * The vDSO setup code does not handle alternative
 		 * instructions.
 		 */
-- 
1.6.0.2

