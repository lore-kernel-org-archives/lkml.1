Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbYDFHYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbYDFHYN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 03:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbYDFHYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 03:24:03 -0400
Received: from ozlabs.org ([203.10.76.45]:42686 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbYDFHYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 03:24:01 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Fix booting pentium+ with dodgy TSC
Date: Sun, 6 Apr 2008 17:23:38 +1000
User-Agent: KMail/1.9.9
Cc: Andi Kleen <ak@suse.de>, "H. Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       lguest <lguest@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804061723.38766.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus please apply.  Almost by definition this patch can't make things worse.

We handle a broken tsc these days, so no need to panic.  We clear the TSC bit
when tsc_init decides it's unreliable (eg. under lguest w/ bad host TSC),
leading to bogus panic.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 5e0a39f4d07b arch/x86/kernel/cpu/bugs.c
--- a/arch/x86/kernel/cpu/bugs.c	Sun Apr 06 13:40:39 2008 +1000
+++ b/arch/x86/kernel/cpu/bugs.c	Sun Apr 06 17:14:12 2008 +1000
@@ -143,14 +143,6 @@ static void __init check_config(void)
 #endif
 
 /*
- * If we configured ourselves for a TSC, we'd better have one!
- */
-#ifdef CONFIG_X86_TSC
-	if (!cpu_has_tsc)
-		panic("Kernel compiled for Pentium+, requires TSC feature!");
-#endif
-
-/*
  * If we were told we had a good local APIC, check for buggy Pentia,
  * i.e. all B steppings and the C2 stepping of P54C when using their
  * integrated APIC (see 11AP erratum in "Pentium Processor
