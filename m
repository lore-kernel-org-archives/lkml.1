Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbXISFgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbXISFgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 01:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbXISFgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 01:36:16 -0400
Received: from koto.vergenet.net ([210.128.90.7]:57370 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbXISFgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 01:36:15 -0400
X-Greylist: delayed 1786 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2007 01:36:15 EDT
Subject: [IA64] Kexec: Remove vector from ia64_machine_kexec()
Date: Wed, 19 Sep 2007 14:02:20 +0900
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
Cc: Eric Biederman <ebiederm@xmission.com>, Nan hai Zou <nanhai.zou@intel.com>,
       Tony Luck <tony.luck@intel.com>,
       Alex Williamson <alex.williamson@hp.com>
From: Simon Horman <horms@verge.net.au>
Message-Id: <20070919050626.8A0024F811@tabatha.lab.ultramonkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The use of vector in ia64_machine_kexec() seems spurios,
and removing it simplifies the code slightly.

As suggested by Alex Williamson <alex.williamson@hp.com>

Cc: Alex Williamson <alex.williamson@hp.com>
Signed-off-by: Simon Horman <horms@verge.net.au>

Index: linux-2.6/arch/ia64/kernel/machine_kexec.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/machine_kexec.c	2007-09-19 13:43:42.000000000 +0900
+++ linux-2.6/arch/ia64/kernel/machine_kexec.c	2007-09-19 13:44:11.000000000 +0900
@@ -79,7 +79,6 @@ static void ia64_machine_kexec(struct un
 	relocate_new_kernel_t rnk;
 	void *pal_addr = efi_get_pal_addr();
 	unsigned long code_addr = (unsigned long)page_address(image->control_code_page);
-	unsigned long vector;
 	int ii;
 
 	BUG_ON(!image);
@@ -107,11 +106,8 @@ static void ia64_machine_kexec(struct un
 	/* unmask TPR and clear any pending interrupts */
 	ia64_setreg(_IA64_REG_CR_TPR, 0);
 	ia64_srlz_d();
-	vector = ia64_get_ivr();
-	while (vector != IA64_SPURIOUS_INT_VECTOR) {
+	while (ia64_get_ivr() != IA64_SPURIOUS_INT_VECTOR)
 		ia64_eoi();
-		vector = ia64_get_ivr();
-	}
 	platform_kernel_launch_event();
 	rnk = (relocate_new_kernel_t)&code_addr;
 	(*rnk)(image->head, image->start, ia64_boot_param,
