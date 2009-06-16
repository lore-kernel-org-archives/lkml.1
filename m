Return-Path: <linux-kernel-owner+w=401wt.eu-S1757114AbZFPM4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbZFPM4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 08:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbZFPMzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 08:55:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:44896 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbZFPMza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 08:55:30 -0400
From: Petr Tesarik <ptesarik@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>, Petr Tesarik <ptesarik@suse.cz>
Subject: [PATCH v3 4/9] x86: mark altinstr-related sections in vDSO as broken
Date: Tue, 16 Jun 2009 14:55:24 +0200
Message-Id: <1245156929-30395-5-git-send-email-ptesarik@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245156929-30395-1-git-send-email-ptesarik@suse.cz>
References: <1245156929-30395-1-git-send-email-ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several reasons why this does not work for the vDSO.

1. The alt_instr records are not processed by anybody.

The .altinstruction sections end up in the vDSO binary, which
is then incorporated verbatim inside a completely different
section, so it is not seen by the main kernel.

There is no code to interpret them during vDSO setup either.

2. The pointers in the alt_instr records are wrong.

They point to the instructions and replacements at the prelinked
addresses, but that's neither where the vDSO blob is located at
startup, nor where it is copied to by the vDSO setup.

The .altinstr_replacement section is not broken per se, but it is
useless dead code without the accompanying .alt_instr section.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 arch/x86/vdso/vdso-layout.lds.S |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index cc66120..3d34d66 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -57,13 +57,6 @@ SECTIONS
 		*(.gnu.linkonce.b.*)
 	}
 
-	.altinstructions : {
-		*(.altinstructions)
-	}
-	.altinstr_replacement : {
-		*(.altinstr_replacement)
-	}
-
 	/*
 	 * Align the actual code well away from the non-instruction data.
 	 * This is the best thing for the I-cache.
@@ -82,6 +75,12 @@ SECTIONS
 	 * if they get used by accident.
 	 */
 	.broken : {
+		/*
+		 * The vDSO setup code does not handle alternative
+		 * instructions.
+		 */
+		*(.altinstructions)
+		*(.altinstr_replacement)
 	}
 }
 
-- 
1.6.0.2

