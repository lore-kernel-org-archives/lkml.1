Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbYFXC4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbYFXC4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 22:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757275AbYFXCzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 22:55:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:33552 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbYFXCyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 22:54:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=H0kzCv9bR30XsxJzA5DVOXEPCE18V+Hp5CnqVzoMWb0kMFpkYw03E/YzpIEhchU8z9
         NIJOCnfrw4HS5oCAOxii+DfSCw13p7UJQSWyCQiglVqkKQakJv1FeAw5OkQNFSgyxys7
         JMiG5KW+D8YztpsF4DvhE5MtYCDFE7ZZ8GYHo=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: setup_arch 32bit move kvm_guest_init later
Date: Mon, 23 Jun 2008 19:55:05 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806231951.10898.yhlu.kernel@gmail.com> <200806231953.33437.yhlu.kernel@gmail.com> <200806231954.23694.yhlu.kernel@gmail.com>
In-Reply-To: <200806231954.23694.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231955.05921.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup_32.c |   32 ++++++++++++++++++--------------
 arch/x86/kernel/setup_64.c |   14 +++++++-------
 2 files changed, 25 insertions(+), 21 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -488,8 +488,6 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	vmi_init();
 #endif
-	kvm_guest_init();
-
 	/*
 	 * NOTE: before this point _nobody_ is allowed to allocate
 	 * any memory using the bootmem allocator.  Although the
@@ -517,9 +515,15 @@ void __init setup_arch(char **cmdline_p)
 
 	early_quirks();
 
+	/*
+	 * Read APIC and some other early information from ACPI tables.
+	 */
 	acpi_boot_init();
 
 #if defined(CONFIG_X86_MPPARSE) || defined(CONFIG_X86_VISWS)
+	/*
+	 * get boot-time SMP configuration:
+	 */
 	if (smp_found_config)
 		get_smp_config();
 #endif
@@ -529,6 +533,7 @@ void __init setup_arch(char **cmdline_p)
 			"CONFIG_X86_PC cannot handle it.\nUse "
 			"CONFIG_X86_GENERICARCH or CONFIG_X86_BIGSMP.\n");
 #endif
+	kvm_guest_init();
 
 	e820_reserve_resources();
 	e820_mark_nosave_regions(max_low_pfn);
