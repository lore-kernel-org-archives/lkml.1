Return-Path: <linux-kernel-owner+w=401wt.eu-S1763848AbXIUUtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763848AbXIUUtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763234AbXIUUo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:44:58 -0400
Received: from ns2.suse.de ([195.135.220.15]:32960 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763159AbXIUUo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:44:57 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: vmpn@hitechman.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [10/45] x86_64: x86_64 Sanitize user specified e820 memmap values
Message-Id: <20070921204451.89C6114EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:44:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Vladimir Berezniker <vmpn@hitechman.com>

Sanitize user specified e820 memory ranges, using the same logic that  
is applied to the values returned by the BIOS.  This ensures  
consistent handling regardless of the source of the memory mappings.

Allows overriding portions of the memory map without specifying one in  
it's entirety (memmap=exactmap).

E.g. marking a range of bad RAM as reserved with memmap=48M$528M

BIOS supplied range

BIOS-e820: 0000000000100000 - 000000007fe80000 (usable)

becomes

user: 0000000000100000 - 0000000021000000 (usable)
user: 0000000021000000 - 0000000024000000 (reserved)
user: 0000000024000000 - 000000007fe80000 (usable)

Previously this did not work, as the original BIOS range was left  
untouched while the user defined range was appended to the end of the  
memory map.

Signed-off-by: Vladimir Berezniker <vmpn@hitechman.com>
Signed-off-by: Andi Kleen <ak@suse.de>


---
 arch/x86_64/kernel/e820.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux/arch/x86_64/kernel/e820.c
===================================================================
--- linux.orig/arch/x86_64/kernel/e820.c
+++ linux/arch/x86_64/kernel/e820.c
@@ -639,6 +639,8 @@ static int __init parse_memmap_opt(char 
 	mem_size = memparse(p, &p);
 	if (p == oldp)
 		return -EINVAL;
+
+	userdef = 1;
 	if (*p == '@') {
 		start_at = memparse(p+1, &p);
 		add_memory_region(start_at, mem_size, E820_RAM);
@@ -658,6 +660,11 @@ early_param("memmap", parse_memmap_opt);
 void __init finish_e820_parsing(void)
 {
 	if (userdef) {
+		char nr = e820.nr_map;
+		if (sanitize_e820_map(e820.map, &nr) < 0)
+			early_panic("Invalid user supplied memory map");
+		e820.nr_map = nr;
+
 		printk(KERN_INFO "user-defined physical RAM map:\n");
 		e820_print_map("user");
 	}
