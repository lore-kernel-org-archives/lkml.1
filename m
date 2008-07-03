Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbYGCHDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbYGCHDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYGCG5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:17 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:54516 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbYGCBwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 21:52:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=t2IbSv0x5Jo/fzsd5pI3BcAky6kMerszN8nUNPHFGqt01dG8fl8L83MNdOx55nEXbB
         4C1jyEzM2fDzjN2Dv+yA4f/oup99fNGzQsZdNzCZ4EHwiQ8WLtBNfB13k4opjNrP8+uy
         2ln6c+j0h99uDSKbLitJ+3JXDYvIRZgwTpXw8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: move init_cpu_to_node after get_smp_config
Date: Wed, 2 Jul 2008 18:53:44 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200806301834.59156.yhlu.kernel@gmail.com>
In-Reply-To: <200806301834.59156.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807021853.44492.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


when acpi=off, cpu_to_apicid is ready after get_smp_config
so need to move init_cpu_to_node after it.

otherwise, we will get wrong cpu->node mapping. and it will rely on
amd_detect_cmp to correct it. but that is too late.
setup_per_cpu_data is already called before that.
we will get per_cpu_data on wrong node.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -780,10 +780,6 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	acpi_boot_init();
 
-#ifdef CONFIG_X86_64
-	init_cpu_to_node();
-#endif
-
 #if defined(CONFIG_X86_MPPARSE) || defined(CONFIG_X86_VISWS)
 	/*
 	 * get boot-time SMP configuration:
@@ -792,6 +788,10 @@ void __init setup_arch(char **cmdline_p)
 		get_smp_config();
 #endif
 
+#ifdef CONFIG_X86_64
+	init_cpu_to_node();
+#endif
+
 	init_apic_mappings();
 	ioapic_init_mappings();
