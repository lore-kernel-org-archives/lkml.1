Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbZCLKol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbZCLKol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbZCLKoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:44:32 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:32621 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbZCLKob convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:44:31 -0400
Message-Id: <49B8F5C4.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 12 Mar 2009 10:45:08 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <jeremy.fitzhardinge@citrix.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: improve e820_search_gap()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Blindly putting the gap close after max_pfn might be fine for native
(though even there I'm uncertain regarding memory hotplug), but will
certainly present a problem on Xen. And properly searching for a gap
above 4Gb shouldn't hurt native.

Also, make the function static to ensure there are no other users that
could depend on the previous behavior regarding the way start_addr gets
specified.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

---
 arch/x86/include/asm/e820.h |    2 --
 arch/x86/kernel/e820.c      |   11 +++++++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

--- linux-2.6.29-rc7/arch/x86/include/asm/e820.h	2009-03-11 17:52:10.000000000 +0100
+++ 2.6.29-rc7-x86_64-e820-setup-gap-64bit/arch/x86/include/asm/e820.h	2009-03-06 11:25:35.000000000 +0100
@@ -79,8 +79,6 @@ extern u64 e820_remove_range(u64 start, 
 			     int checktype);
 extern void update_e820(void);
 extern void e820_setup_gap(void);
-extern int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
-			unsigned long start_addr, unsigned long long end_addr);
 struct setup_data;
 extern void parse_e820_ext(struct setup_data *data, unsigned long pa_data);
 
--- linux-2.6.29-rc7/arch/x86/kernel/e820.c	2009-03-11 17:52:10.000000000 +0100
+++ 2.6.29-rc7-x86_64-e820-setup-gap-64bit/arch/x86/kernel/e820.c	2009-03-06 11:24:34.000000000 +0100
@@ -533,13 +533,19 @@ static void __init update_e820_saved(voi
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
@@ -585,11 +591,12 @@ __init void e820_setup_gap(void)
 
 #ifdef CONFIG_X86_64
 	if (!found) {
-		gapstart = (max_pfn << PAGE_SHIFT) + 1024*1024;
 		printk(KERN_ERR "PCI: Warning: Cannot find a gap in the 32bit "
 		       "address range\n"
 		       KERN_ERR "PCI: Unassigned devices with 32bit resource "
 		       "registers may break!\n");
+		found = e820_search_gap(&gapstart, &gapsize, MAX_GAP_END, 0);
+		BUG_ON(!found);
 	}
 #endif
 



