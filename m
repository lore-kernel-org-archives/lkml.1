Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbYFCRHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbYFCRHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbYFCRFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:05:55 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:46457 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbYFCRFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:05:49 -0400
Message-Id: <20080603170521.459372348@de.ibm.com>
References: <20080603165859.107949986@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jun 2008 18:59:12 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 13/14] initrd vs bss section clearing.
Content-Disposition: inline; filename=112-initrd-bss.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

In case the initrd is located within the bss section it will be
overwritten when the section is cleared. To prevent this just move
the initrd right behind the bss section if it starts within the
section.
The current code already moves the initrd if the bootmem allocator
bitmap would overwrite it. With this patch we should be safe against
initrd corruptions.

Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/early.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

Index: quilt-2.6/arch/s390/kernel/early.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/early.c
+++ quilt-2.6/arch/s390/kernel/early.c
@@ -380,6 +380,23 @@ static __init void detect_machine_facili
 #endif
 }
 
+static __init void rescue_initrd(void)
+{
+#ifdef CONFIG_BLK_DEV_INITRD
+	/*
+	 * Move the initrd right behind the bss section in case it starts
+	 * within the bss section. So we don't overwrite it when the bss
+	 * section gets cleared.
+	 */
+	if (!INITRD_START || !INITRD_SIZE)
+		return;
+	if (INITRD_START >= (unsigned long) __bss_stop)
+		return;
+	memmove(__bss_stop, (void *) INITRD_START, INITRD_SIZE);
+	INITRD_START = (unsigned long) __bss_stop;
+#endif
+}
+
 /*
  * Save ipl parameters, clear bss memory, initialize storage keys
  * and create a kernel NSS at startup if the SAVESYS= parm is defined
@@ -389,6 +406,7 @@ void __init startup_init(void)
 	unsigned long long memsize;
 
 	ipl_save_parameters();
+	rescue_initrd();
 	clear_bss_section();
 	init_kernel_storage_key();
 	lockdep_init();

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

