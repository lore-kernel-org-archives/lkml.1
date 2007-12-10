Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbXLJQC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbXLJQC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 11:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbXLJQCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 11:02:50 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:25719
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751746AbXLJQCu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 11:02:50 -0500
Message-Id: <475D7169.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 10 Dec 2007 16:03:37 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@redhat.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: fix .init section reference warnings
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The change in head_64.S is needed because ld -r renames .init.data to
.init.data.<number> for all but the first instance due to mismatching
section attributes.
The change in init_64.c is necessary because find_early_table_space()
is called from a __meminit function, but calls itself an __init one.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/x86/kernel/head_64.S |    2 +-
 arch/x86/mm/init_64.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.24-rc4/arch/x86/kernel/head_64.S	2007-12-10 16:11:18.000000000 +0100
+++ 2.6.24-rc4-x86_64-init-warning/arch/x86/kernel/head_64.S	2007-12-06 11:07:59.000000000 +0100
@@ -244,7 +244,7 @@ ENTRY(secondary_startup_64)
 
 	/* SMP bootup changes these two */
 #ifndef CONFIG_HOTPLUG_CPU
-	.pushsection .init.data
+	.pushsection .init.data, "aw"
 #endif
 	.align	8
 	.globl	initial_code
--- linux-2.6.24-rc4/arch/x86/mm/init_64.c	2007-12-10 16:11:19.000000000 +0100
+++ 2.6.24-rc4-x86_64-init-warning/arch/x86/mm/init_64.c	2007-12-04 16:09:33.000000000 +0100
@@ -317,7 +317,7 @@ static void __meminit phys_pud_init(pud_
 	__flush_tlb();
 } 
 
-static void __init find_early_table_space(unsigned long end)
+static noinline void __init_refok find_early_table_space(unsigned long end)
 {
 	unsigned long puds, pmds, tables, start;
 



