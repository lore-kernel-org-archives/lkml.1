Return-Path: <linux-kernel-owner+w=401wt.eu-S1751672AbXD3Kap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbXD3Kap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbXD3K30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:29:26 -0400
Received: from ns2.suse.de ([195.135.220.15]:43025 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965337AbXD3K2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:28:09 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: jeremy@goop.org, rusty@rustcorp.com.au, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [33/40] i386: Allow boot-time disable of paravirt_ops patching
Message-Id: <20070430102808.1657B151D2@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:28:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>

Add "noreplace-paravirt" to disable paravirt_ops patching.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    3 +++
 arch/i386/kernel/alternative.c      |   13 +++++++++++++
 2 files changed, 16 insertions(+)

Index: linux/Documentation/kernel-parameters.txt
===================================================================
--- linux.orig/Documentation/kernel-parameters.txt
+++ linux/Documentation/kernel-parameters.txt
@@ -64,6 +64,7 @@ parameter is applicable:
 	GENERIC_TIME The generic timeofday code is enabled.
 	NFS	Appropriate NFS support is enabled.
 	OSS	OSS sound support is enabled.
+	PV_OPS	A paravirtualized kernel
 	PARIDE	The ParIDE subsystem is enabled.
 	PARISC	The PA-RISC architecture is enabled.
 	PCI	PCI bus support is enabled.
@@ -1142,6 +1143,8 @@ and is between 256 and 4096 characters. 
 
 	nomce		[IA-32] Machine Check Exception
 
+	noreplace-paravirt	[IA-32,PV_OPS] Don't patch paravirt_ops
+
 	noreplace-smp	[IA-32,SMP] Don't replace SMP instructions
 			with UP alternatives
 
Index: linux/arch/i386/kernel/alternative.c
===================================================================
--- linux.orig/arch/i386/kernel/alternative.c
+++ linux/arch/i386/kernel/alternative.c
@@ -30,6 +30,16 @@ static int __init setup_noreplace_smp(ch
 }
 __setup("noreplace-smp", setup_noreplace_smp);
 
+#ifdef CONFIG_PARAVIRT
+static int noreplace_paravirt = 0;
+
+static int __init setup_noreplace_paravirt(char *str)
+{
+	noreplace_paravirt = 1;
+	return 1;
+}
+__setup("noreplace-paravirt", setup_noreplace_paravirt);
+#endif
 
 #define DPRINTK(fmt, args...) if (debug_alternative) \
 	printk(KERN_DEBUG fmt, args)
@@ -330,6 +340,9 @@ void apply_paravirt(struct paravirt_patc
 {
 	struct paravirt_patch_site *p;
 
+	if (noreplace_paravirt)
+		return;
+
 	for (p = start; p < end; p++) {
 		unsigned int used;
 
