Return-Path: <linux-kernel-owner+w=401wt.eu-S966250AbXDDBga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966250AbXDDBga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966249AbXDDBf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:35:57 -0400
Received: from 250.sub-75-209-50.myvzw.com ([75.209.50.250]:34557 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966250AbXDDBfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:35:32 -0400
Message-Id: <20070404011453.879668615@goop.org>
References: <20070404010655.400913479@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 03 Apr 2007 18:07:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 6/6] Allow boot-time disable of paravirt_ops patching
Content-Disposition: inline; filename=disable-paravirt-patching.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add "noreplace-paravirt" to disable paravirt_ops patching.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>

---
 Documentation/kernel-parameters.txt |    3 +++
 arch/i386/kernel/alternative.c      |   13 +++++++++++++
 2 files changed, 16 insertions(+)

===================================================================
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -64,6 +64,7 @@ parameter is applicable:
 	GENERIC_TIME The generic timeofday code is enabled.
 	NFS	Appropriate NFS support is enabled.
 	OSS	OSS sound support is enabled.
+	PV_OPS	A paravirtualized kernel
 	PARIDE	The ParIDE subsystem is enabled.
 	PARISC	The PA-RISC architecture is enabled.
 	PCI	PCI bus support is enabled.
@@ -1134,6 +1135,8 @@ and is between 256 and 4096 characters. 
 	nomca		[IA-64] Disable machine check abort handling
 
 	nomce		[IA-32] Machine Check Exception
+
+	noreplace-paravirt	[IA-32,PV_OPS] Don't patch paravirt_ops
 
 	noreplace-smp	[IA-32,SMP] Don't replace SMP instructions
 			with UP alternatives
===================================================================
--- a/arch/i386/kernel/alternative.c
+++ b/arch/i386/kernel/alternative.c
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
@@ -329,6 +339,9 @@ void apply_paravirt(struct paravirt_patc
 {
 	struct paravirt_patch *p;
 
+	if (noreplace_paravirt)
+		return;
+
 	for (p = start; p < end; p++) {
 		unsigned int used;
 

-- 

