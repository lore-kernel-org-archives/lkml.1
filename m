Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbYGCSiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbYGCSiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 14:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbYGCSiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 14:38:03 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:44595 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbYGCSiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 14:38:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=wXG7MIdIYkIjXqYiyMvDGj6SNSwQzkGEZ4+X8cU/m8/DWTCd5Je2uwd7Xt+dZ6ocuh
         oY1Pzb1aM3fNOH1uVqb2FfKMu2UIbFLpbf7I9tsidDWGHz26aKSZAWU/QQK/E/Mh8ELU
         i1Fl1jz3cybgjYBoQnwretCWjzG9a/WRFuRRo=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Bernhard Walle <bwalle@suse.de>
Subject: [PATCH] x86: move saving e820_saved to setup_memory_map
Date: Thu, 3 Jul 2008 11:35:37 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807031135.37465.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so other path that will override memory_setup or machine_specific_memory_setup could
have e820_saved too

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/e820.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1294,8 +1294,6 @@ char *__init default_machine_specific_me
 		e820_add_region(HIGH_MEMORY, mem_size << 10, E820_RAM);
 	}
 
-	memcpy(&e820_saved, &e820, sizeof(struct e820map));
-
 	/* In case someone cares... */
 	return who;
 }
@@ -1313,8 +1311,12 @@ char * __init __attribute__((weak)) memo
 
 void __init setup_memory_map(void)
 {
+	char *who;
+
+	who = memory_setup();
+	memcpy(&e820_saved, &e820, sizeof(struct e820map));
 	printk(KERN_INFO "BIOS-provided physical RAM map:\n");
-	e820_print_map(memory_setup());
+	e820_print_map(who);
 }
 
 #ifdef CONFIG_X86_64
