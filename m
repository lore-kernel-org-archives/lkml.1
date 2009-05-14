Return-Path: <linux-kernel-owner+w=401wt.eu-S1761867AbZENNGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761867AbZENNGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761691AbZENNGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:06:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:41804 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761674AbZENNGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:06:40 -0400
X-Sieve: CMU Sieve 2.2
From: Petr Tesarik <ptesarik@suse.cz>
To: linux-kernel@vger.kernel.org, linux-x86_64@vger.kernel.org, mingo@elte.hu,
       andi@firstfloor.org
Cc: zwane@arm.linux.org.uk, roland@redhat.com, Petr Tesarik <ptesarik@suse.cz>
Message-Id: <2bc7564b5c902a0ebabd5ab652b12c1ffa4214eb.1242299014.git.ptesarik@suse.cz>
In-Reply-To: <f249c3f58a699ce72b6cb416ddff98811848ff6f.1242299014.git.ptesarik@suse.cz>
References: <cover.1242299014.git.ptesarik@suse.cz>
	 <f249c3f58a699ce72b6cb416ddff98811848ff6f.1242299014.git.ptesarik@suse.cz>
In-Reply-To: <cover.1242299014.git.ptesarik@suse.cz>
References: <cover.1242299014.git.ptesarik@suse.cz>
Subject: [PATCH 2/4] x86: Cleanup vdso-layout.lds.S
Organization: SUSE LINUX
Date: Thu, 14 May 2009 15:06:40 +0200
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the following changes:
  - move linker-generated sections out of .data
  - add all (even theoretically) possible rodata, data and text input
    sections to their respective output sections
  - discard .altinstructions and .altinstr_replacements

Since the .altinstructions section is currently not used anyway, this
is a pure cleanup.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 arch/x86/vdso/vdso-layout.lds.S |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index 634a2cf..aaa3026 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -21,29 +21,40 @@ SECTIONS
 	.eh_frame_hdr	: { *(.eh_frame_hdr) }		:text	:eh_frame_hdr
 	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
 
+	/* Linker-generated sections */
 	.dynamic	: { *(.dynamic) }		:text	:dynamic
+	.got		: { *(.got) }			:text
+	.got.plt	: { *(.got.plt) }
+	.dynbss		: { *(.dynbss) }
 
-	.rodata		: { *(.rodata*) }		:text
+	.rodata		: {
+	      *(.rodata*)
+	      *(.gnu.linkonce.r.*)
+	}
 	.data		: {
 	      *(.data*)
 	      *(.sdata*)
-	      *(.got.plt) *(.got)
 	      *(.gnu.linkonce.d.*)
 	      *(.bss*)
-	      *(.dynbss*)
+	      *(.sbss*)
 	      *(.gnu.linkonce.b.*)
 	}
 
-	.altinstructions	: { *(.altinstructions) }
-	.altinstr_replacement	: { *(.altinstr_replacement) }
-
 	/*
 	 * Align the actual code well away from the non-instruction data.
 	 * This is the best thing for the I-cache.
 	 */
 	. = ALIGN(0x100);
 
-	.text		: { *(.text*) }			:text	=0x90909090
+	.text		: {
+	      *(.text*)
+	      *(.gnu.linkonce.t.*)
+	}						:text	=0x90909090
+
+	/DISCARD/ : {
+	      *(.altinstructions)
+	      *(.altinstr_replacement)
+	}
 }
 
 /*
-- 
1.6.0.2


