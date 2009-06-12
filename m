Return-Path: <linux-kernel-owner+w=401wt.eu-S934136AbZFLNrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934136AbZFLNrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933265AbZFLNkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:40:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:42294 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933207AbZFLNki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:40:38 -0400
From: Petr Tesarik <ptesarik@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>, Petr Tesarik <ptesarik@suse.cz>
Subject: [PATCH v2 5/8] x86: mark altinstr-related sections in vDSO as broken
Date: Fri, 12 Jun 2009 15:40:37 +0200
Message-Id: <1244814040-5810-6-git-send-email-ptesarik@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1244814040-5810-1-git-send-email-ptesarik@suse.cz>
References: <1244814040-5810-1-git-send-email-ptesarik@suse.cz>
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
 arch/x86/vdso/vdso-layout.lds.S |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index 7a76159..fc2ad07 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -56,13 +56,6 @@ SECTIONS
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
@@ -80,6 +73,11 @@ SECTIONS
 	 * if they get used by accident.
 	 */
 	.broken : {
+		/* The vDSO setup code does not handle alternative
+		 * instructions.
+		 */ 
+		*(.altinstructions)
+		*(.altinstr_replacement)
 	}
 }
 
-- 
1.6.0.2

