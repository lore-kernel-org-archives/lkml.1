Return-Path: <linux-kernel-owner+w=401wt.eu-S932342AbYENPQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342AbYENPQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760371AbYENPPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:15:37 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45820 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761338AbYENPPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:15:36 -0400
From: Paul Jackson <pj@sgi.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       Paul Jackson <pj@sgi.com>
Date: Wed, 14 May 2008 08:15:34 -0700
Message-Id: <20080514151534.148486.64634.sendpatchset@jackhammer.engr.sgi.com>
In-Reply-To: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
References: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH 6/10] x86 boot: proper use of ARRAY_SIZE instead of repeated E820MAX constant
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

This patch is motivated by a subsequent patch which will allow for more
memory map entries on EFI supported systems than can be passed via the x86
legacy BIOS E820 interface.  The legacy interface is limited to E820MAX ==
128 memory entries, and that "E820MAX" manifest constant was used as the
size for several arrays and loops over those arrays.

The primary change in this patch is to change code loop sizes over those
arrays from using the constant E820MAX, to using the ARRAY_SIZE() macro
evaluated for the array being looped.  That way, a subsequent patch can
change the size of some of these arrays, without breaking this code.

This patch also adds a parameter to the sanitize_e820_map() routine,
which had an implicit size for the array passed it of E820MAX entries.
This new parameter explicitly passes the size of said array.  Once again,
this will allow a subsequent patch to change that array size for some
calls to sanitize_e820_map() without breaking the code.

As part of enhancing the sanitize_e820_map() interface this way, I further
combined the unnecessarily distinct x86_32 and x86_64 declarations for
this routine into a single, commonly used, declaration.

This patch in itself should make no difference to the resulting kernel
binary.

Signed-off-by: Paul Jackson <pj@sgi.com>

---
 arch/x86/boot/memory.c        |    3 ++-
 arch/x86/kernel/e820_32.c     |    9 +++++----
 arch/x86/kernel/e820_64.c     |   15 +++++++++------
 arch/x86/mach-default/setup.c |    4 +++-
 arch/x86/mach-voyager/setup.c |    4 +++-
 include/asm-x86/setup.h       |    4 +++-
 6 files changed, 25 insertions(+), 14 deletions(-)

--- 2.6.26-rc2-mm1.orig/arch/x86/boot/memory.c	2008-05-14 03:07:02.923234780 -0700
+++ 2.6.26-rc2-mm1/arch/x86/boot/memory.c	2008-05-14 03:07:20.607523804 -0700
@@ -13,6 +13,7 @@
  */
 
 #include "boot.h"
+#include <linux/kernel.h>
 
 #define SMAP	0x534d4150	/* ASCII "SMAP" */
 
@@ -53,7 +54,7 @@ static int detect_memory_e820(void)
 
 		count++;
 		desc++;
-	} while (next && count < E820MAX);
+	} while (next && count < ARRAY_SIZE(boot_params.e820_map));
 
 	return boot_params.e820_entries = count;
 }
--- 2.6.26-rc2-mm1.orig/arch/x86/kernel/e820_32.c	2008-05-14 03:07:19.459505040 -0700
+++ 2.6.26-rc2-mm1/arch/x86/kernel/e820_32.c	2008-05-14 03:07:20.627524130 -0700
@@ -262,7 +262,7 @@ void __init add_memory_region(unsigned l
 
 	x = e820.nr_map;
 
-	if (x == E820MAX) {
+	if (x == ARRAY_SIZE(e820.map)) {
 		printk(KERN_ERR "Ooops! Too many entries in the memory map!\n");
 		return;
 	}
@@ -280,7 +280,8 @@ void __init add_memory_region(unsigned l
  * replaces the original e820 map with a new one, removing overlaps.
  *
  */
-int __init sanitize_e820_map(struct e820entry *biosmap, char *pnr_map)
+int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
+				char *pnr_map)
 {
 	struct change_member *change_tmp;
 	unsigned long current_type, last_type;
@@ -414,7 +415,7 @@ int __init sanitize_e820_map(struct e820
 					change_point[chgidx]->addr - last_addr;
 				/* move forward only if the new size was non-zero */
 				if (new_bios[new_bios_entry].size != 0)
-					if (++new_bios_entry >= E820MAX)
+					if (++new_bios_entry >= max_nr_map)
 						break; 	/* no more space left for new bios entries */
 			}
 			if (current_type != 0)	{
@@ -767,7 +768,7 @@ void __init update_e820(void)
 	u8 nr_map;
 
 	nr_map = e820.nr_map;
-	if (sanitize_e820_map(e820.map, &nr_map))
+	if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr_map))
 		return;
 	e820.nr_map = nr_map;
 	printk(KERN_INFO "modified physical RAM map:\n");
--- 2.6.26-rc2-mm1.orig/arch/x86/kernel/e820_64.c	2008-05-14 03:07:19.467505171 -0700
+++ 2.6.26-rc2-mm1/arch/x86/kernel/e820_64.c	2008-05-14 03:07:20.643524392 -0700
@@ -441,7 +441,7 @@ void __init add_memory_region(unsigned l
 {
 	int x = e820.nr_map;
 
-	if (x == E820MAX) {
+	if (x == ARRAY_SIZE(e820.map)) {
 		printk(KERN_ERR "Ooops! Too many entries in the memory map!\n");
 		return;
 	}
@@ -509,7 +509,8 @@ static void __init e820_print_map(char *
  * replaces the original e820 map with a new one, removing overlaps.
  *
  */
-static int __init sanitize_e820_map(struct e820entry *biosmap, char *pnr_map)
+int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
+				    char *pnr_map)
 {
 	struct change_member {
 		struct e820entry *pbios; /* pointer to original bios entry */
@@ -681,7 +682,7 @@ static int __init sanitize_e820_map(stru
 					 * no more space left for new
 					 * bios entries ?
 					 */
-					if (++new_bios_entry >= E820MAX)
+					if (++new_bios_entry >= max_nr_map)
 						break;
 			}
 			if (current_type != 0)	{
@@ -749,7 +750,9 @@ char *__init machine_specific_memory_set
 	 * Otherwise fake a memory map; one section from 0k->640k,
 	 * the next section from 1mb->appropriate_mem_k
 	 */
-	sanitize_e820_map(boot_params.e820_map, &boot_params.e820_entries);
+	sanitize_e820_map(boot_params.e820_map,
+			ARRAY_SIZE(boot_params.e820_map),
+			&boot_params.e820_entries);
 	if (copy_e820_map(boot_params.e820_map, boot_params.e820_entries) < 0)
 		early_panic("Cannot find a valid memory map");
 	printk(KERN_INFO "BIOS-provided physical RAM map:\n");
@@ -820,7 +823,7 @@ void __init finish_e820_parsing(void)
 	if (userdef) {
 		char nr = e820.nr_map;
 
-		if (sanitize_e820_map(e820.map, &nr) < 0)
+		if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr) < 0)
 			early_panic("Invalid user supplied memory map");
 		e820.nr_map = nr;
 
@@ -861,7 +864,7 @@ void __init update_e820(void)
 	u8 nr_map;
 
 	nr_map = e820.nr_map;
-	if (sanitize_e820_map(e820.map, &nr_map))
+	if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr_map))
 		return;
 	e820.nr_map = nr_map;
 	printk(KERN_INFO "modified physical RAM map:\n");
--- 2.6.26-rc2-mm1.orig/arch/x86/mach-default/setup.c	2008-05-14 03:07:02.923234780 -0700
+++ 2.6.26-rc2-mm1/arch/x86/mach-default/setup.c	2008-05-14 03:07:20.659524653 -0700
@@ -163,7 +163,9 @@ char * __init machine_specific_memory_se
 	 * Otherwise fake a memory map; one section from 0k->640k,
 	 * the next section from 1mb->appropriate_mem_k
 	 */
-	sanitize_e820_map(boot_params.e820_map, &boot_params.e820_entries);
+	sanitize_e820_map(boot_params.e820_map,
+			ARRAY_SIZE(boot_params.e820_map),
+			&boot_params.e820_entries);
 	if (copy_e820_map(boot_params.e820_map, boot_params.e820_entries)
 	    < 0) {
 		unsigned long mem_size;
--- 2.6.26-rc2-mm1.orig/arch/x86/mach-voyager/setup.c	2008-05-14 03:07:02.927234845 -0700
+++ 2.6.26-rc2-mm1/arch/x86/mach-voyager/setup.c	2008-05-14 03:07:20.675524915 -0700
@@ -111,7 +111,9 @@ char *__init machine_specific_memory_set
 	 * Otherwise fake a memory map; one section from 0k->640k,
 	 * the next section from 1mb->appropriate_mem_k
 	 */
-	sanitize_e820_map(boot_params.e820_map, &boot_params.e820_entries);
+	sanitize_e820_map(boot_params.e820_map,
+			ARRAY_SIZE(boot_params.e820_map),
+			&boot_params.e820_entries);
 	if (copy_e820_map(boot_params.e820_map, boot_params.e820_entries)
 	    < 0) {
 		unsigned long mem_size;
--- 2.6.26-rc2-mm1.orig/include/asm-x86/setup.h	2008-05-14 03:07:02.927234845 -0700
+++ 2.6.26-rc2-mm1/include/asm-x86/setup.h	2008-05-14 03:07:20.691525176 -0700
@@ -43,6 +43,9 @@ char *machine_specific_memory_setup(void
  */
 extern struct boot_params boot_params;
 
+int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
+			     char *pnr_map);
+
 #ifdef __i386__
 /*
  * Do NOT EVER look at the BIOS memory size location.
@@ -56,7 +59,6 @@ char * __init machine_specific_memory_se
 char *memory_setup(void);
 
 int __init copy_e820_map(struct e820entry *biosmap, int nr_map);
-int __init sanitize_e820_map(struct e820entry *biosmap, char *pnr_map);
 void __init add_memory_region(unsigned long long start,
 			      unsigned long long size, int type);
 

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
