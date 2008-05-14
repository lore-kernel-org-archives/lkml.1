Return-Path: <linux-kernel-owner+w=401wt.eu-S1763312AbYENPRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763312AbYENPRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762218AbYENPPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:15:49 -0400
Received: from relay2.sgi.com ([192.48.171.30]:41219 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762201AbYENPPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:15:47 -0400
From: Paul Jackson <pj@sgi.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       Paul Jackson <pj@sgi.com>
Date: Wed, 14 May 2008 08:15:46 -0700
Message-Id: <20080514151546.148486.91305.sendpatchset@jackhammer.engr.sgi.com>
In-Reply-To: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
References: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH 8/10] x86 boot: change sanitize_e820_map parameter from byte to int to allow bigger memory maps
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

The map size counter passed into, and back out of, sanitize_e820_map(),
was an eight bit type (char or u8), as derived from its origins in
legacy BIOS E820 structures.  This patch changes that type to an 'int',
to allow this sanitize routine to also be used on larger maps (larger
than the 256 count that fits in a char).  The legacy BIOS E820 interface
of course does not change; that remains at 8 bits for this count, holding
up to E820MAX == 128 entries.  But the kernel internals can handle more
when those additional memory map entries are passed from the BIOS via
EFI interfaces.

Signed-off-by: Paul Jackson <pj@sgi.com>

---
 arch/x86/kernel/e820_32.c     |    4 ++--
 arch/x86/kernel/e820_64.c     |   12 ++++++++----
 arch/x86/mach-default/setup.c |    5 ++++-
 arch/x86/mach-voyager/setup.c |    5 ++++-
 include/asm-x86/setup.h       |    2 +-
 5 files changed, 19 insertions(+), 9 deletions(-)

--- 2.6.26-rc2-mm1.orig/arch/x86/kernel/e820_32.c	2008-05-14 03:07:25.795608600 -0700
+++ 2.6.26-rc2-mm1/arch/x86/kernel/e820_32.c	2008-05-14 03:07:30.395683787 -0700
@@ -281,7 +281,7 @@ void __init add_memory_region(unsigned l
  *
  */
 int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
-				char *pnr_map)
+				int *pnr_map)
 {
 	struct change_member *change_tmp;
 	unsigned long current_type, last_type;
@@ -765,7 +765,7 @@ void __init update_memory_range(u64 star
 }
 void __init update_e820(void)
 {
-	u8 nr_map;
+	int nr_map;
 
 	nr_map = e820.nr_map;
 	if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr_map))
--- 2.6.26-rc2-mm1.orig/arch/x86/kernel/e820_64.c	2008-05-14 03:07:25.811608861 -0700
+++ 2.6.26-rc2-mm1/arch/x86/kernel/e820_64.c	2008-05-14 03:07:30.399683852 -0700
@@ -510,7 +510,7 @@ static void __init e820_print_map(char *
  *
  */
 int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
-				    char *pnr_map)
+				    int *pnr_map)
 {
 	struct change_member {
 		struct e820entry *pbios; /* pointer to original bios entry */
@@ -571,6 +571,7 @@ int __init sanitize_e820_map(struct e820
 		return -1;
 
 	old_nr = *pnr_map;
+	BUG_ON(old_nr > max_nr_map);
 
 	/* bail out if we find any unreasonable addresses in bios map */
 	for (i = 0; i < old_nr; i++)
@@ -744,15 +745,18 @@ static void early_panic(char *msg)
 char *__init machine_specific_memory_setup(void)
 {
 	char *who = "BIOS-e820";
+	int new_nr;
 	/*
 	 * Try to copy the BIOS-supplied E820-map.
 	 *
 	 * Otherwise fake a memory map; one section from 0k->640k,
 	 * the next section from 1mb->appropriate_mem_k
 	 */
+	new_nr = boot_params.e820_entries;
 	sanitize_e820_map(boot_params.e820_map,
 			ARRAY_SIZE(boot_params.e820_map),
-			&boot_params.e820_entries);
+			&new_nr);
+	boot_params.e820_entries = new_nr;
 	if (copy_e820_map(boot_params.e820_map, boot_params.e820_entries) < 0)
 		early_panic("Cannot find a valid memory map");
 	printk(KERN_INFO "BIOS-provided physical RAM map:\n");
@@ -821,7 +825,7 @@ early_param("memmap", parse_memmap_opt);
 void __init finish_e820_parsing(void)
 {
 	if (userdef) {
-		char nr = e820.nr_map;
+		int nr = e820.nr_map;
 
 		if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr) < 0)
 			early_panic("Invalid user supplied memory map");
@@ -861,7 +865,7 @@ void __init update_memory_range(u64 star
 
 void __init update_e820(void)
 {
-	u8 nr_map;
+	int nr_map;
 
 	nr_map = e820.nr_map;
 	if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr_map))
--- 2.6.26-rc2-mm1.orig/arch/x86/mach-default/setup.c	2008-05-14 03:07:20.659524653 -0700
+++ 2.6.26-rc2-mm1/arch/x86/mach-default/setup.c	2008-05-14 03:07:30.419684179 -0700
@@ -153,6 +153,7 @@ late_initcall(print_ipi_mode);
 char * __init machine_specific_memory_setup(void)
 {
 	char *who;
+	int new_nr;
 
 
 	who = "BIOS-e820";
@@ -163,9 +164,11 @@ char * __init machine_specific_memory_se
 	 * Otherwise fake a memory map; one section from 0k->640k,
 	 * the next section from 1mb->appropriate_mem_k
 	 */
+	new_nr = boot_params.e820_entries;
 	sanitize_e820_map(boot_params.e820_map,
 			ARRAY_SIZE(boot_params.e820_map),
-			&boot_params.e820_entries);
+			&new_nr);
+	boot_params.e820_entries = new_nr;
 	if (copy_e820_map(boot_params.e820_map, boot_params.e820_entries)
 	    < 0) {
 		unsigned long mem_size;
--- 2.6.26-rc2-mm1.orig/arch/x86/mach-voyager/setup.c	2008-05-14 03:07:20.675524915 -0700
+++ 2.6.26-rc2-mm1/arch/x86/mach-voyager/setup.c	2008-05-14 03:07:30.439684506 -0700
@@ -62,6 +62,7 @@ void __init time_init_hook(void)
 char *__init machine_specific_memory_setup(void)
 {
 	char *who;
+	int new_nr;
 
 	who = "NOT VOYAGER";
 
@@ -111,9 +112,11 @@ char *__init machine_specific_memory_set
 	 * Otherwise fake a memory map; one section from 0k->640k,
 	 * the next section from 1mb->appropriate_mem_k
 	 */
+	new_nr = boot_params.e820_entries;
 	sanitize_e820_map(boot_params.e820_map,
 			ARRAY_SIZE(boot_params.e820_map),
-			&boot_params.e820_entries);
+			&new_nr);
+	boot_params.e820_entries = new_nr;
 	if (copy_e820_map(boot_params.e820_map, boot_params.e820_entries)
 	    < 0) {
 		unsigned long mem_size;
--- 2.6.26-rc2-mm1.orig/include/asm-x86/setup.h	2008-05-14 03:07:20.691525176 -0700
+++ 2.6.26-rc2-mm1/include/asm-x86/setup.h	2008-05-14 03:07:30.459684833 -0700
@@ -44,7 +44,7 @@ char *machine_specific_memory_setup(void
 extern struct boot_params boot_params;
 
 int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
-			     char *pnr_map);
+			     int *pnr_map);
 
 #ifdef __i386__
 /*

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
