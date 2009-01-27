Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbZA0UqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbZA0UqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 15:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZA0UqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 15:46:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbZA0Up7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 15:45:59 -0500
From: Andreas Schwab <schwab@suse.de>
To: hpa@zytor.com
Subject: Fix asm constraints in vesa_store_edid
Cc: linux-kernel@vger.kernel.org
X-Yow: I wish I was a sex-starved manicurist found dead in the Bronx!!
Date: Tue, 27 Jan 2009 21:45:57 +0100
Message-ID: <jer62oxyt6.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the comment explains, the VBE DDC call can clobber any register.
Tell the compiler about that fact.

Signed-off-by: Andreas Schwab <schwab@suse.de>

---
 arch/x86/boot/video-vesa.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/boot/video-vesa.c b/arch/x86/boot/video-vesa.c
index 7511584..4a58c8c 100644
--- a/arch/x86/boot/video-vesa.c
+++ b/arch/x86/boot/video-vesa.c
@@ -269,9 +269,8 @@ void vesa_store_edid(void)
 	   we genuinely have to assume all registers are destroyed here. */
 
 	asm("pushw %%es; movw %2,%%es; "INT10"; popw %%es"
-	    : "+a" (ax), "+b" (bx)
-	    :  "c" (cx), "D" (di)
-	    : "esi");
+	    : "+a" (ax), "+b" (bx), "+c" (cx), "+D" (di)
+	    : : "esi", "edx");
 
 	if (ax != 0x004f)
 		return;		/* No EDID */
@@ -285,9 +284,9 @@ void vesa_store_edid(void)
 	dx = 0;			/* EDID block number */
 	di =(size_t) &boot_params.edid_info; /* (ES:)Pointer to block */
 	asm(INT10
-	    : "+a" (ax), "+b" (bx), "+d" (dx), "=m" (boot_params.edid_info)
-	    : "c" (cx), "D" (di)
-	    : "esi");
+	    : "+a" (ax), "+b" (bx), "+d" (dx), "=m" (boot_params.edid_info),
+	      "+c" (cx), "+D" (di)
+	    : : "esi");
 #endif /* CONFIG_FIRMWARE_EDID */
 }
 

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
