Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbXKKWfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbXKKWfo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 17:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755532AbXKKWff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 17:35:35 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:60426 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577AbXKKWfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 17:35:34 -0500
Date: Sun, 11 Nov 2007 17:34:50 -0500
Message-Id: <200711112234.lABMYo0n004269@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] arch/x86/kernel/setup_64.c compile error (MMOTM-2007-11-10-19-05)
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm using -mm (MMOTM-2007-11-10-19-05) and getting

$ make
  CC      arch/x86/kernel/setup_64.o
arch/x86/kernel/setup_64.c: In function 'setup_arch':
arch/x86/kernel/setup_64.c:420: error: implicit declaration of function 'early_quirks'

That's because the externs for early_quirks() aren't on unless CONFIG_ACPI
is on, but the code in setup_64.c calls early_quirks() if CONFIG_PCI is on
(and early-quirks.c is compiled only if CONFIG_PCI=y).  I'm not sure if the
small fix below is correct, hence no signed-off-by.  But it seems to get the
kernel compiling and linking at least.  Someone should check.

Cheers,
Erez.


diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 5a09161..64644d4 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -416,7 +416,7 @@ void __init setup_arch(char **cmdline_p)
 	reserve_crashkernel();
 	paging_init();
 
-#ifdef CONFIG_PCI
+#if defined(CONFIG_PCI) && defined(CONFIG_ACPI)
 	early_quirks();
 #endif
 
