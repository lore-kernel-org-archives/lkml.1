Return-Path: <linux-kernel-owner+w=401wt.eu-S1759575AbZEFMGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575AbZEFMGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759173AbZEFMGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:06:35 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:15088 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758061AbZEFMGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:06:34 -0400
Message-Id: <4A0199B8.76EA.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 06 May 2009 13:07:52 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: improve e820_search_gap()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: bug fix

Blindly putting the gap close after max_pfn is in conflict with that
same memory range potentially being used by hotplugged memory.

Also, make the function static to ensure there are no other users that
could depend on the previous behavior regarding the way start_addr gets
specified.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/e820.h |    2 --
 arch/x86/kernel/e820.c      |   11 +++++++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

--- linux-2.6.30-rc4/arch/x86/include/asm/e820.h	2009-04-30 09:42:42.000000000 +0200
+++ 2.6.30-rc4-x86_64-e820-setup-gap/arch/x86/include/asm/e820.h	2009-04-27 12:03:48.000000000 +0200
@@ -79,8 +79,6 @@ extern u64 e820_remove_range(u64 start, 
 			     int checktype);
 extern void update_e820(void);
 extern void e820_setup_gap(void);
-extern int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
-			unsigned long start_addr, unsigned long long end_addr);
 struct setup_data;
 extern void parse_e820_ext(struct setup_data *data, unsigned long pa_data);
 
--- linux-2.6.30-rc4/arch/x86/kernel/e820.c	2009-04-30 09:42:42.000000000 +0200
+++ 2.6.30-rc4-x86_64-e820-setup-gap/arch/x86/kernel/e820.c	2009-04-27 12:03:48.000000000 +0200
@@ -574,13 +574,19 @@ static void __init update_e820_saved(voi
 /*
  * Search for a gap in the e820 memory space from start_addr to end_addr.
  */
-__init int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
+static int __init
+e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
 		unsigned long start_addr, unsigned long long end_addr)
 {
 	unsigned long long last;
 	int i = e820.nr_map;
 	int found = 0;
 
+#ifdef CONFIG_X86_64
+	if (start_addr >= MAX_GAP_END)
+		last = end_addr ?: (1UL << boot_cpu_data.x86_phys_bits);
+	else
+#endif
 	last = (end_addr && end_addr < MAX_GAP_END) ? end_addr : MAX_GAP_END;
 
 	while (--i >= 0) {
@@ -626,11 +632,12 @@ __init void e820_setup_gap(void)
 
 #ifdef CONFIG_X86_64
 	if (!found) {
-		gapstart = (max_pfn << PAGE_SHIFT) + 1024*1024;
 		printk(KERN_ERR "PCI: Warning: Cannot find a gap in the 32bit "
 		       "address range\n"
 		       KERN_ERR "PCI: Unassigned devices with 32bit resource "
 		       "registers may break!\n");
+		found = e820_search_gap(&gapstart, &gapsize, MAX_GAP_END, 0);
+		WARN_ON(!found);
 	}
 #endif
 



