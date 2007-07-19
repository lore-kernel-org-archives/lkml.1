Return-Path: <linux-kernel-owner+w=401wt.eu-S937226AbXGSKQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937226AbXGSKQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbXGSJzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:52 -0400
Received: from ns1.suse.de ([195.135.220.2]:35412 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759453AbXGSJza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:30 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: jbeulich@novell.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [38/58] i386: smp-alt-once option is only useful with  HOTPLUG_CPU
Message-Id: <20070719095524.57FBC14E06@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
Hence remove its handling in the opposite case.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

 arch/i386/kernel/alternative.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

Index: linux/arch/i386/kernel/alternative.c
===================================================================
--- linux.orig/arch/i386/kernel/alternative.c
+++ linux/arch/i386/kernel/alternative.c
@@ -5,9 +5,8 @@
 #include <asm/alternative.h>
 #include <asm/sections.h>
 
-static int noreplace_smp     = 0;
-static int smp_alt_once      = 0;
-static int debug_alternative = 0;
+#ifdef CONFIG_HOTPLUG_CPU
+static int smp_alt_once;
 
 static int __init bootonly(char *str)
 {
@@ -15,6 +14,11 @@ static int __init bootonly(char *str)
 	return 1;
 }
 __setup("smp-alt-boot", bootonly);
+#else
+#define smp_alt_once 1
+#endif
+
+static int debug_alternative;
 
 static int __init debug_alt(char *str)
 {
@@ -23,6 +27,8 @@ static int __init debug_alt(char *str)
 }
 __setup("debug-alternative", debug_alt);
 
+static int noreplace_smp;
+
 static int __init setup_noreplace_smp(char *str)
 {
 	noreplace_smp = 1;
@@ -376,8 +382,6 @@ void __init alternative_instructions(voi
 #ifdef CONFIG_HOTPLUG_CPU
 	if (num_possible_cpus() < 2)
 		smp_alt_once = 1;
-#else
-	smp_alt_once = 1;
 #endif
 
 #ifdef CONFIG_SMP
