Return-Path: <linux-kernel-owner+w=401wt.eu-S1762536AbXESNcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762536AbXESNcP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 09:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757483AbXESNcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 09:32:03 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:34343 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757646AbXESNcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 09:32:00 -0400
Date: Sat, 19 May 2007 15:32:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix section mismatch warnings in mtrr
Message-ID: <20070519133257.GB23370@uranus.ravnborg.org>
References: <200705191443.27161.arvidjaar@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705191443.27161.arvidjaar@mail.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following section mismatch warnings were reported by Andrey Borzenkov:

WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text:amd_init_mtrr from .text between 'mtrr_bp_init' (at offset 0x967a) and 'mtrr_attrib_to_str'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text:cyrix_init_mtrr from .text between 'mtrr_bp_init' (at offset 0x967f) and 'mtrr_attrib_to_str'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text:centaur_init_mtrr from .text between 'mtrr_bp_init' (at offset 0x9684) and 'mtrr_attrib_to_str'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text: from .text between 'get_mtrr_state' (at offset 0xa735) and 'generic_get_mtrr'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text: from .text between 'get_mtrr_state' (at offset 0xa749) and 'generic_get_mtrr'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text: from .text between 'get_mtrr_state' (at offset 0xa770) and 'generic_get_mtrr'

It was tracked down to a few functions missing __init tag.
Compile tested only.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
diff --git a/arch/i386/kernel/cpu/mtrr/generic.c b/arch/i386/kernel/cpu/mtrr/generic.c
index c4ebb51..5367e32 100644
--- a/arch/i386/kernel/cpu/mtrr/generic.c
+++ b/arch/i386/kernel/cpu/mtrr/generic.c
@@ -78,7 +78,7 @@ static void __cpuinit print_fixed(unsigned base, unsigned step, const mtrr_type*
 }
 
 /*  Grab all of the MTRR state for this CPU into *state  */
-void get_mtrr_state(void)
+void __init get_mtrr_state(void)
 {
 	unsigned int i;
 	struct mtrr_var_range *vrs;
diff --git a/arch/i386/kernel/cpu/mtrr/main.c b/arch/i386/kernel/cpu/mtrr/main.c
index 1cf466d..02a2f39 100644
--- a/arch/i386/kernel/cpu/mtrr/main.c
+++ b/arch/i386/kernel/cpu/mtrr/main.c
@@ -639,7 +639,7 @@ static struct sysdev_driver mtrr_sysdev_driver = {
  * initialized (i.e. before smp_init()).
  * 
  */
-void mtrr_bp_init(void)
+void __init mtrr_bp_init(void)
 {
 	init_ifs();
 
